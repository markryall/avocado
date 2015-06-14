class Avocado::EventMatchers::AbsoluteTime
  SHORT_DAYNAMES = %w{su mo tu we th fr sa}
  SHORT_MONTHNAMES = %w{nil jan feb mar apr may jun jul aug sep oct nov dec}

  REGEXP = /^(.+) at (\d+)(:\d\d)?([ap])?m?/
  DAY_REGEXP = /on (\w+)/
  SPECIFIC_DATE_REGEXP = /on (\d+)\w+ (\w+)/
  DURATION_REGEXP = /for (\d+) ([m|h])s?/

  MINUTE = 60
  HOUR = MINUTE * 60
  DAY = HOUR * 24

  def matches? text
    @match = REGEXP.match text
  end

  def event now
    _, title, hour, minute, ap = *@match
    hour = hour.to_i
    minute = extract_minute minute
    duration = extract_duration
    time = extract_specific_time now, hour, minute
    unless time
      day_offset = extract_day_offset now
      time = time_on_day now, day_offset, hour, ap, minute
    end
    Avocado::Event.new.tap do |event|
      event.title = title
      event.start_time = time
      event.end_time = time + duration
    end
  end

  def extract_minute string
    return 0 unless string
    string.slice(1..2).to_i
  end

  def extract_duration
    match = DURATION_REGEXP.match @match.post_match
    return 0 unless match
    _, quantity, unit = *match
    quantity = quantity.to_i
    unit = unit == 'm' ? 60 : 60*60
    quantity * unit
  end

  def extract_specific_time now, hour, minute
    match = SPECIFIC_DATE_REGEXP.match @match.post_match
    return nil unless match
    _, day, month_name = *match
    day = day.to_i
    month = SHORT_MONTHNAMES.index month_name.downcase.slice 0..2
    time = Time.new(now.year, month, day, hour, minute)
    if time > now
      time
    else
      Time.new(now.year + 1, month, day, hour, minute)
    end
  end

  def extract_day_offset now
    match = DAY_REGEXP.match @match.post_match
    return nil unless match
    day = SHORT_DAYNAMES.index match[1].downcase.slice 0..1
    offset = day - now.wday
    if offset > 0
      offset
    else
      7 + offset
    end
  end

  def time_on_day now, day_offset, hour, ap, minute
    hour += 12 if hour < 12 && ap && ap.start_with?('p')
    time = Time.new(now.year, now.month, now.day, hour, minute)
    time += day_offset * DAY if day_offset
    time < now ? (time+DAY) : time
  end
end

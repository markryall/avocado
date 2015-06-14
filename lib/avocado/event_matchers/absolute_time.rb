class Avocado::EventMatchers::AbsoluteTime
  SHORT_DAYNAMES = %w{su mo tu we th fr sa}

  REGEXP = /^(.+) at (\d+)([ap])?m?/
  DAY_REGEXP = /on (\w+)/
  DURATION_REGEXP = /for (\d+) ([m|h])s?/

  MINUTE = 60
  HOUR = MINUTE * 60
  DAY = HOUR * 24

  def matches? text
    @match = REGEXP.match text
  end

  def event now
    _, title, hour, ap = *@match
    time = time_on_day now, hour.to_i, ap
    duration = extract_duration
    # day_of_week = extract_day_of_week now
    Avocado::Event.new.tap do |event|
      event.title = title
      event.start_time = time
      event.end_time = time + duration
    end
  end

  def extract_duration
    match = DURATION_REGEXP.match @match.post_match
    return 0 unless match
    _, quantity, unit = *match
    quantity = quantity.to_i
    unit = unit == 'm' ? 60 : 60*60
    quantity * unit
  end

  def extract_day_of_week now
    match = DAY_REGEXP.match @match.post_match
    now.wday
  end

  def time_on_day now, hour, ap
    hour += 12 if ap && ap.start_with?('p')
    time = Time.new(now.year, now.month, now.day, hour)
    time < now ? (time+DAY) : time
  end
end

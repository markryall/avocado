class Avocado::EventMatchers::AbsoluteTime
  SHORT_DAYNAMES = %w{su mo tu we th fr sa}

  REGEXP = /^(.+) at (\d+)([ap])?m?/
  DAY_REGEXP = /on (\w+)/
  DURATION_REGEXP = /for (\d+) ([m|h])s?/

  def matches? text
    @match = REGEXP.match text
  end

  def event now
    _, title, hour, ap = *@match
    time = day now, hour.to_i
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
    pp match
    now.wday
  end

  def day now, hour
    hour += 12 if now.hour >= hour
    Time.new now.year, now.month, now.day, hour
  end
end

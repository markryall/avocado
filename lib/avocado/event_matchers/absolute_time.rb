class Avocado::EventMatchers::AbsoluteTime
  REGEXP = /^(.+) at (\d+)([ap])?m?/

  # abs time with duration
  # REGEXP = /^(.+) at (\d+)([ap])m? for (\d+) (.+)s?$/.match text

  # abs time with day
  # REGEXP = /^(.+) at (\d+)([ap])m? on (.+)$/.match text

  # abs time with duration and day
  # REGEXP = /^(.+) at (\d+)([ap])m? on (.+) for (\d+) (.+)s?$/.match text

  def matches? text
    @match = REGEXP.match text
  end

  def event now
    _, title, hour, ap = *@match
    time = day now, hour.to_i
    Avocado::Event.new.tap do |event|
      event.title = title
      event.start_time = time
      event.end_time = time
    end
  end

  def day now, hour
    hour += 12 if now.hour >= hour
    Time.new now.year, now.month, now.day, hour
  end
end

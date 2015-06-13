require 'avocado/event'

class Avocado::EventBuilder
  attr_reader :errors, :now

  SHORT_DAYNAMES = %w{su mo tu we th fr sa}

  def initialize now=Time.now, tz=nil
    @now, @tz = now, tz
  end

  def usage
    puts "The event was not recognised.  Current patterns are:"
    puts "  Call Mum in 15 minutes"
    puts "  Turn off oven in 2 hours"
    puts "  Medical appointment at 7"
  end

  def build(text)
    match = /^(.+) for (\d+) (.+)s? on (.+) at (\d+)([ap])m?$/.match text
    return event(match[1], 1, 1) if match
    match = /^(.+) for (\d+) (.+)s? at (\d+)([ap])m?$/.match text
    return event(match[1], 1, 1) if match
    match = /^(.+) in (\d+) ([m|h])\w*$/.match text
    return relative_from_now match if match
    match = /^(.+) at (\d+)([ap])?m?$/.match text
    return specific_time match if match
  end

  private

  def specific_time match
    _, title, hour, ap = *match
    time = day hour.to_i
    event(title, time, time)
  end

  def day hour
    hour += 12 if now.hour >= hour
    Time.new now.year, now.month, now.day, hour
  end

  def relative_from_now match
    _, title, quantity, unit = *match
    future_time = @now + increment(quantity,unit)
    event(title, future_time, future_time)
  end

  def increment quantity, unit
    quantity = quantity.to_i
    unit = unit == 'm' ? 60 : 60*60
    quantity * unit
  end

  def event(title, start_time, end_time)
    Avocado::Event.new.tap do |event|
      event.title = title
      event.start_time = start_time
      event.end_time = end_time
    end
  end
end

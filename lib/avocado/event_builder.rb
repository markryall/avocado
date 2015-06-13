require 'avocado/event'

class Avocado::EventBuilder
  attr_reader :errors

  SHORT_DAYNAMES = %w{su mo tu we th fr sa}

  def initialize now=Time.now, tz=nil
    @now, @tz = now, tz
  end

  def build(text)
    @errors = ["\"#{text}\" was not recognised"]
    match = /^(.+) for (\d+) (.+)s? on (.+) at (\d+)([ap])m?$/.match text
    return event(match[1], 1, 1) if match
    match = /^(.+) for (\d+) (.+)s? at (\d+)([ap])m?$/.match text
    return event(match[1], 1, 1) if match
    match = /^(.+) in (\d+) ([m|h])\w*$/.match text
    return relative_from_now match if match
    match = /^(.+) at (\d+)([ap])?m?$/.match text
    return event(match[1], increment(match[2], match[3]), 1) if match
  end

  private

  def relative_from_now match
    future_time = @now + increment(match[2], match[3])
    event(match[1], future_time, future_time)
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

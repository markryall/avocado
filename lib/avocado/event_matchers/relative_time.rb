class Avocado::EventMatchers::RelativeTime
  REGEXP = /^(.+) in (\d+) ([m|h])\w*$/

  def matches? text
    @match = REGEXP.match text
  end

  def event now
    _, title, quantity, unit = *@match
    future_time = now + increment(quantity,unit)
    Avocado::Event.new.tap do |event|
      event.title = title
      event.start_time = future_time
      event.end_time = future_time
    end
  end

  def increment quantity, unit
    quantity = quantity.to_i
    unit = unit == 'm' ? 60 : 60*60
    quantity * unit
  end
end

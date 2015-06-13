require 'avocado/event'

class Avocado::EventBuilder
  attr_reader :event

  def initialize *text
    @event = Avocado::Event.new
    event.start_time = Time.new(2015,6,1)
    event.end_time = event.start_time + (60*60)
    event.all_day = true
    event.title = "Birthday"
    event.location = 'fancy restaurant'
    event.description = 'delicious food and conversation'
    event.timezone = 'Australia/Brisbane'
    event.repeat = :yearly
  end

  def errors
    ['invalid']
  end
end

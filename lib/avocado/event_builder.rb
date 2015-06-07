class Avocado::EventBuilder
  def self.build *args
    new(*args).build
  end

  attr_reader :start_time, :end_time, :all_day, :title, :location, :description, :timezone

  def initialize *args
    @start_time = Time.now
    @end_time = Time.now + (60*60)
    @all_day = false
    @title = 'go on a date together'
    @location = 'fancy restaurant'
    @description = 'delicious food and conversation'
    @timezone = 'Australia/Brisbane'
  end

  def errors
    ['invalid']
  end

  def build
    {
      start: (start_time.to_i * 1000),
      'end': (end_time.to_i * 1000),
      all_day: (all_day ? 'true' : 'false'),
      title: title,
      location: location,
      description: description,
      timezone: timezone
    }
  end
end

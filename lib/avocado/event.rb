class Avocado::Event
  attr_accessor :start_time, :end_time, :all_day, :repeat
  attr_accessor :title, :location, :description, :timezone

  def params
    {}.tap do |hash|
      hash[:start] = start_time.to_i * 1000 if start_time
      hash[:end] = end_time.to_i * 1000 if end_time
      hash[:all_day] = all_day ? 'true' : 'false'
      hash[:title] = title if title
      hash[:location] = location if location
      hash[:description] = description if description
      hash[:timezone] = timezone if timezone
      hash[:repeat] = repeat if repeat
    end
  end
end

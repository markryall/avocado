module Avocado::EventMatchers
  def self.matchers
    %w(relative_time absolute_time_without_day_or_duration).map do |name|
      require_relative "event_matchers/#{name}"
      class_name = name.to_s.split('_').map(&:capitalize).join
      Avocado::EventMatchers.const_get(class_name).new
    end
  end
end

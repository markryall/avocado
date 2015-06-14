module Avocado::EventMatchers
  def classify string
    string.to_s.split('_').map(&:capitalize).join
  end

  def matcher name
    require_relative "event_matchers/#{name}"
    Avocado::EventMatchers.const_get classify name
  end

  def matchers
    %w(relative_time absolute_time_without_day).map {|name| matcher(name).new }
  end
end

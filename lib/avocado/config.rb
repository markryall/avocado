require 'yaml'

module Avocado
end

class Avocado::Config
  def initialize
    @preferences = {}
    @preferences = YAML.load_file preferences_path if File.exists? preferences_path
  end

  def [] key
    unless @preferences[key]
      print "#{key}: "
      self[key] = gets.chomp
    end
    @preferences[key]
  end

  def []= key, value
    @preferences[key] = value
    persist
  end

  private

  def preferences_path
    File.expand_path('~')+'/.avocado'
  end

  def persist
    File.open(preferences_path, 'w') {|f| f.puts @preferences.to_yaml}
  end
end

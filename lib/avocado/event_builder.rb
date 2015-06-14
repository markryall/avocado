require 'avocado/event'
require 'avocado/event_matchers'

class Avocado::EventBuilder
  SHORT_DAYNAMES = %w{su mo tu we th fr sa}

  def initialize now=Time.now
    @now, @matchers = now, Avocado::EventMatchers.matchers
  end

  def usage
    puts "The event was not recognised.  Current patterns are:"
    puts "  Call Mum in 15 minutes"
    puts "  Turn off oven in 2 hours"
    puts "  Medical appointment at 7"
  end

  def build(text)
    @matchers.each do |matcher|
      return matcher.event @now if matcher.matches? text
    end
  end
end

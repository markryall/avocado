require 'avocado/event'
require 'avocado/event_matchers'

class Avocado::EventBuilder
  def initialize now=Time.now
    @now, @matchers = now, Avocado::EventMatchers.matchers
  end

  def usage
    puts <<EOF
That event was not recognised.
Here are examples of recognisable patterns:
  Call Mum in 15 minutes
  Turn off oven in 2 hours
  Attend medical appointment at 7am
  Go to gym at 6:45pm for 2 hours
  Go white water rafting at 8am on Saturday for 6 hours
  Fly to Paris at 7:13am on 17th August
EOF
  end

  def build(text)
    @matchers.each do |matcher|
      return matcher.event @now if matcher.matches? text
    end
    nil
  end
end

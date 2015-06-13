require_relative '../spec_helper'
require 'avocado/event_builder'

describe Avocado::EventBuilder do
  def build description
    Avocado::EventBuilder.new 1465286400, 'Australia/Brisbane', description
  end

  it "can parse single event for a future day" do
    builder = build 'gym for 1 hour on Thursday at 12pm'
    builder.event.params[:start].must_equal 1433666226000
  end
end

# birthday every 27th june
# meet friend for lunch next thursday at 12p

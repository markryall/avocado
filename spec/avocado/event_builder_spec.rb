require_relative '../spec_helper'
require 'avocado/event_builder'

module Times
  def seconds
    self
  end

  def minutes
    seconds * 60
  end

  def hours
    minutes * 60
  end

  def days
    hours * 24
  end
end

Fixnum.include Times

describe Avocado::EventBuilder do
  SUNDAY_6PM    = Time.utc(2015, 06, 07, 18)
  THURSDAY_12PM = Time.utc(2015, 06, 11, 12)
  THURSDAY_1PM  = Time.utc(2015, 06, 11, 13)
  THURSDAY_3PM  = Time.utc(2015, 06, 11, 15)

  let(:builder) { Avocado::EventBuilder.new SUNDAY_6PM.to_i, 'UTC' }

  [
    ['call mum at 7',                              'call mum', THURSDAY_12PM, THURSDAY_1PM],
     ['call mum at 7pm',                            'call mum', THURSDAY_12PM, THURSDAY_1PM],
     ['go to gym for 1 hour at 7pm',                'go to gym', THURSDAY_12PM, THURSDAY_1PM],
     ['go swimming for 1 hour on Thursday at 12pm', 'go swimming', THURSDAY_12PM, THURSDAY_1PM],
     ['go to gym for 3 hours on Thursday at 12pm',  'go to gym', THURSDAY_12PM, THURSDAY_3PM]
  ].each do |args|
    description, title, start_time, end_time = *args
    it description do
      event = builder.build description
      event.params[:title].must_equal title
    end
  end
end

# birthday every 27th june
# meet friend for lunch next thursday at 12p

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
  SUNDAY_6PM     = Time.new(2015, 06, 07, 18)
  SUNDAY_6_05_PM = Time.new(2015, 06, 07, 18, 5)
  SUNDAY_7PM     = Time.new(2015, 06, 07, 19)
  THURSDAY_12PM  = Time.new(2015, 06, 11, 12)
  THURSDAY_1PM   = Time.new(2015, 06, 11, 13)
  THURSDAY_3PM   = Time.new(2015, 06, 11, 15)

  let(:builder) { Avocado::EventBuilder.new SUNDAY_6PM }

  [
    ['turn off stove in 5 minutes',                'turn off stove', SUNDAY_6_05_PM, SUNDAY_6_05_PM],
    ['call mum in 1 hour',                         'call mum', SUNDAY_7PM, SUNDAY_7PM],
    ['call mum at 19',                             'call mum', SUNDAY_7PM, SUNDAY_7PM],
    ['call mum at 7pm',                            'call mum', SUNDAY_7PM, SUNDAY_7PM],
    ['call mum at 7',                              'call mum', SUNDAY_7PM, SUNDAY_7PM],
    ['go to gym at 7pm for 1 hour',                'go to gym', nil, nil],
    ['call mum at 7pm on Thursday',                'call mum', nil, nil],
    ['go swimming at 12pm on Thursday for 1 hour', 'go swimming', nil, nil],
    ['go to gym at 12pm on Thursday for 3 hours',  'go to gym', nil, nil],
    ['go swimming at 12pm for 1 hour on Thursday', 'go swimming', nil, nil],
  ].each do |args|
    description, title, start_time, end_time = *args
    it description do
      event = builder.build description
      event.title.must_equal title
      event.start_time.must_equal start_time if start_time
      event.end_time.must_equal end_time if end_time
    end
  end
end

# birthday every 27th june
# meet friend for lunch next thursday at 12p

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
  SUNDAY_1805 = Time.new(2015,  6,  7, 18,  5)
  SUNDAY_1810 = Time.new(2015,  6,  7, 18, 10)
  SUNDAY_1900 = Time.new(2015,  6,  7, 19)
  SUNDAY_1905 = Time.new(2015,  6,  7, 19,  5)
  SUNDAY_2000 = Time.new(2015,  6,  7, 20)
  MONDAY_0700 = Time.new(2015,  6,  8,  7)
  MONDAY_1800 = Time.new(2015,  6,  8,  18)

  let(:builder) { Avocado::EventBuilder.new SUNDAY_1805 }

  [
    ['turn off stove in 5 minutes',                'turn off stove', SUNDAY_1810, SUNDAY_1810],
    ['call mum in 1 hour',                         'call mum',       SUNDAY_1905, SUNDAY_1905],
    ['call mum at 19',                             'call mum',       SUNDAY_1900, SUNDAY_1900],
    ['call mum at 7pm',                            'call mum',       SUNDAY_1900, SUNDAY_1900],
    ['call mum at 7am',                            'call mum',       MONDAY_0700, MONDAY_0700],
    ['call mum at 7',                              'call mum',       MONDAY_0700, MONDAY_0700],
    ['call mum at 18',                             'call mum',       MONDAY_1800, MONDAY_1800],
    ['go to gym at 7pm for 1 hour',                'go to gym',      SUNDAY_1900, SUNDAY_2000],
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

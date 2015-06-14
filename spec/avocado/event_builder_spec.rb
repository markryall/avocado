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
  SUNDAY_1_1805   = Time.new(2015,  6,  7, 18,  5)
  SUNDAY_1_1810   = Time.new(2015,  6,  7, 18, 10)
  SUNDAY_1_1900   = Time.new(2015,  6,  7, 19)
  SUNDAY_1_1905   = Time.new(2015,  6,  7, 19,  5)
  SUNDAY_1_2000   = Time.new(2015,  6,  7, 20)
  MONDAY_1_0700   = Time.new(2015,  6,  8,  7)
  MONDAY_1_1800   = Time.new(2015,  6,  8, 18)
  THURSDAY_1_1200 = Time.new(2015,  6, 11, 12)
  THURSDAY_1_1300 = Time.new(2015,  6, 11, 13)
  THURSDAY_1_1500 = Time.new(2015,  6, 11, 15)
  THURSDAY_1_1900 = Time.new(2015,  6, 11, 19)
  SUNDAY_2_1900   = Time.new(2015,  6, 14, 19)

  let(:builder) { Avocado::EventBuilder.new SUNDAY_1_1805 }

  [
    ['turn off stove in 5 minutes',                'turn off stove', SUNDAY_1_1810,   SUNDAY_1_1810],
    ['call mum in 1 hour',                         'call mum',       SUNDAY_1_1905,   SUNDAY_1_1905],
    ['call mum at 19',                             'call mum',       SUNDAY_1_1900,   SUNDAY_1_1900],
    ['call mum at 7pm',                            'call mum',       SUNDAY_1_1900,   SUNDAY_1_1900],
    ['call mum at 7am',                            'call mum',       MONDAY_1_0700,   MONDAY_1_0700],
    ['call mum at 7',                              'call mum',       MONDAY_1_0700,   MONDAY_1_0700],
    ['call mum at 18',                             'call mum',       MONDAY_1_1800,   MONDAY_1_1800],
    ['go to gym at 7pm for 1 hour',                'go to gym',      SUNDAY_1_1900,   SUNDAY_1_2000],
    ['call mum at 7pm on Thursday',                'call mum',       THURSDAY_1_1900, THURSDAY_1_1900],
    ['call mum at 7pm on Sunday',                  'call mum',       SUNDAY_2_1900, SUNDAY_2_1900],
    ['go swimming at 12pm on Thursday for 1 hour', 'go swimming',    THURSDAY_1_1200, THURSDAY_1_1300],
    ['go to gym at 12pm on Thursday for 3 hours',  'go to gym',      THURSDAY_1_1200, THURSDAY_1_1500],
    ['go swimming at 12pm for 1 hour on Thursday', 'go swimming',    THURSDAY_1_1200, THURSDAY_1_1300],
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

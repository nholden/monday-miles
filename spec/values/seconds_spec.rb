require 'rails_helper'

RSpec.describe Seconds do

  Given(:seconds) { Seconds.new(quantity) }

  describe "#to_duration" do
    When(:result) { seconds.to_duration }

    context "when quantity is zero" do
      Given(:quantity) { 0 }
      Then { result == '0:00' }
    end

    context "when quantity is less than ten seconds" do
      Given(:quantity) { 9 }
      Then { result == '0:09' }
    end

    context "when quantity is less than a minute" do
      Given(:quantity) { 59 }
      Then { result == '0:59' }
    end

    context "when quantity is a minute" do
      Given(:quantity) { 60 }
      Then { result == '1:00' }
    end

    context "when quantity is between a minute and ten minutes" do
      Given(:quantity) { 599 }
      Then { result == '9:59' }
    end

    context "when quantity is ten minutes" do
      Given(:quantity) { 600 }
      Then { result == '10:00' }
    end

    context "when quantity is less than an hour" do
      Given(:quantity) { 3_599 }
      Then { result == '59:59' }
    end

    context "when quantity is an hour" do
      Given(:quantity) { 3_600 }
      Then { result == '1:00:00' }
    end

    context "when quantity is an hour and a second" do
      Given(:quantity) { 3_601 }
      Then { result == '1:00:01' }
    end

    context "when quantity is an hour, a minute, and a second" do
      Given(:quantity) { 3_661 }
      Then { result == '1:01:01' }
    end

    context "when quantity is two hours, two minutes, and fifty-seven seconds" do
      Given(:quantity) { 7_377 }
      Then { result == '2:02:57' }
    end

    context "when quantity is negative two hours, two minutes, and fifty-seven seconds" do
      Given(:quantity) { -7_377 }
      Then { result == '-2:02:57' }
    end
  end

end

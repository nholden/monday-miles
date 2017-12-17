require 'rails_helper'

RSpec.describe ActivityDecorator do

  Given(:activity) { Activity.new(attributes) }
  Given(:attributes) { FactoryGirl.attributes_for(:activity, polyline: polyline) }
  Given(:decorator) { activity.decorate }

  describe "#vue_data" do
    When(:result) { decorator.vue_data }

    context "when activity has a polyline" do
      Given(:polyline) { 'def456' }
      Then { result[:map].present? }
    end

    context "when activity does not have a polyline" do
      Given(:polyline) { nil }
      Then { result[:map].nil? }
    end
  end

end

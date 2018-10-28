# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSlugGenerator do

  Given(:generator) { UserSlugGenerator.new(first_name: 'Meb', last_name: 'Keflezighi') }

  describe "#generate" do
    When(:result) { generator.generate }

    context "when no user exists with default slug" do
      Then { result == 'meb-keflezighi' }
    end

    context "when a user exists with default slug" do
      Given { FactoryGirl.create(:user, slug: 'meb-keflezighi') }
      Then { result == 'meb-keflezighi-0' }
    end

    context "when a user exists with default slug and numbered slug" do
      Given { FactoryGirl.create(:user, slug: 'meb-keflezighi') }
      Given { FactoryGirl.create(:user, slug: 'meb-keflezighi-0') }

      Then { result == 'meb-keflezighi-1' }
    end

    context "when user name has spaces and non-letter characters" do
      Given { generator.first_name = 'Meb Keflezighi' }
      Given { generator.last_name = '🇺🇸' }

      Then { result == 'meb-keflezighi' }
    end
  end

end

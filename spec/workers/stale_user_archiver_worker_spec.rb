# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StaleUserArchiverWorker do

  Given(:worker) { StaleUserArchiverWorker.new }

  describe "#perform" do
    Given!(:user) { FactoryGirl.create(:user, last_signed_in_at: last_signed_in_at) }
    Given!(:activity) { FactoryGirl.create(:activity, user: user) }

    When { worker.perform }
    When { user.reload }

    context "archives a user who hasn't logged in during the last two months" do
      Given(:last_signed_in_at) { 3.months.ago }

      Then { user.archived? }
      And { user.activities.none? }
    end

    context "doesn't archive a user who logged in during the last two months" do
      Given(:last_signed_in_at) { 1.month.ago }

      Then { !user.archived? }
      And { user.activities.one? }
    end
  end

end

require 'test_helper'
require_relative 'event_spec_helper'

include EventSpecHelper

describe EventUseCase do
  describe "destroy" do
    it "successfully destroys an event if the user has permission" do
      event = Factory.create(:event)
      owner = Factory.create(:owner, :gathering => event.gathering)
      contributor = Factory.create(:contributor, :gathering => event.gathering)
      
      response = use_event(:id => event.id, :user => owner.user).destroy
      response.ok?.must_equal(true)
      response = use_event(:id => event.id, :user => contributor.user).destroy
      response.ok?.must_equal(true)
    end

    it "returns an error when the requesting user does not have permission" do
      event = Factory.create(:event)
      gathering_user = Factory.create(:reader, :gathering => event.gathering)
      
      response = use_event(:id => event.id, :user => gathering_user.user).destroy
      response.ok?.must_equal(false)
      response.errors.must_include(:access_denied)
      response = use_event(:id => event.id, :user => User.new).destroy
      response.ok?.must_equal(false )
      response.errors.must_include(:access_denied)
    end
  end
end

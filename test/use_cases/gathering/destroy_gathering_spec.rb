require 'test_helper'
require_relative 'gathering_spec_helper'

include GatheringSpecHelper

describe GatheringUseCase do
  describe "destroy" do
    it "can only be destroyed by an owner" do
      reader = Factory.create(:reader)
      owner = Factory.create(:owner, :gathering => reader.gathering)
      gathering = owner.gathering
      response = use_gathering(:id => gathering.id, :user => reader.user).destroy
      response.ok?.must_equal(false)
      response.errors.must_include(:access_denied)
      response = use_gathering(:id => gathering.id, :user => owner.user).destroy
      response.ok?.must_equal(true)
      response.gathering.persisted?.must_equal(false)
      GatheringUser.where(:gathering_id => gathering.id).all.must_be_empty
    end
    
    it "successfully destroys a Gathering without Events and destroys any Gathering Users as well" do
      owner = Factory.create(:owner)
      gathering = owner.gathering
      response = use_gathering(:id => gathering.id, :user => owner.user).destroy
      response.ok?.must_equal(true)
      GatheringUser.where(:gathering_id => gathering.id).all.must_be_empty
    end
    
    it "successfully destroys a Gathering with at least one Event and destroys any subsequent Events" do
      event = Factory.create(:event)
      gathering = event.gathering
      owner = Factory.create(:owner, :gathering => gathering)
      response = use_gathering(:id => gathering.id, :user => owner.user).destroy
      response.ok?.must_equal(true)
      Event.where(:id => event.id).must_be_empty
      GatheringUser.where(:gathering_id => gathering.id).all.must_be_empty
    end
  end
end

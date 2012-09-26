require 'test_helper'
require_relative 'gathering_user_spec_helper'

include GatheringUserSpecHelper

describe GatheringUserUseCase do
  describe "destroy" do
    it "successfully destroys a gathering user if it's not the last owner entry for the related gathering and the requesting user has permission" do
      gathering_user_1 = Factory.create(:owner)
      gathering_user_2 = Factory.create(:owner, :gathering => gathering_user_1.gathering)
      response = use(:id => gathering_user_1.id, :user => gathering_user_1.user).destroy
      response.ok?.must_equal(true)
      GatheringUser.find_by_id(gathering_user_2.id).wont_be_nil
    end
    
    it "returns an error if attempting to delete the last owner for the related gathering" do
      gathering_user = Factory.create(:owner)
      response = use(:id => gathering_user.id, :user => gathering_user.user).destroy
      response.ok?.must_equal(false)
      response.errors.must_include(:unable_to_destroy_last_owner)
    end
    
    it "returns an error if attempting to destroy a gathering user that does not exist" do
      user = Factory.create(:user)
      response = use(:id => 0, :user => user).destroy
      response.ok?.must_equal(false)
      response.errors.must_include(:record_not_found)
    end
    
    it "returns an error if attempting to destroy a gathering user and the requesting user does not have permission" do
      gathering_user_other = Factory.create(:owner)
      gathering_user_owner = Factory.create(:owner) 
      gathering_user_destroy = Factory.create(:reader, :gathering => gathering_user_owner.gathering)
      response = use(:id => gathering_user_destroy.id, :user => gathering_user_other.user).destroy
      response.ok?.must_equal(false)
      response.errors.must_include(:access_denied)
    end
  end
end
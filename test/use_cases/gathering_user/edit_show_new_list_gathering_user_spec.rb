require 'test_helper'
require_relative 'gathering_user_spec_helper'

include GatheringUserSpecHelper

describe GatheringUserUseCase do
  describe "edit" do
    it "returns the desired GatheringUser for edit" do
      gathering_owner = Factory.create(:owner)
      gathering_reader = Factory.create(:reader, :gathering => gathering_owner.gathering)
      response = use(:id => gathering_reader.id, :user => gathering_owner.user).edit
      response.ok?.must_equal(true)
      response.gathering_user.must_equal(gathering_reader)
      response.gathering_user.id.must_equal(gathering_reader.id)
    end
    
    it "returns errors if the Gathering does not exist for edit" do
      response = use(:id => 0, :user => Factory.build(:user)).edit
      response.ok?.must_equal(false)
      response.errors.must_include(:record_not_found)
    end
    
    it "returns an error if the requesting user does not have permission to edit the GatheringUser" do
      gathering_owner = Factory.create(:owner)
      gathering_reader = Factory.create(:reader)
      response = use(:id => gathering_reader.gathering.id, :user => gathering_owner.user).edit
      response.ok?.must_equal(false)
      response.errors.must_include(:access_denied)
    end
  end
  
  describe "show" do
    it "returns the desired gathering_user for show" do
      gathering_owner = Factory.create(:owner)
      gathering_reader = Factory.create(:reader, :gathering => gathering_owner.gathering)
      response = use(:id => gathering_reader.id, :user => gathering_owner.user).show
      response.ok?.must_equal(true)
      response.gathering_user.must_equal(gathering_reader)
      response.gathering_user.id.must_equal(gathering_reader.id)
    end
    
    it "returns errors if the Gathering does not exist for show" do
      response = use(:id => 0, :user => Factory.build(:user)).show
      response.ok?.must_equal(false)
      response.errors.must_include(:record_not_found)
    end
    
    it "returns an error if the requesting user does not have permission to edit the GatheringUser" do
      gathering_owner = Factory.create(:owner)
      gathering_reader = Factory.create(:reader)
      response = use(:id => gathering_reader.gathering.id, :user => gathering_owner.user).show
      response.ok?.must_equal(false)
      response.errors.must_include(:access_denied)
    end
  end
  
  describe "new" do
    it "returns an new Gathering instance" do
      user = Factory.create(:user)
      response = use(:user => user).new
      response.ok?.must_equal(true)
      response.gathering_user.must_be_instance_of(GatheringUser)
      response.gathering_user.persisted?.must_equal(false)
    end
  end
  
  describe "list" do
    
    it "returns a list of all GatheringUsers to which the current user is associated" do
      gathering_user_1 = Factory.create(:owner)
      gathering_user_2 = Factory.create(:reader, :user => gathering_user_1.user)
      gathering_user_3 = Factory.create(:contributor, :gathering => gathering_user_1.gathering)
      
      response = use(:user => gathering_user_1.user).list
      response.gathering_users.size.must_equal(2)
      response.gathering_users.must_include(gathering_user_1)
      response.gathering_users.must_include(gathering_user_2)
      response.gathering_users.wont_include(gathering_user_3)
    end
    
    describe "by Gathering" do
      it "returns a list of both GatheringUsers and Users to which the specified gathering is associated if the current user has association to the gathering" do
        gathering_user = Factory.create(:owner)
        Factory.create(:owner)
        response = use(:gathering_id => gathering_user.gathering_id, :user => gathering_user.user).list
        response.users.size.must_equal(1)
        response.users.first.must_equal(gathering_user.user)
      end
      it "returns an error if the current user does not have association to the specified gathering" do
        gathering_user_1 = Factory.create(:owner)
        gathering_user_2 = Factory.create(:owner)
        response = use(:gathering_id => gathering_user_1.gathering_id, :user => gathering_user_2.user).list
        response.ok?.must_equal(false)
        response.errors.must_include(:access_denied)
      end
    end
  end

end


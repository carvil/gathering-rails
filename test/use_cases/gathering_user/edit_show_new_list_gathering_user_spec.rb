require 'test_helper'

include UseCases

describe GatheringUserUseCase do
  describe "edit" do
    it "returns the desired GatheringUser for edit" do
      gathering_user = Factory.create(:owner)
      response = GatheringUserUseCase.new(:id => gathering_user.id).edit
      response.ok?.must_equal(true)
      response.gathering_user.must_equal(gathering_user)
      response.gathering_user.id.must_equal(gathering_user.id)
    end
    
    it "returns errors if the Gathering does not exist for edit" do
      response = GatheringUserUseCase.new(:id => 0).edit
      response.ok?.must_equal(false)
      response.errors.must_include(:record_not_found)
    end
  end
  
  describe "show" do
    it "returns the desired gathering_user for show" do
      gathering_user = Factory.create(:owner)
      response = GatheringUserUseCase.new(:id => gathering_user.id).edit
      response.ok?.must_equal(true)
      response.gathering_user.must_equal(gathering_user)
      response.gathering_user.id.must_equal(gathering_user.id)
    end
    
    it "returns errors if the Gathering does not exist for show" do
      response = GatheringUserUseCase.new(:id => 0).edit
      response.ok?.must_equal(false)
      response.errors.wont_be_nil
    end
  end
  
  describe "new" do
    it "returns an new Gathering instance" do
      response = GatheringUserUseCase.new.new
      response.ok?.must_equal(true)
      response.gathering_user.must_be_instance_of(GatheringUser)
      response.gathering_user.persisted?.must_equal(false)
    end
  end
  
  describe "list" do
    
    it "returns a list of all GatheringUsers in the system" do
      gathering_user_1 = Factory.create(:owner)
      gathering_user_2 = Factory.create(:reader)
      gathering_user_3 = Factory.build(:contributor, :gathering => gathering_user_1.gathering)
      
      response = GatheringUserUseCase.new.list
      response.gathering_users.size.must_equal(2)
      response.gathering_users.must_include(gathering_user_1)
      response.gathering_users.must_include(gathering_user_2)
      response.gathering_users.wont_include(gathering_user_3)
    end
    
    describe "by User" do
      it "returns a list of both GatheringUsers and Gatherings to which the user is associated" do
        gathering_user = Factory.create(:owner)
        Factory.create(:owner)
        response = GatheringUserUseCase.new(:user_id => gathering_user.user_id).list
        response.gatherings.size.must_equal(1)
        response.gatherings.first.must_equal(gathering_user.gathering)
      end
    end
    describe "by Gathering" do
      it "returns a list of both GatheringUsers and Users to which the gathering is associated" do
        gathering_user = Factory.create(:owner)
        Factory.create(:owner)
        response = GatheringUserUseCase.new(:gathering_id => gathering_user.gathering_id).list
        response.users.size.must_equal(1)
        response.users.first.must_equal(gathering_user.user)
      end
    end
  end

end


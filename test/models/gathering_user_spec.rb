require 'test_helper'

def valid_gathering_user
  Factory.build(:reader)
end

def new_gathering_user
  GatheringUser.new
end

describe GatheringUser do
  
  it "returns a list of roles available" do
    GatheringUser.role_list.wont_be_empty
  end
  it "has a finder method for each role" do
    GatheringUser.role_list.each do |role_name|
      GatheringUser.must_respond_to("all_#{role_name}s")
    end
  end
  
  describe "Attributes" do
    it "has a user" do
      new_gathering_user.must_respond_to(:user)
    end
    it "has a gathering" do
      new_gathering_user.must_respond_to(:gathering)
    end
    it "has a role" do
      new_gathering_user.must_respond_to(:role)
    end
  end
  
  describe "Methods" do
    it "has a setter method for each role" do
      GatheringUser.role_list.each do |role_name|
        new_gathering_user.must_respond_to("set_role_as_#{role_name}!")
      end
    end
    it "has a checker method for each role" do
      GatheringUser.role_list.each do |role_name|
        new_gathering_user.must_respond_to("is_#{role_name}?")
      end
    end
    it "has a single_owner? method that describes whether the gathering user is the only owner of a gathering" do
      gathering_user_1 = valid_gathering_user
      gathering_user_1.set_role_as_owner!
      gathering_user_1.save
      gathering_user_1.single_owner?.must_equal(true)
      gathering_user_2 = valid_gathering_user
      gathering_user_2.gathering = gathering_user_1.gathering
      gathering_user_2.set_role_as_owner!
      gathering_user_2.save
      gathering_user_2.single_owner?.must_equal(false)
    end
    it "has a find_by_gathering_and_user method that will return the gathering user record corresponding to the passed gathering and user ids" do
      gathering_user1 = valid_gathering_user; gathering_user1.save;
      gathering_user2 = valid_gathering_user; gathering_user2.save;
      gathering_user3 = valid_gathering_user
      gathering_user3.gathering_id = gathering_user2.gathering_id
      gathering_user3.save
      
      GatheringUser.find_by_gathering_and_user(gathering_user1.gathering_id, gathering_user1.user_id).id.must_equal(gathering_user1.id)
      GatheringUser.find_by_gathering_and_user(gathering_user2.gathering_id, gathering_user2.user_id).id.must_equal(gathering_user2.id)
      GatheringUser.find_by_gathering_and_user(gathering_user3.gathering_id, gathering_user3.user_id).id.must_equal(gathering_user3.id)
      GatheringUser.find_by_gathering_and_user(gathering_user1.gathering_id, gathering_user3.user_id).must_be_nil
    end
  end
  
  describe "Validity" do
    it "is valid with valid attributes" do
      valid_gathering_user.valid?.must_equal(true)
    end
    it "is invalid without a user" do
      gathering = valid_gathering_user
      gathering.user = nil
      gathering.valid?.must_equal(false)
    end
    it "is invalid without a gathering" do
      gathering = valid_gathering_user
      gathering.gathering = nil
      gathering.valid?.must_equal(false)
    end
    it "is invalid without a role" do
      gathering = valid_gathering_user
      gathering.role = nil
      gathering.valid?.must_equal(false)
    end
  end
end
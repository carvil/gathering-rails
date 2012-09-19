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
require 'test_helper'
require_relative 'gathering_user_spec_helper'

include GatheringUserSpecHelper

describe GatheringUserUseCase do  
  describe "create" do    
    def valid_attributes
      gathering = Factory.create(:gathering)
      user = Factory.create(:user)
      {
        :gathering => gathering,
        :user => user,
        :role => "owner"
      }
    end
  
    it "successfully creates and persists a new Gathering User" do
      atts = valid_attributes
      response = use_gathering_user(:atts => atts, :user => atts[:user]).create
      
      response.ok?.must_equal(true)
      gathering_user = response.gathering_user
      gathering_user.id.wont_be_nil
      gathering_user.gathering.must_equal(atts[:gathering])
      gathering_user.user.must_equal(atts[:user])
      gathering_user.role.must_equal(atts[:role])
      
    end
    
    it "successfully creates and persists a new GatheringUser when a Gathering and User ID are passed as a String instead of a Gathering or User object (like an HTML form submission)" do
      atts = valid_attributes
      gathering = atts[:gathering]
      user = atts[:user]
      atts = atts.merge(:gathering => atts[:gathering].id.to_s, :user => atts[:user].id.to_s)
      
      response = use_gathering_user(:atts => atts, :user => user).create
      
      response.ok?.must_equal(true)
      gathering_user = response.gathering_user
      gathering_user.id.wont_be_nil
      gathering_user.gathering.must_equal(gathering)
      gathering_user.user.must_equal(user)
    end
    
    it "successfully creates and persists a new GatheringUser when a Gathering and User ID are passed as a Fixnum instead of a Gathering or User object" do
      atts = valid_attributes
      gathering = atts[:gathering]
      user = atts[:user]
      atts = atts.merge(:gathering => atts[:gathering].id.to_s, :user => atts[:user].id.to_s)
      
      response = use_gathering_user(:atts => atts, :user => user).create
      
      response.ok?.must_equal(true)
      gathering_user = response.gathering_user
      gathering_user.id.wont_be_nil
      gathering_user.gathering.must_equal(gathering)
      gathering_user.user.must_equal(user)
    end
    
    it "returns errors if the create GatheringUser request is not valid" do
      atts = valid_attributes
      user = atts[:user]
      response = use_gathering_user(:atts => atts.merge(:gathering => nil), :user => user).create
      response.ok?.must_equal(false)
      response.errors.must_include(:gathering_id)
      response = use_gathering_user(:atts => atts.merge(:gathering => Gathering.new), :user => user).create
      response.ok?.must_equal(false)
      response.errors.must_include(:gathering_id)
      
      response = use_gathering_user(:atts => atts.merge(:user => nil), :user => user).create
      response.ok?.must_equal(false)
      response.errors.must_include(:user_id)
      response = use_gathering_user(:atts => atts.merge(:user => User.new), :user => user).create
      response.ok?.must_equal(false)
      response.errors.must_include(:user_id)
      
      response = use_gathering_user(:atts => atts.merge(:role => ""), :user => user).create
      response.ok?.must_equal(false)
      response.errors.must_include(:role)
    end
    
    it "returns errors if creating two content user entries for the same user and gathering" do
      atts = valid_attributes
      gathering_user_orig = use_gathering_user(:atts => atts, :user => atts[:user]).create.gathering_user
      response = use_gathering_user(:atts => atts.merge(:role => 'contributor'), :user => atts[:user]).create
      response.ok?.must_equal(false)
      response.errors.wont_be_nil
    end
  end
end

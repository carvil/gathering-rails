require 'test_helper'
require_relative 'gathering_user_spec_helper'

include GatheringUserSpecHelper

describe GatheringUserUseCase do
  describe "update" do
    before :each do
      @gathering_user = Factory.create(:owner)
    end
    
    def new_attributes(atts = {})
      {
        :gathering => Factory.create(:gathering),
        :user => Factory.create(:user),
        :role => "reader"
      }.merge(atts)
    end
    
    it "updates a record when passed valid attributes" do
      new_atts = new_attributes
      response = use(:id => @gathering_user.id, :atts => new_atts).update
      response.ok?.must_equal(true)
      gathering_user = GatheringUser.find(response.gathering_user.id)
      gathering_user.gathering.must_equal(new_atts[:gathering])
      gathering_user.user.must_equal(new_atts[:user])
      gathering_user.role.must_equal(new_atts[:role])
    end
    
    it "successfully updates a GatheringUser when a Gathering and User ID are passed as a String instead of a Gathering or User object (like an HTML form submission)" do
      atts = new_attributes
      gathering = atts[:gathering]
      user = atts[:user]
      atts = atts.merge(:gathering => atts[:gathering].id.to_s, :user => atts[:user].id.to_s)
      
      response = use(:id => @gathering_user.id, :atts => atts).update
      
      response.ok?.must_equal(true)
      gathering_user = response.gathering_user
      gathering_user.id.wont_be_nil
      gathering_user.gathering.must_equal(gathering)
      gathering_user.user.must_equal(user)
    end
    
    it "successfully updates a GatheringUser when a Gathering and User ID are passed as a Fixnum instead of a Gathering or User object" do
      atts = new_attributes
      gathering = atts[:gathering]
      user = atts[:user]
      atts = atts.merge(:gathering => atts[:gathering].id.to_s, :user => atts[:user].id.to_s)
      
      response = use(:id => @gathering_user.id, :atts => atts).update
      
      response.ok?.must_equal(true)
      gathering_user = response.gathering_user
      gathering_user.id.wont_be_nil
      gathering_user.gathering.must_equal(gathering)
      gathering_user.user.must_equal(user)
    end
    
    it "returns an error when passing a blank or non-existent gathering" do
      response = use(:id => @gathering_user.id, :atts => new_attributes(:gathering => nil)).update
      response.ok?.must_equal(false)
      response.errors.must_include(:gathering_id)
      response = use(:id => @gathering_user.id, :atts => new_attributes(:gathering => Gathering.new)).update
      response.ok?.must_equal(false)
      response.errors.must_include(:gathering_id)
    end
    
    it "returns an error when passing a blank or non-existent user" do
      response = use(:id => @gathering_user.id, :atts => new_attributes(:user => nil)).update
      response.ok?.must_equal(false)
      response.errors.must_include(:user_id)
      response = use(:id => @gathering_user.id, :atts => new_attributes(:user => User.new)).update
      response.ok?.must_equal(false)
      response.errors.must_include(:user_id)
    end
    
    it "returns an error when passing a blank role" do
      response = use(:id => @gathering_user.id, :atts => new_attributes(:role => "")).update
      response.ok?.must_equal(false)
      response.errors.must_include(:role)
    end
  end
end

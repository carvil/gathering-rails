require 'test_helper'

include UseCases

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
      response = GatheringUserUseCase.new(:atts => atts).create
      
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
      
      response = GatheringUserUseCase.new(:atts => atts).create
      
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
      
      response = GatheringUserUseCase.new(:atts => atts).create
      
      response.ok?.must_equal(true)
      gathering_user = response.gathering_user
      gathering_user.id.wont_be_nil
      gathering_user.gathering.must_equal(gathering)
      gathering_user.user.must_equal(user)
    end
    
    it "returns errors if the create GatheringUser request is not valid" do
      atts = valid_attributes
      response = GatheringUserUseCase.new(:atts => atts.merge(:gathering => nil)).create
      response.ok?.must_equal(false)
      response.errors.must_include(:gathering_id)
      response = GatheringUserUseCase.new(:atts => atts.merge(:gathering => Gathering.new)).create
      response.ok?.must_equal(false)
      response.errors.must_include(:gathering_id)
      
      response = GatheringUserUseCase.new(:atts => atts.merge(:user => nil)).create
      response.ok?.must_equal(false)
      response.errors.must_include(:user_id)
      response = GatheringUserUseCase.new(:atts => atts.merge(:user => User.new)).create
      response.ok?.must_equal(false)
      response.errors.must_include(:user_id)
      
      response = GatheringUserUseCase.new(:atts => atts.merge(:role => "")).create
      response.ok?.must_equal(false)
      response.errors.must_include(:role)
    end
    
    it "returns errors if creating two content user entries for the same user and gathering" do
      atts = valid_attributes
      gathering_user_orig = GatheringUserUseCase.new(:atts => atts).create.gathering_user
      response = GatheringUserUseCase.new(:atts => atts.merge(:role => 'contributor')).create
      response.ok?.must_equal(false)
      response.errors.wont_be_nil
    end
  end
end

require 'test_helper'
require_relative 'gathering_user_spec_helper'

include GatheringUserSpecHelper

describe GatheringUserUseCase do
  describe "update" do
    before :each do
      @owner = Factory.create(:owner)
      @gathering_user = Factory.create(:owner, :gathering => @owner.gathering)
    end
    
    def new_attributes(atts = {})
      {
        :role => "contributor"
      }.merge(atts)
    end
    
    it "updates a record when passed valid attributes" do
      new_atts = new_attributes
      response = use_gathering_user(:id => @gathering_user.id, :atts => new_atts, :user => @owner.user).update
      response.ok?.must_equal(true)
      gathering_user = GatheringUser.find(response.gathering_user.id)
      gathering_user.role.must_equal(new_atts[:role])
    end   
    
    it "returns an error when passing a blank role" do
      response = use_gathering_user(:id => @gathering_user.id, :atts => new_attributes(:role => ""), :user => @owner.user).update
      response.ok?.must_equal(false)
      response.errors.must_include(:role)
    end
  end
end

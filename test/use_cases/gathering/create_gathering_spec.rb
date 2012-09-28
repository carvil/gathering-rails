require 'test_helper'
require_relative 'gathering_spec_helper'

include GatheringSpecHelper

describe GatheringUseCase do
  describe "create" do    
    def valid_attributes
      {
        :name => "Jane and John Doe Wedding",
        :description => "Jane and John Doe symbolically join their lives in the summer of 2013",
        :scheduled_date => "6/1/2013 17:00",
        :location => "Anywhere, USA"
      }
    end
    def new_user
      Factory.create(:user)
    end
  
    it "successfully creates and persists a new Gathering" do
      user = new_user
      atts = valid_attributes
      response = use_gathering(:atts => atts, :user => user).create
      response.ok?.must_equal(true)
      gathering = response.gathering
      gathering.id.wont_be_nil
      gathering.name.must_equal(atts[:name])
      gathering.description.must_equal(atts[:description])
      gathering.scheduled_date.must_equal(Time.zone.parse(atts[:scheduled_date]))
      gathering.location.must_equal(atts[:location])
    end
    
    it "successfully creates and persists a new Gathering User as owner when creating a new Gathering" do
      user = new_user
      response = use_gathering(:atts => valid_attributes, :user => user).create
      response.ok?.must_equal(true)
      GatheringUser.find_by_gathering_and_user(response.gathering.id, user.id).wont_be_nil
    end
    
    it "returns errors if the create Gathering request is not valid" do
      user = new_user
      response = use_gathering(:atts => valid_attributes.merge(:name => ""), :user => user).create
      response.ok?.must_equal(false)
      response.errors.must_include(:gathering_name)
      response = use_gathering(:atts => valid_attributes.merge(:description => ""), :user => user).create
      response.ok?.must_equal(false)
      response.errors.must_include(:gathering_description)
      response = use_gathering(:atts => valid_attributes.merge(:scheduled_date => nil), :user => user).create
      response.ok?.must_equal(false)
      response.errors.must_include(:gathering_scheduled_date)
      response = use_gathering(:atts => valid_attributes.merge(:location => ""), :user => user).create
      response.ok?.must_equal(true)
      response.errors.must_be_empty
    end
    
    it "returns errors if creating Gathering with a duplicate name" do
      user = new_user
      gathering_orig = use_gathering(:atts => valid_attributes, :user => user).create.gathering
      response = use_gathering(:atts => valid_attributes.merge(:name => gathering_orig.name), :user => user).create
      response.ok?.must_equal(false)
      response.errors.must_include(:gathering_name)
    end
    
    it "returns an error if the requesting user does not have permission (in this case if the user does not exist or is not persisted)" do
      response = use_gathering(:atts => valid_attributes, :user => User.new).create
      response.ok?.must_equal(false)
      response.errors.must_include(:access_denied)
      
      user = new_user
      user.destroy      
      response = use_gathering(:atts => valid_attributes, :user => user).create
      response.ok?.must_equal(false)
      response.errors.must_include(:access_denied)
    end
  end
end

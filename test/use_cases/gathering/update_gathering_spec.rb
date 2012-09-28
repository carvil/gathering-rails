require 'test_helper'
require_relative 'gathering_spec_helper'

include GatheringSpecHelper

describe GatheringUseCase do
  describe "update" do
    before :each do
      @gathering = Factory.create(:gathering)
      @owner = Factory.create(:owner, :gathering => @gathering)
    end
    
    def new_attributes(atts = {})
      {
        :name => "New Name",
        :description => "New Description",
        :scheduled_date => "6/2/2013 17:00",
        :location => "New Location"
      }.merge(atts)
    end
    
    it "updates a record when passed valid attributes" do
      new_atts = new_attributes
      response = use_gathering(:id => @gathering.id, :atts => new_atts, :user => @owner.user).update
      response.ok?.must_equal(true)
      gathering = Gathering.find(response.gathering.id)
      gathering.name.must_equal(new_atts[:name])
      gathering.description.must_equal(new_atts[:description])
      gathering.scheduled_date.must_equal(Time.zone.parse(new_atts[:scheduled_date]))
      gathering.location.must_equal(new_atts[:location])
    end
    
    it "returns a name error when passing a blank name" do
      response = use_gathering(:id => @gathering.id, :atts => new_attributes(:name => ""), :user => @owner.user).update
      response.ok?.must_equal(false)
      response.errors.must_include(:name)
    end
    
    it "returns an error when passing a blank description" do
      response = use_gathering(:id => @gathering.id, :atts => new_attributes(:description => ""), :user => @owner.user).update
      response.ok?.must_equal(false)
      response.errors.must_include(:description)
    end
    
    it "returns no errors when passing a blank location" do
      response = use_gathering(:id => @gathering.id, :atts => new_attributes(:location => ""), :user => @owner.user).update
      response.ok?.must_equal(true)
    end
    
    it "returns an error when the user does not have permission to update the gathering" do
      @reader = Factory.create(:reader, :gathering => @gathering)
      response = use_gathering(:id => @gathering.id, :atts => new_attributes, :user => @reader.user).update
      response.ok?.must_equal(false)
      response.errors.must_include(:access_denied)
      response = use_gathering(:id => @gathering.id, :atts => new_attributes, :user => nil).update
      response.ok?.must_equal(false)
      response.errors.must_include(:access_denied)
    end
  end
end

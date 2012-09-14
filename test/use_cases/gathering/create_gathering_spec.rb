require 'test_helper'

include UseCases

describe GatheringUseCase do
  describe "create" do    
    def valid_attributes
      {
        :name => "Jane and John Doe Wedding",
        :description => "Jane and John Doe symbolically join their lives in the summer of 2013",
        :location => "Anywhere, USA"
      }
    end
  
    it "successfully creates and persists a new Gathering" do
      response = GatheringUseCase.new(:atts => valid_attributes).create
      
      response.ok?.must_equal(true)
      gathering = response.gathering
      gathering.id.wont_be_nil
      gathering.name.must_equal(valid_attributes[:name])
      gathering.description.must_equal(valid_attributes[:description])
      gathering.location.must_equal(valid_attributes[:location])
      
    end
    
    it "returns errors if the create Gathering request is not valid" do
      response = GatheringUseCase.new(:atts => valid_attributes.merge(:name => "")).create
      response.ok?.must_equal(false)
      response.errors.must_include(:name)
      response = GatheringUseCase.new(:atts => valid_attributes.merge(:description => "")).create
      response.ok?.must_equal(false)
      response.errors.must_include(:description)
      response = GatheringUseCase.new(:atts => valid_attributes.merge(:location => "")).create
      response.ok?.must_equal(true)
      response.errors.must_be_nil
    end
    
    it "returns errors if creating Gathering with a duplicate name" do
      gathering_orig = GatheringUseCase.new(:atts => valid_attributes).create.gathering
      response = GatheringUseCase.new(:atts => valid_attributes.merge(:name => gathering_orig.name)).create
      response.ok?.must_equal(false)
      response.errors.wont_be_nil
    end
  end
end

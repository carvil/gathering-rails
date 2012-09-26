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
    def new_user
      Factory.create(:user)
    end
  
    it "successfully creates and persists a new Gathering" do
      user = new_user
      response = GatheringUseCase.new(:atts => valid_attributes, :user => user).create
      
      response.ok?.must_equal(true)
      gathering = response.gathering
      gathering.id.wont_be_nil
      gathering.name.must_equal(valid_attributes[:name])
      gathering.description.must_equal(valid_attributes[:description])
      gathering.location.must_equal(valid_attributes[:location])
    end
    
    it "successfully creates and persists a new Gathering User as owner when creating a new Gathering" do
      user = new_user
      response = GatheringUseCase.new(:atts => valid_attributes, :user => user).create
      response.ok?.must_equal(true)
      GatheringUser.find_by_gathering_and_user(response.gathering.id, user.id).wont_be_nil
    end
    
    it "returns errors if the create Gathering request is not valid" do
      user = new_user
      response = GatheringUseCase.new(:atts => valid_attributes.merge(:name => ""), :user => user).create
      response.ok?.must_equal(false)
      response.errors.must_include(:gathering_name)
      response = GatheringUseCase.new(:atts => valid_attributes.merge(:description => ""), :user => user).create
      response.ok?.must_equal(false)
      response.errors.must_include(:gathering_description)
      response = GatheringUseCase.new(:atts => valid_attributes.merge(:location => ""), :user => user).create
      response.ok?.must_equal(true)
      response.errors.must_be_empty
      # Tests for non-persisted user
      response = GatheringUseCase.new(:atts => valid_attributes, :user => User.new).create
      response.ok?.must_equal(false)
      response.errors.must_include(:user_not_found)
      user.destroy      
      response = GatheringUseCase.new(:atts => valid_attributes, :user => user).create
      response.ok?.must_equal(false)
      response.errors.must_include(:user_not_found)
    end
    
    it "returns errors if creating Gathering with a duplicate name" do
      user = new_user
      gathering_orig = GatheringUseCase.new(:atts => valid_attributes, :user => user).create.gathering
      response = GatheringUseCase.new(:atts => valid_attributes.merge(:name => gathering_orig.name), :user => user).create
      response.ok?.must_equal(false)
      response.errors.must_include(:gathering_name)
    end
  end
end

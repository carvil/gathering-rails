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
      GatheringUser.where(:gathering_id => response.gathering.id, :user_id => user.id).all.size.must_equal(1)
    end
    
    it "returns errors if the create Gathering request is not valid" do
      user = new_user
      response = GatheringUseCase.new(:atts => valid_attributes.merge(:name => ""), :user => user).create
      response.ok?.must_equal(false)
      response.errors.must_include(:name)
      response = GatheringUseCase.new(:atts => valid_attributes.merge(:description => ""), :user => user).create
      response.ok?.must_equal(false)
      response.errors.must_include(:description)
      response = GatheringUseCase.new(:atts => valid_attributes.merge(:location => ""), :user => user).create
      response.ok?.must_equal(true)
      response.errors.must_be_nil
      response = GatheringUseCase.new(:atts => valid_attributes, :user => User.new).create
      response.ok?.must_equal(false)
    end
    
    it "returns errors if creating Gathering with a duplicate name" do
      user = new_user
      gathering_orig = GatheringUseCase.new(:atts => valid_attributes, :user => user).create.gathering
      response = GatheringUseCase.new(:atts => valid_attributes.merge(:name => gathering_orig.name), :user => user).create
      response.ok?.must_equal(false)
      response.errors.wont_be_nil
    end
  end
end

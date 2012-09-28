require 'test_helper'

include UseCases

describe GatheringUseCase do
  describe "edit" do
    it "returns the desired gathering for edit" do
      owner = Factory.create(:owner)
      gathering = owner.gathering
      response = use_gathering(:id => gathering.id, :user => owner.user).edit
      response.ok?.must_equal(true)
      response.gathering.must_equal(gathering)
      response.gathering.id.must_equal(gathering.id)
    end
    
    it "returns errors if the Gathering does not exist for edit" do
      user = Factory.create(:user)
      response = use_gathering(:id => 0, :user => user).edit
      response.ok?.must_equal(false)
      response.errors.must_include(:record_not_found)
    end
    
    it "returns an error if the requesting user does not have permission to edit" do
      owner = Factory.create(:owner)
      reader = Factory.create(:reader, :gathering => owner.gathering)
      response = use_gathering(:id => owner.gathering.id, :user => reader.user).edit
      response.ok?.must_equal(false)
      response.errors.must_include(:access_denied)
    end
  end
  
  describe "show" do
    it "returns the desired gathering for show" do
      owner = Factory.create(:owner)
      gathering = owner.gathering
      response = use_gathering(:id => gathering.id, :user => owner.user).show
      response.ok?.must_equal(true)
      response.gathering.must_equal(gathering)
      response.gathering.id.must_equal(gathering.id)
    end
    
    it "returns errors if the Gathering does not exist for show" do
      user = Factory.create(:user)
      response = use_gathering(:id => 0, :user => user).show
      response.ok?.must_equal(false)
      response.errors.must_include(:record_not_found)
    end
    
    it "returns an error if the requesting user does not have permission to show" do
      owner = Factory.create(:owner)
      reader = Factory.create(:reader)
      response = use_gathering(:id => owner.gathering.id, :user => reader.user).show
      response.ok?.must_equal(false)
      response.errors.must_include(:access_denied)
    end
  end
  
  describe "new" do
    it "returns an new Gathering instance" do
      user = Factory.create(:user)
      response = use_gathering(:user => user).new
      response.ok?.must_equal(true)
      response.gathering.must_be_instance_of(Gathering)
      response.gathering.persisted?.must_equal(false)
    end
    
    it "returns an error if the requesting user does not have permission to make new Gatherings" do
      response = use_gathering(:user => User.new).new
      response.ok?.must_equal(false)
      response.errors.must_include(:access_denied)
      response = use_gathering(:user => nil).new
      response.ok?.must_equal(false)
      response.errors.must_include(:access_denied)
    end
  end

end


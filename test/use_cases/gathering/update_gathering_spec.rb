require 'test_helper'

include UseCases

describe GatheringUseCase do
  describe "update" do
    before :each do
      @gathering = Factory(:gathering)
    end
    
    def new_attributes(atts = {})
      {
        :name => "New Name",
        :description => "New Description",
        :location => "New Location"
      }.merge(atts)
    end
    
    it "updates a record when passed valid attributes" do
      new_atts = new_attributes
      response = GatheringUseCase.new(:id => @gathering.id, :atts => new_attributes).update
      response.ok?.must_equal(true)
      gathering = Gathering.find(response.gathering.id)
      gathering.name.must_equal(new_atts[:name])
      gathering.description.must_equal(new_atts[:description])
      gathering.location.must_equal(new_atts[:location])
    end
    
    it "returns an error when passing a blank name" do
      response = GatheringUseCase.new(:id => @gathering.id, :atts => new_attributes(:name => "")).update
      response.ok?.must_equal(false)
      response.errors.wont_be_nil
    end
    
    it "returns an error when passing a blank description" do
      response = GatheringUseCase.new(:id => @gathering.id, :atts => new_attributes(:description => "")).update
      response.ok?.must_equal(false)
      response.errors.wont_be_nil
    end
    
    it "returns no errors when passing a blank location" do
      response = GatheringUseCase.new(:id => @gathering.id, :atts => new_attributes(:location => "")).update
      response.ok?.must_equal(true)
    end
  end
end

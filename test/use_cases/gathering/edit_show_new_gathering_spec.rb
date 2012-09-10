require 'test_helper'

include UseCases

describe GatheringUseCase do
  describe "edit" do
    it "returns the desired gathering for edit" do
      gathering = Factory.create(:gathering)
      response = GatheringUseCase.new(:id => gathering.id).edit
      response.ok?.must_equal(true)
      response.gathering.must_equal(gathering)
      response.gathering.id.must_equal(gathering.id)
    end
    
    it "returns errors if the Gathering does not exist for edit" do
      response = GatheringUseCase.new(:id => 0).edit
      response.ok?.must_equal(false)
      response.errors.wont_be_nil
    end
  end
  
  describe "show" do
    it "returns the desired gathering for show" do
      gathering = Factory.create(:gathering)
      response = GatheringUseCase.new(:id => gathering.id).edit
      response.ok?.must_equal(true)
      response.gathering.must_equal(gathering)
      response.gathering.id.must_equal(gathering.id)
    end
    
    it "returns errors if the Gathering does not exist for show" do
      response = GatheringUseCase.new(:id => 0).edit
      response.ok?.must_equal(false)
      response.errors.wont_be_nil
    end
  end
  
  describe "new" do
    it "returns an new Gathering instance" do
      response = GatheringUseCase.new.new
      response.ok?.must_equal(true)
      response.gathering.must_be_instance_of(Gathering)
      response.gathering.persisted?.must_equal(false)
    end
  end

end


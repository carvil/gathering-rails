require 'test_helper'

include UseCases

describe GatheringUserUseCase do
  describe "destroy" do
    it "successfully destroys a gathering user if it's not the last owner entry for the related gathering" do
      gathering_user_1 = Factory.create(:owner)
      gathering_user_2 = Factory.create(:owner, :gathering => gathering_user_1.gathering)
      response = GatheringUserUseCase.new(:id => gathering_user_1.id).destroy
      response.ok?.must_equal(true)
    end
    
    it "returns an error if attempting to delete the last owner for the related gathering" do
      gathering_user = Factory.create(:owner)
      response = GatheringUserUseCase.new(:id => gathering_user.id).destroy
      response.ok?.must_equal(false)
      response.errors.must_include(:unable_to_destroy_last_owner)
    end
  end
end
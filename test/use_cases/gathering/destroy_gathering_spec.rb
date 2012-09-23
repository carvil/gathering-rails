require 'test_helper'

include UseCases

describe GatheringUseCase do
  describe "destroy" do
    def ability(user)
      if user.class == GatheringUser
        user = user.user
      end
      Ability.new(user)
    end
    
    it "can only be destroyed by an owner" do
      reader = Factory.create(:reader)
      owner = Factory.create(:owner, :gathering => reader.gathering)
      gathering = owner.gathering
      response = GatheringUseCase.new(:id => gathering.id, :ability => ability(reader.user)).destroy
      response.ok?.must_equal(false)
      response.errors.must_include(:access_denied)
      response = GatheringUseCase.new(:id => gathering.id, :ability => ability(owner.user)).destroy
      response.ok?.must_equal(true)
      response.gathering.persisted?.must_equal(false)
      GatheringUser.where(:gathering_id => gathering.id).all.must_be_empty
    end
    
    it "successfully destroys a Gathering without Events and destroys any Gathering Users as well" do
      gathering_user = Factory.create(:owner)
      gathering = gathering_user.gathering
      response = GatheringUseCase.new(:id => gathering.id, :ability => ability(gathering_user.user)).destroy
      response.ok?.must_equal(true)
      GatheringUser.where(:gathering_id => gathering.id).all.must_be_empty
    end
    
    it "successfully destroys a Gathering with at least one Event and destroys any subsequent Events" do
      event = Factory.create(:event)
      gathering = event.gathering
      gathering_user = Factory.create(:owner, :gathering => gathering)
      response = GatheringUseCase.new(:id => gathering.id, :ability => ability(gathering_user.user)).destroy
      response.ok?.must_equal(true)
      Event.where(:id => event.id).must_be_empty
      GatheringUser.where(:gathering_id => gathering.id).all.must_be_empty
    end
  end
end

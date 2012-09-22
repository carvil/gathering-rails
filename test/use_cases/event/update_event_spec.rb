require 'test_helper'

include UseCases

describe EventUseCase do
  describe "update" do
    before :each do
      @event = Factory.create(:event)
    end
    
    def new_attributes(atts = {})
      {
        :title => "New Title",
        :description => "New Description",
        :location => "New Location",
        :scheduled_date => "1/1/1900 00:00",
        :cancelled_at => "1/2/1900 00:01",
        :gathering => Factory.create(:gathering)
      }.merge(atts)
    end
    
    it "updates a record when passed valid attributes" do
      new_atts = new_attributes
      response = EventUseCase.new(:id => @event.id, :atts => new_attributes).update
      response.ok?.must_equal(true)
      event = Event.find(response.event.id)
      event.title.must_equal(new_atts[:title])
      event.description.must_equal(new_atts[:description])
      event.location.must_equal(new_atts[:location])
      event.scheduled_date.must_equal(Time.zone.parse(new_atts[:scheduled_date]))
      event.cancelled_at.wont_be_nil
    end
    
    it "successfully updates an Event when a gathering ID as a String is passed instead of a gathering object (like an HTML form submission)" do
      atts = new_attributes
      gathering = atts[:gathering]
      atts = atts.merge(:gathering => atts[:gathering].id.to_s)
      response = EventUseCase.new(:atts => atts).create
      
      response.ok?.must_equal(true)
      event = response.event
      event.id.wont_be_nil
      event.gathering.must_equal(gathering)
    end
    
    it "successfully updates an Event when a gathering ID as a Fixnum is passed instead of a gathering object" do
      atts = new_attributes
      gathering = atts[:gathering]
      atts = atts.merge(:gathering => atts[:gathering].id)
      response = EventUseCase.new(:atts => atts).create
      
      response.ok?.must_equal(true)
      event = response.event
      event.id.wont_be_nil
      event.gathering.must_equal(gathering)
    end
    
    it "returns an error when passing a blank title" do
      response = EventUseCase.new(:id => @event.id, :atts => new_attributes(:title => "")).update
      response.ok?.must_equal(false)
      response.errors.must_include(:title)
    end
    
    it "returns an error when passing a blank description" do
      response = EventUseCase.new(:id => @event.id, :atts => new_attributes(:description => "")).update
      response.ok?.must_equal(false)
      response.errors.must_include(:description)
    end
    
    it "returns an error when passing a blank location" do
      response = EventUseCase.new(:id => @event.id, :atts => new_attributes(:location => "")).update
      response.ok?.must_equal(false)
      response.errors.must_include(:location)
    end
    
    it "returns an error when passing a blank scheduled_date" do
      response = EventUseCase.new(:id => @event.id, :atts => new_attributes(:scheduled_date => "")).update
      response.ok?.must_equal(false)
      response.errors.must_include(:scheduled_date)
    end
    
    it "returns an error when passing a blank gathering" do
      response = EventUseCase.new(:id => @event.id, :atts => new_attributes(:gathering => nil)).update
      response.ok?.must_equal(false)
      response.errors.must_include(:gathering_id)
    end
     
    it "returns an error when passing an invalid gathering" do
      response = EventUseCase.new(:id => @event.id, :atts => new_attributes(:gathering => Gathering.new)).update
      response.ok?.must_equal(false)
      response.errors.must_include(:gathering_id)
    end
    
    it "returns no error when passing a blank cancelled_at" do
      response = EventUseCase.new(:id => @event.id, :atts => new_attributes(:cancelled_at => "")).update
      response.ok?.must_equal(true)
    end
    
    it "sets the cancelled_at to current date/time if any non-zero/false/nil value is passed" do
      event = Factory.create(:event)
      response = EventUseCase.new(:id => event.id, :atts => new_attributes(:cancelled_at => "asdf")).update
      response.ok?.must_equal(true)
      response.event.cancelled_at.wont_be_nil
      
      event = Factory.create(:event)
      response = EventUseCase.new(:id => event.id, :atts => new_attributes(:cancelled_at => 1)).update
      response.ok?.must_equal(true)
      response.event.cancelled_at.wont_be_nil
      
      event = Factory.create(:event)
      response = EventUseCase.new(:id => event.id, :atts => new_attributes(:cancelled_at => true)).update
      response.ok?.must_equal(true)
      response.event.cancelled_at.wont_be_nil
      
      event = Factory.create(:event)
      response = EventUseCase.new(:id => event.id, :atts => new_attributes(:cancelled_at => 0)).update
      response.ok?.must_equal(true)
      response.event.cancelled_at.must_be_nil
      
      event = Factory.create(:event)
      response = EventUseCase.new(:id => event.id, :atts => new_attributes(:cancelled_at => nil)).update
      response.ok?.must_equal(true)
      response.event.cancelled_at.must_be_nil
      
      event = Factory.create(:event)
      response = EventUseCase.new(:id => event.id, :atts => new_attributes(:cancelled_at => false)).update
      response.ok?.must_equal(true)
      response.event.cancelled_at.must_be_nil  
    end
  end
end

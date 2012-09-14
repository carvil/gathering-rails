require 'test_helper'

def valid_event
  Factory.create(:event)
end

def default_event
  Event.new
end

describe Event do
  
  describe "Attributes" do
    it "has a title" do
      default_event.must_respond_to("title")
    end
    it "has a description" do
      default_event.must_respond_to("description")
    end
    it "has a scheduled date" do
      default_event.must_respond_to("scheduled_date")
    end
    it "has a gathering" do
      default_event.must_respond_to("gathering")
    end
    it "has a location" do
      default_event.must_respond_to("location")
    end
    it "has a cancelled date" do
      default_event.must_respond_to('cancelled_at')
    end
  end
  
  describe "Validity" do
    it "is valid with valid attributes" do
      valid_event.valid?.must_equal(true)
    end
    it "is invalid without a title" do
      event = valid_event
      event.title = nil
      event.valid?.must_equal(false)
    end
    it "is invalid without a description" do
      event = valid_event
      event.description = nil
      event.valid?.must_equal(false)
    end
    it "is invalid without a scheduled date" do
      event = valid_event
      event.scheduled_date = nil
      event.valid?.must_equal(false)
    end
    it "is invalid without a location" do
      event = valid_event
      event.location = nil
      event.valid?.must_equal(false)
    end
    it "is valid without a cancelled date" do
      event = valid_event
      event.cancelled_at = nil
      event.valid?.must_equal(true)
    end
    it "is invalid without a gathering id" do
      event = valid_event
      event.gathering_id = nil
      event.valid?.must_equal(false)
    end
    it "is invalid if associated to a non-existent gathering" do
      event = valid_event
      event.gathering = Gathering.new
      event.valid?.must_equal(false)
    end
  end
  
  describe "Methods" do
    it "is_cancelled? is a method that returns true if the attribute 'cancelled_at' is populated and false otherwise" do
      event = default_event
      event.must_respond_to("is_cancelled?")
      event.is_cancelled?.must_equal(false)
      event.cancelled_at = Time.new
      event.is_cancelled?.must_equal(true)
    end
  end
  
end

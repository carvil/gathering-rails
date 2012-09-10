require 'test_helper'

def valid_gathering
  Factory.build(:gathering)
end

def default_gathering
  Gathering.new
end

describe Gathering do
  
  describe "Attributes" do
    it "has a name" do
      default_gathering.must_respond_to("name")
    end
    it "has a description" do
      default_gathering.must_respond_to("description")
    end
    it "has a location" do
      default_gathering.must_respond_to("location")
    end
  end
  
  describe "Validity" do
    it "is valid with valid attributes" do
      valid_gathering.valid?.must_equal(true)
    end
    it "is invalid without a name" do
      gathering = valid_gathering
      gathering.name = nil
      gathering.valid?.must_equal(false)
    end
    it "is invalid without a description" do
      gathering = valid_gathering
      gathering.description = nil
      gathering.valid?.must_equal(false)
    end
    it "is valid without a location" do
      gathering = valid_gathering
      gathering.location = nil
      gathering.valid?.must_equal(true)
    end
  end
  
end

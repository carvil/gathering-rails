require 'test_helper'

#TODO: Build out the error module tests
class ErrorModuleClass
  include ErrorsModule
  
  attr_accessor :errors
  
  def initialize
    initialize_errors_module
  end
  
  def add_error_public(error, location, action, item, message)
    add_error(error, location, action, item, message)
  end
  
  def add_class_errors_hash_public(klass, errors_hash, location, action)
    add_class_errors_hash(klass, errors_hash, location, action)
  end
  
end

describe ErrorsModule do
  before :each do
    @error_class = ErrorModuleClass.new
  end
  
  def error_parms
    {
      :error => :some_error, :location => :some_location, :action => :some_action, :item => :some_item, :message => "some_message"
    }
  end
  
  describe "Attributes" do
    it "has an errors hash" do
      @error_class.must_respond_to("errors")
      @error_class.errors.is_a?(Hash)
    end
  end
  describe "Methods" do
    it "has an add_error method that accpets an error key, location, action, item, and message" do
      err = error_parms
      err_key = err[:error]
      @error_class.add_error_public(err_key, err[:location], err[:action], err[:item], err[:message])
      @error_class.errors.size.must_equal(1)
      @error_class.errors.must_include(err_key)
      @error_class.errors[err_key].location.must_equal(err[:location])
      @error_class.errors[err_key].action.must_equal(err[:action])
      @error_class.errors[err_key].item.must_equal(err[:item])
      @error_class.errors[err_key].message.must_equal(err[:message])
    end
    
    it "has an add_class_errors_hash method that accepts a class and a hash of errors and adds each message to the errors hash with a key of <class name>_<error attribute>" do
      gathering = Gathering.new
      gathering.save
      err = error_parms
      @error_class.add_class_errors_hash_public(Gathering, gathering.errors.messages, err[:location], err[:action])
      @error_class.errors.wont_be_empty
      gathering.errors.messages.each do |am_key, am_msg|
        err_key = "gathering_#{am_key}".to_sym
        @error_class.errors.must_include(err_key)
        error = @error_class.errors[err_key]
        error.location.must_equal(err[:location])
        error.action.must_equal(err[:action])
        error.item.must_equal(am_key)
        error.message.must_equal(am_msg)
      end
    end
  end
end
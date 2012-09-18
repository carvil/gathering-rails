# Used the example found at https://github.com/RailsApps/rails3-devise-rspec-cucumber/blob/master/spec/models/user_spec.rb

require 'test_helper'

describe User do
  
  def new_user(atts = {})
    Factory.build(:user, atts)
  end
  
  def create_user(atts = {})
    Factory.create(:user, atts)
  end
  
  describe "Attributes" do
    it "has an email" do
      User.new.must_respond_to(:email)
    end
    
    it "has a display name" do
      User.new.must_respond_to(:display_name)
    end
    
    it "has a first name" do
      User.new.must_respond_to(:first_name)
    end
    
    it "has a last name" do
      User.new.must_respond_to(:last_name)
    end
    
    it "has an inactive date" do
      User.new.must_respond_to(:inactive_at)
    end
    
    it "has an is_active? method" do
      User.new.must_respond_to(:is_active?)
    end
    
    it "returns false for is_active? if inactive date is populated and true if not" do
      user = new_user
      user.is_active?.must_equal(true)
      user.inactive_at = Time.new
      user.is_active?.must_equal(false)
    end
    
    it "has a display name" do
      User.new.must_respond_to(:display_name)
    end
  end
  
  describe "Validity" do
    it "should create a new instance given a valid attribute" do
      user = create_user
      user.id.wont_be_nil
    end
    
    it "should require an email address" do
      no_email_user = new_user(:email => "")
      no_email_user.valid?.must_equal(false)
    end
    
    it "should accept valid email addresses" do
      addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
      addresses.each do |address|
        valid_email_user = new_user(:email => address)
        valid_email_user.valid?.must_equal(true)
      end
    end
    
    it "should reject invalid email addresses" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. user@@example.com]
      addresses.each do |address|
        invalid_email_user = new_user(:email => address)
        invalid_email_user.valid?.must_equal(false)
      end
    end
    
    it "should reject duplicate email addresses" do
      user_orig = create_user
      user_with_duplicate_email = new_user(:email => user_orig.email)
      user_with_duplicate_email.valid?.must_equal(false)
    end
    
    it "should reject email addresses identical up to case" do
      user_orig = create_user
      user_with_duplicate_email = new_user(:email => user_orig.email.upcase)
      user_with_duplicate_email.valid?.must_equal(false)
    end
  end
  
  describe "Passwords" do

    before(:each) do
      @user = new_user
    end

    it "should have a password attribute" do
      @user.must_respond_to(:password)
    end

    it "should have a password confirmation attribute" do
      @user.must_respond_to(:password_confirmation)
    end
    
    describe "Validations" do
  
      it "should require a password" do
        new_user(:password => "", :password_confirmation => "").valid?.must_equal(false)
      end
  
      it "should require a matching password confirmation" do
        new_user(:password_confirmation => "invalid").valid?.must_equal(false)
      end
      
      it "should reject short passwords" do
        short = "a" * 5
        new_user(:password => short, :password_confirmation => short).valid?.must_equal(false)
      end
      
    end
    
    describe "Encryption" do
      
      # before(:each) do
        # @user = create_user
      # end
      
      it "should have an encrypted password attribute" do
        @user.must_respond_to(:encrypted_password)
      end
  
      it "should set the encrypted password attribute" do
        @user.encrypted_password.wont_equal("")
        @user.encrypted_password.wont_be_nil
      end
  
    end
    
  end
  


end
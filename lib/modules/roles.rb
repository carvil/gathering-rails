
# Roles module assumes that here is a string attribute available as :role that describes the current role of the object
# It also expects that you have set a ROLE_LIST constant in your object; if it has not been set it will default to the list specified below
module Roles
  # Default role list if none is already specified
  ROLE_LIST ||= %w[owner contributor reader]

  # define a scope within the including model, create finder class-methods for each role, and define a method to return the list of configured roles
  def self.included(base)
    base.class_eval do
      #scope :with_role, lambda {|r| where(:role => r)}
      
      # metaprogramming that defines some simple finders on the class
      class << self
        def with_role(role_name)
          where(:role => role_name)
        end
        ROLE_LIST.each do |role_name|
          # Finders
          define_method "all_#{role_name}s" do
            with_role(role_name)
          end
        end
        def role_list
          ROLE_LIST
        end
      end
    end
  end
  
  # metaprogramming that defines some simple setters and checkers on the instances
  ROLE_LIST.each do |role_name|
    # Setters
    define_method "set_role_as_#{role_name}!" do
      role_will_change!
      self.role = role_name
      if self.role == role_name
        return role_name
      else
        return nil
      end
    end
    # Instance Checkers
    define_method "is_#{role_name}?" do
      self.role == role_name
    end
  end

end
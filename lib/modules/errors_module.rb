
# Roles module assumes that here is a string attribute available as :role that describes the current role of the object
# It also expects that you have set a ROLE_LIST constant in your object; if it has not been set it will default to the list specified below
module ErrorsModule

  class ErrorItem < OpenStruct
  end
  
  protected
  def initialize_errors
    self.errors = {}
  end
  
  # Primary method to add new errors to the hash
  # error parameter is the key and each of the other items become "attributes" of the ErrorItem instance that error keys to
  def add_error(error, location, action, item, message)
    add_error_to_hash(get_error_hash(error, location, action, item, message))
  end
  
  # Helper to convert a list of active record errors into individual entries in the errors hash
  # Uses the downcased class name + '_' + field name as the key and the active record message as the message
  def add_class_errors_hash(klass, errors_hash, location, action)
    add_error_to_hash(get_class_errors_hash(klass, errors_hash, location, action))
  end
  
  def get_error_hash(error, location, action, item, message)
    message = error_message(error, location, action, item) if message.nil?
    {error => ErrorItem.new(:location => location, :action => action, :item => item, :message => message)}
  end
  
  def get_class_errors_hash(klass, errors_hash, location, action)
    # change a camel case class name to an underscore string
    prefix = klass.to_s.underscore << '_'
    errors_hash.each do |key, message|
      add_error((prefix + key.to_s).to_sym, location, action, key, message)
    end
  end
  
  private
  def add_error_to_hash(errors_hash = {})
    # for now we'll just merge in all of the errors passed in, but we may want to return some error code (how meta) if an error already exists in the errors hash
    self.errors.merge!(errors_hash) unless errors_hash.nil?
  end
  
  def error_message(error, location, action, item)
    # TODO: add in some kind of yaml/xml message lookup here...
    "Default error message for %{error}; %{item} has generated an issue at %{location} attempting to %{action}"
  end
  
  public
  
end
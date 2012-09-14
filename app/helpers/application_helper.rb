module ApplicationHelper

  # view model
  def vm
    @vm
  end

  # Returns a content string for inline error rendering.  Currently assumes that errors is an ActiveRecord::Model 
  def errors(attribute)
    return nil if vm.errors.nil? || vm.errors[attribute].nil? || vm.errors[attribute].length == 0
    content_tag( 'span', class: 'help-inline' ) do
      vm.errors[attribute].join( '; ' )
    end
  end

end
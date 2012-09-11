module ApplicationHelper

  # view model
  def vm
    @vm
  end

  def errors(attribute)
    return nil unless vm.errors && vm.errors[attribute].length > 0
    content_tag( 'span', class: 'help-inline' ) do
      vm.errors[attribute].join( '; ' )
    end
  end

end
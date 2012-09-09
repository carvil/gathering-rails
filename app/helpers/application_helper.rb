module ApplicationHelper

  # view model
  def vm
    @vm
  end

  def errors(attribute)
    return '' unless vm.errors && !vm.errors.blank?
    content_tag( 'span', class: 'help-inline' ) do
      vm.errors[attribute].join( '; ' )
    end
  end

end
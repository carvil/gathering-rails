module ApplicationHelper

  # view model
  def vm
    @vm
  end

  # Returns a content string for inline error rendering.  Currently assumes that errors is an ActiveRecord::Model 
  def errors(attribute)
    return nil if vm.errors.nil? || vm.errors[attribute].nil? || vm.errors[attribute].length == 0
    content_tag( 'span', class: 'help-inline' ) do
      vm.errors[attribute].message
    end
  end
  
  def render_top_bar
    render partial: "shared/top_bar"
  end
  
  def render_top_nav_bar
    render partial: "shared/top_nav_bar"
  end
  
  def render_alert_boxes
    render partial: "shared/alert_boxes"
  end

  def render_sign_in_modal
    render partial: "shared/login_form"
  end
  
end
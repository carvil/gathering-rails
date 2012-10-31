module GatheringsHelper
  def render_gathering_events(events)
    render :partial => "events/event", :collection => events, :locals => {:show_link => true}
  end
end

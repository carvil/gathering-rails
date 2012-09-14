class EventsController < ApplicationController
  include UseCases
  
  respond_to :html
  
  def use(atts = {})
    EventUseCase.new(atts)
  end
  
  def index
    @vm = use.list
    respond_with @vm
  end

  def show
    @vm = use(:id => params[:id]).show
    respond_with @vm do |format|
      format.html {
        if @vm.errors
          redirect_to events_path , :alert => "Event with id #{params[:id]} does not exist." if @vm.errors[:record_not_found]
        end
      }
    end
  end

  def edit
    @vm = use(:id => params[:id]).edit
    respond_with @vm
  end

  def new
    @vm = use.new
    respond_with @vm
  end

  def create
    @vm = use(:atts => params[:event]).create
    respond_with @vm do |format|
      format.html { 
        if @vm.ok?
          redirect_to event_path(@vm.event)
        else
          redirect_to new_event_path, :alert => "Error: Unable to save event: #{@vm.errors.full_messages}"
          #render "new", :alert => "Error: Unable to save event"
        end
      }
    end
    
  end

  def update
    @vm = use(:id => params[:id], :atts => params[:event]).update
    respond_with @vm do |format|
      format.html { 
        if @vm.ok?
          redirect_to event_path(@vm.event)
        else
          render 'edit', :flash => "Error: Unable to save event"
        end
      }
    end
  end

  def destroy
    @vm = use(:id => params[:id]).destroy
    
    if @vm.ok?
      flash[:flash] = "Event destroyed"
    else
      flash[:flash] = "Event could not be destroyed."
    end
    
    respond_with @vm do |format|
      format.html {
        redirect_to events_path
      }
    end
  end
end

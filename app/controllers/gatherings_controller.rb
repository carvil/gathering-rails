class GatheringsController < ApplicationController
  include UseCases
  
  respond_to :html
  
  def use(atts = {})
    GatheringUseCase.new(atts)
  end
  
  def index
    # @vm = OpenStruct.new
    # @vm.gatherings = Gathering.all
    # respond_with @vm
    @vm = use.list
    respond_with @vm
  end

  def show
    @vm = use(:id => params[:id]).show
    respond_with @vm
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
    @vm = use(:atts => params[:gathering]).create
    respond_with @vm do |format|
      format.html { 
        if @vm.ok?
          redirect_to gathering_path(@vm.gathering)
        else
          render 'new', :flash => "Error: Unable to save gathering"
        end
      }
    end
    
  end

  def update
    @vm = use(:id => params[:id], :atts => params[:gathering]).update
    respond_with @vm do |format|
      format.html { 
        if @vm.ok?
          redirect_to gathering_path(@vm.gathering)
        else
          render 'edit', :flash => "Error: Unable to save gathering"
        end
      }
    end
  end

  def destroy
    @vm = use(:id => params[:id]).destroy
    
    if @vm.ok?
      flash[:flash] = "Gathering destroyed"
    else
      flash[:flash] = "Gathering could not be destroyed."
    end
    
    respond_with @vm do |format|
      format.html {
        redirect_to gatherings_path
      }
    end
  end
end

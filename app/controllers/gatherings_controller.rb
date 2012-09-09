class GatheringsController < ApplicationController
  
  respond_to :html
  
  def index
    @vm = OpenStruct.new
    @vm.gatherings = Gathering.all
    respond_with @vm
  end

  def show
    @vm = OpenStruct.new
    @vm.gathering = Gathering.find(params[:id])
    respond_with @vm
  end

  def edit
    @vm = OpenStruct.new
    @vm.gathering = Gathering.find(params[:id])
    respond_with @vm
  end

  def new
    @vm = OpenStruct.new
    @vm.gathering = Gathering.new
    respond_with @vm
  end

  def create
    @vm = OpenStruct.new
    @vm.gathering = Gathering.new(params[:gathering])
    success = @vm.gathering.save
    @vm.errors = @vm.gathering.errors

    respond_with @vm do |format|
      format.html do
        if success
          redirect_to gathering_path(@vm.gathering)
        else
          render 'new', :flash => "Error: Unable to save gathering"
        end
      end
    end
    
  end

  def update
    @vm = OpenStruct.new
    @vm.gathering = Gathering.find(params[:id])
    @vm.gathering.update_attributes(params[:gathering])
    success = @vm.gathering.save
    @vm.errors = @vm.gathering.errors
    
    respond_with @vm do |format|
      format.html do
        if success
          redirect_to gatherings_path
        else
          render 'edit', :flash => "Error: Unable to save gathering"
        end
      end
    end
  end

  def destroy
    @vm = OpenStruct.new
    @vm.gathering = Gathering.find(params[:id])
    if @vm.gathering.destroy
      flash[:flash] = "Content destroyed"
    else
      flash[:flash] = "Content could not be destroyed."
    end
    
    respond_with @vm do |format|
      format.html {
        redirect_to gatherings_path
      }
    end
  end
end

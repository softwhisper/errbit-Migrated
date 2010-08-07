class ErrsController < ApplicationController
  
  def index
    @errs = Err.unresolved.ordered.paginate(:page => params[:page])
  end
  
  def all
    @errs = Err.ordered.paginate(:page => params[:page])
  end
  
  def show
    @project  = Project.find(params[:project_id])
    @err      = @project.errs.find(params[:id])
    @notices  = @err.notices.ordered.paginate(:page => (params[:notice] || @err.notices.count), :per_page => 1)
    @notice   = @notices.first
  end
  
  def resolve
    @project  = Project.find(params[:project_id])
    @err      = @project.errs.unresolved.find(params[:id])
    
    # Deal with bug in mogoid where find is returning an Enumberable obj
    @err = @err.first if @err.respond_to?(:first)
    
    @err.resolve!
    
    flash[:success] = 'Great news everyone! The error has been resolved.'
    redirect_to errs_path
  end
  
end
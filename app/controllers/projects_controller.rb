class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only:[:new, :create, :edit, :update, :destroy]
  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
    @project = Project.new
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

      if @project.save
        ProjectJob.perform_now(@project, false)
        head :ok
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end

  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        flash[:success] = 'Project was successfully updated.'
        format.html { redirect_to root_path}
        format.json { render :show, status: :ok, location: root_path }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    ProjectJob.perform_now(@project, true)

    @project.destroy

    head :no_content
  end


  private
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in first"
        redirect_to login_url
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :url, :desc)
    end
end

class Api::ProjectsController < Api::BaseController
    before_action :set_project, only: [:show, :update, :destroy]
    before_action :authorize_project, only: [:show, :edit, :update, :destroy]

    def index
      projects = policy_scope(Project).includes(:client, :tags, :users, :integrations)
      projects = projects.by_tags(params[:tags]) if params[:tags].present?
      projects = projects.by_name(params[:name]) if params[:name].present?
      projects = projects.by_client(params[:client]) if params[:client].present?
      paginate(projects)
    end

    def show
      render json: @project
    end

    def create
      @project = Project.new(project_params)
      authorize @project
      @project.user_ids = current_user.id
      if @project.save
        render json: @project, status: :created
      else
        render json: @project.errors, status: :unprocessable_entity
      end
    end

    def update
      if @project.update(project_params)
        render json: @project
      else
        render json: @project.errors, status: :unprocessable_entity
      end
    end
    
    def destroy
      @project.destroy
      head :no_content
    end

    private

    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(:name, :client_id, user_ids: [], tag_ids: [])
    end

    def authorize_project
      authorize @project
    end
end

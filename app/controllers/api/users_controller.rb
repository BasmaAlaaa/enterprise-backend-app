class Api::UsersController < Api::BaseController
  before_action :set_user, only: [:show, :update, :destroy, :update_permissions]

  def index
    users = policy_scope(TeamMember)
    users = users.by_projects(params[:projects]) if params[:projects]
    users = users.by_name(params[:name]) if params[:name]
    paginate(users)
  end 

  def show      
    authorize @user # Calls UserPolicy#show?
    render json: @user
  end

  def show_current_user
    # authorize current_user
    render json: current_user
  end

  def create
    @user = current_user.team_members.new(user_params)
    authorize @user  # Calls UserPolicy#create?
    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @user  # Calls UserPolicy#update?

    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def edit_current_user
    @user = current_user
    # authorize @user  # Calls UserPolicy#edit_current_user?

    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @user  
    @user.destroy
    head :no_content
  end




  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(:name,:email, :password, :password_confirmation)
  end
end

  
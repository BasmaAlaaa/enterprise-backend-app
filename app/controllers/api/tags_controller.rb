class Api::TagsController < Api::BaseController
  before_action :set_tag, only: [:show, :update, :destroy]
  before_action :authorize_tag, only: [:show, :edit, :update, :destroy]


  def index
    tags = policy_scope(Tag)
    paginate(tags) 
  end

  def show
    render json: @tag
  end

  def create
    @tag = current_user.tags.new(tag_params)
    if @tag.save
      render json: @tag, status: :created
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  def update

    if @tag.update(tag_params)
      render json: @tag
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @tag.destroy
    head :no_content
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end

  def authorize_tag
    authorize @tag
  end
end

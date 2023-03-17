class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  # GET /users/:user_id/items

  def index
    if params[:user_id]
      user = find_user
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  # GET /users/:user_id/items/:id
  def show
    item = Item.find(params[:id])
    render json: item, include: :user
  end

  # POST /users/:user_id/items
  def create
    user = find_user
    item = user.items.create(item_params)
    render json: item, status: :created
  end

  private

  def render_not_found_response
    render json: { error: "Item not found" }, status: :not_found
  end

  def render_unprocessable_entity_response(invalid)
    render json: { errors: invalid.record.errors }, status: :unprocessable_entity
  end

  def item_params
    params.permit(:name, :description, :price)
  end

  def find_user
    User.find(params[:user_id])
  end
  
end

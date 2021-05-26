class Api::V1::UsersController < ApplicationController
  before_action :find_user, only: %i(update destroy)

  def index
    render json: { users: User.all }
  end

  def create
    @user = User.new(user_params)
    handle_request(@user.save)
  end

  def update
    handle_request(@user.update(user_params))
  end

  def destroy
    handle_request(@user.destroy)
  end

  private

  def user_params
    params.require(:user).permit(User::PARAMS)
  end

  def find_user
    @user = User.find_by(id: params[:id])
  end

  def not_success_response
    { success: false, errors: @user.errors.full_messages }
  end

  def success_response
    { success: true, user: @user }
  end

  def handle_request action
    response = action ? success_response : not_success_response
    render json: response
  end
end

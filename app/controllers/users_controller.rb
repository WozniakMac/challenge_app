class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def show
  end

  def index
  	@user = User.order(points: :desc)
  end

  private

    def set_user
      @user = User.find(params[:id])
    end
end

class UsersController < ApplicationController


  def index
  	@users = User.all
  end

  def new
  	@user = User.new
  end

  def create
  	flash[:success] = "User created successfully!"
  	@user = User.new(user_params)
  	if @user.save
      log_in @user
  		redirect_to users_path
  	else
  		render 'new'
  	end
  end

  def show
  	@user = User.find(params[:id])
  end

  private

  def user_params
  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end

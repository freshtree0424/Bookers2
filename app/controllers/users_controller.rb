class UsersController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]
  
  def show
    @user = current_user
    @users = User.find(params[:id])
    @books = @users.books
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
   @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "successfully updated."
      redirect_to user_path
    else
      flash[:alert] = "error"
      render :edit
    end
  end

 def index
   @user = current_user
   @book = Book.new
   @users = User.all
 end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end
  
  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to post_images_path
    end
  end

end

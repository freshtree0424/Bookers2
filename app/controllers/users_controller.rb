class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path
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

end

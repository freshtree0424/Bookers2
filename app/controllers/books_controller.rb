class BooksController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]
  
  def index
    @user = current_user
    @books = Book.all
    @book = Book.new
  end
  
  def show
    @book = Book.find(params[:id])
    @user = @book.user
  end

  def edit
    @book = Book.find(params[:id])
  end

  def create
    @book = Book.new(book_params)
    @book.user = current_user
   if @book.save
    flash[:notice] = "Book was successfully created."
    redirect_to book_path(@book.id)
   else
    @user = current_user
    @books = Book.all
    flash[:Alert] = "error"
    render :index
   end
  end

  def update
   @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "Book was successfully updated."
      redirect_to book_path(@book.id)
    else
      flash[:alert] = "error"
      render :edit
    end
  end

  def destroy
    flash[:notice] = "Book was successfully destroy."
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
  
  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to books_path
    end
  end
end

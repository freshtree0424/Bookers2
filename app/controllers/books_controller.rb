class BooksController < ApplicationController
  def index
    @user = current_user
    @books = Book.all
    @book = Book.new
  end

  def show
    @user = current_user
    @book = Book.find(params[:id])

  end

  def edit
    @book = Book.find(params[:id])
  end

  def create
    @book = Book.new(book_params)
    @book.user = current_user
   if @book.save
    redirect_to book_path(@book.id)
   else
    @user = current_user
    @books = Book.all
    render :index
   end
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
end

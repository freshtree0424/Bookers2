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
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
   if @book.save
    flash[:notice] = "Book was successfully created."
    redirect_to book_path(@book.id)
   else
    @books = Book.all
    flash[:alert] = "Book was unsuccessfully created."
    render :index
   end
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
end

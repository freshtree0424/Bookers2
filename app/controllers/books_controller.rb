class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    to  = Time.current.at_end_of_day
    from  = (to - 6.day).at_beginning_of_day
    @books = Book.all.sort {|a,b| 
      b.favorites.where(created_at: from...to).size <=> 
      a.favorites.where(created_at: from...to).size
    }
    @book_comment = BookComment.new
    @book = Book.new
  end

  def show
    @book = Book.find(params[:id])
    @book_comment = BookComment.new
    @user = @book.user
    @book_detail = Book.find(params[:id])
     unless ViewCount.find_by(user_id: current_user.id, book_id: @book_detail.id)
       current_user.view_counts.create(book_id: @book_detail.id)
     end
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @userEntry = Entry.where(user_id: @user.id)
    if @user.id == current_user.id
    else
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
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
    @book = Book.find(params[:id])
    user = @book.user
    unless user.id == current_user.id
      redirect_to books_path
    end
  end
end

class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :check_author, only: [:edit]
  def new
    # Viewへ渡すためのインスタンス変数に空のModelオブジェクトを生成する。
    @book = Book.new 
  end

  def index
    @books = Book.all 
    @book = Book.new
    @user = current_user
    @users = User.all
    
  end
  
  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @new_book = Book.new
  end
  
  def edit
    @book = Book.find(params[:id])
    @books = Book.all
  end

  
  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    @user = current_user
    @users = User.all
   
     if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book.id)
     else
      
      @books = Book.all
      render "index"    
     end
  end
  
  def update
    @book = Book.find(params[:id])
     if @book.update(book_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to book_path(@book.id)
     else
      render "edit"    
     end
  end
  
  def destroy
    book = Book.find(params[:id])  # データ（レコード）を1件取得
    book.destroy  # データ（レコード）を削除
    redirect_to books_path  # 投稿一覧画面へリダイレクト  
  end
  
  private
  def book_params
    params.require(:book).permit(:title, :body)  
  end
  
  def check_author
    @book = Book.find(params[:id])
    if current_user != @book.user
      redirect_to books_path
    end
  end
  
end

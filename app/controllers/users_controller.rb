class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_author, only: [:edit]

  def index
    @books = Book.new
    @user = current_user
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
    @book = Book.new
    @books = @user.books
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = User.find(params[:id])
     if params[:user][:profile_image].nil?
      @user.profile_image.purge
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      @user.profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
     end
     if @user.update(user_params)
      flash[:notice] = "You have updated user successfully."
      redirect_to user_path(@user.id)
     else
      render "edit" 
     end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
  
  def check_author
    @user = User.find(params[:id])
    if current_user != @user
      redirect_to user_path(current_user.id), notice: "他人のユーザ情報編集画面にはアクセスできません"
    end
  end

end
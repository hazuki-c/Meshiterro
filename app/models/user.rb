class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :books, dependent: :destroy
  
  has_one_attached :profile_image
  
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
  
  validates :name, presence: true, uniqueness: true, length: { minimum: 2, maximum:20 }
  validates :introduction, length: { maximum: 50 }
  
  #update_without_current_passwordは現在のパスワードを入力せずにユーザー情報を更新するメソッド
  def update_without_current_password(params, *options)
    #引数として渡されたparamsオブジェクトからcurrent_passwordを削除
    params.delete(:current_password)

    #引数params内のpasswordとpassword_confirmationが空である場合は、それらも削除
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update_attributes(params, *options)
    #パスワード関連のデータをクリアするために、clean_up_passwordsメソッドも呼び出す
    clean_up_passwords
    #更新が成功したかどうかをresultという変数に格納して返す
    result
  end
          
end

class User < ApplicationRecord
   attr_accessor :remember_token
#   before_save { self.email = email.downcase }
   validates :name, presence: true, length: { maximum: 50 }
   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
   validates :email, presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },
                       uniqueness: { case_sensitive: false }
                       has_secure_password
                       validates :password, presence: true, 
                       length: { minimum: 6 }, allow_nil: true

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続セッションのためにユーザーをDBに記憶する(クッキー認証のための準備)
  def remember
    # new_tokenを発行する
    self.remember_token = User.new_token
    # remember_digestの中にUser.digest(remember_token)を入れる
    #→　update_attributeで無駄にvalidationをかける必要がなくハッシュ化して入る
    self.update_attribute(:remember_digest,User.digest(remember_token))
  end
  
  # ユーザーのログイン情報を破棄する
  def forget
    self.update_attribute(:remember_digest, nil)
  end
  
   # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil? #authenticated?を更新して、ダイジェストが存在しない場合に対応
    BCrypt::Password.new(self.remember_digest).is_password?(remember_token)
  end
                       
end

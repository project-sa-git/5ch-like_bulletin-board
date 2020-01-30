class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update] #順番に注意! 上から順番に「ログインしたユーザー」且つ正しいユーザー
  # include SessionsHelper  　#=> ヘルパー連動（AppConに）
  before_action :admin_user,     only: [:destroy]
  
  def index
    #旧 @users = User.all
    @users = User.paginate(page: params[:page])
  end
  
  # GET /users/:id
  def show
    @user = User.find(params[:id])
    # => app/views/users/show.html.erb
    # debugger
  end
  
  # GET /users/new
  def new
    @user = User.new
    # => form_for @user
  end
  
  # POST /users
  def create
    # オプション引数はキーワードにシンボルが入ってバリューに値が入ってる集合体
    # 　→　User.new(name: ..., email:, ...)
    # @user.name = params[:user][:name]
    # @user.user = params[:user][:email]
    # @user.password = params[:user][:password]
    # 1行で完結
    @user = User.new(user_params)
      if @user.save #=> Validation
        # Sucess
        @user.send_activation_email #=>signup後にactivation_emailを送りつける
        #不要 UserMailer.account_activation(@user).deliver_now
        flash[:info] = "Please check your email to activate your account."
        redirect_to root_url
        
        # 旧
      # log_in @user #=> ユーザー登録時にログイン
      # flash[:success] = "Welcome to the Sample App!"
      # redirect_to @user
        # redirect_to user_path(@user.id)
        # user_pathの引数デフォルトがidなので「.id」省略可、
        # redirect_to user_path(@user)
        # さらにredirect_toのデフォルト挙動としてユーザオブジェクトを渡すとuser_pathになるので
      #GETリクエスト(が右にいく) => "/users/#{@user.id}" => showアクションが動く
      else
      #Failure
      render 'new'
      end
  end
  
  # GET /users/:id/edit
  def edit
    @user = User.find(params[:id])
    #=> app/views/users/edit.html.erb
  end
  
  # PATCH /users/:id
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Success
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      # Failure
      #=> @user.errors.full_messages()
      render 'edit'
    end
  end
  
  # DELETE /users/:id
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  # beforeアクション

  # ログイン済みユーザーかどうか確認
  def logged_in_user
    unless logged_in?
      # GET   /users/:id/edit
      # PATCH /users/:id
      store_location #=> アクセスしようとしたURLを覚えておく
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
  
  # 正しいユーザーかどうか確認
  def correct_user
    # GET   /users/:id/edit
    # PATCH /users/:id
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)  #=> @user == current_user
  end
  
   # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end

class UsersController < ApplicationController
  before_action :authenticate_user,{only: [:index,:show,:edit,:update,:board_edit,:board_update]}
  before_action :forbid_login_user,{only: [:new,:create,:login,:login_form]}
  before_action :ensure_correct_user,{only: [:edit,:update,:board_edit,:board_update]}

  def index
    @user = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(
      name: params[:name],
      email: params[:email],
      image_name: "default_user.jpg",
      password: params[:password],
      board: "＊ひま＊"
    )
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "ユーザー登録が完了しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/new")
    end

  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    @user.name = params[:name]
    @user.email = params[:email]
    if params[:image]
      @user.image_name = "#{@user.id}.jpg"
      image = params[:image]
      File.binwrite("/home/vagrant/rails_app/myapp/public/user_images/#{@user.image_name}",image.read)
    end

    if @user.save
      flash[:notice]="ユーザー情報を編集しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/edit")
    end
  end

  def login_form

  end

  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      flash[:notice] = "ログインしました"
      session[:user_id] = @user.id
      redirect_to("/users/index")
    else
      @email = params[:email]
      @password = params[:password]
      @error_message = "メールアドレスまたはパスワードが間違っています"
      render("users/login_form")
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/login")
  end

  def board_edit
    @user = User.find_by(id: params[:id])
  end

  def board_update
    @user = User.find_by(id: params[:id])
    @user.board = "*#{params[:board]}*"
    if @user.save
      flash[:notice] = "更新しました"
      redirect_to("/users/index")
    else
      render("users/board_edit")
    end
  end

  def ensure_correct_user
    if params[:id].to_i != @current_user.id
      flash[:notice] = "権限がありません"
      redirect_to("/users/index")
    end
  end
end

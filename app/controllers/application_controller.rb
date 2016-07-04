require './config/environment'

class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "Vu0=$LbdNf284&z3!/BwS7"
  end

  get '/' do
    erb :index
  end

  get '/signup' do
    if !logged_in?
      erb :'user/signup'
    else
      redirect '/user_home'
    end
  end

  post '/signup' do
    if params[:username] == "" || params[:email] == "" || params[:password] == ""
      redirect '/signup'
    else
      @user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
      @user.save
      session[:user_id] = @user.id
      redirect '/user_home'
    end
  end

  get '/login' do

  end

  post '/login' do

  end

  get '/user_home' do
    if logged_in?
      erb :'user/user_home'
    else
      redirect '/'
    end
  end






  helpers do

    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end

  end

end

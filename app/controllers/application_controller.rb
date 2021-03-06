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
    if !logged_in?
      erb :index
    else
      redirect '/user_home'
    end
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
    if !session[:user_id]
      erb :'user/login'
    else
      redirect '/user_home'
    end
  end

  post '/login' do
    @user = User.find_by(:email => params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/user_home'
    else
      redirect '/login'
    end
  end

  get '/logout' do
    if session[:user_id] != nil
      session.destroy
      redirect '/'
    else
      redirect '/'
    end
  end
  get '/user_home' do
    if logged_in?
      erb :'user/user_home'
    else
      redirect '/'
    end
  end

  post '/user_home' do
    if params[:task] == ""
      redirect '/user_home'
    else
      @user = User.find_by_id(session[:user_id])
      @task = Task.create(:content => params[:task], :user_id => @user.id)
      redirect '/user_home'
    end
  end
  get '/user_home/:id' do
    if session[:user_id]
      @task = Task.find_by_id(params[:id])
      erb :'tasks/show_task'
    else
      redirect '/'
    end
  end
  delete '/user_home/:id/delete' do
    @task = Task.find_by_id(params[:id])
    if session[:user_id]
      @task = Task.find_by_id(params[:id])
      if @task.user_id == session[:user_id]
        @task.delete
        redirect '/user_home'
      else
        redirect '/user_home'
      end
    else
      redirect '/'
    end
  end
  get '/user_home/:id/edit' do
    if session[:user_id]
      @task = Task.find_by_id(params[:id])
      if @task.user_id == session[:user_id]
       erb :'tasks/edit_task'
      else
        redirect '/user_home'
      end
    else
      redirect '/'
    end
  end
  patch '/user_home/:id' do
    if params[:content] == ""
      redirect to "/user_home/#{params[:id]}/edit"
    else
      @task = Task.find_by_id(params[:id])
      @task.content = params[:content]
      @task.save
      redirect "/user_home"
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

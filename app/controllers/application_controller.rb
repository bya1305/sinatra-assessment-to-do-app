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
    erb :'user/signup'
  end

end

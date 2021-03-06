require 'sinatra/base'
require 'data_mapper'
require 'rack-flash'

require './lib/link'
require './lib/tag'
require './lib/user'

class BookmarkManager < Sinatra::Base

  env = ENV['RACK_ENV'] || 'development'

  DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

  DataMapper.finalize

  DataMapper.auto_upgrade!

  enable :sessions
  set :session_secret, 'super secret'
  use Rack::Flash
  use Rack::MethodOverride

  get '/' do
    @links = Link.all
    erb :index
  end

  get '/links/new' do
    erb :"links/new"
  end

  post '/links' do
    url = params["url"]
    title = params["title"]
    tags = params["tags"].split(" ").map do |tag|
      Tag.first_or_create(:text => tag)
    end
    Link.create(:url => url, :title => title, :tags => tags)
    redirect to('/')
  end

  get '/tags/:text' do
    tag = Tag.first(:text => params[:text])
    @links = tag ? tag.links : []
    erb :index
  end

  get '/users/new' do
    @user = User.new
    erb :"users/new"
  end

  post '/users' do
    @user = User.new(:email => params[:email],
                :password => params[:password],
                :password_confirmation => params[:password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      redirect to('/')
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :"users/new"
    end
  end

  get '/sessions/new' do
    erb :"sessions/new"
  end

  post '/sessions' do
    email, password = params[:email], params[:password]
    user = User.authenticate(email, password)
    if user
      session[:user_id] = user.id
      redirect to('/')
    else
      flash[:errors] = ["The email or password is incorrect"]
      erb :"sessions/new"
    end
  end

  delete '/sessions' do
    flash[:notice] = 'Good bye!'
    session[:user_id] = nil
    redirect to('/')
  end

  # post '/sessions/reminder' do
  #   user = User.first(:email => params[:email])
  #   user.password_token = (1.64).map{('A'..'Z').to_a.sample}.join
  #   user.save
  #   'Check your email'
  # end

  # get '/sessions/request_token'
  #   erb :"sessions/request_token"
  # end

  # get '/sessions/change_password/:token'
  #   @password_token = params[:token]
  #   erb :"sessions/change_password" 
  # end

  # post '/sessions/change_reset'
  #   user = Usser.first(:password_token => params[:password_token])
  #   user.update(:password => params[:new_password], :password_confirmation => params[:password_confirmation]
  #   user.save
  # end

  helpers do
    def current_user
      @current_user ||=User.get(session[:user_id]) if session[:user_id]
    end
  end


  # start the server if ruby file executed directly
  run! if app_file == $0
end













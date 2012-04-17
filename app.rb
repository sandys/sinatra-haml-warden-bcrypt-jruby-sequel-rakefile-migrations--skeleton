require 'rubygems'
require 'sinatra'
require 'sinatra_warden'
require 'haml'


Warden::Manager.serialize_into_session{|id| id }
Warden::Manager.serialize_from_session{|id| id }


Warden::Strategies.add(:password) do
  
=begin
    def valid?
      puts 'password strategy valid?'
      username = params["name"]
      username and username != ''
    end
=end

=begin
  def authenticate!
      puts 'password strategy authenticate'
      username = params['username']
      puts "username = #{username}"
      if ['tim', 'rach'].include?(username)
        begin
          success!(username)
        end
      else
        fail!('could not login')
      end
  end
end
=end

  def authenticate!
    user = User.authenticate(params["username"], params["password"])
    user.nil? ? fail!("Invalid credentials. Login failed") : success!(user, "Auth success")
  end
end

env_index = ARGV.index("-e")
env_arg = ARGV[env_index+1] if env_index
@@env = env_arg || ENV["SINATRA_ENV"] || "development"


require_relative 'models/init'

class App < Sinatra::Base

  enable :sessions
  set :session_secret, 'super secret session key'
  set :static, true
  set :public_folder,   'public'
  set :haml, :format => :html5
  use Rack::Session::Cookie

  configure :production do
    set :haml, { :ugly=>true }
    set :clean_trace, true
    set :css_files, :blob
    set :js_files, :blob
  end

  configure :development do
    require "sinatra/reloader"
    register Sinatra::Reloader
    also_reload 'helpers/*.rb'
    also_reload 'models/*.rb'
    enable :reload_templates
  end

  helpers do
    include Rack::Utils
    alias_method :h, :escape_html

    def ensure_authenticated
     unless env['warden'].authenticate!
       throw(:warden)
     end
   end

    def user
      env['warden'].user
    end 
  end
  
  enable :sessions

  register Sinatra::Warden
  set :auth_failure_path, '/login'
  use Warden::Manager do |manager|
    manager.default_strategies :password
    manager.failure_app = FailureApp.new
  end

  def call(env)
    #global logging
    #puts 'manager: ' + env['REQUEST_METHOD'] + ' ' + env['REQUEST_URI']
    super
  end

  before '/admin*' do
    puts "entering admin"
    env['warden'].authenticate!
  end

  get "/admin" do
    haml :admin
  end

  
  get "/login/?" do
    puts "coming to login"
    haml :login
  end

  post "/login/?" do
    if env['warden'].authenticate
      redirect '/'
    else
      redirect '/login'
    end
  end
  
  get "/register/?" do
    puts "coming to register"
    haml :register
  end

  post "/register/?" do
    @user = User.new
    @user.email = params[:email]
    @user.username = params[:username]
    @user.password = params[:password]
    @user.save 
  end

  get "/logout/?" do
    env['warden'].logout
    redirect '/'
  end

  not_found do
    puts "404... not found"
  end

end

class FailureApp < Sinatra::Base
  def call(env)
    uri = env['REQUEST_URI']
    env['rack.session'][:return_to] = env['warden.options'][:attempted_path]
    puts 'failure: ' + env['REQUEST_METHOD'] + ' ' + uri
    #[302, {'Location' => '/error?uri=' + CGI::escape(uri)}, '']
    [302, {'Location' => '/login/?'}, '']
  end
end

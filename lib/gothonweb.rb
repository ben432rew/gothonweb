require_relative "gothonweb/version"
require_relative "map"
require "sinatra"
require "erb"
include Rooms

  use Rack::Session::Pool

  get '/' do
    # this is used to "setup" the session with starting values
    p START
    session[:room] = START
    redirect("/game")
  end

  get '/game' do
    erb :show_room, :locals => {:room => session[:room]}
  end

  post '/game' do
    action = "#{params[:action] || nil}"
    # there is a bug here, can you fix it?
    if session[:room]
      session[:room] = session[:room].go(:action)
    else 
      session[:room].go(GENERIC_DEATH)
    end
    redirect("/game")
  end

  not_found do
    status 404
    erb :oops
  end

  get '/count' do
    session[:count] ||= 0
    session[:count] += 1
    "Count #{session[:count]}"
  end

  get '/reset' do
    session.clear
    "count reset to 0."
  end
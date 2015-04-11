require 'sinatra'
require 'sinatra/reloader'
require_relative 'db/connection'
require_relative 'models/cell'
require_relative 'models/ship'
require_relative 'models/ocean'
require_relative 'models/constants'
require_relative 'models/game'
require_relative 'models/player'

before do
  @difficulty_settings = DIFFICULTY_SETTINGS
  @milton_bradley_ships = MILTON_BRADLEY_SHIPS
  @oceans_of_the_world = OCEANS_OF_THE_WORLD
end

get '/' do
  erb :index
end

get '/players' do
  @players = Player.all
  erb :'players/index'
end

get '/players/new' do
  erb :'players/new'
end

get '/players/:id' do
  @player = Player.find(params[:id])
  erb :'players/show'
end

get '/players/:id/records' do
  @player = Player.find(params[:id])
  @completed_games = @player.games.where(complete: true)
  erb :'players/records'
end

get '/players/:id/games/new' do
  @player = Player.find(params[:id])
  erb :'games/new'
end

get '/players/:id/games/existing' do
  @player = Player.find(params[:id])
  @existing_games = @player.games.where(complete: false)
  erb :'games/existing'
end

get '/players/:player_id/games/:game_id' do
  @player = Player.find(params[:player_id])
  @game = @player.games.find(params[:game_id])
  @ocean = @game.ocean
  erb :'games/show'
end

post '/players' do
  @player = Player.new(name: params[:name], games_won: 0)
  @player.save
  redirect to("/players/#{@player.id}")
end

post '/players/:id/games' do
  @player = Player.find(params[:id])
  difficulty = params[:difficulty].to_sym
  @game = @player.start_new_single_player_game(difficulty)
  redirect to("/players/#{@player.id}/games/#{@game.id}")
end

post '/players/:player_id/games/:game_id/move' do
  x, y = params[:x_coord], params[:y_coord]
  @player = Player.find(params[:player_id])
  @game = @player.games.find(params[:game_id])
  @cell = @game.ocean.cells.where(x_coord: x, y_coord: y).first
  @cell.hit = true
  @cell.save
  redirect to("/players/#{@player.id}/games/#{@game.id}")
end

after do
  ActiveRecord::Base.connection.close
end


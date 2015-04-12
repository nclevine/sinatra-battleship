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

# get '/players' do
#   @players = Player.all
#   erb :'players/index-old'
# end

get '/players/login' do
  erb :'players/login'
end

get '/players/bad_login' do
  erb :'players/bad_login'
end

get '/players/new' do
  erb :'players/new'
end

get '/players/new_bad_input' do
  erb :'players/new_bad_input'
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
  @width, @height = @ocean.width, @ocean.height
  @ships = @ocean.ships
  erb :'games/show'
end

get '/players/:player_id/games/:game_id/bad-move' do
  @player = Player.find(params[:player_id])
  @game = @player.games.find(params[:game_id])
  @ocean = @game.ocean
  @width, @height = @ocean.width, @ocean.height
  @ships = @ocean.ships
  erb :'games/show_bad_move'
end

get '/players/:player_id/games/:game_id/already-shot' do
  @player = Player.find(params[:player_id])
  @game = @player.games.find(params[:game_id])
  @ocean = @game.ocean
  @width, @height = @ocean.width, @ocean.height
  @ships = @ocean.ships
  erb :'games/show_already_shot'
end

# post '/players' do
#   @player = Player.new(name: params[:name], games_won: 0)
#   @player.save
#   redirect to("/players/#{@player.id}")
# end

post '/players/new' do
  if params.values.include?('')
    redirect to('/players/new_bad_input')
  else
    @player = Player.new(name: params[:username], password: params[:password], games_won: 0)
    @player.save
    redirect to("/players/#{@player.id}")
  end
end

post '/players/login' do
  @player = Player.find_by(name: params[:username], password: params[:password])
  if @player
    redirect to("/players/#{@player.id}")
  else
    redirect to("/players/bad_login")
  end
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
  @target_cell = @game.ocean.cells.where(x_coord: x, y_coord: y).first
  if @target_cell && !@target_cell.hit
    @game.play(@target_cell)
    redirect to("/players/#{@player.id}/games/#{@game.id}")  
  elsif !@target_cell
    redirect to("/players/#{@player.id}/games/#{@game.id}/bad-move")
  elsif @target_cell.hit
    redirect to("/players/#{@player.id}/games/#{@game.id}/already-shot")
  end
end

after do
  ActiveRecord::Base.connection.close
end


require_relative 'db/connection'
require_relative 'lib/cell'
require_relative 'lib/ship'
require_relative 'lib/ocean'
require_relative 'lib/constants'
require_relative 'lib/game'
require_relative 'lib/player'

def display_main_menu
    puts LOGO
    puts MENU_BORDER
    puts '|      1. Choose Player      |'.center(60, ' ')
    puts '|      2. New Player         |'.center(60, ' ')
    puts '|      3. Delete Player      |'.center(60, ' ')
    puts '|      4. Exit               |'.center(60, ' ')
    puts MENU_BORDER
end

def get_valid_menu_choice num_choices
  user_input = gets.strip.to_i
  until (1..num_choices).include?(user_input)
    puts 'Select an available option.'
    user_input = gets.strip.to_i
  end
  return user_input
end

def display_existing_players
    puts LOGO
    puts MENU_BORDER
    if Player.all.any?
        puts '|      Select a player:      |'.center(60, ' ')
        Player.all.each_with_index { |player, index| puts ("|      #{index + 1}. #{player}".ljust(29) + '|').center(60, ' ') }
    else
        puts '|    No existing players.    |'.center(60, ' ')
    end
    if Player.all.length < 9
        puts "|      #{Player.all.length + 1}. Cancel             |".center(60, ' ')
    else
        puts "|      #{Player.all.length + 1}. Cancel            |".center(60, ' ')
    end
    puts MENU_BORDER
end

def make_new_player
    puts 'What is your name?'
    name = gets.strip
    new_player = Player.new(name: name, games_won: 0)
    until new_player.valid?
        puts 'Enter a name at least two letters long.'
        name = gets.strip
        new_player.name = name
    end
    new_player.save
    return new_player
end

def display_new_game_menu
    puts LOGO
    puts MENU_BORDER
    puts '|    Choose a difficulty:    |'.center(60, ' ')
    puts '|    1. Baby (Arctic)        |'.center(60, ' ')
    puts '|    2. Easy (Southern)      |'.center(60, ' ')
    puts '|    3. Normal (Indian)      |'.center(60, ' ')
    puts '|    4. Hard (Atlantic)      |'.center(60, ' ')
    puts '|    5. Impossible (Pacific) |'.center(60, ' ')
    puts MENU_BORDER
end

difficulties = {1 => :baby, 2 => :easy, 3 => :normal, 4 => :hard, 5 => :impossible}

# begin UI
loop do
    system ('clear')
    display_main_menu
    user_input = get_valid_menu_choice(4)
    if user_input == 1 # Choose Player
        system ('clear')
        display_existing_players
        user_input = get_valid_menu_choice(Player.all.length + 1)
        if (1..Player.all.length).include?(user_input)
            system ('clear')
            player = Player.all[user_input - 1]
            player.display_games_menu
            user_input = get_valid_menu_choice(4)
            if user_input == 1 # New Game
                system ('clear')
                display_new_game_menu
                user_input = get_valid_menu_choice(5)
                game = player.start_new_single_player_game(difficulties[user_input])
                game.play
            elsif user_input == 2 # Load Save Game
                system ('clear')
                incomplete_games = player.display_saved_games
                user_input = get_valid_menu_choice(incomplete_games.length + 1)
                if (1..incomplete_games.length).include?(user_input)
                    game = incomplete_games[user_input - 1]
                    game.play
                end
            elsif user_input == 3 # View Past Games
                system ('clear')
                completed_games = player.display_completed_games
                user_input = get_valid_menu_choice(completed_games.length + 1)
                if (1..completed_games.length).include?(user_input)
                    game = completed_games[user_input - 1]
                    system ('clear')
                    game.display_board
                    puts 'Press any key to return to menu.'
                    go_back = gets
                end
            end
        end
    elsif user_input == 2 # New Player
        system ('clear')
        new_player = make_new_player
        puts("#{new_player} created!")
    elsif user_input == 3 # Delete Player
        system ('clear')
        display_existing_players
        user_input = get_valid_menu_choice(Player.all.length + 1)
        if (1..Player.all.length).include?(user_input)
            player_to_delete = Player.all[user_input - 1]
            system('clear')
            user_input = player_to_delete.display_delete_player_menu
            if user_input == 'y'
                puts("#{player_to_delete} deleted!")
                player_to_delete.destroy
            end
        end
    else
        system('clear')
        exit
    end
end
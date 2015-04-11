require_relative 'constants'

class Player < ActiveRecord::Base
    has_and_belongs_to_many :games
    validates :name, presence: true, length: { in: 2..50 }

    def to_str
        name
    end

    def to_s
        to_str
    end

    def start_new_single_player_game difficulty
        new_game = games.create(num_torpedoes: 0, complete: false)
        new_game.build_ocean(difficulty)
        return new_game
    end

    def display_games_menu
        puts LOGO
        puts MENU_BORDER
        puts ("|      Welcome   #{self}".ljust(29) + '|').center(60, ' ')
        puts '|      1. New Game           |'.center(60, ' ')
        puts '|      2. Saved Games        |'.center(60, ' ')
        puts '|      3. Completed Games    |'.center(60, ' ')
        puts '|      4. Cancel             |'.center(60, ' ')
        puts MENU_BORDER
    end

    def display_saved_games
        incomplete_games = games.where(complete: false)
        puts LOGO
        puts MENU_BORDER
        if incomplete_games.any?
            puts '|      Continue Playing:     |'.center(60, ' ')
            incomplete_games.each_with_index { |game, index| puts ("| #{index + 1}. #{game}".ljust(29) + '|').center(60, ' ') }
        else
            puts ('|' + 'No games in progress.'.center(28, ' ') + '|').center(60, ' ')
        end
        puts ("| #{incomplete_games.length + 1}. Cancel".ljust(29) + '|').center(60, ' ')
        puts MENU_BORDER
        return incomplete_games
    end

    def display_completed_games
        completed_games = games.where(complete: true)
        puts LOGO
        puts MENU_BORDER
        if completed_games.any?
            puts '|    View Completed Game:    |'.center(60, ' ')
            completed_games.each_with_index { |game, index| puts ("| #{index + 1}. #{game}".ljust(29) + '|').center(60, ' ') }
        else
            puts ('|' + 'No completed games.'.center(28, ' ') + '|').center(60, ' ')
        end
        puts ("| #{completed_games.length + 1}. Cancel".ljust(29) + '|').center(60, ' ')
        puts ('|' + "#{games_won} games won  |".rjust(29)).center(60, ' ')
        puts MENU_BORDER
        return completed_games
    end

    def display_delete_player_menu
        puts 'Are you sure you want to delete ' + self + '?'
        puts 'Y / N'
        user_input = gets.strip.downcase
        until ['y', 'n'].include?(user_input)
            puts 'Select \'Y\' or \'N\'.'
            user_input = gets.strip.downcase
        end
        return user_input
    end
end
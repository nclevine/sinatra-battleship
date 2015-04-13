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
end
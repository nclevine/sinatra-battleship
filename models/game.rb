require_relative 'constants'

class Game < ActiveRecord::Base
    has_and_belongs_to_many :players
    has_one :ocean

    def to_str
        if !complete
            "#{num_torpedoes} turns left, #{created_at.strftime("%D")}"
        else
            "#{ocean.name}, #{completed_at.strftime("%D")}"
        end
    end

    def to_s
        to_str
    end

    def build_ships difficulty
        built_ships = []
        ship_names = DIFFICULTY_SETTINGS[difficulty][:ship_array]
        ship_attrs = []
        ship_names.each { |ship_name| ship_attrs << MILTON_BRADLEY_SHIPS[ship_name] }
        ship_attrs.each { |ship_attr| built_ships << Ship.new(ship_attr) }
        return built_ships
    end

    def build_ocean difficulty
        ocean_attrs = OCEANS_OF_THE_WORLD[DIFFICULTY_SETTINGS[difficulty][:region]]
        new_ocean = Ocean.new(ocean_attrs)
        new_ocean.game = self
        new_ocean.save
        new_ocean.populate_with_cells
        built_ships = build_ships(difficulty)
        built_ships.each do |ship|
            ship.ocean = new_ocean
            ship.save
        end
        new_ocean.arrange_ships
        self.num_torpedoes = DIFFICULTY_SETTINGS[difficulty][:torpedoes]
        self.save
    end

    def fire_torpedo target_cell
        target_cell.hit = true
        target_cell.save
        self.num_torpedoes -= 1
        self.save
        return target_cell.ship
    end

    def update_ships_sunk_status
        ocean.ships.each { |ship| ship.update_sunk_status }
        sunk_ships = ocean.ships.where(sunk: true)
        return sunk_ships.length
    end

    def update_completed_status
        sunk_ships = update_ships_sunk_status
        if self.num_torpedoes == 0 || sunk_ships == ocean.ships.length
            self.update(complete: true)
            self.completed_at = Time.now
        end
        self.save
        return complete
    end

    def check_if_player_won
        sunk_ships = update_ships_sunk_status
        if sunk_ships == ocean.ships.length
            player_wins = players.first.games_won + 1
            players.first.update(games_won: player_wins)
            return true
        else
            return false
        end
    end

    def play(target_cell)
        fire_torpedo(target_cell)
        update_completed_status
        check_if_player_won
    end
end
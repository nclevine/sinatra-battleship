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

    def play_or_quit
        puts '(A)im torpedo | (Q)uit'
        user_input = gets.strip.downcase
        until ['a', 'q'].include?(user_input)
            puts 'Select an available option.'
            user_input = gets.strip.downcase
        end
        return user_input
    end

    def fire_torpedo target_cell
        target_cell.hit = true
        target_cell.save
        self.num_torpedoes -= 1
        self.save
        return target_cell.ship
    end

    def aim_and_fire_torpedo
        hit_a_cell = false
        until hit_a_cell
            puts 'Aim torpedo at which cell? (format "column#,row#")'
            user_input = gets.strip
            until user_input.include?(',')
                puts 'Enter the coordinates in the proper format.'
                user_input = gets.strip
            end
            coords = user_input.split(',').map(&:to_i)
            target_cell = ocean.cells.where(x_coord: coords.first, y_coord: coords.last).first
            if target_cell == nil
                puts 'Invalid coordinates. Re-enter.'
            elsif target_cell.hit
                puts 'You have already hit that sector. Re-enter.'
            else
                hit_ship = fire_torpedo(target_cell)
                hit_a_cell = true
            end
        end
        result_string = "You shot (#{coords.first}, #{coords.last})...\n"
        if hit_ship
            result_string += 'You hit a ship!'
            update_ships_sunk_status
            result_string += "\nThe ship sunk!!" if hit_ship.reload.sunk
        else
            result_string += 'sploosh.'
        end

        result_string += "\n#{self.num_torpedoes} torpedoes left"
        return result_string
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

    def display_board
        system ('clear')
        puts ocean
    end

    def results
        if complete
            check_if_player_won ? puts('YOU WON!') : puts('GAME OVER')
            puts "\nPress any key to continue."
            gets
        end
    end

    def play
        result_of_turn = "#{self.num_torpedoes} torpedoes left"
        until self.complete
            display_board
            puts result_of_turn
            user_input = play_or_quit
            user_input == 'a' ? (result_of_turn = aim_and_fire_torpedo) : break
            update_completed_status
        end
        display_board
        results
        return complete
    end
end
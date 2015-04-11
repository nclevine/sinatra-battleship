class Ship < ActiveRecord::Base
    has_many :cells
    belongs_to :ocean

    def to_str
        name
    end

    def to_s
        to_str
    end

    def insert_into_empty_cells empty_cells
        empty_cells.each do |cell| 
            cell.ship = self
            cell.save
        end
    end

    def update_sunk_status
        hit_cells = cells.where(hit: true)
        self.update(sunk: true) if hit_cells.length == self.length
        return sunk
    end
end
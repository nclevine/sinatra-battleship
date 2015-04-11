class Cell < ActiveRecord::Base
    belongs_to :ocean
    belongs_to :ship

    def to_str
        if hit
            if ship != nil
                '#'
            else
                'o'
            end
        else
            '.'
        end
    end

    def to_s
        to_str
    end
end
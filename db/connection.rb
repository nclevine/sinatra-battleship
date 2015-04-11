require 'active_record'

ActiveRecord::Base.establish_connection(
    database: 'battleship',
    adapter: 'postgresql'
)
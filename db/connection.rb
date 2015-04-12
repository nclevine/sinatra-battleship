require 'active_record'

ActiveRecord::Base.establish_connection(
    database: 'ncl_battleship',
    adapter: 'postgresql',
    host: 'localhost'
)
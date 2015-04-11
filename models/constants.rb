# require 'pry'

DIFFICULTY_SETTINGS = {
    impossible: {region: :pacific, torpedoes: 70, ship_array: [:aircraft_carrier, :aircraft_carrier, :aircraft_carrier, :battleship, :battleship, :battleship, :battleship, :submarine, :submarine, :cruiser, :cruiser, :destroyer]},
    hard: {region: :atlantic, torpedoes: 55, ship_array: [:aircraft_carrier, :aircraft_carrier, :battleship, :battleship, :submarine, :submarine, :cruiser, :destroyer, :destroyer]},
    normal: {region: :indian, torpedoes: 41, ship_array: [:aircraft_carrier, :battleship, :submarine, :cruiser, :cruiser, :destroyer]},
    easy: {region: :southern, torpedoes: 30, ship_array: [:battleship, :submarine, :cruiser, :destroyer]},
    baby: {region: :arctic, torpedoes: 21, ship_array: [:aircraft_carrier, :aircraft_carrier]}
}

MILTON_BRADLEY_SHIPS = {
    aircraft_carrier: {name: 'aircraft carrier', length: 5, sunk: false},
    battleship: {name: 'battleship', length: 4, sunk: false},
    submarine: {name: 'submarine', length: 3, sunk: false},
    cruiser: {name: 'cruiser', length: 3, sunk: false},
    destroyer: {name: 'destroyer', length: 2, sunk: false}
}

OCEANS_OF_THE_WORLD = {
    pacific: {name: 'Pacific Ocean', width: 15, height: 15},
    atlantic: {name: 'Atlantic Ocean', width: 13, height: 12},
    indian: {name: 'Indian Ocean', width: 10, height: 10},
    southern: {name: 'Southern Ocean', width: 8, height: 7},
    arctic: {name: 'Arctic Ocean', width: 6, height: 6}
}

LOGO = '  ____    _  _____ _____ _     _____ ____  _   _ ___ ____  
 | __ )  / \|_   _|_   _| |   | ____/ ___|| | | |_ _|  _ \ 
 |  _ \ / _ \ | |   | | | |   |  _| \___ \| |_| || || |_) |
 | |_) / ___ \| |   | | | |___| |___ ___) |  _  || ||  __/ 
 |____/_/   \_\_|   |_| |_____|_____|____/|_| |_|___|_|    
                                                           '

MENU_BORDER = '------------------------------'.center(60, " ")

# binding.pry
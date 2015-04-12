drop table if exists players;
drop table if exists games;
drop table if exists games_players;
drop table if exists oceans;
drop table if exists ships;
drop table if exists cells;

create table players(
    id serial primary key,
    name varchar(50) not null,
    password varchar(50) not null,
    games_won integer not null
);

create table games(
    id serial primary key,
    created_at timestamp not null,
    num_torpedoes integer not null,
    complete boolean not null,
    completed_at timestamp
);

create table games_players(
    player_id integer not null,
    game_id integer not null
);

create table oceans(
    id serial primary key,
    name varchar(50) not null,
    width integer not null,
    height integer not null,
    game_id integer not null
);

create table ships(
    id serial primary key,
    name varchar(50) not null,
    length integer not null,
    sunk boolean not null,
    ocean_id integer not null
);

create table cells(
    id serial primary key,
    x_coord integer not null,
    y_coord integer not null,
    hit boolean not null,
    ocean_id integer not null,
    ship_id integer
);

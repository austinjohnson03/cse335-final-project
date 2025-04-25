CREATE DATABASE IF NOT EXISTS nba;
USE nba;

CREATE TABLE IF NOT EXISTS franchises (
	id INT UNSIGNED PRIMARY KEY,
	most_recent_name VARCHAR(64) NOT NULL,
	year_founded INT UNSIGNED NOT NULL,
	year_folded INT UNSIGNED,
	is_active BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS teams (
	id INT UNSIGNED PRIMARY KEY,
	name VARCHAR(48) NOT NULL,
	franchise_id INT UNSIGNED,
	FOREIGN KEY (franchise_id) REFERENCES franchises(id)
		ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS team_details (
  id INT UNSIGNED PRIMARY KEY,
  abbreviation VARCHAR(3) NOT NULL UNIQUE,
  nickname VARCHAR(16) NOT NULL UNIQUE,
  city VARCHAR(24) NOT NULL,
  state CHAR(2) NOT NULL CHECK (state REGEXP '^[A-Z]{2}$'),
  arena VARCHAR(32) NOT NULL,
  arena_capacity INT UNSIGNED NOT NULL CHECK (arena_capacity > 0),
  owner VARCHAR(64),
  general_manager VARCHAR(64),
  head_coach VARCHAR(64) NOT NULL,
  d_league_affiliation VARCHAR(64) UNIQUE,
  FOREIGN KEY (id) REFERENCES teams(id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS seasons (
	id INT UNSIGNED PRIMARY KEY,
	start_date DATE NOT NULL,
	end_date DATE NOT NULL,
	season_type ENUM (
		'Preseason', 'Regular Season', 'All-Star Weekend', 'Playoffs'
	) NOT NULL,
    end_year INT UNSIGNED NOT NULL
);

CREATE TABLE IF NOT EXISTS players (
	id INT UNSIGNED PRIMARY KEY,
	first_name VARCHAR(24) NOT NULL,
	last_name VARCHAR(32) NOT NULL,
	birthdate DATE NOT NULL,
	school VARCHAR(32),
	country VARCHAR(32) NOT NULL,
	last_affiliation VARCHAR(64) NOT NULL,
	height INT UNSIGNED,
	weight INT UNSIGNED,
	season_exp INT UNSIGNED NOT NULL,
	jersey_num INT UNSIGNED,
	position VARCHAR(24),
	is_active BOOLEAN NOT NULL DEFAULT FALSE,
	franchise_id INT UNSIGNED,
	from_year INT UNSIGNED,
	to_year INT UNSIGNED,
	is_d_league BOOLEAN NOT NULL DEFAULT FALSE,
	is_nba BOOLEAN NOT NULL DEFAULT FALSE,
	has_played BOOLEAN NOT NULL DEFAULT FALSE,
	is_greatest_75 BOOLEAN NOT NULL DEFAULT FALSE,
	FOREIGN KEY (franchise_id) REFERENCES franchises(id)
		ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS draft_history (
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	player_id INT UNSIGNED,
	name VARCHAR(64) NOT NULL,
	season INT UNSIGNED NOT NULL,
	round_number INT UNSIGNED,
	round_pick INT UNSIGNED,
	overall_pick INT UNSIGNED,
	draft_type ENUM(
	'Draft', 'Territorial'
	) NOT NULL,
	team_id INT UNSIGNED,
	organization VARCHAR(64),
	organization_type ENUM(
	'College/University', 'High School','Other Team/Club'
	)
);

CREATE TABLE IF NOT EXISTS games (
  id INT UNSIGNED PRIMARY KEY,
  season_id INT UNSIGNED NOT NULL,
  game_date DATE NOT NULL,
  attendance INT UNSIGNED,
  game_time VARCHAR(8),
  lead_changes INT UNSIGNED,
  times_tied INT UNSIGNED,
  FOREIGN KEY (season_id) REFERENCES seasons(id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS team_games (
  game_id INT UNSIGNED NOT NULL,
  team_id INT UNSIGNED NOT NULL,
  fgm INT UNSIGNED,
  fga INT UNSIGNED,
  fg3m INT UNSIGNED,
  fg3a INT UNSIGNED,
  ftm INT UNSIGNED,
  fta INT UNSIGNED,
  oreb INT UNSIGNED,
  dreb INT UNSIGNED,
  reb INT UNSIGNED,
  ast INT UNSIGNED,
  stl INT UNSIGNED,
  blk INT UNSIGNED,
  tov INT UNSIGNED,
  pf INT UNSIGNED,
  pts INT UNSIGNED NOT NULL,
  plus_minus INT,
  pts_paint INT UNSIGNED,
  pts_2nd_chance INT UNSIGNED,
  pts_fb INT UNSIGNED,
  largest_lead INT UNSIGNED,
  team_turnovers INT UNSIGNED,
  total_turnovers INT UNSIGNED,
  team_rebounds INT UNSIGNED,
  pts_off_to INT UNSIGNED,
  is_home BOOLEAN,
  PRIMARY KEY (game_id, team_id),
  FOREIGN KEY (game_id) REFERENCES games(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (team_id) REFERENCES teams(id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS quarter_scores (
  game_id INT UNSIGNED NOT NULL,
  period_num INT UNSIGNED NOT NULL,
  is_ot BOOLEAN,
  points INT UNSIGNED,
  team_id INT UNSIGNED NOT NULL,
  PRIMARY KEY(game_id, team_id, period_num),
  FOREIGN KEY (game_id) REFERENCES games(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (team_id) REFERENCES teams(id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS officials (
  id INT UNSIGNED PRIMARY KEY,
  first_name VARCHAR(24) NOT NULL,
  last_name VARCHAR(32) NOT NULL,
  jersey_num INT UNSIGNED
);

CREATE TABLE IF NOT EXISTS game_officials ( 
  game_id INT UNSIGNED NOT NULL,
  official_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (game_id, official_id),
  FOREIGN KEY (game_id) REFERENCES games(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (official_id) REFERENCES officials(id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS conferences (
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(32) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS divisions (
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(32) NOT NULL,
    conference_id INT UNSIGNED
);

CREATE TABLE IF NOT EXISTS franchise_divisions (
	season_id INT UNSIGNED NOT NULL,
    franchise_id INT UNSIGNED NOT NULL,
    division_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (season_id, franchise_id),
    FOREIGN KEY (season_id) REFERENCES seasons(id)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (franchise_id) REFERENCES franchises(id)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (division_id) REFERENCES divisions(id)
		ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS franchise_conferences (
	season_id INT UNSIGNED NOT NULL,
    franchise_id INT UNSIGNED NOT NULL,
    conference_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (season_id, franchise_id),
    FOREIGN KEY (season_id) REFERENCES seasons(id)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (franchise_id) REFERENCES franchises(id)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (conference_id) REFERENCES conference(id)
		ON DELETE CASCADE ON UPDATE CASCADE
);

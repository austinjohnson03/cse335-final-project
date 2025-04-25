CREATE INDEX idx_franchises_is_active ON franchises(is_active);

CREATE INDEX idx_teams_franchise_id ON teams(franchise_id);

CREATE INDEX idx_team_details_team_id ON team_details(id);
CREATE INDEX idx_team_details_abbreviation ON team_details(abbreviation);
CREATE INDEX idx_team_details_nickname ON team_details(nickname);

CREATE INDEX idx_seasons_start_date ON seasons(start_date);
CREATE INDEX idx_seasons_season_type ON seasons(season_type);

CREATE INDEX idx_players_franchise_id ON players(franchise_id);
CREATE INDEX idx_players_is_active ON players(is_active);
CREATE INDEX idx_players_is_nba ON players(is_nba);
CREATE INDEX idx_players_to_year ON players(to_year);

CREATE INDEX idx_draft_history_player_id ON draft_history(player_id);
CREATE INDEX idx_draft_history_season ON draft_history(season);
CREATE INDEX idx_games_season_id ON games(season_id);
CREATE INDEX idx_games_game_date ON games(game_date);
CREATE INDEX idx_team_games_game_id ON team_games(game_id);
CREATE INDEX idx_team_games_team_id ON team_games(team_id);

CREATE INDEX idx_quarter_scores_game_id ON quarter_scores(game_id);
CREATE INDEX idx_quarter_scores_team_id ON quarter_scores(team_id);

CREATE INDEX idx_officials_jersey_num ON officials(jersey_num);
CREATE INDEX idx_game_officials_game_id ON game_officials(game_id);

CREATE INDEX idx_conferences_name ON conferences(name);

CREATE INDEX idx_divisions_conference_id ON divisions(conference_id);

CREATE INDEX idx_franchise_divisions_season_id ON franchise_divisions(season_id);
CREATE INDEX idx_franchise_divisions_franchise_id ON franchise_divisions(franchise_id);

CREATE INDEX idx_franchise_conferences_season_id ON franchise_conferences(season_id);
CREATE INDEX idx_franchise_conferences_franchise_id ON franchise_conferences(franchise_id);

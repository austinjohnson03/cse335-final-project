SET @game_id = 22100001;

SELECT 
    g.id AS game_id,
    g.game_date,
    g.attendance,
    g.game_time,
    g.lead_changes,
    g.times_tied,
    t.name AS team_name,
    IF(gs.is_home, 'Home', 'Away') AS team_type,
    td.arena,
    gs.pts,
    gs.fgm,
    gs.fga,
    ROUND((gs.fgm / NULLIF(gs.fga, 0)) * 100, 2) AS fg_pct,
    gs.fg3m,
    gs.fg3a,
    ROUND((gs.fg3m / NULLIF(gs.fg3a, 0)) * 100, 2) AS fg3_pct,
    gs.ftm,
    gs.fta,
    ROUND((gs.ftm / NULLIF(gs.fta, 0)) * 100, 2) AS ft_pct,
    gs.oreb,
    gs.dreb,
    gs.reb,
    gs.ast,
    gs.stl,
    gs.blk,
    gs.tov,
    gs.pf,
    gs.plus_minus,
    gs.pts_paint,
    gs.pts_2nd_chance,
    gs.pts_fb,
    gs.largest_lead,
    gs.team_turnovers,
    gs.total_turnovers,
    gs.team_rebounds,
    gs.pts_off_to,
    (
        SELECT GROUP_CONCAT(CONCAT(o.first_name, ' ', o.last_name) ORDER BY go.official_id SEPARATOR ', ')
        FROM game_officials go
        JOIN officials o ON go.official_id = o.id
        WHERE go.game_id = g.id
    ) AS officials
FROM 
    games g
JOIN 
    team_games gs ON g.id = gs.game_id
JOIN 
    teams t ON gs.team_id = t.id
JOIN 
    team_details td ON t.franchise_id = td.id
WHERE 
    g.id = @game_id;

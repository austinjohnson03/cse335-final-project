-- Set the variable with the desired draft year
SET @draft_year = 2021;

-- Now use the variable in your query
SELECT
    dh.id AS draft_id,
    dh.player_id,
    dh.name AS player_name,
    dh.season AS draft_year,
    dh.round_number,
    dh.round_pick,
    dh.overall_pick,
    dh.draft_type,
    dh.team_id AS drafted_team_id,
    f.most_recent_name AS drafted_team_name,
    dh.organization,
    dh.organization_type
FROM draft_history dh
JOIN franchises f ON dh.team_id = f.id
WHERE dh.season = @draft_year;


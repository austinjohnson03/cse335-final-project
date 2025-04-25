WITH final_playoff_games AS (
    SELECT
        g.id AS game_id,
        g.season_id,
        g.game_date,
        MAX(CASE WHEN tg.is_home THEN t.name END) AS home_team,
        MAX(CASE WHEN tg.is_home THEN tg.pts END) AS home_score,
        MAX(CASE WHEN tg.is_home = FALSE THEN t.name END) AS away_team,
        MAX(CASE WHEN tg.is_home = FALSE THEN tg.pts END) AS away_score,
        RANK() OVER (PARTITION BY g.season_id ORDER BY g.game_date DESC, g.id DESC) AS rnk
    FROM games g
    JOIN team_games tg ON g.id = tg.game_id
    JOIN teams t ON tg.team_id = t.id
    WHERE g.season_id LIKE '4%'
    GROUP BY g.id, g.season_id, g.game_date
),
champions AS (
    SELECT
        season_id,
        CASE
            WHEN home_score > away_score THEN home_team
            ELSE away_team
        END AS champion
    FROM final_playoff_games
    WHERE rnk = 1
)
SELECT
    s.end_year AS championship_year,
    c.champion
FROM champions c
JOIN seasons s ON s.id = c.season_id
ORDER BY s.end_year;

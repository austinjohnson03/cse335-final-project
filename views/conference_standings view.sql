CREATE VIEW conference_standings AS
SELECT
    wlv.season_id,
    wlv.end_year,
    t.id AS team_id,
    wlv.team_name,
    wlv.wins,
    wlv.losses,
    ROUND((wlv.wins / (wlv.wins + wlv.losses)) * 100, 2) AS win_percent,
    fc.conference_id,
    c.name AS conference_name,
    RANK() OVER (PARTITION BY wlv.season_id, fc.conference_id ORDER BY (wlv.wins / (wlv.wins + wlv.losses)) DESC) AS `rank`
FROM
    win_loss_view wlv
JOIN
    teams t ON wlv.team_name = t.name
JOIN
    franchise_conferences fc ON t.franchise_id = fc.franchise_id AND wlv.season_id = fc.season_id
JOIN
    conferences c ON fc.conference_id = c.id
ORDER BY
    wlv.season_id DESC, fc.conference_id, `rank`;

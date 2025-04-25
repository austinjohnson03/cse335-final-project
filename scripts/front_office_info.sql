SELECT
	td.nickname AS nickname,
    td.owner AS owner,
    td.general_manager AS general_manager,
    td.head_coach as head_coach
FROM team_details td
JOIN teams t on td.id = t.id
ORDER BY td.nickname;
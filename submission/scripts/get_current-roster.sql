SET @team_id = 15;  -- LAL (Lakers)

SELECT 
    f.most_recent_name AS team_name,
    p.first_name,
    p.last_name,
    p.position,
    p.jersey_num,
    p.height,
    p.weight,
    p.school,
    p.birthdate
FROM 
    players p
JOIN 
    franchises f ON p.franchise_id = f.id
WHERE 
    p.franchise_id = @team_id
    AND p.is_active = 1;

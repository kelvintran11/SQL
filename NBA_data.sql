SELECT *
FROM NBA_data


/* 
Column Explanantion:
gp: game played
pts: points
reb: rebounds
ast: assists
net_rating: plus/minus stats for a given player when in a game and not in the game
oreb: offsensive rebound
dreb: defensive rebound
usg: usage percentage
ts: true shooting (field goal pct, free throw pct, three-point pct)
ast_pct: percent of team assists
*/


--- Clean Data
--- Change 1st Column Name
sp_rename 'NBA_data.column1', 'id', 'COLUMN';

--- Fill Blank for Colleges
SELECT *
FROM NBA_data
WHERE TRIM(college) IS NULL --- Finds blanks in data

SELECT *
FROM NBA_data
WHERE college LIKE 'logan' --- Check to see spelling of colleges

UPDATE NBA_data
SET college = 'Kentucky' --- Had to look up on google their colleges
WHERE id = 9750 

UPDATE NBA_data
SET college = 'Kentucky'
WHERE id = 10585 

UPDATE NBA_data
SET college = 'New Mexico'
WHERE id = 9906 

UPDATE NBA_data
SET college = 'New Mexico'
WHERE id = 10237

UPDATE NBA_data
SET college = 'John A. Logan'
WHERE id = 11242 

--- CAST gp to float
ALTER TABLE NBA_data
ALTER COLUMN gp float;

--- Draft_round and Draft_Number  0 to Undrafted
UPDATE NBA_data
SET draft_round = 'Undrafted'
WHERE draft_round = '0'

UPDATE NBA_data
SET draft_number = 'Undrafted'
WHERE draft_number = '0'







--- Looking at common stats
--- Average stats
SELECT AVG(age) AS avg_age, AVG(player_height) AS avg_height, AVG(player_weight) AS avg_weight,
AVG(gp) AS avg_gp, AVG(pts) AS avg_pts, AVG(reb) AS avg_reb, AVG(ast) AS avg_ast, 
AVG(oreb_pct) AS avg_oreb, AVG(dreb_pct) AS avg_dreb, AVG(usg_pct) AS avg_usg, AVG(ts_pct) AS avg_ts, AVG(ast_pct) AS avg_ast_pct
FROM NBA_data



--- College Count
SELECT college, count(college) AS college_count
FROM NBA_data
GROUP BY college
ORDER BY college_count DESC



--- Country Count
SELECT country, count(country) AS country_count
FROM NBA_data
GROUP BY country
ORDER BY country_count DESC



--- Undrafted vs Drafted(All Years)
SELECT draft_round, AVG(gp) AS avg_gp, AVG(pts) AS avg_pts, AVG(reb) AS avg_reb, AVG(ast) AS avg_ast, 
AVG(oreb_pct) AS avg_oreb, AVG(dreb_pct) AS avg_dreb, AVG(usg_pct) AS avg_usg, AVG(ts_pct) AS avg_ts, AVG(ast_pct) AS avg_ast_pct
FROM NBA_data
GROUP BY draft_round
ORDER BY draft_round



--- College vs None (2020-21)
--- None
SELECT college, AVG(gp) AS avg_gp, AVG(pts) AS avg_pts, AVG(reb) AS avg_reb, AVG(ast) AS avg_ast, 
AVG(oreb_pct) AS avg_oreb, AVG(dreb_pct) AS avg_dreb, AVG(usg_pct) AS avg_usg, AVG(ts_pct) AS avg_ts, AVG(ast_pct) AS avg_ast_pct
FROM NBA_data
WHERE college = 'none'
Group BY college

--- College
WITH CTE AS(
SELECT college, AVG(gp) AS avg_gp, AVG(pts) AS avg_pts, AVG(reb) AS avg_reb, AVG(ast) AS avg_ast, 
AVG(oreb_pct) AS avg_oreb, AVG(dreb_pct) AS avg_dreb, AVG(usg_pct) AS avg_usg, AVG(ts_pct) AS avg_ts, AVG(ast_pct) AS avg_ast_pct
FROM NBA_data
WHERE college != 'none'
Group BY college)

SELECT AVG(avg_gp) AS avg_gp, AVG(avg_pts) AS avg_pts, AVG(avg_reb) AS avg_reb, AVG(avg_ast) AS avg_ast, 
AVG(avg_oreb) AS avg_oreb, AVG(avg_dreb) AS avg_dreb, AVG(avg_usg) AS avg_usg, AVG(avg_ts) AS avg_ts, AVG(avg_ast_pct) AS avg_ast_pct
FROM CTE









--- What Makes a Champion?
/* 
NBA: Champions
97'-98' CHI, 99' SAS, 2000-02' LAL, 03' SAS, 04' DET, 05' SAS, 06' MIA, 
07' SAS, 08' BOS, 09-10' LAL, 11' DAL, 12-13' MIA, 14' SAS, 15' GSW, 16' CLE, 
17-18' GSW, 19' TOR, 20' LAL, 21' MIL
*/
--- 
--- NBA Champions by Years
--- Average Championship Team
WITH CTE AS(
SELECT team_abbreviation, season, AVG(age) AS avg_age, AVG(player_height) AS avg_height, AVG(player_weight) AS avg_weight,
SUM(pts) AS team_avg_pts, SUM(reb) AS team_avg_reb, SUM(ast) AS team_avg_ast,
AVG(ts_pct) AS avg_ts_pct, AVG(ast_pct) AS avg_ast_pct 
FROM NBA_data
WHERE (team_abbreviation = 'CHI' AND season = '1996-97') OR 
(team_abbreviation = 'CHI' AND season = '1997-98') OR
(team_abbreviation = 'SAS' AND season = '1998-99') OR
(team_abbreviation = 'LAL' AND season = '1999-00') OR
(team_abbreviation = 'LAL' AND season = '2000-01') OR
(team_abbreviation = 'LAL' AND season = '2001-02') OR
(team_abbreviation = 'SAS' AND season = '2002-03') OR
(team_abbreviation = 'DET' AND season = '2003-04') OR
(team_abbreviation = 'SAS' AND season = '2004-05') OR
(team_abbreviation = 'MIA' AND season = '2005-06') OR
(team_abbreviation = 'SAS' AND season = '2006-07') OR
(team_abbreviation = 'BOS' AND season = '2007-08') OR
(team_abbreviation = 'LAL' AND season = '2008-09') OR
(team_abbreviation = 'LAL' AND season = '2009-10') OR
(team_abbreviation = 'DAL' AND season = '2010-11') OR
(team_abbreviation = 'MIA' AND season = '2011-12') OR
(team_abbreviation = 'MIA' AND season = '2012-13') OR
(team_abbreviation = 'SAS' AND season = '2013-14') OR
(team_abbreviation = 'GSW' AND season = '2014-15') OR
(team_abbreviation = 'CLE' AND season = '2015-16') OR
(team_abbreviation = 'GSW' AND season = '2016-17') OR
(team_abbreviation = 'GSW' AND season = '2017-18') OR
(team_abbreviation = 'TOR' AND season = '2018-19') OR
(team_abbreviation = 'LAL' AND season = '2019-20') OR
(team_abbreviation = 'MIL' AND season = '2020-21')
GROUP BY team_abbreviation, season)

SELECT AVG(avg_age) AS avg_age, AVG(avg_height) AS avg_height, AVG(avg_weight) AS avg_weight,
AVG(team_avg_pts) AS team_avg_pts, AVG(team_avg_reb) AS team_avg_reb, AVG(team_avg_ast) AS team_avg_ast,
AVG(avg_ts_pct) AS avg_ts_pct, AVG(avg_ast_pct) AS avg_ast_pct 
FROM CTE



--- Average Team
With CTE AS (
SELECT team_abbreviation, season, AVG(age) AS avg_age, AVG(player_height) AS avg_height, AVG(player_weight) AS avg_weight,
SUM(pts) AS team_avg_pts, SUM(reb) AS team_avg_reb, SUM(ast) AS team_avg_ast,
AVG(ts_pct) AS avg_ts_pct, AVG(ast_pct) AS avg_ast_pct 
FROM NBA_data
GROUP BY team_abbreviation, season)

SELECT AVG(avg_age) AS avg_age, AVG(avg_height) AS avg_height, AVG(avg_weight) AS avg_weight,
AVG(team_avg_pts) AS team_avg_pts, AVG(team_avg_reb) AS team_avg_reb, AVG(team_avg_ast) AS team_avg_ast,
AVG(avg_ts_pct) AS avg_ts_pct, AVG(avg_ast_pct) AS avg_ast_pct 
FROM CTE









--- Building the Best Team

--- Best Players by Net Ratings (2020-21) Potential trades
--- More than 50 games played
SELECT player_name, team_abbreviation, net_rating, season, gp
FROM NBA_data
WHERE season = '2020-21'  AND  gp > 50 --- average gp
ORDER BY net_rating DESC
--- Greater than 20 games played
SELECT player_name, team_abbreviation, net_rating, season, gp
FROM NBA_data
WHERE season = '2020-21'  AND  gp < 50 AND  gp > 20
ORDER BY net_rating DESC

--- Potential Scorers
SELECT player_name, team_abbreviation, pts, net_rating, ts_pct, season, gp
FROM NBA_data
WHERE season = '2020-21' AND pts > 8 AND ts_pct > .51 --- above average
ORDER BY pts DESC











/* 
For NBA Fantasy (2020-21) Win/Loss Categories
PTS, FG%, REB, AST, STL, BLK, TO (Win 4/7 categories)
Find best PTS, FG%, REB, AST to optimize and win teams
Can pick: 
Starting Line Up: 1 Center, 4 Forwards, 4 Guards, 1 Wildcard
Bench: 3 Wildcard
*/


--- Players/postions with PTS
SELECT player_name, team_abbreviation, pts, season, gp
FROM NBA_data
WHERE season = '2020-21'
ORDER BY pts DESC


--- Players/postions with FG%
SELECT player_name, team_abbreviation, ts_pct, season, gp
FROM NBA_data
WHERE season = '2020-21' AND gp > 20
ORDER BY ts_pct DESC


--- Players/postions with REB
SELECT player_name, team_abbreviation, reb, oreb_pct, dreb_pct, season, gp
FROM NBA_data
WHERE season = '2020-21'
ORDER BY reb DESC


--- Players/postions with AST
SELECT player_name, team_abbreviation, ast, ast_pct, season, gp
FROM NBA_data
WHERE season = '2020-21' 
ORDER BY ast DESC

--- Optimal Players
--- Players with high usg_pct, pts, ts_pct, ast, reb
SELECT player_name, team_abbreviation, pts, ast, ts_pct, reb, usg_pct, season, gp
FROM NBA_data
WHERE season = '2020-21' AND gp > 20
ORDER BY usg_pct DESC, pts DESC, ast DESC, ts_pct DESC, reb DESC



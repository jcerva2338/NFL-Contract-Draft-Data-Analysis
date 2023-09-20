-- Name: John Cervantes

-- See the layout and possible insights that may be in the dataset
SELECT * FROM nfl_contracts_drafts$;

-- To be able to analyze the data based on position, a temporary table for distinct player id rows will be made
CREATE TABLE #distinct_nfl_data (
	id FLOAT,
	draft_year FLOAT,
	rnd FLOAT,
	pick FLOAT,
	player NVARCHAR(255),
	pos NVARCHAR(255),
	g FLOAT
);

-- Insert the 'static' data that does not change based on year into the distinct table to analyze those columns more in-depth
INSERT INTO #distinct_nfl_data
SELECT 
	DISTINCT (id), draft_year, rnd, pick, player, pos, g
FROM nfl_contracts_drafts$;

-- See the selected columns and rows from the distinct data table
SELECT * FROM #distinct_nfl_data;

-- See the number of players that exist in the dataset
SELECT COUNT(id) AS number_of_players FROM #distinct_nfl_data;

-- For each year, get the frequency that a position was drafted at each round to see the demand of each position change depending on round
SELECT draft_year, pos, rnd, COUNT(*) AS frequency FROM #distinct_nfl_data GROUP BY draft_year, pos, rnd ORDER BY draft_year ASC, rnd ASC, frequency DESC;

-- Calculate the average games played per position to see the longevity of each position's career
SELECT pos, AVG(g) AS career_games_played FROM #distinct_nfl_data GROUP BY pos ORDER BY career_games_played DESC;

-- Count the frequency of each position drafted grouped by their draft pick
SELECT pos, pick, COUNT(*) AS frequency FROM #distinct_nfl_data WHERE rnd = 1 GROUP BY pos, pick ORDER BY pos ASC, pick ASC, frequency DESC;

-- Calculate the average of player contracts signed per year to see the disparity between the contract figures for each position
SELECT year_signed, pos, ROUND(AVG(value), 0) AS average FROM nfl_contracts_drafts$ GROUP BY year_signed, pos ORDER BY year_signed ASC, average DESC;
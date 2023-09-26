-- NAMA : MHD.Fisabiluddin , KELOMPOK : 15 

--4. Use movie dataset and create stored procedure or function for counting movie based on genre. Use genre as a parameter, and return the count of movie
CREATE OR REPLACE FUNCTION CountMoviesByGenre(genreTitleParam VARCHAR(255))
RETURNS INT AS $$
DECLARE
  movieCount INT;
BEGIN
  SELECT COUNT(*) INTO movieCount
  FROM movie m
  JOIN movie_genres mg ON m.mov_id = mg.mov_id
  JOIN genres g ON mg.gen_id = g.gen_id
  WHERE g.gen_title = genreTitleParam;
  
  RETURN movieCount;
END;
$$ LANGUAGE plpgsql;
            --Contoh menjalankan stored procedure CountMoviesByGenre
            SELECT CountMoviesByGenre('Action');

--5. Use movie dataset, write one optimized query (using the tips for revamp query). You are free to create any query.
SELECT m.mov_title, r.rev_stars
FROM movie AS m
INNER JOIN rating AS r ON m.mov_id = r.mov_id
WHERE r.rev_stars > 7;

--6.Use the ninja dataset, write a query that return nama and desa, use email as a filter.Create a proper index to satisfy the query, provide the explain result before and after index creation. (do set enable_seqscan = off first)
    -- sebelum index dibuat
SET enable_seqscan = off;

EXPLAIN
SELECT nama, desa
FROM ninja
WHERE email = 'gara@gmail.com';

    --setelah index di buat
CREATE INDEX idx_email ON ninja(email);

EXPLAIN
SELECT nama, desa
FROM ninja
WHERE email = 'gara@gmail.com';

--7. Find the most favorite (highest rating) for each genre (use rank() window function)
WITH MovieRatingGenres AS (
  SELECT
    m.mov_id,
    m.mov_title,
    r.rev_stars,
    mg.gen_id
  FROM
    movie m
    JOIN rating r ON m.mov_id = r.mov_id
    JOIN movie_genres mg ON m.mov_id = mg.mov_id
)
, RankedGenres AS (
  SELECT
    MRG.mov_title,
    G.gen_title,
    MRG.rev_stars,
    RANK() OVER (PARTITION BY G.gen_title ORDER BY MRG.rev_stars DESC) AS genre_rank
  FROM
    MovieRatingGenres MRG
    JOIN genres G ON MRG.gen_id = G.gen_id
)
SELECT
  RG.gen_title,
  RG.mov_title,
  RG.rev_stars
FROM
  RankedGenres RG
WHERE
  RG.genre_rank = 1;

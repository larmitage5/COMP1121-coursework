/*
@Lucy Armitage

This is an sql file to put your queries for SQL coursework. 
You can write your comment in sqlite with -- or /* * /

To read the sql and execute it in the sqlite, simply
type .read sqlcwk.sql on the terminal after sqlite3 musicstore.db.
*/

/* =====================================================
   WARNNIG: DO NOT REMOVE THE DROP VIEW
   Dropping existing views if exists
   =====================================================
*/
DROP VIEW IF EXISTS vNoCustomerEmployee; 
DROP VIEW IF EXISTS v10MostSoldMusicGenres; 
DROP VIEW IF EXISTS vTopAlbumEachGenre; 
DROP VIEW IF EXISTS v20TopSellingArtists; 
DROP VIEW IF EXISTS vTopCustomerEachGenre; 

CREATE VIEW vNoCustomerEmployee AS
SELECT EmployeeId, FirstName, LastName, Title
FROM employees 
EXCEPT
SELECT EmployeeId, FirstName, LastName, Title
FROM employee
LEFT JOIN customers ON  employee.EmployeeId = customers.SupportRepId;


/*
============================================================================
Task 2: Complete the query for v10MostSoldMusicGenres
DO NOT REMOVE THE STATEMENT "CREATE VIEW v10MostSoldMusicGenres AS"
============================================================================
*/

CREATE VIEW v10MostSoldMusicGenres AS
SELECT genres.Name, SUM(invoice_items.Quantity) as Sales
FROM genres 
INNER JOIN tracks ON tracks.GenreId = genres.GenreId
INNER JOIN invoice_items ON invoice_items.TrackId = tracks.TrackId
GROUP BY genres.Name
HAVING COUNT(*) > 1
ORDER BY Sales DESC limit 10;


/*
============================================================================
Task 3: Complete the query for vTopAlbumEachGenre
DO NOT REMOVE THE STATEMENT "CREATE VIEW vTopAlbumEachGenre AS"
============================================================================
*/

CREATE VIEW vTopAlbumEachGenre AS
SELECT genres.Name, albums.Title, artists.Name, SUM(invoice_items.Quantity) as Sales
FROM genres
INNER JOIN tracks ON tracks.GenreId = genres.GenreId
INNER JOIN invoice_items ON invoice_items.TrackId = tracks.TrackId
INNER JOIN albums ON albums.AlbumId = tracks.AlbumId
INNER JOIN artists ON artists.ArtistId = albums.ArtistId
WHERE genres.Name IN (SELECT DISTINCT genres.Name FROM genres)
GROUP BY albums.AlbumId
HAVING COUNT(*) > 1
ORDER BY Sales DESC;



/*
============================================================================
Task 4: Complete the query for v20TopSellingArtists
DO NOT REMOVE THE STATEMENT "CREATE VIEW v20TopSellingArtists AS"
============================================================================
*/

--CREATE VIEW v20TopSellingArtists AS
--Remove this line and complete your query for Task 4 here


/*
============================================================================
Task 5: Complete the query for vTopCustomerEachGenre
DO NOT REMOVE THE STATEMENT "CREATE VIEW vTopCustomerEachGenre AS" 
============================================================================
*/
--CREATE VIEW vTopCustomerEachGenre AS
--Remove this line and complete your query for Task 5 here


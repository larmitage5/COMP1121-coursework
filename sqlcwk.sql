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
SELECT employees.EmployeeId, employees.FirstName, employees.LastName, employees.Title
FROM employees
EXCEPT
SELECT employees.EmployeeId, employees.FirstName, employees.LastName, employees.Title
FROM employees 
INNER JOIN customers ON employees.EmployeeId = customers.SupportRepId;

/*
============================================================================
Task 2: Complete the query for v10MostSoldMusicGenres
DO NOT REMOVE THE STATEMENT "CREATE VIEW v10MostSoldMusicGenres AS"
============================================================================
*/

CREATE VIEW v10MostSoldMusicGenres AS
SELECT genres.Name AS Genre, SUM(invoice_items.Quantity) as Sales
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
SELECT Genre, Album, Artist, MAX(Sales) AS Sales
FROM (
   SELECT genres.Name as Genre, albums.Title as Album, artists.Name as Artist, SUM(invoice_items.Quantity) as Sales
   FROM genres
   INNER JOIN tracks ON tracks.GenreId = genres.GenreId
   INNER JOIN invoice_items ON invoice_items.TrackId = tracks.TrackId
   INNER JOIN albums ON albums.AlbumId = tracks.AlbumId
   INNER JOIN artists ON artists.ArtistId = albums.ArtistId
   GROUP BY albums.albumId, genres.genreid
)
GROUP BY genre;



/*
============================================================================
Task 4: Complete the query for v20TopSellingArtists
DO NOT REMOVE THE STATEMENT "CREATE VIEW v20TopSellingArtists AS"
============================================================================
*/

CREATE VIEW v20TopSellingArtists AS
SELECT artists.Name AS Artist, COUNT(DISTINCT tracks.albumId) as TotalAlbum, SUM(invoice_items.Quantity) as TrackSold
FROM artists
INNER JOIN albums ON albums.ArtistId = artists.ArtistId
INNER JOIN tracks ON tracks.AlbumId = albums.AlbumId
INNER JOIN invoice_items ON invoice_items.trackId = tracks.TrackId
GROUP BY artists.Name
ORDER BY TrackSold DESC limit 20;


/*
============================================================================
Task 5: Complete the query for vTopCustomerEachGenre
DO NOT REMOVE THE STATEMENT "CREATE VIEW vTopCustomerEachGenre AS" 
============================================================================
*/

CREATE VIEW vTopCustomerEachGenre AS
SELECT Genre, TopSpender, MAX(TotalSpend) AS TotalSpending
FROM(
   SELECT genres.Name AS Genre, customers.FirstName || ' ' || customers.LastName as TopSpender, ROUND(SUM(invoice_items.quantity) * invoice_items.UnitPrice, 2) AS TotalSpend
   FROM genres
   INNER JOIN tracks ON tracks.genreId = genres.genreId
   INNER JOIN invoice_items ON tracks.trackId = invoice_items.trackId
   INNER JOIN invoices ON invoices.invoiceId = invoice_items.invoiceId
   INNER JOIN customers ON customers.customerId = invoices.customerId
   GROUP BY Genre, TopSpender
)
GROUP BY Genre;




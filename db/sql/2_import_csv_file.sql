COPY book(ISBN,Title,Author,PublicationYear,Publisher,ImageURLSmall,ImageURLMedium,ImageURLLarge)
FROM '/docker-entrypoint-initdb.d/books.csv'
DELIMITER ';'
ENCODING 'UTF8'
CSV HEADER;
-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/RGAr1z
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

\c appdb;

CREATE SCHEMA bookstore;

CREATE TABLE bookstore.book (
    ID  SERIAL  NOT NULL,
    ISBN text   NOT NULL,
    Title text   NOT NULL,
    Author text   NOT NULL,
    PublicationYear int   NOT NULL,
    Publisher text   NOT NULL,
    ImageURLSmall text   NOT NULL,
    ImageURLMedium text   NOT NULL,
    ImageURLLarge text   NOT NULL,
    CONSTRAINT pk_book PRIMARY KEY (
        ID
    )
);

CREATE INDEX idx_book_ISBN
ON bookstore.book (ISBN);

CREATE INDEX idx_book_Title
ON bookstore.book (Title);

CREATE INDEX idx_book_Author
ON bookstore.book (Author);

CREATE INDEX idx_book_PublicationYear
ON bookstore.book (PublicationYear);

CREATE INDEX idx_book_Publisher
ON bookstore.book (Publisher);

-- Apply All Grants *only* at the end
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA bookstore TO appusr;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA bookstore TO appusr;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA bookstore to appusr;

GRANT ALL PRIVILEGES ON DATABASE appdb TO appusr;

ALTER SCHEMA bookstore OWNER TO appusr;
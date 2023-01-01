-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/RGAr1z
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE book (
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
ON book (ISBN);

CREATE INDEX idx_book_Title
ON book (Title);

CREATE INDEX idx_book_Author
ON book (Author);

CREATE INDEX idx_book_PublicationYear
ON book (PublicationYear);

CREATE INDEX idx_book_Publisher
ON book (Publisher);


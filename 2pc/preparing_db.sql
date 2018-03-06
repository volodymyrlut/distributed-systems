DROP DATABASE IF EXISTS tpc_hotels;
DROP DATABASE IF EXISTS tpc_flights;
DROP DATABASE IF EXISTS tpc_accounts;

CREATE DATABASE tpc_hotels WITH ENCODING 'UTF8' LC_CTYPE 'en_US.UTF-8' LC_COLLATE 'en_US.UTF-8';
CREATE DATABASE tpc_flights WITH ENCODING 'UTF8' LC_CTYPE 'en_US.UTF-8' LC_COLLATE 'en_US.UTF-8';
CREATE DATABASE tpc_accounts WITH ENCODING 'UTF8' LC_CTYPE 'en_US.UTF-8' LC_COLLATE 'en_US.UTF-8';

\c tpc_hotels;

CREATE TABLE hotels("Booking ID" serial primary key,
  "Client Name" text,
  "Hotel Name" text,
  "Arrival" date,
  "Departure" date
);

INSERT INTO hotels("Client Name", "Hotel Name", "Arrival", "Departure") VALUES ('Nik', 'Hilton', '01/05/2015', '07/05/2015');

\c tpc_flights;

CREATE TABLE flights("Booking ID" serial primary key,
  "Client Name" text,
  "Fly Number" text,
  "From" text,
  "To" text,
  "Date" date
);
INSERT INTO flights("Client Name", "Fly Number", "From", "To", "Date") VALUES ('Nik', 'KLM 1382', 'KBP', 'AMS', '01/05/2015');

\c tpc_accounts

CREATE TABLE accounts("Account ID" serial primary key,
  "Client Name" text,
  "Amount" INT CHECK ("Amount" >= 0)
);

INSERT INTO accounts("Client Name", "Amount") VALUES ('Nik', 200);

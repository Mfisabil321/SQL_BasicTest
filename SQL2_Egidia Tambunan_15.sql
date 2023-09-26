-- Nama : Egidia N Tambunan , Kelompok 15

3. --create table students for school database, consist these columns:
--id (integer, PK, auto increment)
--first_name (varchar, not null)
--last_name (varchar, default null)
--email (varchar, unique, not null)
--age (integer, default value 18)
--gender (varchar, check constraint to allow only 'male' or 'female')
--date_of_birth (date, not null)
--created_at (timestamp with time zone, default value now)

CREATE TABLE students (
  id serial PRIMARY KEY,
  first_name VARCHAR NOT NULL,
  last_name VARCHAR DEFAULT NULL,
  email VARCHAR UNIQUE NOT NULL,
  age INTEGER DEFAULT 18,
  gender VARCHAR CHECK (gender IN ('male', 'female')),
  date_of_birth DATE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);


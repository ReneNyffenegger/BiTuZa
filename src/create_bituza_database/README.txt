for creating a new database, just rung the file
createBiTuZaDatabase.py



structur2sqlite.py reads the BiTuZa/data/Struktur_Generator/BiTuZa.Struktur file with
BiTuZaStrukturParser.py and writes the "structure"-table in the database.

TeXParsers2.py reads the structure-table in the database first, then one by another all tex-files
and writes all the payload in the database.

so for generating a new database, you want to run the file "structur2sqlite.py" and then "TeXParser2.py".

Sadly, TeXParser2 is very very slow (it takes about 45min to parse all the TeX-files on my machine), 
i think mostly because it uses a lot of regular expressions in strings (re.sub and string.startswith).
and because of a lot of database-queries.

As this code is designed for single usage (later you probably want to work with the database),
so i think this is ok.
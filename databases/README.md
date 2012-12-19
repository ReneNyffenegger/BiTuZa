The database generated from the Tex-files and the BiTuZa.Struktur-file

The database schema ist the following:

Table structure:
  - structure_row_id	: primary key for the whole database
  - book_id		: incrementing id, begins with 1 at genesis, ends with 66 at revelations
  - book_string		: the common name of the book in german
  - chapter		: nomen est omen
  - verse		: ''
  - word		: ''

Table word:
  - structure_row_id	: primary key
  - wv
  - wk
  - wb
  - abk
  - abb
  - abv
  - anz_b
  - tw
  - code
  - origin_text		: latex-encoding for the hebrew strings
  - origin_unicode	: unicode-encoding for the hebrew strings (currently empty, it will comeing soon)
  - transcode		: transcoded hebrew with latin chars
  - translation_de	: the german translation (elberfelder)

Table elberfelder:
  - structure_row_id	: primary key
  - verse		: the translation of this verse in the german elberfelder-translation

Table stats:
  - structure_row_id	: primary key
  - verse
  - total_v
  - total_k
  - total_b
  - sum_v
  - sum_k
  - sum_b

_Usage-Example:_

If you want to get the stats for genesis 40,1 than the corresponding sql-query may be something like:
SELECT * FROM structure NATURAL JOIN stats WHERE book_id=1 AND chapter=40 AND verse=1

Another Example:
SELECT * FROM structure NATURAL JOIN wort WHERE book_id=1 AND chapter=40 AND verse=1
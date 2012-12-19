This is the README-file for the file hebrewbible.1.1.db

This Database contains the hebrew bible as found on the page 
http://ancient-hebrew.org/hebrewbible/0_index.html

It is a sqlite3-database, with the following schemata:

books:	
	- row_id
	- name: 	the names of the books, as used in the content- and content2-table as key
	- chapters: how many chapters in this book are

content: you probably want to use the content2-table

content2:
	- row_id
	- book		: the name of the current book, correspndens with name in table "books"
	- chapter 	: key
	- verse		: key
	- content 	: payload

dictionary:		not really ready for use

words:			not really ready for use
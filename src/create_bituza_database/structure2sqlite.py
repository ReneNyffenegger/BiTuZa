
# -*- coding: utf-8 -*-

import sqlite3
from BiTuZaStrukturParser import BiTuZaStrukturParser 

class Struktur2sqlite(object):
    def __init__(self):
        self.filepath = "../../data/Struktur_Generator/BiTuZa-1.Struktur"
        self.dbpath = "../../databases/tuz.sqlite.db"
        
        self.connection, self.cursor = self.openConnection()
        self.createTable()
        
    def main(self):
        Parser = BiTuZaStrukturParser()
        structur = Parser.readFile(self.filepath)
        
        for row in structur:
            self.writeToDB(row)
            
        self.connection.commit()
        
    def openConnection(self):
        connection = sqlite3.connect(self.dbpath)
        cursor = connection.cursor()
        
        return connection, cursor
        
    def writeToDB(self, row):
        query = "insert into structure ( book_id, book_string, chapter, verse, word ) values ( ?, ?, ?, ?, ? )"
        print row
        self.cursor.execute(query, row)
        #self.connection.commit()
        
    #table structure
    #- buch_id numeric
    #- buch_string string primary key
    #- chapter numeric key
    #- verse numeric key
    #- word numeric
    def createTable(self):
        try:
            self.cursor.execute("drop table structure")
        except:
            pass
        query = "CREATE TABLE structure (structure_row_id integer primary key autoincrement, book_id integer, book_string string key, chapter integer key, verse integer key, word integer)"
        self.cursor.execute(query)
        
#c = Struktur2sqlite()
#r = c.main()
#print r
#c.createTable()
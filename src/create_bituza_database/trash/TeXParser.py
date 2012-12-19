# -*- coding: utf_8 -*-

import sqlite3, re, sys
from TuZ import TuZ, Wort, Stats, Elberfelder

class TeX2SQL(object):
    def __init__(self):
        self.texfolder = "../../data/Tex/"
        self.dbpath = "../../databases/tuz.sqlite.db"
        
        self.connection, self.cursor = self.createConnection()
        
        tuz2db = InsertTuz2DB(self.connection, self.cursor)
        tuz2db.flushDB()
        
        #sys.exit()
        
        self.db_row_id = 31102
        
        book_list = self.getBookList()
        
        self.getNextFile(book_list)
    
    def getNextFile(self, book_list):
        i = 0
        for book in book_list:
            i += 1
            
            book = book[0]
            filename = book+".Tex"
            print filename
            
            self.feedTexFile(filename, i)
            
            self.connection.commit()
    
    def feedTexFile(self, filename, i):
        Parser = TeXParser(self.connection, self.cursor)
        tuz = Parser.feed(self.texfolder, filename, i)
        
        self.saveResultInDB(tuz)
        
    def saveResultInDB(self, tuz):
        Insert = InsertTuz2DB(self.connection, self.cursor)
        Insert.insert(tuz)
    
    def createConnection(self):
        connection = sqlite3.connect(self.dbpath)
        cursor = connection.cursor()
        
        return connection, cursor
        
    def getBookList(self):
        query = "SELECT buch_string FROM structure WHERE row_Id = 1"
        self.cursor.execute(query)
        result = self.cursor.fetchall()
        
        result_list = []
        result_list.append( result[0] )
        
        #print result_list
        
        i = 1
        while i < self.db_row_id:
            i += 1
            
            query = "SELECT buch_string FROM structure WHERE row_id = "+str(i)
            
            self.cursor.execute(query)
            result = self.cursor.fetchall()
            
            if result_list[-1] != result[0]:
                result_list.append(result[0])
            
        return result_list
            
            
class InsertTuz2DB(object):
    def __init__(self, connection, cursor):
        self.connection = connection
        self.cursor = cursor
        
    def flushDB(self):
        self.dropTables()
        self.createTableWort()
        self.createTableStats()
        self.createTableElberfelder()
    
    def insert(self, tuz):
        #print tuz
        
        i = 0
        for item in tuz:
            i += 1
            print i
            
            wort_list = item.getWortList()
            stats = item.getStats()
            elberfelder = item.getElberfelder()
            
            self.insertWortList(wort_list)
            self.insertStats(stats)
            self.insertElberfelder(elberfelder)
            
            #self.connection.commit()
            
    def insertWortList(self, wort_list):
        query = "INSERT INTO wort ( structure_row_id, wv, wk, wb, abk, abb, abv, anz_b, tw, code, origin_text, transcode, translation_de ) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
        for wort in wort_list:
            data = wort.getEverything()
            self.cursor.execute(query, data)
    def insertStats(self, stats):
        query = "INSERT INTO stats ( structure_row_id, vers, total_v, total_k, total_b, sum_v, sum_k, sum_b ) values (?, ?, ?, ?, ?, ?, ?, ?)"
        data = stats.getEverything()
        self.cursor.execute(query, data)
    def insertElberfelder(self, elberfelder):
        #print elberfelder.getStructureRowId()
        query = "INSERT INTO elberfelder ( structure_row_id, vers ) values (?, ?)"
        data = elberfelder.getStructureRowId(), elberfelder.getVers()
        self.cursor.execute(query, data)
            
    def dropTables(self):
        self.cursor.execute("DROP TABLE wort")
        self.cursor.execute("DROP TABLE stats")
        self.cursor.execute("DROP TABLE elberfelder")
    def createTableWort(self):
        query = "CREATE TABLE wort ( structure_row_id, wv integer, wk integer, wb integer, abk integer, abb integer, abv integer, anz_b integer, tw integer, code integer, origin_text string, origin_unicode, transcode string, translation_de string )"
        self.cursor.execute(query)
    def createTableStats(self):
        query = "CREATE TABLE stats ( structure_row_id, vers integer, total_v integer, total_k integer, total_b integer, sum_v integer, sum_k integer, sum_b integer )"
        self.cursor.execute(query)
    def createTableElberfelder(self):
        query = "CREATE TABLE elberfelder ( structure_row_id, vers string )"
        self.cursor.execute(query)
        
class TeXParser(object):
    def __init__(self, connection, cursor):
        self.connection = connection
        self.cursor = cursor
        
        self.in_tabular = False
        self.between_tabular = False
        
        self.structure_book_id = -1
        
        self.chapter = -1
        self.verse = -1
        
        self.wort_list = []
        self.stats = None
        
        self.row_id = -1
    
    def feed(self, texfolder, filename, book_id):
        self.structure_book_id = book_id
        
        filepath = texfolder + filename
        
        fobj = open(filepath, "r")
        
        tuz = []
        for line in fobj:
            line = unicode(line.decode("latin1"))
            
            #line = self.replaceRegexp(line)
            #tuz.append( self.readLine(line) )
            result = self.readLine(line)
            
            if result != None:
                tuz.append( result )
            
        fobj.close()
        
        return tuz
    
    def ignoreThisLine(self, line):
        if line.startswith(r"WV&WK"):
            return True
        elif line.startswith(r"Ende des Verses"):
            return True
        elif line.startswith(r"\\"):
            return True
        elif line.startswith(r"{\bf Ende"):
            return True
        
        else:
            return False
    
    def replaceRegexp(self, line):
        # "a "e "i "o "u "s
        line = re.sub("\"a", "ä", line)
        line = re.sub("\"o", "ö", line)
        line = re.sub("\"u", "ü", line)
        line = re.sub("\"s", "ß", line)
        
        line = re.sub("\"A", "Ä", line)
        line = re.sub("\"O", "ö", line)
        line = re.sub("\"U", "Ü", line)
        
        line = re.sub(r"\\\\", "", line)
        line = re.sub(r"\\textcolor{red}{", "", line)
        line = re.sub(r"}}", "}", line)
        line = re.sub(r"\$\|\$", "###", line)
        line = re.sub(r"&", " ", line)
        
        return line
    
    def readLine(self, line):
        if not self.ignoreThisLine(line):
            line = self.replaceRegexp(line)
            #print line
        
            if line.startswith(r"\begin{tabular}"):
                self.in_tabular = True
                self.between_tabular = False
                return
            elif line.startswith(r"\end{tabular}"):
                self.in_tabular = False
                self.between_tabular = True
                return
            elif line.startswith(r"\newpage"):
                self.in_tabular = False
                self.between_tabular = False
                return
            elif line.startswith(r"{\bf"):
                self.in_tabular = False
                self.between_tabular = False
                
                line = re.sub(r"}", "", line)
                
                splitted = line.split(None)
                splitted2 = splitted[2].split(".")
                
                #print splitted, splitted2
                
                self.chapter = splitted2[0]
                self.verse = splitted2[1]
            
            if self.in_tabular:
                self.inTabular(line)
            elif self.between_tabular:
                return self.betweenTabular(line)
    
    def inTabular(self, line):
        #print line
        
        pipe_splitted = line.split(r"###")
        space_splitted = pipe_splitted[0].split(None)
        translation = pipe_splitted[1]
        
        #print space_splitted
        #print translation
        #print space_splitted, translation
        
        self.getRowId()
        
        wort = Wort()
        wort.setID( self.row_id )
        wort.setWV(space_splitted[0])
        wort.setWK(space_splitted[1])
        wort.setWB(space_splitted[2])
        wort.setABK(space_splitted[3])
        wort.setABB(space_splitted[4])
        wort.setABV(space_splitted[5])
        wort.setAnzB(space_splitted[6])
        wort.setTW(space_splitted[7])
        wort.setCode(space_splitted[8])
        
        textcjheb = space_splitted[9]
        textcjheb = re.sub(r"\\textcjheb{", "", textcjheb)
        textcjheb = re.sub(r"}", "", textcjheb)
        wort.setOriginText(textcjheb)
        
        wort.setTranscode(space_splitted[10])
        
        wort.setTranslationDE(translation)
        
        
        
        #return wort
        self.wort_list.append(wort)
    
    def getRowId(self):
        query = "SELECT row_id FROM structure WHERE buch_id = ? AND chapter = ? AND verse = ?"
        data = self.structure_book_id, self.chapter, self.verse
        self.cursor.execute(query, data)
        result = self.cursor.fetchall()
        self.row_id = result[0][0]
        
        print result, data
    
    def betweenTabular(self, line):
        if line.startswith("Verse"):
            #print line
            
            splitted = line.split(None)
            
            stats = Stats()
            stats.setID(self.row_id)
            stats.setVers(splitted[1])
            stats.setTotalV(splitted[3])
            stats.setTotalK(splitted[4])
            stats.setTotalB(splitted[5])
            stats.setSumV(splitted[7])
            stats.setSumK(splitted[8])
            stats.setSumB(splitted[9])
            
            self.stats = stats
            
        else:
            
            
            
            elberfelder = Elberfelder()
            elberfelder.setStructureRowId(self.row_id)
            elberfelder.setVers(line)
            
            
            tuz = TuZ()
            tuz.setWortList( self.wort_list )
            tuz.setStats( self.stats )
            tuz.setElberfelder( elberfelder )
            
            return tuz
    
    
c = TeX2SQL()
#c.getBookList()
from BiTuZa_Struktur_Parser import BiTuZaParser
from TuZ_Parser import TuZParser
import sqlite3, os

class TuZ2sqlite(object):
    def __init__(self):
        self.connection = sqlite3.connect("../../databases/tuz.sqlite.db")
        self.cursor = self.connection.cursor()
        
        self.path = "../../data/TuZ/"
    
    def main(self):
        structure_list = self.getStructure()
        file_list = self.getFileList()
        
        for structure in structure_list:
            kapitel = structure[2]
            vers = structure[3]
            woerter = structure[4]
            
    
    def parseAll(self):
        files_list = self.getFileList()
        
        parser = TuZParser()
        
        for file in files_list:
            path = self.path+file
            parser.feed(path)
            tuz = parser.getTuZ()
            
            print tuz[0]
            #print tuz
            
    
    def getFileList(self):
        #base, dirs, files = iter(os.walk("../data/TuZ")).next()
        files = os.listdir(self.path)
        return sorted(files)
    
    def getStructure(self):
        parser = BiTuZaParser()
        structure = parser.getStructureList()
        return structure
    
    def createTable(self):
        query = "create table content ( book_id numeric primary key, kap_vers numeric key, WV numeric, WK numeric, WB numeric, ABK numeric, ABB numeric, ABV numeric, AnzB numeric, TW numeric, Zahlencode numeric, Grundtext string, Umschrift string, Ubersetzung string )"
        self.cursor.execute(query)
        self.connection.commit()
        
    
    
c = TuZ2sqlite()
c.parseAll()
#c.main()
#c.createTable()
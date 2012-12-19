# -*- coding: utf-8 -*-

# Parser for the file BiTuZa.Struktur

import re, sys, codecs

class BiTuZaStrukturParser(object):
    def __init__(self):
        #filepath = "../../data/Struktur_Generator/BiTuZa.Struktur"
        
        #self.structure = self.readFile(filepath)
        self.structure = "this is deprecated!"
    
    def replaceRegexp(self, line):
        line = re.sub(r"\ \([0-9]*\.[0-9]*\)", "", line)
        #print line, "#############"
        return line
    
    # returns a list of lists containing every line of the file BiTuZa.Struktur
    def readFile(self, filepath):
        fobj = open(filepath, "r")
        #fobj = codecs.open(filepath, "rb", "utf-8")
        
        #fobj_unicode = fobj.readlines()
        
        #print fobj_unicode
        
        structure = []
        for line in fobj:
            #line = line.decode('iso-8859-1').encode('utf8')
            line = unicode(line.decode("latin1"))
            #line = unicode(line.decode("latin1").encode("utf-8"))
            #line.decode("latin1").encode("utf8")
            
            #line = line.encode("utf-8")
            #print line
            
            line = self.replaceRegexp(line)
            structure.append( self.readLine(line) )
            
        fobj.close()
        
        return structure
        
    # returns a list like: ['1', '1Mose', '1', '1', '7']
    # from left to right:
    # 1 is the number of the current book: the first one
    # 1Mose is the name of the book
    # 1 is the section
    # 1 is the verse-number
    # 7 is the amount of words in this line
    def readLine(self, line):
        line = line.strip() #removes \n
        splitted = line.split(None)
        
        if len(splitted) == 6:
            return self.len6(splitted)
        if len(splitted) == 5:
            return self.len5(splitted)
        
    def len5(self, splitted):
        result_list = []
        i = -1
        temp0 = ""
        temp1 = ""
        for item in splitted:
            i += 1
            
            if i == 0:
                temp0 = item
            elif i == 1:
                result_list.append(item)#(temp0 + " " + item)
            elif i == 2:
                result_list.append( item[1:-1] )
            elif i == 3:
                pass #drop --
            elif i == 4:
                for number in item.split("."):
                    result_list.append(number)
                    
        return result_list
        
    def len6(self, splitted):
        result_list = []
        i = -1
        temp0 = ""
        temp1 = ""
        for item in splitted:
            i += 1
            
            if i == 0:
                temp0 = item
            elif i == 1:
                result_list.append(item)#( temp0 + " " + item) # append the number of the book
            elif i == 2:
                temp1 = item # the number of the current book
            elif i == 3:
                result_list.append( temp1[1:] + " " + item[:-1] ) # merges the number of the book with its name as a string
            elif i == 4:
                pass # drops the "--"
            elif i == 5:
                for number in item.split("."):
                    result_list.append(number)
                
        return result_list
        
        return splitted
        
    def getStructureList(self):
        return self.structure
        
#c = BiTuZaStrukturParser()
#r = c.getStructureList()
#print r
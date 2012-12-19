# Parser for the .TuZ-files

# a line is one of:
# - Buch
# - Wort
# - ELB

# an ELB is a string
# a Wort is a list
# a Buch is a list

class TuZParser(object):
    def __init__(self):
        pass
        
    def feed(self, filepath):
        #filepath = "AT 01 1. Mose.TuZ"
        
        #self.tuz = self.readFile(filepath)
        self.tuz = self.buildTuZ(filepath)
    
    
    def buildTuZ(self, filepath):
        fobj = open(filepath, "r")
        
        tuz = []
        for line in fobj:
            tuz.append( self.buildVerse(line) )
        
        fobj.close()
        
        return tuz
    
    def buildVerse(self, line):
        pass
    
    
    
    
    
    
    def getTuZ(self):
        return self.tuz
    
    
    
    
    
    
    
    
    
    
    
    def readFile(self, filepath):
        fobj = open(filepath, "r")
        
        tuz = []
        for line in fobj:
            tuz.append( self.readLine(line) )
        
        fobj.close()
        
        return tuz
        
    def readLine(self, line):
        line = line.strip()
        
        vers = []
        wort = []
        
        if line.startswith("Buch"):
            vers.append( self.parseBuch(line) )
        elif line.startswith("Wort"):
            wort.append( self.parseWort(line) )
        elif line.startswith("Ende"):
            pass # not neccessary
        elif line.startswith("Verse:"):
            vers.append(wort)
            
            vers.append( self.parseVerse(line) )
        elif line.startswith("ELB"):
            vers.append( str(line[4:]) )
        
        return vers
    
    def parseBuch(self, line):
        space_splitted = line.split(None)
        
        result_list = []
        i = -1
        temp = ""
        for item in space_splitted:
            i += 1
            if i == 2:
                temp = item
            elif i == 3:
                result_list.append(temp + " " + item)
            #elif i == 4:
            #    pass
            else:
                result_list.append(item)
                
        return result_list
    
    def parseWort(self, line):
        pipe_splitted = line.split("|")
        
        space_splitted = pipe_splitted[0].split(None)
        space_splitted.append(pipe_splitted[1])
        
        return space_splitted
        
    def parseVerse(self, line):
        space_splitted = line.split(None)
        
        return space_splitted
    
#c = TuZParser()
#r = c.getTuZ()
#print r
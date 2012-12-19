# -*- coding: utf_8 -*-

import sqlite3, re

class Latex2unicode(object):
    def __init__(self):
        self.Greek = Greek2unicode()
        self.Hebrew = CJHeb2unicode()
        
        self.connection = sqlite3.connect("../../databases/tuz.sqlite.db")
        self.cursor = self.connection.cursor()
        
        #query = "SELECT latex_text FROM word WHERE word_row_id = ?"
        #query2 = u"INSERT INTO word (unicode) VALUES '"
        
        #self.hebrew()
        self.greek()
        
    def hebrew(self):
        i = 0
        
        while i < 305498: #structure_row_id = 23145
            i += 1
            
            self.cursor.execute("SELECT ascii FROM word WHERE word_row_id = " + str(i))
            result = self.cursor.fetchall()
            
            uc, ts = self.Hebrew.heb2unicodeASCII( result[0][0] )
            #ts = self.Hebrew.ascii2Transcription( result[0][0] )
            
            #query = u"UPDATE word SET unicode = '" + unicode(uc[::-1]) + u"' , transcription = '" +unicode(ts)+ "' WHERE word_row_id = " + unicode(i)
            query = u"UPDATE word SET unicode=?, transcription=? WHERE word_row_id=?"
            #print query
            
            values = uc, unicode(ts), i
            self.cursor.execute( query, values )
        self.connection.commit()
        
    def greek(self):
        i = 305498
        while i < 446175:
            i += 1
            
            self.cursor.execute("SELECT latex FROM word WHERE word_row_id = " + str(i))
            
            result = self.cursor.fetchall()
            
            #print result[0][0]
            
            uc, ts = self.Greek.greek2unicode( result[0][0] )
            
            #query = u"UPDATE word SET unicode = '" + unicode(uc) + u"' WHERE word_row_id = " + unicode(i)
            query = u"UPDATE word SET unicode=?, transcription=? WHERE word_row_id=?"
            values = uc, unicode(ts), i
            self.cursor.execute( query, values )
            
        self.connection.commit()

class Greek2unicode(object):
    def __init__(self):
        pass
    
    def greek2unicode(self, data):
        greek_dict = self.unicodeDict()
        latin_dict = self.transDict()
        
        print data
        data = re.sub("\{", "", data)
        data = re.sub("\$", "", data)
        data = re.sub("mathrm", "", data)
        data = re.sub("boldsymbol", "", data)
        data += "\\"
        
        #print data
        
        current_latex_char = ""
        unicode_string = ""
        latin_string = ""
        for char in data:
            if char == "\\":
                
                if current_latex_char != "":
                    
                    #print current_latex_char
                    unicode_string += greek_dict[ current_latex_char ]
                    latin_string += latin_dict[ current_latex_char ]
                    
                    current_latex_char = ""
            else:
                current_latex_char += char
                
        if unicode_string[-1:] == u"σ":
            unicode_string = unicode_string[:-1] + u"ς"
        
        return unicode_string, latin_string
    
    def transDict(self):
        return {
                "o"           : "o",
                
                "upalpha"     : "a",
                "upbeta"      : "b",
                "upgamma"     : "g",
                "updelta"     : "d",
                "upepsilon"   : "e",
                "upzeta"      : "z",
                "upeta"       : "ē",
                "upvartheta"  : "th",
                "upiota"      : "i",
                "upkappa"     : "k",
                "uplambda"    : "l",
                "upmu"        : "m",
                "upnu"        : "n",
                "upxi"        : "x",
                "upomikron"   : "o",
                "uppi"        : "p",
                "uprho"       : "r",
                "upsigma"     : "s",
                
                "endsigma"    : "s",
                
                "uptau"       : "t",
                "upsilon"     : "y",
                "upvarphi"    : "ph",
                "upchi"       : "ch",
                "uppsi"       : "ps",
                "upomega"     : "ō"
                }
    
    def unicodeDict(self):
        dict = {
                "o"           : u"ο",
                
                "upalpha"     : u"α",
                "upbeta"      : u"β",
                "upgamma"     : u"γ",
                "updelta"     : u"δ",
                "upepsilon"   : u"ε",
                "upzeta"      : u"ζ",
                "upeta"       : u"η",
                "upvartheta"     : u"θ",
                "upiota"      : u"ι",
                "upkappa"     : u"κ",
                "uplambda"    : u"λ",
                "upmu"        : u"μ",
                "upnu"        : u"ν",
                "upxi"        : u"ξ",
                "upomikron"   : u"ο",
                "uppi"        : u"π",
                "uprho"       : u"ρ",
                "upsigma"     : u"σ",
                
                "endsigma"    : u"ς",
                
                "uptau"       : u"τ",
                "upsilon"   : u"υ",
                "upvarphi"       : u"φ",
                "upchi"       : u"χ",
                "uppsi"       : u"ψ",
                "upomega"     : u"ω"
                }
        return dict

class CJHeb2unicode(object):
    def __init__(self):
        pass
            
    def heb2unicodeASCII(self, ascii):
        print ascii
        
        hebrew_dict = self.asciiDict()
        trans_dict = self.transDict()
        
        if ascii[-1:] == "K":
            ascii = ascii[:-1] + "1"
        elif ascii[-1:] == "M":
            ascii = ascii[:-1] + "2"
        elif ascii[-1:] == "N":
            ascii = ascii[:-1] + "3"
        elif ascii[-1:] == "P":
            ascii = ascii[:-1] + "4"
        elif ascii[-1:] == "ß":
            ascii = ascii[:-1] + "5"
        
        #ascii = ascii[::-1]
        
        #ascii.decode("cp1250").encode("utf8")
        #print "##############################", ascii
        ascii = self.replaceS(ascii)
        #ascii = re.sub("ß", "6", ascii)
        #ascii.replace("ß", "6")
        print ascii
            
        ustring = ""
        trans_string = u""
        for char in ascii:
            #print char
            uchar = unichr( hebrew_dict[ char ] )
            ustring = ustring + uchar
            
            tchar = trans_dict[ char ]
            trans_string = trans_string + tchar
        
        print ustring, trans_string
        return ustring, trans_string#[::-1]
    
    # for some reason re.sub() or string.replace() does not work here
    def replaceS(self, ascii):
        result =  ""
        for char in ascii:
            if char == "ß":
                char = "6"
                
            result = result + char
            
        return result
            
    def heb2unicodeLatex(self, heb):
        
        if heb[:1] == "k":
            heb = "K" + heb[1:]
        elif heb[:1] == "m":
            heb = "M" + heb[1:]
        elif heb[:1] == "n":
            heb = "N" + heb[1:]
        elif heb[:1] == "p":
            heb = "P" + heb[1:]
        elif heb[:2] == ".s":
            heb = ".S" + heb[1:]
        
        ucode = u""
        
        heb_len = len(heb)
        
        for char in heb:
            #first_char = ""
            
            if char.startswith("."):
                first_char = char
            elif char.startswith("/"):
                first_char = char
            elif char.startswith(","):
                first_char = char
            elif char.startswith("+"):
                first_char = char
            else:
                try:
                    current_string = first_char + char
                except:
                    current_string = char
                
                first_char = ""
                
                hebrew_dict = self.unicodeDict()
                
                current_string = re.sub("'", "#", current_string)
                current_string = re.sub("`", "+", current_string)
                #print current_string, " current_string"
                
                uchar = unichr( hebrew_dict[ current_string ] )
                #print uchar, " uchar"
                ucode += uchar
                
        #print ucode[-1:]
        #if ucode[:1] == u"כ":
        #    ucode = ucode[1:] + unichr(1498) #u"ך"
        print ucode
        
        return ucode
    
    def asciiDict(self):
        dict = {
                "a" : 1506,
                "A" : 1488,
                "B" : 1489,
                "C" : 1495,
                "D" : 1491,
                "G" : 1490,
                "H" : 1492,
                "J" : 1497,
                
                "K" : 1499,
                "1" : 1498,
                
                "L" : 1500,
                "M" : 1502,
                "2" : 1501,
                "N" : 1504,
                "3" : 1503,
                "P" : 1508,
                "4" : 1507,
                "Q" : 1511,
                "R" : 1512,
                "s" : 1505,
                "S" : 1513,
                "t" : 1496,
                "T" : 1514,
                "W" : 1493,
                "Z" : 1494,
                "6" : 1510, #ß
                "5" : 1509,
                }
        return dict
    
    def transDict(self):
        dict = {
                "a" : "`",
                "A" : "\'",
                "B" : "b",
                "C" : "ẖ",
                "D" : "d",
                "G" : "g",
                "H" : "h",
                "J" : "y",
                
                "K" : "k",
                "1" : "kh",
                
                "L" : "l",
                "M" : "m",
                "2" : "m",
                "N" : "n",
                "3" : "n",
                "P" : "p",
                "4" : "f",
                "Q" : "k",
                "R" : "r",
                "s" : "s",
                "S" : "sh",
                "t" : "t",
                "T" : "t",
                "W" : "v",
                "Z" : "z",
                "6" : "ts", #ß
                "5" : "ts",
                }
        return dict
    
    def unicodeDict(self):
        dict = {
                "#" : 1488,
                "b" : 1489,
                "g" : 1490,
                "d" : 1491,
                "h" : 1492,
                "w" : 1493,
                "z" : 1494,
                ".h" : 1495,
                ".t" : 1496,
                "y" : 1497,
                "k" : 1499,
                "K" : 1498,
                "l" : 1500,
                "m" : 1501,
                "M" : 1502,
                
                "n" : 1504,
                "N" : 1503,
                "s" : 1505,
                "+" : 1506,
                "p" : 1508,
                "P" : 1507,
                ".s" : 1510,
                ".S" : 1509,
                "q" : 1511,
                "r" : 1512,
                "/s" : 1513,
                ",s" : 64299,
                "+s" : 64298,
                "t" : 1514
                }
        return dict
    
    def unicodeDict_old(self):
        dict = {
                "#" : "‏א",
                "b" : "ב",
                "g" : "ג",
                "d" : "ד",
                "h" : "‎ה",
                "w" : "ו",
                "z" : "ז‎",
                ".h" : "‎ח",
                ".t" : "ט",
                "y" : "י",
                "k" : "כ",
                "K" : "‏ך",
                "l" : "‎ל",
                "m" : "מ",
                "M" : "ם",
                
                "n" : "נ",
                "N" : "‎ן‎",
                "s" : "‎ס",
                "+" : "ע",
                "p" : "פ",
                "P" : "‎ף‎",
                ".s" : "צ",
                ".S" : "ץ‎",
                "q" : "ק",
                "r" : "ר",
                "/s" : "ש",
                ",s" : "שׂ",
                "+s" : "שׁ",
                "t" : "ת"
                }
        return dict
    
c = Latex2unicode()
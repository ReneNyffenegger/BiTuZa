class TuZ(object):
    def __init__(self):
        self.wort_list = None
        self.stats = None
        self.elberfelder = "blauer elefant"
        
    def setWortList(self, wort_list):
        self.wort_list = wort_list
    def setStats(self, stats):
        self.stats = stats
    def setElberfelder(self, elberfelder):
        self.elberfelder = elberfelder
        
    def getWortList(self):
        return self.wort_list
    def getStats(self):
        return self.stats
    def getElberfelder(self):
        return self.elberfelder
    
class Wort(object):
    def __init__(self):
        self.structure_row_id = -1
        self.wv = -1
        self.wk = -1
        self.wb = -1
        self.abk = -1
        self.abb = -1
        self.abv = -1
        self.anz_b = -1
        self.tw = -1
        self.code = ""
        self.origin_text = ""
        self.transcode = ""
        self.translation_de = ""
        
    def setEverything(self, id, wv, wk, wb, abk, abb, abv, anz_b, tw, code, origin_text, transcode, translation_de):
        self.structure_row_id = id
        self.wv = wv
        self.wk = wk
        self.wb = wb
        self.abk = abk
        self.abb = abb
        self.abv = abv
        self.anz_b = anz_b
        self.tw = tw
        self.code = code
        self.origin_text = origin_text
        self.transcode = transcode
        self.translation_de = translation_de
        
    def setID(self, id):
        self.structure_row_id = id
    def setWV(self, wv):
        self.wv = wv
    def setWK(self, wk):
        self.wk = wk
    def setWB(self, wb):
        self.wb = wb
    def setABK(self, abk):
        self.abk = abk
    def setABB(self, abb):
        self.abb = abb
    def setABV(self, abv):
        self.abv = abv
    def setAnzB(self, anz_b):
        self.anz_b = anz_b
    def setTW(self, tw):
        self.tw = tw
    def setCode(self, code):
        self.code = code
    def setOriginText(self, origin_text):
        self.origin_text = origin_text
    def setTranscode(self, transcode):
        self.transcode = transcode
    def setTranslationDE(self, translation_de):
        self.translation_de = translation_de
        
    def getEverything(self):
        return self.structure_row_id, self.wv, self.wk, self.wb, self.abk, self.abb, self.abv, self.anz_b, self.tw, self.code, self.origin_text, self.transcode, self.translation_de
        
    
class Stats(object):
    def __init__(self):
        self.structure_row_id = -1
        self.vers = -1
        self.total_v = -1
        self.total_k = -1
        self.total_b = -1
        self.sum_v = -1
        self.sum_k = -1
        self.sum_b = -1
        
    def setEverything(self, id, vers, tv, tk, tb, sv, sk, sb):
        self.structure_row_id = id
        self.vers = vers
        self.total_v = tv
        self.total_k = tk
        self.total_b = tb
        self.sum_v = sv
        self.sum_k = sk
        self.sum_b = sb
        
    def setID(self, id):
        self.structure_row_id = id
    def setVers(self, vers):
        self.vers = vers
    def setTotalV(self, tv):
        self.total_v = tv
    def setTotalK(self, tk):
        self.total_k = tk
    def setTotalB(self, tb):
        self.total_b = tb
    def setSumV(self, sv):
        self.sum_v = sv
    def setSumK(self, sk):
        self.sum_k = sk
    def setSumB(self, sb):
        self.sum_b = sb
        
    def getEverything(self):
        return self.structure_row_id, self.vers, self.total_v, self.total_k, self.total_b, self.sum_v, self.sum_k, self.sum_b
    
    def getID(self):
        return self.structure_row_id
    def getVers(self):
        return self.vers
    def getTotalV(self):
        return self.total_v
    def getTotalK(self):
        return self.total_k
    def getTotalB(self):
        return self.total_b
    def getSumV(self):
        return self.sum_v
    def getSumK(self):
        return self.sum_k
    def getSumB(self):
        return self.sum_b
    
class Elberfelder(object):
    def __init__(self):
        self.structure_row_id = -1
        self.vers = ""
        
    def setStructureRowId(self, id):
        self.structure_row_id = id
    def setVers(self, vers):
        self.vers = vers
        
    def getStructureRowId(self):
        return self.structure_row_id
    def getVers(self):
        return self.vers
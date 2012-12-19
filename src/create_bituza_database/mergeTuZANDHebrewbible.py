import sqlite3

class MergeDatabases(object):
    def __init__(self):
        self.connection = sqlite3.connect(database)
        
    def dict(self):
        return {
                1 : "Genesis",
                2 : "Exodus",
                3 : "Leviticus",
                4 : "Numbers",
                5 : "Deuteronomy",
                6 : "Joshua",
                7 : "Judges",
                8 : "Ruth",
                9 : "1Samuel",
                10 : "2Samuel",
                11 : "1Kings",
                12 : "2Kings",
                13 : "1Chronicles",
                14 : "2Chronicles",
                15 : "Ezra",
                16 : "Nehemiah",
                17 : "Esther",
                18 : "Job",
                19 : "Psalms",
                20 : "Proverbs",
                21 : "Ecclesiastes",
                22 : "SofS",
                23 : "Isaiah",
                24 : "Jeremiah",
                25 : "Lamentations",
                26 : "Ezekiel",
                27 : "Daniel",
                28 : "Hosea",
                29 : "Joel",
                30 : "Amos",
                31 : "Obadiah",
                32 : "Jonah",
                33 : "Micah",
                34 : "Nahum",
                35 : "Habakkuk",
                36 : "Zephaniah",
                37 : "Haggai",
                38 : "Zechariah",
                39 : "Malachi",
                }
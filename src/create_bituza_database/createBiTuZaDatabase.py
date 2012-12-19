import time

from structure2sqlite import Struktur2sqlite
from TeXParser2 import TeX2SQL


time1 = time.strftime("%H:%M")
print time1

print "parsing structure ..."
structure = Struktur2sqlite()
structure.main()
print "... done"

time2 = time.strftime("%H:%M")
print time2

print "parsing tex ..."
tex = TeX2SQL()
print "... done"

time3 = time.strftime("%H:%M")
print time3

print "calculating unicode characters (hebrew and greek) ..."
from latex2unicode import Latex2unicode
latex = Latex2unicode()
print "... done"

time4 = time.strftime("%H:%M")

print "DATABASE COMPLETED"

print time1, time2, time3, time4
#print time4-time3, time3-time2, time2-time1
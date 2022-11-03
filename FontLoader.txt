    1 REM QuickFont loader
    2 REM By Ryan Gray
    3 REM 10 September 2022
    4 REM 
    5 REM Make room for font at
    6 REM top of RAM below UDGs.
   10 CLEAR USR "a"-768-1
   11 LET ufont=PEEK 23730+PEEK 23731*256+1
   12 REM Set CHARS to point to
   13 REM the ROM font, just in
   14 REM case.
   16 POKE 23606,0: POKE 23607,60
   20 CLS 
   30 PRINT "Position tape and press a key"'"to load the font file."
   40 PAUSE 0
   50 LOAD ""CODE ufont,768
   60 REM Set the system variable
   61 REM CHARS to point to the 
   62 REM user font.
   64 LET uh=INT (ufont/256)
   66 LET ul=ufont-256*uh
   70 POKE 23606,ul: POKE 23607,uh-1
   71 REM CHARS is 256 less than
   72 REM the actual data address
   80 PRINT "User font loaded and active."

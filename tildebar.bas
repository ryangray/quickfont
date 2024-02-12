    1 REM Tilde and vertical bar
    2 REM as UDG "A" and "B"
    3 REM for TS2068 since FREE
    4 REM and STICK replaced them
    5 REM 
   10 LET ug=USR "a"
   20 LET vg=USR "b"
   30 LET ur=126*8
   40 LET vr=124*8
   50 LET chars=(PEEK 23607)*256 + PEEK 23606
   60 FOR a=0 TO 7
   70 POKE ug+a,PEEK (ur+chars+a)
   80 POKE vg+a,PEEK (vr+chars+a)
   90 NEXT a
  100 PRINT "UDG ""A"" = \a (tilde)"
  110 PRINT "UDG ""B"" = \b (vertical bar)"

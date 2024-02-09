    9 REM \::\::\::\::\::\::\::\::\::\::\::\::
   10 REM  Quick-font 
   11 REM      by     
   12 REM  Ryan  Gray 
   13 REM \::\::\::\::\::\::\::\::\::\::\::\::
   14 REM   6-30-84   
   15 REM             
   16 REM 
   20 PAPER 0: INK 7: BORDER 0: CLS 
   23 INPUT "Font address:";ch
   24 LET ch=ch-256: LET hb=INT (ch/256): LET lb=ch-256*hb: CLEAR ch-1
   40 PLOT 0,0: DRAW 0,175: DRAW 255,0: DRAW 0,-175: DRAW -255,0
   41 PLOT 0,115: DRAW 255,0
   42 PRINT INVERSE 1;AT 0,0;"    Quick-font  by Ryan Gray    "; INVERSE 0
   43 PLOT 119,47: DRAW 0,65: DRAW 65,0: DRAW 0,-65: DRAW -65,0
   45 LET lb=PEEK 23730+1: LET hb=PEEK 23731: LET ch=lb+256*hb: INPUT "Is there a font there?";z$
   46 IF z$="y" OR z$="Y" THEN GO TO 50
   47 PRINT AT 18,1; FLASH 1;" One moment "
   48 FOR a=0 TO 767: PRINT AT 20,1;767-a;" ": POKE ch+256+a,PEEK (61*256+a): NEXT a
   50 PRINT AT 15,25;" ": GO SUB 600
   60 PRINT AT 1,8;"current characters"
   70 PRINT AT 16,1;"Options:  "
   80 PRINT AT 18,1;"1 : edit character            ";AT 19,1;"2 : save characters           ";AT 20,1;"3 : load characters           "
   90 INPUT "Choice? ";c
   99 IF c=3 THEN GO TO 1500
  100 IF c=2 THEN GO TO 1000
  101 IF c=1 THEN GO TO 110
  102 IF c<>1 OR c<>2 OR c<>3 THEN BEEP .2,1: GO TO 90
  110 DIM a$(8,8)
  111 PRINT INVERSE 1;AT 18,1;"1 : edit character"; INVERSE 0
  120 FOR r=1 TO 8: PRINT AT 7+r,15;a$(r): NEXT r
  121 INPUT "Which character? "; LINE c$
  122 IF c$="" OR c$<" " OR c$>"\*" THEN BEEP .2,-10: GO TO 121
  129 LET c$=c$(1)
  130 LET ca=ch+256+8*(CODE c$-32)
  131 IF c$<>"~" AND c$<>"|" THEN POKE 23606,lb: POKE 23607,hb: PRINT AT 15,25;c$: POKE 23606,0: POKE 23607,60
  135 DIM k(8)
  140 FOR p=ca TO ca+7: LET q=PEEK p: LET k(p-ca+1)=q
  141 IF q>127 THEN LET a$(p-ca+1,1)="\::": LET q=q-128
  142 IF q>63 THEN LET a$(p-ca+1,2)="\::": LET q=q-64
  143 IF q>31 THEN LET a$(p-ca+1,3)="\::": LET q=q-32
  144 IF q>15 THEN LET a$(p-ca+1,4)="\::": LET q=q-16
  145 IF q>7 THEN LET a$(p-ca+1,5)="\::": LET q=q-8
  146 IF q>3 THEN LET a$(p-ca+1,6)="\::": LET q=q-4
  147 IF q>1 THEN LET a$(p-ca+1,7)="\::": LET q=q-2
  148 IF q>0 THEN LET a$(p-ca+1,8)="\::"
  149 NEXT p
  150 FOR w=1 TO 8: PRINT AT 7+w,15;a$(w): NEXT w: INVERSE 0
  170 LET r=1: LET c=1
  171 PRINT AT 18,1;"A-Z-K-L move  space mark/erase";AT 19,1;"                              ";AT 20,1;"ENTER to finish   C to cancel"
  180 PRINT AT 7+r,14+c;a$(r,c);AT 7+r,14+c; OVER 1;"+"
  190 LET o$=INKEY$
  191 IF o$="c" THEN GO TO 400
  192 IF o$=CHR$ 13 THEN GO TO 300
  193 LET xr=r: LET xc=c: LET r=r+(o$="z" AND r<8)-(o$="a" AND r>1): LET c=c+(o$="l" AND c<8)-(o$="k" AND c>1)
  195 IF o$=" " THEN LET a$(r,c)=(" " AND a$(r,c)="\::")+("\::" AND a$(r,c)=" "): GO SUB 250
  197 PRINT AT 7+xr,14+xc; OVER 1;"+"
  200 GO TO 180
  250 IF a$(r,c)=" " THEN POKE ca+r-1,PEEK (ca+r-1)-2^(8-c)
  255 IF a$(r,c)="\::" THEN POKE ca+r-1,PEEK (ca+r-1)+2^(8-c)
  260 IF c$="~" OR c$="|" THEN GO TO 270
  261 PRINT AT 15,25;c$: POKE 23606,0: POKE 23607,60
  270 RETURN 
  300 FOR a=1 TO 8: PRINT AT 7+a,15;"        ": NEXT a
  350 GO TO 50
  400 FOR a=1 TO 8: PRINT AT 7+a,15;"        ": NEXT a
  405 FOR p=ca TO ca+7: POKE p,k(p-ca+1): NEXT p
  410 GO TO 50
  600 POKE 23606,lb: POKE 23607,hb
  601 PRINT AT 3,1;" !""#$%&'()*+,-./0123456789:;<=";AT 4,1;">?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[";AT 5,1;"\\]^_`abcdefghijklmnopqrstuvwxy";AT 6,1;"z{|}~\*"
  602 POKE 23606,0: POKE 23607,60
  699 RETURN 
  999 REM  save 
 1000 PRINT AT 19,1; INVERSE 1;"2 : save characters"
 1030 INPUT "Filename? ";f$
 1035 IF f$="" THEN BEEP .1,-5: GO TO 70
 1040 SAVE f$CODE ch+256,768
 1050 GO TO 50
 1500 REM  load 
 1505 PRINT AT 20,1; INVERSE 1;"3 : load characters"
 1510 INPUT "Filename? ";f$
 1520 INPUT "Location? ";loc
 1530 PRINT AT 20,1; FLASH 1;"start tape and press a key"; FLASH 0;AT 20,1;
 1531 PAUSE 60
 1535 IF INKEY$="" THEN GO TO 1535
 1536 PRINT "       loading...             "
 1537 PRINT AT 10,0;
 1540 LOAD f$CODE loc
 1580 GO TO 50

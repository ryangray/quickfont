    1 REM xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    2 REM  QUICKFONT 2.2f for TS2068 with Zebra OS-64
    3 REM  by Ryan Gray
    4 REM 
    5 REM v2.0  September  4,1985
    6 REM v2.2f September 30,2022
    7 REM 
    8 LET ad=USR "a"-768: GO SUB 6200: IF ad>=rt1 THEN GO TO 10: REM Font addr already above BASIC
    9 CLEAR ad-1: GO SUB 6200: LET ad=rt1
   10 GO SUB 6250: POKE 23658,0: REM NO CAPS
   11 LET bc=0: LET c$="A"
   12 DIM a$(8,8): DIM d(8): DIM e(8)
   13 GO SUB 80: REM ROM font
   14 GO SUB 9100: REM Set mc vars
   15 IF PEEK decode<>42 THEN PRINT "Loading machine code": GO SUB 9000
   17 GO SUB 700: REM Set desta
   20 GO SUB 7000: REM BaseScreen
   21 GO SUB 7100: REM View menu
   22 GO SUB 55: REM Bytes into d
   23 GO SUB 60: REM Bits into a$
   24 GO SUB 70: REM Print a$
   30 LET k$=INKEY$: LET k=CODE k$: IF k$="" THEN GO TO 30
   31 IF k=199 THEN GO TO 500
   32 IF k=15 THEN GO TO 4000
   33 IF k=4 THEN GO TO 5000
   34 IF k=5 THEN GO TO 6000
   35 IF k=8 THEN GO SUB 7050
   36 IF k=9 THEN GO SUB 7060
   37 IF k=13 THEN GO TO 90
   38 IF k=205 THEN LET k$="\\"
   39 IF k=204 THEN LET k$="{"
   40 IF k=203 THEN LET k$="}"
   41 IF k=198 THEN LET k$="["
   42 IF k=197 THEN LET k$="]"
   43 IF k=14 THEN GO SUB 7150
   44 IF k=200 THEN GO SUB 450
   45 IF k=11 THEN GO SUB 7070
   46 IF k=10 THEN GO SUB 7080
   47 IF k=226 THEN LET k$=CHR$ 126
   48 IF k=195 THEN LET k$=CHR$ 124
   52 IF k$>=" " AND k$<="\*" THEN LET c$=k$: GO SUB 82: GO SUB 55: GO SUB 60: GO SUB 70
   53 GO TO 30
   54 REM Set cad & load bytes
   55 LET co=8*(CODE c$-32): LET cad=ad+co: REM Char. offset/addr.
   56 LET ho=INT (co/256): LET lo=co-256*ho
   57 FOR a=1 TO 8: LET d(a)=PEEK (cad+a-1): NEXT a
   58 POKE offs,lo: POKE offs+1,ho: RETURN 
   59 REM Decode char bits into a$
   60 GO SUB 700: REM Update a$ addr. in desta
   61 GO SUB 81: REM User font
   62 RANDOMIZE USR decode
   63 GO SUB 80: REM ROM font
   69 RETURN 
   70 REM Print a$
   71 FOR a=1 TO 8: PRINT AT 11+a,35;a$(a): NEXT a
   72 RETURN 
   80 POKE 23606,rl: POKE 23607,rh: RETURN : REM Switch to ROM font
   81 POKE 23606,l: POKE 23607,h: RETURN : REM Switch to alt font
   82 GO SUB 81: REM Alt font
   83 PRINT AT 17,56;c$
   84 GO SUB 80: REM ROM font
   85 PRINT AT 14,56;c$;
   86 RETURN 
   90 REM Edit
   91 GO SUB 55: REM Load bits
   92 FOR a=1 TO 8: LET e(a)=d(a): NEXT a: REM save for cancel
   95 GO SUB 7130: REM Edit menu
  100 LET r=1: LET c=1
  101 LET b$=a$(r,c): PRINT AT 11+r,34+c;b$;AT 11+r,34+c; OVER 1;"+"
  102 LET k$=INKEY$: LET k=CODE k$: IF k$="" THEN GO TO 102
  103 IF k$="c" OR k=7 THEN GO TO 900
  104 IF k=13 THEN GO SUB 7032: GO TO 21: REM Exit edit
  105 IF k$=" " OR k$="b" THEN GO TO 200
  106 LET xr=r: LET xc=c: LET r=r+((k$="z" OR k=10) AND r<8)-((k$="a" OR k=11) AND r>1): LET c=c+((k$="l" OR k=9) AND c<8)-((k$="k" OR k=8) AND c>1)
  107 IF xr<>r OR xc<>c THEN PRINT AT 11+xr,34+xc;b$
  108 IF k$="0" THEN GO SUB 300
  109 IF k$="5" THEN GO SUB 7050
  110 IF k$="8" THEN GO SUB 7060
  113 IF k$="r" THEN GO SUB 400
  114 IF k$="R" THEN GO SUB 410
  119 GO TO 101
  200 IF b$="\::" THEN LET a$(r,c)=" ": LET d(r)=d(r)-2^(8-c): GO TO 202
  201 IF b$=" " THEN LET a$(r,c)="\::": LET d(r)=d(r)+2^(8-c)
  202 POKE cad+r-1,d(r)
  203 GO SUB 82: GO TO 101
  300 REM Clear bits in current char
  302 INPUT "Confirm clear all bits (y/n)";z$: PAUSE 30: IF z$<>"y" THEN RETURN 
  310 FOR a=1 TO 8: LET a$(a)="": POKE cad+a-1,0: LET d(a)=0: NEXT a
  320 GO SUB 60: GO SUB 70: GO SUB 82
  330 RETURN 
  400 REM Copy ROM bits
  402 INPUT "Copy ROM bits for "; INVERSE 1;VAL$ "c$"; INVERSE 0;" (y/n)?";z$: PAUSE 30: IF z$<>"y" THEN RETURN 
  410 FOR a=1 TO 8: LET d(a)=PEEK (15615+co+a): POKE cad+a-1,d(a): NEXT a
  412 GO SUB 60: REM d() to a$
  414 GO SUB 70: REM print a$
  416 GO SUB 82: REM Print char
  420 RETURN 
  449 REM Copy ROM font
  450 INPUT "Replace with ROM font (y/n)?";z$: PAUSE 30: IF z$<>"y" THEN RETURN 
  451 PRINT #0;"Copying ROM font...";
  452 GO SUB 81: REM User font
  453 RANDOMIZE USR copyall
  454 INPUT ""
  455 GO SUB 7032: REM Redraw user font
  456 LET k$=c$: REM Force current char reload
  459 RETURN 
  500 REM Quit program
  501 CLS 
  502 PRINT "To use the font now, enter:"''" GO SUB 81"''"while the QuickFont progam is"'"still loaded. For ROM font use:"'" GO SUB 80"
  504 PRINT '"To load and use a saved font:"''
  505 PRINT " CLEAR ";ad-1
  506 PRINT " LOAD """"CODE ";ad;",768"
  508 PRINT " POKE 23606,";l;": POKE 23607,";h
  509 PRINT '"To revert to the ROM font:"''" POKE 23606,";rl;": POKE 23607,";rh
  510 STOP 
  700 REM Set desta to a$ addr.
  701 LET a$(1,1)=CHR$ PEEK 23629
  702 POKE desta,CODE a$(1,1)
  703 LET a$(1,1)=CHR$ PEEK 23630
  704 POKE desta+1,CODE a$(1,1)
  705 LET a$(1,1)="A"
  706 LET t=PEEK desta+256*PEEK (desta+1)
  707 IF PEEK t<>65 THEN STOP 
  709 RETURN 
  900 REM Cancel
  901 PRINT #0; INVERSE 1;" EDIT CANCELED  "
  902 FOR a=1 TO 8: POKE cad+a-1,e(a): NEXT a
  903 PAUSE 60: INPUT ""
  904 GO SUB 7032: GO TO 21
 4000 REM Test
 4010 PAPER bc: CLS 
 4020 LET caps=0
 4030 PRINT AT 20,0;"Begin typing."'"Press ""STOP"" to end.";
 4032 PRINT AT 0,0;"\::";AT 0,0;
 4035 GO SUB 81: REM Alt font
 4040 PAUSE 0: LET k$=INKEY$: LET k=CODE k$
 4042 IF k=13 AND PEEK 23689>3 THEN PRINT " "'"\::";CHR$ 8;: BEEP 0.01,5
 4043 IF k=6 THEN LET caps=8-caps: POKE 23658,caps
 4045 IF k=14 THEN GO SUB 7150
 4046 IF k=12 THEN PRINT CHR$ 8;"\:: ";CHR$ 8;CHR$ 8;
 4047 IF k$>=" " AND k$<="\*" AND (PEEK 23689>3 OR PEEK 23688>2) THEN PRINT k$;"\::";CHR$ 8;
 4048 IF k=226 THEN GO SUB 80: POKE 23658,0: GO TO 20
 4050 BEEP 0.01,0: GO TO 4040
 5000 REM Save
 5010 GO SUB 7200
 5020 PRINT AT 11,1; INVERSE 1;"SAVE MODE"; INVERSE 0''" Enter file"'" name to save"'" (<=10 chars)"'" or none"'" to cancel."
 5029 INPUT f$
 5030 IF f$="" OR LEN f$>10 THEN PRINT #0; INVERSE 1;" SAVE CANCELED ": PAUSE 120: INPUT "": GO TO 21
 5040 SAVE f$CODE ad,768
 5050 GO SUB 7200: PRINT AT 11,1; INVERSE 1;"SAVE DONE"; INVERSE 0''" Do you want"'" to verify"'" the file?"'" y/n"
 5060 INPUT k$: IF k$<>"y" THEN GO TO 21
 5070 GO SUB 7200: PRINT AT 11,1;"Rewind and"'" play the "'" tape to"'" verify."
 5075 PRINT AT 0,0;
 5080 VERIFY f$CODE ad,768
 5090 PRINT #0; INVERSE 1;" FILE OK ": PAUSE 120: INPUT "": GO TO 20
 6000 REM Load
 6010 GO SUB 7200
 6020 PRINT AT 11,1; INVERSE 1;"LOAD MODE"; INVERSE 0''" Input file"'" name to"'" load or"'" ""STOP"" to"'" cancel."
 6030 INPUT f$: IF f$=CHR$ 226 THEN PRINT #0; INVERSE 1;" LOAD CANCELED ": PAUSE 120: INPUT "": GO TO 21
 6040 GO SUB 7200: PRINT AT 11,1;"Play tape"'" now to"'" load."
 6045 PRINT AT 0,0;
 6050 LOAD f$CODE ad,768
 6060 GO SUB 7000: GO TO 21
 6200 REM RAMTOP+1 and ROM font addresses
 6210 LET rt1=1+PEEK 23730+256*PEEK 23731
 6212 LET rl=PEEK 23606: LET rh=PEEK 23607
 6214 IF rl<>0 OR rh<>119 THEN LET rl=0: LET rh=119: GO SUB 80: REM ROM font not active, so make it active
 6220 RETURN 
 6250 REM Set font addr h/l bytes
 6260 LET h=INT (ad/256)-1: LET l=ad-256*(h+1)
 6270 RETURN 
 7000 REM BASE SCREEN
 7010 PAPER bc: OVER 0: CLS 
 7011 PRINT AT 0,0;" QUICKFONT                                         BY RYAN GRAY "
 7012 PLOT 0,167: DRAW 255,0: REM Top black line
 7024 PLOT 138,81: DRAW 35,0: DRAW 0,-67: DRAW -35,0: DRAW 0,67: DRAW 0,-67: DRAW 1,-1: DRAW 35,0: DRAW 0,67: DRAW 1,0: DRAW 0,-67: REM Bit Box border
 7025 FOR q=12 TO 19: PRINT AT q,35;"        ": NEXT q: REM Bit box BG
 7026 PLOT 236,48: DRAW 0,-25: DRAW -21,0: DRAW 0,25: DRAW 21,0: DRAW 1,-1: DRAW 0,-25: DRAW -21,0: DRAW 22,0: DRAW 0,25: REM Preview border
 7030 PRINT AT 4,11;" !""#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNO";AT 7,11;"PQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{}\*": IF speccy=1 THEN PRINT AT 7,55;CHR$ 124;"}";CHR$ 126;"\*"
 7031 PRINT AT 3,4;"USER >";AT 6,4;"FONT >"
 7032 GO SUB 81: REM Alt font
 7033 PRINT AT 3,11;" !""#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNO";AT 6,11;"PQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{}\*": IF speccy=1 THEN PRINT AT 6,55;CHR$ 124;"}";CHR$ 126;"\*"
 7034 GO SUB 80: REM ROM font
 7039 PRINT AT 16,54; PAPER bc;"   ";AT 17,54;"   ";AT 18,54;"   "
 7040 GO SUB 82
 7041 RETURN 
 7050 LET bc=bc-1: IF bc=-1 THEN LET bc=7
 7051 GO TO 7039
 7060 LET bc=bc+1: IF bc=8 THEN LET bc=0
 7061 GO TO 7039
 7070 IF c$>" " THEN LET k$=CHR$ (CODE c$-1)
 7071 RETURN 
 7080 IF c$<"\*" THEN LET k$=CHR$ (CODE c$+1)
 7081 RETURN 
 7100 REM VIEW MENU
 7110 PRINT AT 11,0;" Press key to view char."'" Shift+6/7: Prev/Next char"'" Enter    : EDIT          "'" Shift+3  : SAVE          "'" Shift+4  : LOAD          "'" Shift+9  : TEST Typing   "'" Symbl+Q  : QUIT          "'" >=      : Copy ROM       "'" Shift + SymbolShift,     "'
 7111 IF speccy THEN PRINT " then: y u p a s d f g    "'" gets: [ ] \* ~ | \\ { }    "
 7112 IF NOT speccy THEN PRINT " then: y u p d f g        "'" gets: [ ] \* \\ { }        "
 7120 PRINT AT 12,53;"VIEWING";AT 20,53;AT 21,53;"BG:^5/^8": RETURN 
 7125 REM EDIT MENU
 7130 PRINT AT 11,0;" a : UP    or             "'" z : DOWN  arrow          "'" k : LEFT  keys           "'" l : RIGHT                "'" r : Copy bits from ROM   "
 7131 PRINT " R : Copy bits w/o asking "'" c : CANCEL               "'" 0 : ALL OFF              "'" Enter : FINISH           "'" Space : ON/OFF           "'"         or b             "
 7140 PRINT AT 12,53;"EDITING";AT 21,53;"BG: 5/ 8": RETURN 
 7150 BEEP 0.01,10: REM After shift+symbol     shift, wait for key to get to   symbols under keys
 7151 LET z$=INKEY$: IF z$="" OR z$=CHR$ 14 THEN GO TO 7151
 7152 IF z$="a" THEN LET k$=CHR$ 126
 7153 IF z$="y" THEN LET k$="["
 7154 IF z$="u" THEN LET k$="]"
 7155 IF z$="p" THEN LET k$="\*"
 7156 IF z$="d" THEN LET k$="\\"
 7157 IF z$="f" THEN LET k$="{"
 7158 IF z$="g" THEN LET k$="}"
 7159 IF z$="s" THEN LET k$=CHR$ 124
 7160 REM Chars 124 and 126 are really Spectrum-only. Would need to make an MC print routine to show them on a TS2068. You can edit the bits but not see the chars.
 7161 IF k$=CHR$ 14 THEN BEEP 0.01,0
 7162 RETURN 
 7200 FOR a=11 TO 21: PRINT AT a,1;"                         ";" " AND a>19: NEXT a: RETURN 
 9000 REM Load machine code into REM on first line
 9001 LET h$="2A365C2401FFFF09545D21FFFF0608481A0608173004368F180236202310F4134110ECC9": REM decode
 9002 LET h$=h$+"2A365C24545D21003D010003EDB0C9": REM copyall
 9011 IF PEEK (prog+4)<>234 THEN PRINT "First line not a REM line.": STOP 
 9012 LET b=PEEK (prog+2)+256*PEEK (prog+3): REM rem line length
 9013 LET bfree=b-2-LEN h$/2
 9014 IF bfree<0 THEN PRINT "REM line too short."'"Needs ";-bfree;" more, ";b-2-bfree;" total.": STOP 
 9016 LET i=prog+5
 9018 PRINT AT 0,0;"Loading machine code"
 9019 PRINT h$;AT 1,0;
 9020 FOR a=1 TO LEN h$ STEP 2
 9022 LET h1=CODE h$(a): LET h2=CODE h$(a+1)
 9024 LET x=16*(h1-(48 AND h1<65)-(55 AND h1>64 AND h1<97)-(87 AND h1>96))+(h2-(48 AND h2<65)-(55 AND h2>64 AND h2<97)-(87 AND h2>96))
 9030 PRINT INVERSE 1;h$(a TO a+1);
 9031 POKE i,x
 9032 LET i=i+1
 9040 NEXT a
 9045 PRINT 'bfree;" bytes remain"
 9046 POKE copyall+7,rl: POKE copyall+8,rh+1: REM Set ROM font addr in mc routine
 9049 RETURN 
 9100 REM Set MC data var addresses
 9101 LET prog=PEEK 23635+256*PEEK 23636: REM 26710, start of BASIC program
 9102 LET decode=prog+5: REM Mc routine to decode cad to a$
 9103 LET offs=decode+5: REM Char offset mc var
 9105 LET desta=decode+11: REM Address of a$
 9106 LET copyall=decode+36: REM MC routine to copy bytes of rom font to userfont
 9110 CLS : PRINT CHR$ 126;: REM Tilde on a ZX Spectrum
 9111 LET speccy=0: REM Keyword FREE on a TS2068 prints 6 chars
 9112 IF PEEK 23688=32 THEN LET speccy=1: REM Only printed 1 char
 9113 CLS 
 9120 RETURN 

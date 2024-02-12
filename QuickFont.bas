    1 REM xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    2 REM  QUICKFONT 2.4
    3 REM  by Ryan Gray
    4 REM 
    5 REM v2.0  September  4,1985
    6 REM v2.4  February  11,2024
    7 REM 
    8 LET ad=USR "a"-768: GO SUB 6200: GO SUB 9100: IF ad-nb*cart>=rt1 THEN GO TO 10: REM Don't need to move RAMTOP
    9 CLEAR ad-1-nb*cart: GO SUB 6200: GO SUB 9100: LET ad=rt1+nb*cart: REM Move RAMTOP, redo RT1, MC vars, and ad
   10 GO SUB 6250: POKE 23658,0: REM NO CAPS
   11 LET fc=0: LET bc=7: LET uf=0: LET ub=5: LET c$="A": LET g=0: LET f$="": LET u$=""
   12 DIM a$(8,8): DIM d(8): DIM e(8): DIM u(8)
   13 GO SUB 80: REM ROM font
   15 IF PEEK decode<>42 THEN GO SUB 9000: REM Load MC
   16 GO SUB 9200: REM Spectrum?
   20 GO SUB 7000: REM BaseScreen
   21 GO SUB 7100: REM View menu
   22 GO SUB 55: REM Set co, cad, ho, lo, copy 8 bytes into d, set OFFS in MC
   23 GO SUB 60: REM Decode char bits into a$
   24 GO SUB 70: REM Print a$
   30 LET k$=INKEY$: LET k=CODE k$: IF k$="" THEN GO TO 30: REM View mode key loop
   31 IF k=199 THEN GO TO 500: REM Quit (<= symbol shift Q)
   32 IF k=12 THEN GO TO 4000: REM Test (shift 0)
   33 IF k=4 THEN GO TO 5000: REM Save (shift 3)
   34 IF k=5 THEN GO TO 6000: REM Load (shift 4)
   35 IF k=8 THEN GO SUB 7050: REM BG- (shift 5)
   36 IF k=9 THEN GO SUB 7060: REM BG+ (shift 8)
   37 IF k=13 THEN GO TO 90: REM Edit mode (Enter)
   38 IF k=205 THEN LET k$="\\": REM Symbol shift d = backslash
   39 IF k=204 THEN LET k$="{": REM symsh f = {
   40 IF k=203 THEN LET k$="}": REM symsh g = }
   41 IF k=198 THEN LET k$="[": REM symsh y = [
   42 IF k=197 THEN LET k$="]": REM symsh u = ]
   43 IF k=14 THEN GO SUB 7150: REM shift+symsh = wait for ext mode key
   44 IF k=200 THEN GO SUB 450: REM (>= symsh e) Copy ROM font
   45 IF k=10 THEN GO SUB 7070: REM (down shift+6) FC-
   46 IF k=11 THEN GO SUB 7080: REM (up shift+7) FC+
   47 IF k=226 THEN LET k$=CHR$ 126: REM (STOP symsh+a) Tilde
   48 IF k=195 THEN LET k$=CHR$ 124: REM (NOT symsh+s) Vert. bar
   49 IF k=7 THEN GO SUB 600: GO SUB 7100: REM 7=Sh+1 = show bytes
   50 IF k=6 THEN LET ub=ub+1 AND ub<7: PAPER ub: LET uf=7 AND ub<2: GO SUB 7000: GO SUB 7100: GO SUB 70: REM (shift+2) Change app BG
   51 IF k=15 THEN GO SUB 7300: REM (delete shift+9) Toggle UDG mode
   52 IF k$>=" " AND k$<="\*" THEN LET c$=k$: GO SUB 82: GO SUB 55: GO SUB 60: GO SUB 70: REM View character
   53 GO TO 30: REM Wait for key
   54 REM Set cad & load bytes
   55 LET co=8*(CODE c$-32): LET cad=ad+co: REM Char. offset/addr.
   56 LET ho=INT (co/256): LET lo=co-256*ho
   57 FOR a=1 TO 8: LET d(a)=PEEK (cad+a-1): NEXT a
   58 POKE offs,lo: POKE offs+1,ho
   59 REM Decode char bits into a$
   60 REM Update a$ addr. in desta
   61 LET a$(1,1)=CHR$ PEEK 23629
   62 POKE desta,CODE a$(1,1)
   63 LET a$(1,1)=CHR$ PEEK 23630
   64 POKE desta+1,CODE a$(1,1)
   65 LET a$(1,1)="A": LET t=PEEK desta+256*PEEK (desta+1)
   66 IF PEEK t<>65 THEN STOP 
   67 GO SUB 81: RANDOMIZE USR decode
   68 PRINT AT 17,27; INK fc; PAPER bc;c$
   69 GO SUB 80
   70 REM Print a$
   71 FOR a=1 TO 8: PRINT AT 11+a,14; INK 0; PAPER 7;a$(a): NEXT a
   76 PRINT AT 14,27;c$;
   77 RETURN 
   80 POKE 23606,0: POKE 23607,60: RETURN : REM Switch to ROM font
   81 POKE 23606,l: POKE 23607,h: RETURN : REM Switch to alt font
   82 GO SUB 81: REM Alt font
   83 PRINT AT 17,27; INK fc; PAPER bc;c$
   84 GO SUB 80: REM ROM font
   85 PRINT AT 14,27;c$;
   86 RETURN 
   90 REM Edit
   92 FOR a=1 TO 8: LET e(a)=d(a): NEXT a: REM save for cancel
   95 GO SUB 7130: REM Edit menu
  100 LET r=1: LET c=1
  101 LET b$=a$(r,c): PRINT AT 11+r,13+c; INK 0; PAPER 7;b$;AT 11+r,13+c; OVER 1;"+"
  102 LET k$=INKEY$: LET k=CODE k$: IF k$="" THEN GO TO 102
  103 IF k=7 THEN GO TO 900: REM sh+1=cancel
  104 IF k=13 THEN GO SUB 7032: GO TO 21: REM enter=exit edit
  105 IF k$=" " OR k$="b" THEN GO TO 200: REM toggle bit
  106 LET xr=r: LET xc=c: LET r=r+((k$="z" OR k=10) AND r<8)-((k$="a" OR k=11) AND r>1): LET c=c+((k$="l" OR k=9) AND c<8)-((k$="k" OR k=8) AND c>1)
  107 IF xr<>r OR xc<>c THEN PRINT AT 11+xr,13+xc; INK 0; PAPER 7;b$
  108 IF k$="0" THEN GO SUB 300: REM clear
  109 IF k$="5" THEN GO SUB 7050: REM Preview BG color
  110 IF k$="8" THEN GO SUB 7060
  111 IF k$="6" THEN GO SUB 7070: REM Preview FG color
  112 IF k$="7" THEN GO SUB 7080
  113 IF k$="e" OR k=200 THEN GO SUB 400: REM e or >=, get ROM char
  114 IF k$="E" THEN GO SUB 410: REM get ROM char
  115 IF k$="c" THEN GO SUB 7400: REM copy
  116 IF k$="p" THEN GO SUB 7500: REM paste
  117 IF k$="K" THEN GO SUB 7600: REM Shift Lt
  118 IF k$="L" THEN GO SUB 7650: REM Shift Rt
  119 IF k$="A" THEN GO SUB 7700: REM Shift Up
  120 IF k$="Z" THEN GO SUB 7750: REM Shift Dn
  121 IF k$="h" THEN GO SUB 7800: REM H flip
  122 IF k$="v" THEN GO SUB 7850: REM V flip
  123 IF k$="r" THEN GO SUB 7900: REM L rotate
  124 IF k$="t" THEN GO SUB 7950: REM R rotate
  125 IF k$="?" THEN GO SUB 6300: REM Extra keys help
  150 GO TO 101
  200 IF b$="\::" THEN LET a$(r,c)=" ": LET d(r)=d(r)-2^(8-c): GO TO 202
  201 IF b$=" " THEN LET a$(r,c)="\::": LET d(r)=d(r)+2^(8-c)
  202 POKE cad+r-1,d(r)
  203 GO SUB 82: GO TO 101
  300 REM Clear bits in current char
  302 INPUT "Confirm clear all bits (y/n)";z$: PAUSE 30: IF z$<>"y" THEN RETURN 
  310 FOR a=1 TO 8: POKE cad+a-1,0: LET d(a)=0: NEXT a
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
  501 IF g=1 THEN GO SUB 7300
  502 PAPER 7: INK 0: BORDER 7: CLS 
  503 PRINT "To use the font now, enter:"''" GO SUB 81"''"while the QuickFont progam is"'"still loaded. For ROM font use:"'" GO SUB 80"
  504 PRINT '"To load and use a saved font:"''
  505 PRINT " CLEAR ";ad-1
  506 PRINT " LOAD """"CODE ";ad;",768"
  508 PRINT " POKE 23606,";l;": POKE 23607,";h
  509 PRINT '"To revert to the ROM font:"''" POKE 23606,0: POKE 23607,60"
  510 STOP 
  600 REM List bytes
  610 PRINT AT 11,0;" Bytes:       "'
  620 FOR a=0 TO 7
  630 PRINT "  ";a;": ";d(a+1);TAB 13
  640 NEXT a
  650 PRINT TAB 14;AT 21,1;TAB 15;
  660 PRINT #0;"Press a key"
  670 PAUSE 0: INPUT ""
  680 RETURN 
  900 REM Cancel
  901 PRINT #0; FLASH 1;" EDIT CANCELED  "
  902 FOR a=1 TO 8: POKE cad+a-1,e(a): NEXT a
  903 PAUSE 60: INPUT ""
  904 GO SUB 7032: GO TO 21
 4000 REM Test
 4010 PAPER bc: INK fc: BORDER bc: CLS 
 4020 LET caps=0
 4030 PRINT AT 18,0;"Begin typing. ""STOP"" to end."'"Shift+9 then 1-8 or shift 1-8   for graphic char., or a-u for   UDG char.";
 4032 PRINT AT 0,0;"\::";AT 0,0;
 4035 GO SUB 81: REM Alt font
 4040 PAUSE 0: LET k$=INKEY$: LET k=CODE k$
 4042 IF k=13 AND PEEK 23689>3 THEN PRINT " "'"\::";CHR$ 8;: BEEP 0.01,5
 4043 IF k=6 THEN LET caps=8-caps: POKE 23658,caps
 4044 IF k=15 THEN GO SUB 7170: REM Wait for Graphics char
 4045 IF k=14 THEN GO SUB 7150: REM Wait for sh+symb char
 4046 IF k=12 THEN PRINT CHR$ 8;"\:: ";CHR$ 8;CHR$ 8;
 4047 IF ((k$>=" " AND k$<="\*") OR (k$>=CHR$ 128 AND k$<=CHR$ 164)) AND (PEEK 23689>3 OR PEEK 23688>2) THEN PRINT k$;"\::";CHR$ 8;
 4048 IF k=226 THEN GO SUB 80: POKE 23658,0: GO TO 20
 4050 BEEP 0.01,0: GO TO 4040
 5000 REM Save
 5010 LET g$=(f$ AND NOT g)+(u$ AND g)
 5020 PRINT AT 11,0;" "; INVERSE 1;"SAVE ";"FONT" AND NOT g;"UDGs" AND g; INVERSE 0;"    "'TAB 13'" Enter file  "'" name to save"'" (<=10 chars)"'TAB 13
 5022 IF g$<>"" THEN PRINT " Empty to use"'" """;g$;"""";TAB 13
 5024 IF g$="" THEN PRINT TAB 13'" Empty or    "
 5025 PRINT " STOP=cancel "
 5026 PRINT TAB 14;AT 21,1;TAB 15;
 5029 INPUT z$
 5030 IF z$="" THEN LET z$=g$
 5035 IF z$="" OR z$=CHR$ 226 OR LEN z$>10 THEN GO TO 21
 5040 IF NOT g THEN LET f$=z$: LET c=ad: LET i=768: REM Saving font
 5041 IF g THEN LET u$=z$: LET c=USR "a": LET i=21*8: GO SUB 5100: REM Saving UDGs, put UDGs back
 5042 SAVE z$CODE c,i
 5050 PRINT AT 11,0;" "; INVERSE 1;"SAVE DONE"; INVERSE 0;"    "'TAB 13'" Do you want "'" to verify   "'" the file?   "'" y/n         "'TAB 13'TAB 13'TAB 13'TAB 14;AT 21,1;TAB 15;
 5060 INPUT k$: IF k$<>"y" THEN GO TO 5095
 5070 CLS : PRINT "Rewind & play the tape to verify"'
 5080 VERIFY z$CODE c,i
 5085 PRINT #0; FLASH 1;" FILE OK ": PAUSE 120: INPUT ""
 5090 IF g THEN GO SUB 5100: REM UDGs back into font
 5099 GO TO 20
 5100 REM Swap UDGs and font A-U
 5110 GO SUB 81: RANDOMIZE USR u2f: GO SUB 80: RETURN 
 6000 REM Load
 6010 PRINT AT 11,0;" "; INVERSE 1;"LOAD ";"UDGs" AND g;"FONT" AND NOT g; INVERSE 0;"    "'TAB 13'
 6020 PRINT " Input file  "'" name to load"'" or empty for"'" next one,   "'" or ""STOP"" to"'" cancel.     "'TAB 13'TAB 14;AT 21,1;TAB 15;
 6030 INPUT z$: IF z$=CHR$ 226 THEN GO TO 21
 6040 CLS : PRINT "Play tape now to load."'
 6050 IF g THEN LET c=USR "a": LET i=21*8: GO SUB 5100
 6052 IF NOT g THEN LET c=ad: LET i=768
 6060 LOAD z$CODE c,i
 6070 IF z$="" THEN GO SUB 6100
 6080 IF NOT g THEN LET f$=z$
 6090 IF g THEN LET u$=z$: GO SUB 5100
 6099 GO TO 20
 6100 REM Read loaded bytes name
 6102 LET b=24-PEEK 23689-1
 6104 LET z$=""
 6110 FOR a=1 TO 10
 6112 LET k$=SCREEN$ (b,6+a)
 6120 LET z$=z$+k$
 6130 NEXT a
 6140 LET i=LEN z$
 6150 IF i>0 THEN IF z$(i)=" " THEN LET i=i-1: GO TO 6150
 6160 IF i>0 THEN LET z$=z$( TO i)
 6190 RETURN 
 6200 REM RAMTOP+1 address
 6210 LET rt1=1+PEEK 23730+256*PEEK 23731
 6220 RETURN 
 6250 REM Set user font addr h/l bytes from ad
 6260 LET h=INT (ad/256)-1: LET l=ad-256*(h+1)
 6270 RETURN 
 6300 REM EDIT extras help
 6310 PRINT AT 11,0;" Other keys:  "'TAB 13'" e/E:Copy    "'"    ROM bits "'" t:Rot. right"'" r:Rot. left "'" h:Flip horiz"'" v:Flip vert "'" c:copy      "'" p:paste      ";AT 21,1;TAB 15;
 6320 PRINT #0;"Press a key"
 6330 PAUSE 0: INPUT ""
 6350 GO SUB 7125
 6390 RETURN 
 7000 REM BASE SCREEN
 7010 INK 0: PAPER ub: FLASH 0: OVER 0: INVERSE 0: BRIGHT 0: BORDER 0: CLS 
 7011 PRINT AT 0,0; INK 0; PAPER 7;" QUICKFONT                      "
 7012 GO SUB 7250
 7018 PLOT 0,167: DRAW 255,0: REM Top black line
 7020 PLOT 3,175: DRAW -1,0: DRAW -1,-1: DRAW 0,1: DRAW -1,0: DRAW 0,-3: REM TL corner
 7021 PLOT 252,175: DRAW 1,0: DRAW 1,-1: DRAW 0,1: DRAW 1,0: DRAW 0,-3: REM TR corner
 7022 PLOT 255,3: DRAW 0,-1: DRAW -1,-1: DRAW 1,0: DRAW 0,-1: DRAW -3,0: REM BR corner
 7023 PLOT 3,0: DRAW -1,0: DRAW -1,1: DRAW 0,-1: DRAW -1,0: DRAW 0,3: REM BL corner
 7024 PLOT 111,80: DRAW 65,0: DRAW 0,-65: DRAW -65,0: DRAW 0,65: DRAW 0,-65: DRAW 1,-1: DRAW 65,0: DRAW 0,65: DRAW 1,0: DRAW 0,-65: REM Bit Box border
 7025 FOR q=12 TO 19: PRINT AT q,14; INK 0; PAPER 7;"        ": NEXT q: REM Bit box BG
 7026 PLOT 232,48: DRAW 0,-25: DRAW -25,0: DRAW 0,25: DRAW 25,0: DRAW 1,-1: DRAW 0,-25: DRAW -25,0: DRAW 26,0: DRAW 0,25: REM Preview box
 7027 PLOT 0,92: DRAW 255,0
 7028 INK uf
 7029 REM Font character labels in ROM font
 7030 PRINT AT 3,7;" !""#$%&'()*+,-./01234567";AT 5,7;"89:;<=>?@ABCDEFGHIJKLMNO";AT 7,7;"PQRSTUVWXYZ[\\]^_`abcdefg";AT 9,7;"hijklmnopqrstuvwxyz{}\*": IF speccy=1 THEN PRINT AT 9,27;CHR$ 124;"}";CHR$ 126;"\*"
 7031 PRINT AT 2,1;"USER>";AT 3,1;"FONT";AT 4,5;">";AT 6,5;">";AT 8,5;">": IF g=1 THEN PRINT AT 5,16; INVERSE 1;"ABCDEFGHIJKLMNO";AT 7,7;"PQRSTU";
 7032 GO SUB 81: REM Alt font
 7033 PRINT AT 2,7;" !""#$%&'()*+,-./01234567";AT 4,7;"89:;<=>?@";"ABCDEFGHIJKLMNO";AT 6,7;"PQRSTUVWXYZ[\\]^_`abcdefg";AT 8,7;"hijklmnopqrstuvwxyz{}\*": IF speccy=1 THEN PRINT AT 8,27;CHR$ 124;"}";CHR$ 126;"\*"
 7034 GO SUB 80: REM ROM font
 7038 REM Current char preview area
 7039 PRINT AT 16,26; PAPER bc;"   ";AT 17,26;"   ";AT 18,26;"   "
 7040 GO SUB 82
 7041 RETURN 
 7049 REM REM char preview BG color
 7050 LET bc=bc-1: IF bc=-1 THEN LET bc=7
 7051 GO TO 7039: REM Redraw
 7060 LET bc=bc+1: IF bc=8 THEN LET bc=0
 7061 GO TO 7039
 7069 REM REM char preview FG color
 7070 LET fc=fc-1: IF fc=-1 THEN LET fc=7
 7071 GO TO 7039
 7080 LET fc=fc+1: IF fc=8 THEN LET fc=0
 7081 GO TO 7039
 7100 REM VIEW MENU
 7109 PRINT AT 11,0;" Char.key:VIEW"'" Enter:EDIT  "'" ^3:SAVE     "'" ^4:LOAD "; INVERSE 1;"^"; INVERSE 0;"E: "'" ^0:TEST Copy"
 7110 PRINT " ^1:DATA ROM"'" ^2:BkGd font"'" "; INVERSE 1;"^"; INVERSE 0;"Q:QUIT     "'" ^Shift+Symb"; INVERSE 1;"^"; INVERSE 0'
 7111 IF speccy THEN PRINT " then:yupasdfg";AT 21,1;"gets:[]\*~|\\{}"
 7112 IF NOT speccy THEN PRINT " then:yupdfg  ";AT 21,1;"gets:[]\*\\{}"
 7114 GO SUB 7380
 7120 PRINT AT 12,24;"VIEWING";AT 20,23;"FG:^6/^7";AT 21,23;"BG:^5/^8": RETURN 
 7125 REM EDIT MENU
 7130 PRINT AT 11,0;" a:UP   or    "'" z:DOWN arrow"'" k:LEFT keys "'" l:RIGHT     "'" 0:CLEAR     "'"^1:CANCEL    "'" AZKL:Shift  "'"      bits   "'" Enter:FINISH"'" Space:ON/OFF ";AT 21,1;"or b         ";
 7132 PRINT AT 21,15;"?:more ";
 7140 PRINT AT 12,24;"EDITING";AT 20,23;"FG: 6/ 7";AT 21,23;"BG: 5/ 8": RETURN 
 7150 BEEP 0.01,10: REM After shift+symbol     shift, wait for key to get to   symbols under keys
 7151 LET z$=INKEY$: IF z$="" OR z$=CHR$ 14 THEN GO TO 7151
 7152 IF z$="a" THEN LET k$=CHR$ 126: REM tilde
 7153 IF z$="y" THEN LET k$="["
 7154 IF z$="u" THEN LET k$="]"
 7155 IF z$="p" THEN LET k$="\*"
 7156 IF z$="d" THEN LET k$="\\"
 7157 IF z$="f" THEN LET k$="{"
 7158 IF z$="g" THEN LET k$="}"
 7159 IF z$="s" THEN LET k$=CHR$ 124: REM vert bar
 7160 REM Chars 124 and 126 are really Spectrum-only. Would need to make an MC print routine to show them on a TS2068. You can edit the bits but not see the chars.
 7161 IF k$=CHR$ 14 THEN BEEP 0.01,0
 7162 RETURN 
 7169 REM Wait for Graphics mode char key
 7170 BEEP 0.01,15: LET g$="123\..\:'\.:\:.\: \::\.'\. "
 7171 LET z$=INKEY$: IF z$="" OR z$=CHR$ 15 THEN GO TO 7171
 7172 IF z$>="a" AND z$<="u" THEN LET k$=CHR$ (CODE z$-97+144): REM UDG
 7173 IF z$>="1" AND z$<="7" THEN LET k$=CHR$ (CODE z$-49+129): REM Block G
 7174 IF z$>=CHR$ 4 AND z$<=CHR$ 11 THEN LET k$=g$(CODE z$)
 7175 IF z$="8" THEN LET k$=CHR$ 128
 7198 IF k$=CHR$ 15 THEN BEEP 0.01,0
 7199 RETURN 
 7250 REM Update file name
 7260 PRINT AT 0,19; INK 0; PAPER 7;"          ";AT 0,15;"UDGs:" AND g;u$ AND g;"Font:" AND NOT g;f$ AND NOT g
 7290 RETURN 
 7300 REM Swap UDGs & user font
 7310 LET g=NOT g: REM Toggle UDG mode
 7320 GO SUB 81: REM User font
 7330 RANDOMIZE USR u2f: REM Swap bytes
 7340 PRINT AT 4,16;"ABCDEFGHIJKLMNO";AT 6,7;"PQRSTU"
 7350 GO SUB 80: PRINT AT 5,16; INVERSE g;"ABCDEFGHIJKLMNO";AT 7,7;"PQRSTU";
 7360 LET k$=c$: REM Force reload
 7370 GO SUB 7250: REM Update filename
 7380 PRINT AT 21,15;"^9:UDGs" AND NOT g;"^9:Font" AND g
 7390 RETURN 
 7400 REM Copy
 7410 PRINT #0; FLASH 1;"Copying bits"
 7420 FOR a=1 TO 8
 7430 LET u(a)=d(a)
 7440 NEXT a
 7450 INPUT ""
 7460 RETURN 
 7500 REM Paste
 7510 INPUT "Paste over bits (y/n)?";z$: IF z$<>"y" THEN RETURN 
 7520 FOR a=1 TO 8
 7530 LET d(a)=u(a)
 7532 POKE cad+a-1,u(a)
 7540 NEXT a
 7550 GO SUB 60: GO SUB 70: GO SUB 82
 7560 RETURN 
 7600 PRINT #0; FLASH 1;"Shift left ..."
 7610 FOR a=1 TO 8
 7620 LET d(a)=d(a)*2-255*(d(a)>127)
 7625 POKE cad+a-1,d(a)
 7630 NEXT a
 7640 INPUT "": GO TO 7550
 7650 PRINT #0; FLASH 1;"Shift right ..."
 7660 FOR a=1 TO 8
 7670 LET d(a)=INT (d(a)/2)+128*(d(a)/2<>INT (d(a)/2))
 7675 POKE cad+a-1,d(a)
 7680 NEXT a
 7690 INPUT "": GO TO 7550
 7700 REM Shift up
 7705 LET x=d(1)
 7710 FOR a=1 TO 7
 7720 LET d(a)=d(a+1)
 7730 POKE cad+a-1,d(a)
 7740 NEXT a
 7745 LET d(8)=x
 7746 POKE cad+7,d(8)
 7748 GO TO 7550
 7750 REM Shift down
 7755 LET x=d(8)
 7760 FOR a=8 TO 2 STEP -1
 7765 LET d(a)=d(a-1)
 7770 POKE cad+a-1,d(a)
 7775 NEXT a
 7780 LET d(1)=x
 7785 POKE cad,d(1)
 7790 GO TO 7550
 7800 REM Flip horiz.
 7805 PRINT #0; FLASH 1;"Horizontal flip ..."
 7810 FOR a=1 TO 8: LET x=d(a): LET d(a)=0
 7815 FOR b=1 TO 8: LET i=INT (x/2)
 7820 LET d(a)=2*d(a)+(x-2*i)
 7825 LET x=i
 7830 POKE cad+a-1,d(a)
 7835 NEXT b
 7840 NEXT a
 7845 INPUT "": GO TO 7550
 7850 REM Flip vert.
 7855 PRINT #0; FLASH 1;"Vertical flip ..."
 7860 FOR a=1 TO 4: LET x=d(a)
 7865 LET d(a)=d(9-a): POKE cad+a-1,d(a)
 7870 LET d(9-a)=x: POKE cad+8-a,d(9-a)
 7875 NEXT a
 7880 INPUT ""
 7890 GO TO 7550
 7900 REM Rotate L
 7905 PRINT #0; FLASH 1;"Rotate left ..."
 7910 DIM r$(8,8)
 7915 FOR a=1 TO 8: LET d(a)=0
 7920 FOR b=1 TO 8: LET r$(a,b)=a$(b,9-a)
 7925 IF r$(a,b)<>" " THEN LET d(a)=d(a)+2^(8-b)
 7930 NEXT b: POKE cad+a-1,d(a): NEXT a
 7935 FOR a=1 TO 8: LET a$(a)=r$(a): NEXT a
 7940 INPUT ""
 7945 GO TO 7550
 7950 REM Rotate R
 7955 PRINT #0; FLASH 1;"Rotate right ..."
 7960 DIM r$(8,8)
 7965 FOR a=1 TO 8: LET d(a)=0
 7970 FOR b=1 TO 8: LET r$(a,b)=a$(9-b,a)
 7975 IF r$(a,b)<>" " THEN LET d(a)=d(a)+2^(8-b)
 7980 NEXT b: POKE cad+a-1,d(a): NEXT a
 7985 FOR a=1 TO 8: LET a$(a)=r$(a): NEXT a
 7990 INPUT ""
 7995 GO TO 7550
 9000 REM Load machine code into REM on first line
 9001 PRINT AT 0,0;"Loading machine code"
 9002 IF cart THEN LET i=ad-nb: GO TO 9017
 9011 IF PEEK (prog+4)<>234 THEN PRINT "First line not a REM line.": STOP 
 9012 LET b=PEEK (prog+2)+256*PEEK (prog+3): REM rem line length
 9013 LET bfree=b-2-nb
 9014 IF bfree<0 THEN PRINT "REM line too short."'"Needs ";-bfree;" more, ";b-2-bfree;" total.": STOP 
 9016 LET i=prog+5
 9017 RESTORE 
 9019 PRINT AT 1,0;"[";AT INT (nb/32)+1,nb-32*INT (nb/32)-1;"]";AT 1,0;
 9020 FOR a=1 TO nb
 9022 READ x
 9024 PRINT "\::";
 9031 POKE i+a-1,x
 9040 NEXT a
 9049 RETURN 
 9100 REM Set MC data var addresses
 9102 LET prog=PEEK 23635+256*PEEK 23636: REM Start of BASIC program
 9103 REM Check if we are a cartridge. We can't poke or peek the program area.
 9104 LET nxt=PEEK 23637+256*PEEK 23638: LET nxtlin=256*PEEK nxt+PEEK (nxt+1)
 9106 LET cart=nxtlin<>9106: REM If a cart, the peeks will be from RAM, not ROM and give wrong #
 9110 LET decode=prog+5: REM Mc routine to decode cad to a$
 9112 IF cart THEN LET decode=rt1: REM MC at RT1 versus line 1
 9120 LET offs=decode+5: REM Char offset mc var
 9130 LET desta=decode+11: REM Address of a$
 9140 LET copyall=decode+36: REM MC routine to copy bytes of rom font to userfont
 9150 LET u2f=copyall+15
 9160 LET nb=75: REM #of MC bytes
 9190 RETURN 
 9200 REM Detect if on a Spectrum
 9260 CLS : PRINT CHR$ 126;: REM Tilde on a ZX Spectrum
 9270 LET speccy=0: REM Keyword FREE on a TS2068 prints 6 chars
 9280 IF PEEK 23688=32 THEN LET speccy=1: REM Only printed 1 char
 9290 CLS : RETURN 
 9900 DATA 42,54,92,36,1,255,255,9,84,93,33,255,255,6,8,72,26,6,8: REM decode 1
 9901 DATA 23,48,4,54,143,24,2,54,32,35,16,244,19,65,16,236,201: REM decode 2
 9902 DATA 42,54,92,36,84,93,33,0,61,1,0,3,237,176,201: REM copyall
 9903 DATA 42,54,92,1,8,2,9,84,93,42,123,92,6,168,26,79,126,18,113,19,35,16,247,201: REM u2f

'revision 2.4
DECLARE SUB cletter (amo%)
DECLARE SUB SwitchSound ()
DECLARE SUB help ()
DECLARE SUB ScriptBars ()
DECLARE SUB Speed (am!)
DECLARE SUB LoadBars ()
DECLARE SUB SaveBars ()
DECLARE SUB drawbar ()
DECLARE SUB moveup ()
DECLARE SUB movedown ()
DECLARE SUB Playwave ()
DECLARE SUB drawcur ()
DECLARE SUB moveleft ()
DECLARE SUB moveright ()
DECLARE SUB DrawBars ()
DECLARE SUB refmenu ()
DIM SHARED selText AS INTEGER
DIM SHARED xbar AS INTEGER
DIM SHARED barheight(1 TO 30) AS INTEGER
DIM SHARED BarTime
DIM SHARED sound$
DIM SHARED letters%
COMMON SHARED progdir$
COLOR 30
CHDIR (progdir$)
CLS

OPEN "quiet.txt" FOR INPUT AS #1
          LINE INPUT #1, sound$
CLOSE

BarTime = 1
selText = 1
xbar = 15
FOR checkbar = 1 TO 30
     barheight(checkbar) = 9
NEXT checkbar

SCREEN 13
menu:
SELECT CASE sound$
     CASE "1": SOUND 30000, 5
     CASE "2": SOUND 800, 1
END SELECT

LOCATE 3, 4
COLOR 15
PRINT "Welcome to ";
COLOR 40
PRINT "JakSound ";
COLOR 15
PRINT "studio 2.4"

SELECT CASE sound$
     CASE "1": SOUND 30000, 5
     CASE "2": SOUND 300, 1
END SELECT

CLS
LOCATE 3, 4
COLOR 15
PRINT "Welcome to ";
COLOR 55
PRINT "JakSound ";
COLOR 15
PRINT "studio 2.4"
SELECT CASE sound$
     CASE "1": SOUND 30000, 5
     CASE "2": SOUND 400, 1: SOUND 250, 1: SOUND 450, 1: SOUND 600, 1: SOUND 400, 1: SOUND 250, 1: SOUND 100, 1: SOUND 150, 1: SOUND 900, 1: SOUND 600, 1
END SELECT

redomenu:
refmenu
DO
SELECT CASE INKEY$
     CASE CHR$(0) + "H": selText = selText - 1: refmenu
     CASE CHR$(0) + "P": selText = selText + 1: refmenu
     CASE "": SLEEP 0
     CASE "s": SwitchSound
     CASE CHR$(13): GOSUB ChoseSoGo
     CASE ELSE: GOTO redomenu
END SELECT
LOOP



program:
DrawBars
drawcur
DO
SELECT CASE INKEY$
     CASE CHR$(0) + "K": moveleft: drawcur
     CASE CHR$(0) + "M": moveright: drawcur
     CASE CHR$(0) + "H": moveup: drawbar: drawcur
     CASE CHR$(0) + "P": movedown: drawbar: drawcur
     CASE "p": Playwave
     CASE CHR$(0) + ";": SaveBars: DrawBars 'F1 Saves
     CASE CHR$(0) + "<": LoadBars: DrawBars 'F2 Loads
     CASE CHR$(0) + "=": ScriptBars: DrawBars
     CASE "-": Speed (-1)
     CASE "+": Speed (1)
     CASE "": SLEEP 0
     CASE CHR$(27): GOTO menu
END SELECT
LOOP


endit:
CHAIN ("qjakmenu.bas")
END

ChoseSoGo:
IF (selText = 1) THEN
     GOTO program
ELSEIF (selText = 2) THEN
     help
     GOTO menu
ELSEIF (selText = 3) THEN
     GOTO endit
END IF
RETURN

SUB cletter (amo%)
letters% = letters% + amo%
IF (letters% < 0) THEN
     letters% = 0
ELSEIF (letters% > 8) THEN
     letters% = 8
END IF

END SUB

SUB drawbar
      LINE (xbar * 10, 180)-(xbar * 10 + 8, 0), 16, BF
      LINE (xbar * 10, 180)-(xbar * 10 + 8, 180 - barheight(xbar) * 10), 5, BF
      LINE (xbar * 10 + 1, 180 - 1)-(xbar * 10 + 7, 181 - barheight(xbar) * 10), 13, BF
END SUB

SUB DrawBars
CLS
FOR barnum = 1 TO 30
      LINE (barnum * 10, 180)-(barnum * 10 + 8, 180 - barheight(barnum) * 10), 5, BF
      LINE (barnum * 10 + 1, 180 - 1)-(barnum * 10 + 7, 181 - barheight(barnum) * 10), 13, BF
NEXT barnum
LOCATE 25, 1
COLOR 16
PRINT "                                        ";
LOCATE 25, 1
COLOR 4
PRINT "Length"; BarTime; "[+-] Save[F1] Load[F2] Play[p]";
END SUB

SUB drawcur
xbarnow = xbar * 10 + 3
LINE (xbarnow, 184)-(xbarnow + 1, 184), 1
LINE STEP(0, 0)-STEP(3, 3), 1
LINE STEP(0, 0)-STEP(-7, 0), 1
LINE STEP(0, 0)-STEP(3, -3), 1
LINE (xbarnow, 185)-(xbarnow + 1, 185), 9
LINE (xbarnow - 1, 186)-(xbarnow + 2, 186), 9
END SUB

SUB help
     CLS
     COLOR 15
     PRINT "JakSound Studio 2.4"                    '
     COLOR 115
     PRINT "   1.   Arrow keys left and right move"
     PRINT "        between bars."
     PRINT
     COLOR 116
     PRINT "   2.   Arrow keys up and down change"
     PRINT "        bar height.  Height of bars"
     PRINT "        adjusts pitch of sound."
     PRINT
     COLOR 115
     PRINT "   3.   + and - adjusts how fast the"
     PRINT "        whole wave plays."
     PRINT
     COLOR 116
     PRINT "   4.   File Features:"
     COLOR 115
     PRINT "        [F1] save: saves to a file."
     PRINT "            Type 8 or less letters"
     PRINT "            for a filename."
     COLOR 116
     PRINT "        [F2] load: loads from file."
     PRINT "            type in 8 or less"
     PRINT "            letters, the name of a"
     PRINT "            previously saved file."
     COLOR 115
     PRINT "        [F3] script sound: writes"
     PRINT "            the sound information"
     PRINT "            to a QBasic .bas file."
     COLOR 15
     PRINT "Press a key to continue..."
     SLEEP 0
END SUB

SUB LoadBars
CLS
COLOR 34
LOCATE 1, 1
PRINT "Load file:         "
letters% = 0

relo:
COLOR 0
LOCATE 1, 12
PRINT "        ";
COLOR 34
LOCATE 1, 12
PRINT filenam$;
SLEEP 0
DO
     dumr$ = INKEY$
     SELECT CASE dumr$
          CASE "": GOTO relo
          CASE CHR$(8): CALL cletter(-1): filenam$ = MID$(filenam$, 1, letters%): GOTO relo
          CASE CHR$(32): GOTO relo
          CASE CHR$(9): GOTO relo
          CASE "/": GOTO relo
          CASE "\": GOTO relo
          CASE CHR$(9): GOTO relo
          CASE CHR$(27): letters% = 0: EXIT DO
          CASE CHR$(13): EXIT DO
          CASE ELSE: filenam$ = filenam$ + dumr$: CALL cletter(1): filenam$ = MID$(filenam$, 1, letters%): GOTO relo
     END SELECT
LOOP

COLOR 0
LOCATE 1, 1
PRINT "                   "
SELECT CASE letters%
     CASE 0: GOTO noLoad
     CASE ELSE
END SELECT

OPEN filenam$ + ".jas" FOR INPUT AS #1
     DO UNTIL (EOF(1))
          barnum = barnum + 1
          LINE INPUT #1, temp$
          barheight(barnum) = ASC(temp$)
          barheight(barnum) = barheight(barnum) - 40
     LOOP
CLOSE
noLoad:
END SUB

SUB movedown
barheight(xbar) = barheight(xbar) - 1
IF barheight(xbar) < 1 THEN
     barheight(xbar) = 1
END IF
END SUB

SUB moveleft
'PSET (xbar * 10 + 3, 190), 16
LINE (xbar * 10 - 1, 184)-(xbar * 10 + 9, 188), 16, BF

xbar = xbar - 1
IF (xbar < 1) THEN
     xbar = 1
END IF
END SUB

SUB moveright
LINE (xbar * 10 - 1, 184)-(xbar * 10 + 9, 188), 16, BF

PSET (xbar * 10 + 3, 190), 16
xbar = xbar + 1
IF (xbar > 30) THEN
     xbar = 30
END IF
END SUB

SUB moveup
barheight(xbar) = barheight(xbar) + 1
IF barheight(xbar) > 18 THEN
     barheight(xbar) = 18
END IF
END SUB

SUB Playwave
FOR barnum = 1 TO 30
     SOUND barheight(barnum) * 50, BarTime / 10
NEXT barnum
END SUB

SUB refmenu
IF (selText < 1) THEN
     selText = 1
ELSEIF (selText > 3) THEN
     selText = 3
END IF
COLOR 16
LOCATE 12, 16
PRINT ""
LOCATE 13, 16
PRINT ""
LOCATE 14, 16
PRINT ""
COLOR 11
IF (selText = 1) THEN
     LOCATE 12, 16
     PRINT ""
     COLOR 3
     LOCATE 12, 17
     PRINT "Studio"
     COLOR 125
     LOCATE 13, 17
     PRINT "Help"
     COLOR 125
     LOCATE 14, 17
     PRINT "Quit"
ELSEIF (selText = 2) THEN
     LOCATE 13, 16
     PRINT ""
     COLOR 125
     LOCATE 12, 17
     PRINT "Studio"
     COLOR 3
     LOCATE 13, 17
     PRINT "Help"
     COLOR 125
     LOCATE 14, 17
     PRINT "Quit"
ELSEIF (selText = 3) THEN
     LOCATE 14, 16
     PRINT ""
     COLOR 125
     LOCATE 12, 17
     PRINT "Studio"
     COLOR 125
     LOCATE 13, 17
     PRINT "Help"
     COLOR 3
     LOCATE 14, 17
     PRINT "Quit"
END IF


END SUB

SUB SaveBars
CLS
COLOR 34
LOCATE 1, 1
PRINT "Save file:         "
letters% = 0

resa:
COLOR 0
LOCATE 1, 12
PRINT "        ";
COLOR 34
LOCATE 1, 12
PRINT filenam$;
SLEEP 0
DO
     dumr$ = INKEY$
     SELECT CASE dumr$
          CASE "": GOTO resa
          CASE CHR$(8): CALL cletter(-1): filenam$ = MID$(filenam$, 1, letters%): GOTO resa
          CASE CHR$(32): GOTO resa
          CASE CHR$(9): GOTO resa
          CASE "/": GOTO resa
          CASE "\": GOTO resa
          CASE CHR$(9): GOTO resa
          CASE CHR$(27): letters% = 0: EXIT DO
          CASE CHR$(13): EXIT DO
          CASE ELSE: filenam$ = filenam$ + dumr$: CALL cletter(1): filenam$ = MID$(filenam$, 1, letters%): GOTO resa
     END SELECT
LOOP

COLOR 0
LOCATE 1, 1
PRINT "                   "
SELECT CASE letters%
     CASE 0: GOTO noSave
     CASE ELSE
END SELECT

OPEN filenam$ + ".jas" FOR OUTPUT AS #1
     FOR barnum = 1 TO 30
          temp$ = CHR$(barheight(barnum) + 40)
          PRINT #1, temp$;
          PRINT #1, CHR$(13);
     NEXT barnum
CLOSE

noSave:
END SUB

SUB ScriptBars

CLS
COLOR 34
LOCATE 1, 1
PRINT "Script as:         "
letters% = 0

resc:
COLOR 0
LOCATE 1, 12
PRINT "        ";
COLOR 34
LOCATE 1, 12
PRINT filenam$;
SLEEP 0
DO
     dumr$ = INKEY$
     SELECT CASE dumr$
          CASE "": GOTO resc
          CASE CHR$(8): CALL cletter(-1): filenam$ = MID$(filenam$, 1, letters%): GOTO resc
          CASE CHR$(32): GOTO resc
          CASE CHR$(9): GOTO resc
          CASE "/": GOTO resc
          CASE "\": GOTO resc
          CASE CHR$(9): GOTO resc
          CASE CHR$(27): letters% = 0: EXIT DO
          CASE CHR$(13): EXIT DO
          CASE ELSE: filenam$ = filenam$ + dumr$: CALL cletter(1): filenam$ = MID$(filenam$, 1, letters%): GOTO resc
     END SELECT
LOOP

COLOR 0
LOCATE 1, 1
PRINT "                   "
SELECT CASE letters%
     CASE 0: GOTO noSc
     CASE ELSE
END SELECT

OPEN filenam$ + ".bas" FOR OUTPUT AS #1
     FOR barnum = 1 TO 30
          PRINT #1, "SOUND "; barheight(barnum) * 50; ", "; BarTime / 10
     NEXT barnum
CLOSE

noSc:
END SUB

SUB Speed (am)
BarTime = BarTime + am
IF (BarTime < 1) THEN
     BarTime = 1
ELSEIF (BarTime > 10) THEN
     BarTime = 10
END IF
LOCATE 25, 1
COLOR 16
PRINT "                                        ";
LOCATE 25, 1
COLOR 4
PRINT "Length"; BarTime; "[+-] Save[F1] Load[F2] Play[p]";
END SUB

SUB SwitchSound

OPEN "quiet.txt" FOR OUTPUT AS #1
     SELECT CASE sound$
          CASE "1": PRINT #1, "2": sound$ = "2"
          CASE "2": PRINT #1, "1": sound$ = "1"
     END SELECT
CLOSE

END SUB


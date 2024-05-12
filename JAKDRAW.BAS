'revision 2.7 (new with mouse)
DECLARE FUNCTION MouseInit% ()
DECLARE SUB MouseStatus (Lb%, Rb%, xMouse%, yMouse%)
DECLARE SUB MouseRange (X1%, Y1%, x2%, Y2%)
DECLARE SUB MousePut (X%, Y%)
DECLARE SUB MouseHide ()
DECLARE SUB MouseDriver (ax%, bx%, cx%, dx%)
DECLARE SUB MouseShow ()

DECLARE SUB brushMouse ()
DECLARE SUB checkSize ()
DECLARE SUB getcol ()
DECLARE SUB Ffill ()
DECLARE SUB fill ()
DECLARE SUB help ()
DECLARE SUB FreshWindow ()
DECLARE SUB cletter (amo%)
DECLARE SUB colFresh ()
DECLARE SUB makezero ()
DECLARE SUB seeSize ()
DECLARE SUB SaveJAG ()
DECLARE SUB LoadJAG ()
DECLARE SUB SwitchSound ()
DECLARE SUB getloc ()
DECLARE SUB colchange (xc%, yc%)
DECLARE SUB brush ()
DECLARE SUB DrawWindow ()
DECLARE SUB moveCur (xm%, ym%)
DECLARE SUB getCur ()
DECLARE SUB drawJakdraw ()
DECLARE SUB getJakDraw ()
COMMON SHARED progdir$
CHDIR (progdir$)


'start mouse initialization
DEFINT A-Z: DEF SEG = &HA000:
DIM SHARED mouse$: mouse$ = SPACE$(57)
SCREEN 13
FOR i% = 1 TO 57:  READ a$:  H$ = CHR$(VAL("&H" + a$))
MID$(mouse$, i%, 1) = H$: NEXT i%
DATA 55,89,E5,8B,5E,0C,8B,07,50,8B,5E,0A,8B,07,50,8B
DATA 5E,08,8B,0F,8B,5E,06,8B,17,5B,58,1E,07,CD,33,53
DATA 8B,5E,0C,89,07,58,8B,5E,0A,89,07,8B,5E,08,89,0F
DATA 8B,5E,06,89,17,5D,CA,08,00
RESTORE
ms% = MouseInit%
IF NOT ms% THEN
  PRINT "Mouse not found"
  SOUND 40, 2
  END
END IF
 LOCATE 1, 1
MousePut 26, 38
MouseRange 16, 34, 594, 183
'end mouse initialization

DIM SHARED X
DIM SHARED Y
DIM SHARED pJakDraw(1 TO 1716)
DIM SHARED pCur!(1 TO 8)
DIM SHARED xCur
DIM SHARED yCur
DIM SHARED dotrad AS INTEGER
DIM SHARED xColr
DIM SHARED yColr
DIM SHARED sound$
DIM SHARED qt$
DIM SHARED letters%
DIM SHARED tipnum%
qt$ = CHR$(34)

'Check sound setting
OPEN "quiet.txt" FOR INPUT AS #2
          LINE INPUT #2, sound$
CLOSE #2

'See if user just loaded a file
OPEN "check.did" FOR INPUT AS #1
     LINE INPUT #1, didit$
CLOSE #1
IF didit$ = "1" THEN
     GOTO beginning
     ELSE
END IF

SCREEN 13
getJakDraw
CLS
drawJakdraw
SLEEP 2
CLS

beginning:
dotrad = 1
xCur = 14
yCur = 40
xColr = 9
yColr = 0
tipnum% = 1
makezero
DrawWindow
getCur
afterclear:

colFresh
CALL colchange(0, 0)
help
seeSize
start:
DO
OLDX = X
OLDY = Y
 MouseStatus Lb, Rb, X, Y
xCur = X / 2 + 2
yCur = Y + 2
 SELECT CASE Lb%
  CASE -1: PUT (OLDX / 2, OLDY), pCur!, XOR: brushMouse: PUT (X / 2, Y), pCur!, XOR
  CASE ELSE: PUT (OLDX / 2, OLDY), pCur!, XOR: PUT (X / 2, Y), pCur!, XOR
 END SELECT
     SELECT CASE INKEY$
          CASE CHR$(0) + "K": CALL moveCur(-1, 0)
          CASE CHR$(0) + "M": CALL moveCur(1, 0)
          CASE CHR$(0) + "H": CALL moveCur(0, -1)
          CASE CHR$(0) + "P": CALL moveCur(0, 1)
          CASE "a": CALL colchange(-1, 0): seeSize
          CASE "d":  CALL colchange(1, 0): seeSize
          CASE "w": CALL colchange(0, -1): seeSize
          CASE "s":  CALL colchange(0, 1): seeSize
          CASE CHR$(0) + "G": CALL moveCur(0, -1): brush
          CASE CHR$(0) + "O": CALL moveCur(0, 1):  brush
          CASE CHR$(0) + "S": CALL moveCur(-1, 0): brush
          CASE CHR$(0) + "Q": CALL moveCur(1, 0):  brush
          CASE "p": brush
          CASE "f": fill
          CASE "F": Ffill
          CASE "h": tipnum% = tipnum% + 1: help: IF tipnum% > 8 THEN tipnum% = 0
          CASE "g": getcol: colFresh: CALL colchange(0, 0)
          CASE "+": dotrad = dotrad + 1: checkSize: CALL moveCur(0, 0): seeSize
          CASE "-": dotrad = dotrad - 1: checkSize: CALL moveCur(0, 0): seeSize
          CASE CHR$(32): LINE (10, 36)-(299, 185), 0, BF: FreshWindow:  PUT (X / 2, Y), pCur!, XOR: GOTO afterclear
          CASE CHR$(0) + ";": SaveJAG: GOTO afterclear 'F1 Saves
          CASE CHR$(0) + "<": LoadJAG: GOTO afterclear 'F2 Loads
          CASE CHR$(9): SwitchSound
          CASE CHR$(27): EXIT DO
          CASE ELSE
     END SELECT
LOOP

endit:
CHAIN ("qjakmenu.bas")
END

SUB brush
PUT (X / 2, Y), pCur!, XOR
SELECT CASE dotrad
     CASE 1: PSET (xCur, yCur), yColr * 16 + xColr
     CASE 2: PSET (xCur, yCur), yColr * 16 + xColr
          CIRCLE (xCur, yCur), dotrad - 1, yColr * 16 + xColr
     CASE 3: LINE (xCur - 1, yCur - 1)-(xCur + 1, yCur + 1), yColr * 16 + xColr, BF
          CIRCLE (xCur, yCur), dotrad - 1, yColr * 16 + xColr
     CASE 4: CIRCLE (xCur, yCur), dotrad - 1, yColr * 16 + xColr
          LINE (xCur - 1, yCur)-(xCur + 1, yCur), yColr * 16 + xColr
          LINE (xCur - 2, yCur - 1)-(xCur + 2, yCur + 1), yColr * 16 + xColr, BF
     CASE 5: CIRCLE (xCur, yCur), dotrad - 1, yColr * 16 + xColr
          LINE (xCur - 3, yCur - 1)-(xCur + 3, yCur + 1), yColr * 16 + xColr, BF
          LINE (xCur - 1, yCur - 2)-(xCur + 1, yCur + 2), yColr * 16 + xColr, BF
     CASE 6: CIRCLE (xCur, yCur), dotrad - 1, yColr * 16 + xColr
          LINE (xCur - 2, yCur - 3)-(xCur + 2, yCur + 3), yColr * 16 + xColr, BF
          LINE (xCur - 4, yCur - 1)-(xCur + 4, yCur + 1), yColr * 16 + xColr, BF
          LINE (xCur - 3, yCur - 2)-(xCur + 3, yCur + 2), yColr * 16 + xColr, B
     CASE 7: CIRCLE (xCur, yCur), dotrad - 1, yColr * 16 + xColr
          LINE (xCur - 5, yCur - 1)-(xCur + 5, yCur + 1), yColr * 16 + xColr, BF
          LINE (xCur - 2, yCur - 4)-(xCur + 2, yCur + 4), yColr * 16 + xColr, BF
          LINE (xCur - 3, yCur - 3)-(xCur + 3, yCur + 3), yColr * 16 + xColr, B
          LINE (xCur - 4, yCur - 2)-(xCur + 4, yCur + 2), yColr * 16 + xColr, B
     CASE 8: CIRCLE (xCur, yCur), dotrad - 1, yColr * 16 + xColr
          LINE (xCur - 2, yCur - 5)-(xCur + 2, yCur + 5), yColr * 16 + xColr, BF
          LINE (xCur - 6, yCur - 1)-(xCur + 6, yCur + 1), yColr * 16 + xColr, BF
          LINE (xCur - 5, yCur - 3)-(xCur + 5, yCur + 3), yColr * 16 + xColr, BF
          LINE (xCur - 4, yCur - 4)-(xCur + 4, yCur + 4), yColr * 16 + xColr, B
     CASE 9: CIRCLE (xCur, yCur), dotrad - 1, yColr * 16 + xColr
          LINE (xCur - 2, yCur - 6)-(xCur + 2, yCur + 6), yColr * 16 + xColr, BF
          LINE (xCur - 7, yCur - 1)-(xCur + 7, yCur + 1), yColr * 16 + xColr, BF
          LINE (xCur - 4, yCur - 5)-(xCur + 4, yCur + 5), yColr * 16 + xColr, BF
          LINE (xCur - 6, yCur - 3)-(xCur + 6, yCur + 3), yColr * 16 + xColr, BF
          LINE (xCur - 5, yCur - 4)-(xCur + 5, yCur + 4), yColr * 16 + xColr, B
     CASE 10: CIRCLE (xCur, yCur), dotrad - 1, yColr * 16 + xColr
          LINE (xCur - 4, yCur - 6)-(xCur + 4, yCur + 6), yColr * 16 + xColr, BF
          LINE (xCur - 8, yCur - 1)-(xCur + 8, yCur + 1), yColr * 16 + xColr, BF
          LINE (xCur - 6, yCur - 5)-(xCur + 6, yCur + 5), yColr * 16 + xColr, BF
          LINE (xCur - 7, yCur - 3)-(xCur + 7, yCur + 3), yColr * 16 + xColr, B
END SELECT
DrawWindow
PUT (X / 2, Y), pCur!, XOR
END SUB

SUB brushMouse
SELECT CASE dotrad
     CASE 1: PSET (xCur, yCur), yColr * 16 + xColr
     CASE 2: PSET (xCur, yCur), yColr * 16 + xColr
          CIRCLE (xCur, yCur), dotrad - 1, yColr * 16 + xColr
     CASE 3: LINE (xCur - 1, yCur - 1)-(xCur + 1, yCur + 1), yColr * 16 + xColr, BF
          CIRCLE (xCur, yCur), dotrad - 1, yColr * 16 + xColr
     CASE 4: CIRCLE (xCur, yCur), dotrad - 1, yColr * 16 + xColr
          LINE (xCur - 1, yCur)-(xCur + 1, yCur), yColr * 16 + xColr
          LINE (xCur - 2, yCur - 1)-(xCur + 2, yCur + 1), yColr * 16 + xColr, BF
     CASE 5: CIRCLE (xCur, yCur), dotrad - 1, yColr * 16 + xColr
          LINE (xCur - 3, yCur - 1)-(xCur + 3, yCur + 1), yColr * 16 + xColr, BF
          LINE (xCur - 1, yCur - 2)-(xCur + 1, yCur + 2), yColr * 16 + xColr, BF
     CASE 6: CIRCLE (xCur, yCur), dotrad - 1, yColr * 16 + xColr
          LINE (xCur - 2, yCur - 3)-(xCur + 2, yCur + 3), yColr * 16 + xColr, BF
          LINE (xCur - 4, yCur - 1)-(xCur + 4, yCur + 1), yColr * 16 + xColr, BF
          LINE (xCur - 3, yCur - 2)-(xCur + 3, yCur + 2), yColr * 16 + xColr, B
     CASE 7: CIRCLE (xCur, yCur), dotrad - 1, yColr * 16 + xColr
          LINE (xCur - 5, yCur - 1)-(xCur + 5, yCur + 1), yColr * 16 + xColr, BF
          LINE (xCur - 2, yCur - 4)-(xCur + 2, yCur + 4), yColr * 16 + xColr, BF
          LINE (xCur - 3, yCur - 3)-(xCur + 3, yCur + 3), yColr * 16 + xColr, B
          LINE (xCur - 4, yCur - 2)-(xCur + 4, yCur + 2), yColr * 16 + xColr, B
     CASE 8: CIRCLE (xCur, yCur), dotrad - 1, yColr * 16 + xColr
          LINE (xCur - 2, yCur - 5)-(xCur + 2, yCur + 5), yColr * 16 + xColr, BF
          LINE (xCur - 6, yCur - 1)-(xCur + 6, yCur + 1), yColr * 16 + xColr, BF
          LINE (xCur - 5, yCur - 3)-(xCur + 5, yCur + 3), yColr * 16 + xColr, BF
          LINE (xCur - 4, yCur - 4)-(xCur + 4, yCur + 4), yColr * 16 + xColr, B
     CASE 9: CIRCLE (xCur, yCur), dotrad - 1, yColr * 16 + xColr
          LINE (xCur - 2, yCur - 6)-(xCur + 2, yCur + 6), yColr * 16 + xColr, BF
          LINE (xCur - 7, yCur - 1)-(xCur + 7, yCur + 1), yColr * 16 + xColr, BF
          LINE (xCur - 4, yCur - 5)-(xCur + 4, yCur + 5), yColr * 16 + xColr, BF
          LINE (xCur - 6, yCur - 3)-(xCur + 6, yCur + 3), yColr * 16 + xColr, BF
          LINE (xCur - 5, yCur - 4)-(xCur + 5, yCur + 4), yColr * 16 + xColr, B
     CASE 10: CIRCLE (xCur, yCur), dotrad - 1, yColr * 16 + xColr
          LINE (xCur - 4, yCur - 6)-(xCur + 4, yCur + 6), yColr * 16 + xColr, BF
          LINE (xCur - 8, yCur - 1)-(xCur + 8, yCur + 1), yColr * 16 + xColr, BF
          LINE (xCur - 6, yCur - 5)-(xCur + 6, yCur + 5), yColr * 16 + xColr, BF
          LINE (xCur - 7, yCur - 3)-(xCur + 7, yCur + 3), yColr * 16 + xColr, B
END SELECT
DrawWindow
END SUB

SUB checkSize
IF (dotrad > 10) THEN
     dotrad = 10
ELSEIF (dotrad < 1) THEN
     dotrad = 1
END IF
END SUB

SUB cletter (amo%)
letters% = letters% + amo%
IF (letters% < 0) THEN
     letters% = 0
ELSEIF (letters% > 8) THEN
     letters% = 8
END IF
END SUB

SUB colchange (xc%, yc%)
LINE (xColr * 2 + 272, yColr * 2 - 1)-(xColr * 2 + 274, yColr * 2 + 1), 0, B
xColr = xColr + xc%
yColr = yColr + yc%
IF (xColr < 0) THEN
     xColr = 15
ELSEIF (xColr > 15) THEN
     xColr = 0
ELSEIF (yColr < 0) THEN
     yColr = 15
ELSEIF (yColr > 15) THEN
     yColr = 0
END IF

FOR yo = 0 TO 15
     FOR xo = 0 TO 15
          PSET (xo * 2 + 273, yo * 2), yo * 16 + xo
     NEXT xo
NEXT yo

LINE (xColr * 2 + 272, yColr * 2 - 1)-(xColr * 2 + 274, yColr * 2 + 1), 32, B
    SELECT CASE sound$
          CASE "1": IF (xc% <> 0) OR (yc% <> 0) THEN SOUND 20000, .2
          CASE "2": IF (xc% <> 0) OR (yc% <> 0) THEN SOUND 1000, .2
    END SELECT
COLOR 154
LOCATE 25, 31
PRINT "          ";
LOCATE 25, 31
PRINT "color"; yColr * 16 + xColr;
END SUB

SUB colFresh
FOR xco = 0 TO 15
     FOR yco = 0 TO 15
          LINE (xco * 2 + 272, yco * 2 - 1)-(xco * 2 + 274, yco * 2 + 1), 0, B
     NEXT yco
NEXT xco
END SUB

SUB drawJakdraw

FOR i = 77 TO 51 STEP -1
     PUT (51, i), pJakDraw, PSET
     SOUND i + 20000, .2
     PUT (51, i), pJakDraw, XOR
NEXT i
FOR i = 51 TO 0 STEP -1
     PUT (i, i), pJakDraw, PSET
     SOUND i + 20000, .2
     PUT (i, i), pJakDraw, XOR
NEXT i
PUT (0, 0), pJakDraw, PSET

COLOR 9
LOCATE 2, 11
PRINT "2.7"
END SUB

SUB DrawWindow
'window
LINE (10, 35)-STEP(290, 0), 8
LINE STEP(-291, 0)-STEP(0, 151), 8
LINE STEP(291, -150)-STEP(0, 150), 7
LINE STEP(-290, 0)-STEP(289, 0), 7

LINE STEP(2, -151)-STEP(0, 152), 15
LINE STEP(-1, 0)-STEP(-291, 0), 15
LINE STEP(-1, -153)-STEP(294, 154), 24, B
LINE STEP(1, 1)-STEP(-296, -156), 24, B

LINE STEP(0, -1)-STEP(296, 0), 15
LINE STEP(-297, 0)-STEP(0, 157), 15
LINE STEP(0, 1)-STEP(298, 0), 8
LINE STEP(0, -1)-STEP(0, -157), 8

END SUB

SUB Ffill
PUT (xCur - 2, yCur - 2), pCur!, XOR
COLOR 34
LOCATE 1, 7
PRINT "Filling...  [escape]Дcancels"

colno = 0
xp = 0
yp = 0
underColr = POINT(xCur, yCur)
FOR xfi = 0 TO 289
     FOR yfi = 0 TO 149
     testCol = POINT(xfi + 10, yfi + 36)
     IF (testCol = underColr) THEN
          PSET (xfi + 10, yfi + 36), yColr * 16 + xColr
     ELSE
     END IF
     SELECT CASE INKEY$
        CASE CHR$(27): GOTO stopFfill
     END SELECT
     NEXT yfi
NEXT xfi

stopFfill:
LOCATE 1, 7
PRINT "                            "
help
PUT (xCur - 2, yCur - 2), pCur!, XOR
END SUB

SUB fill
PUT (xCur - 2, yCur - 2), pCur!, XOR
COLOR 34
LOCATE 1, 7
PRINT "filling...  [escape]Дcancels"

ydiro = 1
yp = 0
underColr = POINT(xCur, yCur)

aheadfilup:
yp = 0
aheadfill:
colno = 0
xp = 0
DO
     testCol = POINT(xCur + xp, yCur + (yp * ydiro))
     IF (testCol = underColr) THEN
          PSET (xCur + xp, yCur + (yp * ydiro)), yColr * 16 + xColr
          xp = xp + 1
     ELSE
          colno = 1
     END IF
        SELECT CASE INKEY$
                CASE CHR$(27): GOTO exfil
        END SELECT
LOOP UNTIL colno = 1

'behind fill:
colno = 0
xp = 1
DO
     testCol = POINT(xCur - xp, yCur + (yp * ydiro))
     IF (testCol = underColr) THEN
          PSET (xCur - xp, yCur + (yp * ydiro)), yColr * 16 + xColr
          xp = xp + 1
     ELSE
          colno = 1
     END IF
        SELECT CASE INKEY$
                CASE CHR$(27): GOTO exfil
        END SELECT
LOOP UNTIL colno = 1

yp = yp + 1
testCol = POINT(xCur, yCur + (yp * ydiro))
IF (testCol = underColr) THEN
     GOTO aheadfill
ELSE
END IF
        SELECT CASE INKEY$
                CASE CHR$(27): GOTO exfil
        END SELECT

IF (ydiro = -1) THEN
     GOTO exfil
ELSE
     ydiro = -1
     GOTO aheadfilup
END IF
exfil:
LOCATE 1, 7
PRINT "                            "
help
PUT (xCur - 2, yCur - 2), pCur!, XOR
END SUB

SUB FreshWindow
'black outside
LINE (1, 32)-(5, 190), 0, BF     'left
LINE (112, 29)-(308, 31), 0, BF  'top
LINE (1, 191)-(308, 192), 0, BF  'bottom
LINE (305, 32)-(308, 190), 0, BF 'right

'pallette
CALL colchange(0, 0)

'window
LINE (10, 35)-STEP(290, 0), 8
LINE STEP(-291, 0)-STEP(0, 151), 8
LINE STEP(291, -150)-STEP(0, 150), 7
LINE STEP(-290, 0)-STEP(289, 0), 7

LINE STEP(2, -151)-STEP(0, 152), 15
LINE STEP(-1, 0)-STEP(-291, 0), 15
LINE STEP(-1, -153)-STEP(294, 154), 24, B
LINE STEP(1, 1)-STEP(-296, -156), 24, B

LINE STEP(0, -1)-STEP(296, 0), 15
LINE STEP(-297, 0)-STEP(0, 157), 15
LINE STEP(0, 1)-STEP(298, 0), 8
LINE STEP(0, -1)-STEP(0, -157), 8

END SUB

SUB getcol
colrnumb% = POINT(xCur, yCur)
yColr = INT(colrnumb% / 16)
xColr = colrnumb% - (INT(colrnumb% / 16) * 16)
seeSize
END SUB

SUB getCur
LINE (0, 0)-(4, 4), 0
LINE (2, 0)-STEP(0, 1), 15
LINE STEP(0, 2)-STEP(0, 1), 15
LINE STEP(-3, -2)-STEP(2, 0), 15
LINE STEP(2, 0)-STEP(1, 0), 15
GET (0, 0)-(4, 4), pCur!(1)
END SUB

SUB getJakDraw

COLOR 52
jdX = 0
jdY = 96

'"J" in Jak
     LINE (jdX, jdY)-STEP(1, 1), 53
     LINE STEP(0, 0)-STEP(10, -2), 53
     LINE STEP(0, 0)-STEP(0, -15), 53
     LINE STEP(10, 0)-STEP(-20, 0), 53
LOCATE 12, 3
PRINT "ak"

'"D" in Draw
LOCATE 12, 7
PRINT "raw"
     LINE (jdX + 40, jdY - 2)-STEP(0, -17), 53
     CIRCLE STEP(-5, 10), 12, 53, 4.7, 1.5
GET (0, 77)-(75, 97), pJakDraw

END SUB

SUB getloc
     colnum = yColr * 16 + xColr
     COLOR 15
     LOCATE 23, 28
     PRINT colnum
END SUB

SUB help
'clear the help tip area
COLOR 0
LOCATE 1, 5
PRINT "                              "
LOCATE 2, 5
PRINT "                              "
LOCATE 3, 5
PRINT "                              "

'ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
IF (tipnum% = 1) THEN
'[arrows/mouse]Дmove cursor
LOCATE 2, 8
COLOR 123
PRINT "[";
COLOR 26
PRINT "arrows/mouse";
COLOR 123
PRINT "]Д";
COLOR 54
PRINT "move cursor"
'ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
ELSEIF (tipnum% = 2) THEN
'  Ъ Home ї
'Del End PgDn
'  АрPAINTЩ
LOCATE 1, 11
COLOR 123
PRINT "  Ъ ";
COLOR 26
PRINT "Home ";
COLOR 123
PRINT "ї";

LOCATE 2, 11
COLOR 26
PRINT "Del End PgDn"

LOCATE 3, 11
COLOR 123
PRINT "  Ар";
COLOR 54
PRINT "PAINT";
COLOR 123
PRINT "Щ"
'ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
ELSEIF (tipnum% = 3) THEN
'[p]Дspot paint
LOCATE 2, 11
COLOR 123
PRINT "[";
COLOR 26
PRINT "p";
COLOR 123
PRINT "]Д";
COLOR 54
PRINT "spot paint"
'ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
ELSEIF (tipnum% = 4) THEN
' wДДї
'asdДБmove through palette
LOCATE 1, 10
COLOR 26
PRINT " w";
COLOR 123
PRINT "ДДї";

LOCATE 2, 10
COLOR 26
PRINT "asd";
COLOR 123
PRINT "ДБ";
COLOR 54
PRINT "move through palette"
'ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
ELSEIF (tipnum% = 5) THEN
'[f,F]Дfill, Flood-fill
LOCATE 2, 11
COLOR 123
PRINT "[";
COLOR 26
PRINT "f";
COLOR 123
PRINT ",";
COLOR 26
PRINT "F";
COLOR 123
PRINT "]Д";
COLOR 54
PRINT "fill, Flood-fill";
'ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
ELSEIF (tipnum% = 6) THEN
'[F1,F2]Дsave, load
LOCATE 2, 11
COLOR 123
PRINT "[";
COLOR 26
PRINT "F1";
COLOR 123
PRINT ",";
COLOR 26
PRINT "F2";
COLOR 123
PRINT "]Д";
COLOR 54
PRINT "save, load"
'ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
ELSEIF (tipnum% = 7) THEN
'[spacebar]Дclear drawing area
LOCATE 2, 6
COLOR 123
PRINT "[";
COLOR 26
PRINT "spacebar";
COLOR 123
PRINT "]Д";
COLOR 54
PRINT "clear drawing area"
'ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
ELSEIF (tipnum% = 8) THEN
'[g]Дget color under cursor
LOCATE 2, 9
COLOR 123
PRINT "[";
COLOR 26
PRINT "g";
COLOR 123
PRINT "]Д";
COLOR 54
PRINT "get color under cursor"
'ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
ELSEIF (tipnum% = 9) THEN
'[tab]Дsound on/off
LOCATE 2, 11
COLOR 123
PRINT "[";
COLOR 26
PRINT "tab";
COLOR 123
PRINT "]Д";
COLOR 54
PRINT "sound on/off"
END IF
'ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД

LOCATE 25, 1
COLOR 123
PRINT "[";
COLOR 26
PRINT "h";
COLOR 123
PRINT "]Д";
COLOR 54
PRINT "change help tip";
END SUB

SUB LoadJAG
PUT (xCur - 2, yCur - 2), pCur!, XOR

COLOR 34
LOCATE 1, 7
PRINT "Load file:         "
'LOCATE 2, 7
'SHELL ("dir *.jg1")
letters% = 0

resa:
COLOR 0
LOCATE 1, 18
PRINT "        ";
COLOR 34
LOCATE 1, 18
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
LOCATE 1, 7
PRINT "                   "
SELECT CASE letters%
     CASE 0: GOTO noLoad
     CASE ELSE
END SELECT
COLOR 34
LOCATE 1, 7
PRINT "loading...        "
CHAIN (filenam$ + ".jg1")

noLoad:
help
PUT (xCur - 2, yCur - 2), pCur!, XOR
END SUB

SUB makezero
'lets program know that the program
'isn't restarting after loading a file
OPEN "check.did" FOR OUTPUT AS #2
     PRINT #2, "0"
CLOSE #2

END SUB

DEFLNG A-Z
SUB MouseDriver (ax%, bx%, cx%, dx%)
  DEF SEG = VARSEG(mouse$)
  mouse% = SADD(mouse$)
  CALL Absolute(ax%, bx%, cx%, dx%, mouse%)
END SUB

SUB MouseHide
 ax% = 2
 MouseDriver ax%, 0, 0, 0
END SUB

FUNCTION MouseInit%
  ax% = 0
  MouseDriver ax%, 0, 0, 0
  MouseInit% = ax%
END FUNCTION

SUB MousePut (X%, Y%)
  ax% = 4
  cx% = X%
  dx% = Y%
  MouseDriver ax%, 0, cx%, dx%
END SUB

SUB MouseRange (X1%, Y1%, x2%, Y2%)
  ax% = 7
  cx% = X1%
  dx% = x2%
MouseDriver ax%, 0, cx%, dx%
  ax% = 8
  cx% = Y1%
  dx% = Y2%
  MouseDriver ax%, 0, cx%, dx%
END SUB

SUB MouseShow
  PUT (X / 2, Y), pCur!, XOR
END SUB

SUB MouseStatus (Lb%, Rb%, xMouse%, yMouse%)
  ax% = 3
  MouseDriver ax%, bx%, cx%, dx%
  Lb% = ((bx% AND 1) <> 0)
  Rb% = ((bx% AND 2) <> 0)
  xMouse% = cx%
  yMouse% = dx%
END SUB

DEFINT A-Z
SUB moveCur (xm%, ym%)
xCur = xCur + xm%
yCur = yCur + ym%
MousePut X + xm% * 2, Y + ym%
DrawWindow
END SUB

SUB SaveJAG
PUT (X / 2, Y), pCur!, XOR
COLOR 34
LOCATE 1, 7
PRINT "Save as:          "
letters% = 0
resab:
COLOR 0
LOCATE 1, 16
PRINT "        ";
COLOR 34
LOCATE 1, 16
PRINT filenam$;
SLEEP 0
DO
     dumr$ = INKEY$
     SELECT CASE dumr$
          CASE "": GOTO resab
          CASE CHR$(8): CALL cletter(-1): filenam$ = MID$(filenam$, 1, letters%): GOTO resab
          CASE CHR$(32): GOTO resab
          CASE CHR$(9): GOTO resab
          CASE "/": GOTO resab
          CASE "\": GOTO resab
          CASE CHR$(9): GOTO resab
          CASE CHR$(27): letters% = 0: EXIT DO
          CASE CHR$(13): EXIT DO
          CASE ELSE: filenam$ = filenam$ + dumr$: CALL cletter(1): filenam$ = MID$(filenam$, 1, letters%): GOTO resab
     END SELECT
LOOP
LOCATE 1, 7
COLOR 0
PRINT "                  "
SELECT CASE letters%
     CASE 0: GOTO noSave
     CASE ELSE
END SELECT
COLOR 34
LOCATE 1, 7
PRINT "saving...         "


FOR xmap = 1 TO 2
FOR ymap = 1 TO 2

IF (xmap = 1) AND (ymap = 1) THEN
OPEN (filenam$ + ".jg1") FOR OUTPUT AS #1
     PRINT #1, "SCREEN 13"
     FOR Y% = 1 TO 75
          FOR X% = 1 TO 145
               IF (X% = 1) THEN
                    PRINT #1, "DATA "; POINT(X% + 9, Y% + 35);
               ELSE
                    PRINT #1, ","; POINT(X% + 9, Y% + 35);
               END IF
          NEXT X%
          PRINT #1,
     NEXT Y%
     PRINT #1, "CHDIR "; qt$; progdir$; qt$
     PRINT #1, "FOR y = 1 TO 75"
     PRINT #1, "    FOR x = 1 TO 145"
     PRINT #1, "         READ z"
     PRINT #1, "         PSET (x + 9, y + 35), z"
     PRINT #1, "    NEXT"
     PRINT #1, "NEXT"
     PRINT #1, "OPEN "; qt$; "check.did"; qt$; " FOR OUTPUT AS #1"
     PRINT #1, "     PRINT #1, "; qt$; "1"; qt$
     PRINT #1, "CLOSE"
     PRINT #1, "CHAIN "; qt$; filenam$; ".jg2"; qt$
CLOSE #1
ELSEIF (xmap = 1) AND (ymap = 2) THEN
OPEN (filenam$ + ".jg2") FOR OUTPUT AS #1
     PRINT #1, "SCREEN 13"
     FOR Y% = 1 TO 75
          FOR X% = 1 TO 145
               IF (X% = 1) THEN
                    PRINT #1, "DATA "; POINT(X% + 154, Y% + 35);
               ELSE
                    PRINT #1, ","; POINT(X% + 154, Y% + 35);
               END IF
          NEXT X%
          PRINT #1,
     NEXT Y%
     PRINT #1, "CHDIR "; qt$; progdir$; qt$
     PRINT #1, "FOR y = 1 TO 75"
     PRINT #1, "    FOR x = 1 TO 145"
     PRINT #1, "         READ z"
     PRINT #1, "         PSET (x + 154, y + 35), z"
     PRINT #1, "    NEXT"
     PRINT #1, "NEXT"
     PRINT #1, "OPEN "; qt$; "check.did"; qt$; " FOR OUTPUT AS #1"
     PRINT #1, "     PRINT #1, "; qt$; "1"; qt$
     PRINT #1, "CLOSE"
     PRINT #1, "CHAIN "; qt$; filenam$; ".jg3"; qt$
CLOSE #1
ELSEIF (xmap = 2) AND (ymap = 1) THEN
OPEN (filenam$ + ".jg3") FOR OUTPUT AS #1
     PRINT #1, "SCREEN 13"
     FOR Y% = 1 TO 75
          FOR X% = 1 TO 145
               IF (X% = 1) THEN
                    PRINT #1, "DATA "; POINT(X% + 9, Y% + 110);
               ELSE
                    PRINT #1, ","; POINT(X% + 9, Y% + 110);
               END IF
          NEXT X%
          PRINT #1,
     NEXT Y%
     PRINT #1, "CHDIR "; qt$; progdir$; qt$
     PRINT #1, "FOR y = 1 TO 75"
     PRINT #1, "    FOR x = 1 TO 145"
     PRINT #1, "         READ z"
     PRINT #1, "         PSET (x + 9, y + 110), z"
     PRINT #1, "    NEXT"
     PRINT #1, "NEXT"
     PRINT #1, "OPEN "; qt$; "check.did"; qt$; " FOR OUTPUT AS #1"
     PRINT #1, "     PRINT #1, "; qt$; "1"; qt$
     PRINT #1, "CLOSE"
     PRINT #1, "CHAIN "; qt$; filenam$; ".jg4"; qt$
CLOSE #1
ELSEIF (xmap = 2) AND (ymap = 2) THEN
OPEN (filenam$ + ".jg4") FOR OUTPUT AS #1
     PRINT #1, "SCREEN 13"
     FOR Y% = 1 TO 75
          FOR X% = 1 TO 145
               IF (X% = 1) THEN
                    PRINT #1, "DATA "; POINT(X% + 154, Y% + 110);
               ELSE
                    PRINT #1, ","; POINT(X% + 154, Y% + 110);
               END IF
          NEXT X%
          PRINT #1,
     NEXT Y%
     PRINT #1, "CHDIR "; qt$; progdir$; qt$
     PRINT #1, "FOR y = 1 TO 75"
     PRINT #1, "    FOR x = 1 TO 145"
     PRINT #1, "         READ z"
     PRINT #1, "         PSET (x + 154, y +110), z"
     PRINT #1, "    NEXT"
     PRINT #1, "NEXT"
     PRINT #1, "OPEN "; qt$; "check.did"; qt$; " FOR OUTPUT AS #1"
     PRINT #1, "     PRINT #1, "; qt$; "1"; qt$
     PRINT #1, "CLOSE"
     PRINT #1, "COLOR 34"
     PRINT #1, "LOCATE 1, 7"
     PRINT #1, "PRINT "; qt$; "                  "; qt$
     PRINT #1, "CHAIN "; qt$; "JAKDRAW.BAS"; qt$
CLOSE #1
END IF

NEXT ymap
NEXT xmap

LOCATE 1, 7
COLOR 0
PRINT "                  "

noSave:
help
PUT (X / 2, Y), pCur!, XOR
END SUB

SUB seeSize
LINE (10, 0)-(30, 20), 0, BF
SELECT CASE dotrad
     CASE 1: PSET (20, 10), yColr * 16 + xColr
     CASE ELSE: CIRCLE (20, 10), dotrad - 1, yColr * 16 + xColr: PAINT (20, 10), yColr * 16 + xColr
END SELECT
COLOR 54
LOCATE 4, 1
PRINT "size ";
COLOR 123
PRINT "[";
COLOR 26
PRINT "+";
COLOR 123
PRINT ",";
COLOR 26
PRINT "-";
COLOR 123
PRINT "] "; dotrad - 1;
END SUB

SUB SwitchSound

OPEN "quiet.txt" FOR OUTPUT AS #1
     SELECT CASE sound$
          CASE "1": PRINT #1, "2": sound$ = "2"
          CASE "2": PRINT #1, "1": sound$ = "1"
     END SELECT
CLOSE #1

END SUB


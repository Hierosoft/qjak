'revision 2.7 (new with mouse)
DECLARE FUNCTION MouseInit% ()
DECLARE SUB MouseStatus (Lb%, Rb%, xMouse%, yMouse%)
DECLARE SUB MouseRange (X1%, Y1%, x2%, Y2%)
DECLARE SUB MousePut (xMouseRaw%, yMouseRaw%)
DECLARE SUB MouseHide ()
DECLARE SUB MouseDriver (ax%, bx%, cx%, dx%)
DECLARE SUB MouseShow ()
DECLARE SUB MovePointer (xm%, ym%)
DECLARE SUB MakePointer ()

DECLARE SUB OnMouseDownOver ()
DECLARE SUB checkSize ()
DECLARE SUB getcol ()
DECLARE SUB ColorReplace ()
DECLARE SUB FloodFill ()
DECLARE SUB help ()
DECLARE SUB FreshWindow ()
DECLARE SUB cletter (iAdder%)
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
DECLARE SUB drawJakdraw ()
DECLARE SUB getJakDraw ()
COMMON SHARED progdir$
OPEN "qjak.ini" FOR INPUT AS #1
          LINE INPUT #1, progdir$
CLOSE
FOR charnow = 1 TO LEN(progdir$)
        IF MID$(progdir$, charnow, 1) = "=" THEN GOTO SPLITHERE
NEXT charnow
SPLITHERE:
progdir$ = RIGHT$(progdir$, LEN(progdir$) - (charnow))  'this is correct since STARTS at right
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
'mouse extra stuff:
DIM SHARED xMouseRaw
DIM SHARED yMouseRaw
DIM SHARED pPointer!(1 TO 8)
DIM SHARED xPointer
DIM SHARED yPointer
'end mouse initialization

DIM SHARED sarrDigit(0 TO 9) AS STRING
sarrDigit(0) = "0"
sarrDigit(1) = "1"
sarrDigit(2) = "2"
sarrDigit(3) = "3"
sarrDigit(4) = "4"
sarrDigit(5) = "5"
sarrDigit(6) = "6"
sarrDigit(7) = "7"
sarrDigit(8) = "8"
sarrDigit(9) = "9"



DIM SHARED pJakDraw(1 TO 1716)
DIM SHARED iBrushRad AS INTEGER
DIM SHARED xColr
DIM SHARED yColr
DIM SHARED sound$
DIM SHARED qt$
DIM SHARED letters%
DIM SHARED tipnum%
qt$ = CHR$(34)

'Check sound setting
OPEN "bsound.dat" FOR INPUT AS #2
          LINE INPUT #2, sound$
CLOSE #2

'See if user just loaded a file
OPEN "bloading.dat" FOR INPUT AS #1
     LINE INPUT #1, didit$
CLOSE #1
IF didit$ = "1" THEN
     GOTO postinit
     ELSE
END IF

SCREEN 13
getJakDraw
CLS
drawJakdraw
SLEEP 2
CLS

postinit:
iBrushRad = 1
xPointer = 14
yPointer = 40
xColr = 9
yColr = 0
tipnum% = 1
makezero
DrawWindow
MakePointer 'sets pPointer
afterclear:

colFresh
CALL colchange(0, 0)
help
seeSize
start:
DO
xMouseRawPrev = xMouseRaw
yMouseRawPrev = yMouseRaw
 MouseStatus Lb, Rb, xMouseRaw, yMouseRaw
xPointer = xMouseRaw / 2 + 2
yPointer = yMouseRaw + 2
 SELECT CASE Lb%
  CASE -1: PUT (xMouseRawPrev / 2, yMouseRawPrev), pPointer!, XOR: OnMouseDownOver: PUT (xMouseRaw / 2, yMouseRaw), pPointer!, XOR
  CASE ELSE: PUT (xMouseRawPrev / 2, yMouseRawPrev), pPointer!, XOR: PUT (xMouseRaw / 2, yMouseRaw), pPointer!, XOR
 END SELECT
     SELECT CASE INKEY$
          CASE CHR$(0) + "K": CALL MovePointer(-1, 0)
          CASE CHR$(0) + "M": CALL MovePointer(1, 0)
          CASE CHR$(0) + "H": CALL MovePointer(0, -1)
          CASE CHR$(0) + "P": CALL MovePointer(0, 1)
          CASE "a": CALL colchange(-1, 0): seeSize
          CASE "d":  CALL colchange(1, 0): seeSize
          CASE "w": CALL colchange(0, -1): seeSize
          CASE "s":  CALL colchange(0, 1): seeSize
          CASE CHR$(0) + "G": CALL MovePointer(0, -1): brush
          CASE CHR$(0) + "O": CALL MovePointer(0, 1):  brush
          CASE CHR$(0) + "S": CALL MovePointer(-1, 0): brush
          CASE CHR$(0) + "Q": CALL MovePointer(1, 0):  brush
          CASE "p": brush
          CASE "f": FloodFill
          CASE "F": ColorReplace
          CASE "h": tipnum% = tipnum% + 1: help: IF tipnum% > 8 THEN tipnum% = 0
          CASE "g": getcol: colFresh: CALL colchange(0, 0)
          CASE "+": iBrushRad = iBrushRad + 1: checkSize: CALL MovePointer(0, 0): seeSize
          CASE "-": iBrushRad = iBrushRad - 1: checkSize: CALL MovePointer(0, 0): seeSize
          CASE "e": iBrushRad = iBrushRad + 1: checkSize: CALL MovePointer(0, 0): seeSize
          CASE "q": iBrushRad = iBrushRad - 1: checkSize: CALL MovePointer(0, 0): seeSize
          CASE CHR$(32): LINE (10, 36)-(299, 185), 0, BF: FreshWindow:  PUT (xMouseRaw / 2, yMouseRaw), pPointer!, XOR: GOTO afterclear
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
	PUT (xMouseRaw / 2, yMouseRaw), pPointer!, XOR
	SELECT CASE iBrushRad
	     CASE 1: PSET (xPointer, yPointer), yColr * 16 + xColr
	     CASE 2: PSET (xPointer, yPointer), yColr * 16 + xColr
	          CIRCLE (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
	     CASE 3: LINE (xPointer - 1, yPointer - 1)-(xPointer + 1, yPointer + 1), yColr * 16 + xColr, BF
	          CIRCLE (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
	     CASE 4: CIRCLE (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
	          LINE (xPointer - 1, yPointer)-(xPointer + 1, yPointer), yColr * 16 + xColr
	          LINE (xPointer - 2, yPointer - 1)-(xPointer + 2, yPointer + 1), yColr * 16 + xColr, BF
	     CASE 5: CIRCLE (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
	          LINE (xPointer - 3, yPointer - 1)-(xPointer + 3, yPointer + 1), yColr * 16 + xColr, BF
	          LINE (xPointer - 1, yPointer - 2)-(xPointer + 1, yPointer + 2), yColr * 16 + xColr, BF
	     CASE 6: CIRCLE (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
	          LINE (xPointer - 2, yPointer - 3)-(xPointer + 2, yPointer + 3), yColr * 16 + xColr, BF
	          LINE (xPointer - 4, yPointer - 1)-(xPointer + 4, yPointer + 1), yColr * 16 + xColr, BF
	          LINE (xPointer - 3, yPointer - 2)-(xPointer + 3, yPointer + 2), yColr * 16 + xColr, B
	     CASE 7: CIRCLE (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
	          LINE (xPointer - 5, yPointer - 1)-(xPointer + 5, yPointer + 1), yColr * 16 + xColr, BF
	          LINE (xPointer - 2, yPointer - 4)-(xPointer + 2, yPointer + 4), yColr * 16 + xColr, BF
	          LINE (xPointer - 3, yPointer - 3)-(xPointer + 3, yPointer + 3), yColr * 16 + xColr, B
	          LINE (xPointer - 4, yPointer - 2)-(xPointer + 4, yPointer + 2), yColr * 16 + xColr, B
	     CASE 8: CIRCLE (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
	          LINE (xPointer - 2, yPointer - 5)-(xPointer + 2, yPointer + 5), yColr * 16 + xColr, BF
	          LINE (xPointer - 6, yPointer - 1)-(xPointer + 6, yPointer + 1), yColr * 16 + xColr, BF
	          LINE (xPointer - 5, yPointer - 3)-(xPointer + 5, yPointer + 3), yColr * 16 + xColr, BF
	          LINE (xPointer - 4, yPointer - 4)-(xPointer + 4, yPointer + 4), yColr * 16 + xColr, B
	     CASE 9: CIRCLE (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
	          LINE (xPointer - 2, yPointer - 6)-(xPointer + 2, yPointer + 6), yColr * 16 + xColr, BF
	          LINE (xPointer - 7, yPointer - 1)-(xPointer + 7, yPointer + 1), yColr * 16 + xColr, BF
	          LINE (xPointer - 4, yPointer - 5)-(xPointer + 4, yPointer + 5), yColr * 16 + xColr, BF
	          LINE (xPointer - 6, yPointer - 3)-(xPointer + 6, yPointer + 3), yColr * 16 + xColr, BF
	          LINE (xPointer - 5, yPointer - 4)-(xPointer + 5, yPointer + 4), yColr * 16 + xColr, B
	     CASE 10: CIRCLE (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
	          LINE (xPointer - 4, yPointer - 6)-(xPointer + 4, yPointer + 6), yColr * 16 + xColr, BF
	          LINE (xPointer - 8, yPointer - 1)-(xPointer + 8, yPointer + 1), yColr * 16 + xColr, BF
	          LINE (xPointer - 6, yPointer - 5)-(xPointer + 6, yPointer + 5), yColr * 16 + xColr, BF
	          LINE (xPointer - 7, yPointer - 3)-(xPointer + 7, yPointer + 3), yColr * 16 + xColr, B
	END SELECT
	DrawWindow
	PUT (xMouseRaw / 2, yMouseRaw), pPointer!, XOR
	'end brush
END SUB

SUB OnMouseDownOver
SELECT CASE iBrushRad
     CASE 1: PSET (xPointer, yPointer), yColr * 16 + xColr
     CASE 2: PSET (xPointer, yPointer), yColr * 16 + xColr
          CIRCLE (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
     CASE 3: LINE (xPointer - 1, yPointer - 1)-(xPointer + 1, yPointer + 1), yColr * 16 + xColr, BF
          CIRCLE (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
     CASE 4: CIRCLE (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
          LINE (xPointer - 1, yPointer)-(xPointer + 1, yPointer), yColr * 16 + xColr
          LINE (xPointer - 2, yPointer - 1)-(xPointer + 2, yPointer + 1), yColr * 16 + xColr, BF
     CASE 5: CIRCLE (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
          LINE (xPointer - 3, yPointer - 1)-(xPointer + 3, yPointer + 1), yColr * 16 + xColr, BF
          LINE (xPointer - 1, yPointer - 2)-(xPointer + 1, yPointer + 2), yColr * 16 + xColr, BF
     CASE 6: CIRCLE (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
          LINE (xPointer - 2, yPointer - 3)-(xPointer + 2, yPointer + 3), yColr * 16 + xColr, BF
          LINE (xPointer - 4, yPointer - 1)-(xPointer + 4, yPointer + 1), yColr * 16 + xColr, BF
          LINE (xPointer - 3, yPointer - 2)-(xPointer + 3, yPointer + 2), yColr * 16 + xColr, B
     CASE 7: CIRCLE (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
          LINE (xPointer - 5, yPointer - 1)-(xPointer + 5, yPointer + 1), yColr * 16 + xColr, BF
          LINE (xPointer - 2, yPointer - 4)-(xPointer + 2, yPointer + 4), yColr * 16 + xColr, BF
          LINE (xPointer - 3, yPointer - 3)-(xPointer + 3, yPointer + 3), yColr * 16 + xColr, B
          LINE (xPointer - 4, yPointer - 2)-(xPointer + 4, yPointer + 2), yColr * 16 + xColr, B
     CASE 8: CIRCLE (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
          LINE (xPointer - 2, yPointer - 5)-(xPointer + 2, yPointer + 5), yColr * 16 + xColr, BF
          LINE (xPointer - 6, yPointer - 1)-(xPointer + 6, yPointer + 1), yColr * 16 + xColr, BF
          LINE (xPointer - 5, yPointer - 3)-(xPointer + 5, yPointer + 3), yColr * 16 + xColr, BF
          LINE (xPointer - 4, yPointer - 4)-(xPointer + 4, yPointer + 4), yColr * 16 + xColr, B
     CASE 9: CIRCLE (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
          LINE (xPointer - 2, yPointer - 6)-(xPointer + 2, yPointer + 6), yColr * 16 + xColr, BF
          LINE (xPointer - 7, yPointer - 1)-(xPointer + 7, yPointer + 1), yColr * 16 + xColr, BF
          LINE (xPointer - 4, yPointer - 5)-(xPointer + 4, yPointer + 5), yColr * 16 + xColr, BF
          LINE (xPointer - 6, yPointer - 3)-(xPointer + 6, yPointer + 3), yColr * 16 + xColr, BF
          LINE (xPointer - 5, yPointer - 4)-(xPointer + 5, yPointer + 4), yColr * 16 + xColr, B
     CASE 10: CIRCLE (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
          LINE (xPointer - 4, yPointer - 6)-(xPointer + 4, yPointer + 6), yColr * 16 + xColr, BF
          LINE (xPointer - 8, yPointer - 1)-(xPointer + 8, yPointer + 1), yColr * 16 + xColr, BF
          LINE (xPointer - 6, yPointer - 5)-(xPointer + 6, yPointer + 5), yColr * 16 + xColr, BF
          LINE (xPointer - 7, yPointer - 3)-(xPointer + 7, yPointer + 3), yColr * 16 + xColr, B
END SELECT
DrawWindow
END SUB

SUB checkSize
IF (iBrushRad > 10) THEN
     iBrushRad = 10
ELSEIF (iBrushRad < 1) THEN
     iBrushRad = 1
END IF
END SUB

SUB cletter (iAdder%)
letters% = letters% + iAdder%
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

LINE (xColr * 2 + 272, yColr * 2 - 1)-(xColr * 2 + 274, yColr * 2 + 1), 28, B
    SELECT CASE sound$
          CASE "0": IF (xc% <> 0) OR (yc% <> 0) THEN SOUND 20000, .2
          CASE "1": IF (xc% <> 0) OR (yc% <> 0) THEN SOUND 1000, .2
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

SUB ColorReplace
PUT (xPointer - 2, yPointer - 2), pPointer!, XOR
COLOR 34
LOCATE 1, 7
PRINT "Filling...  [escape]Äcancels"

colno = 0
xp = 0
yp = 0
underColr = POINT(xPointer, yPointer)
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
PUT (xPointer - 2, yPointer - 2), pPointer!, XOR
END SUB

SUB FloodFill
PUT (xPointer - 2, yPointer - 2), pPointer!, XOR
COLOR 34
LOCATE 1, 7
PRINT "filling...  [escape]Äcancels"

ydiro = 1
yp = 0
underColr = POINT(xPointer, yPointer)

aheadfilup:
yp = 0
aheadfill:
colno = 0
xp = 0
DO
     testCol = POINT(xPointer + xp, yPointer + (yp * ydiro))
     IF (testCol = underColr) THEN
          PSET (xPointer + xp, yPointer + (yp * ydiro)), yColr * 16 + xColr
          xp = xp + 1
     ELSE
          colno = 1
     END IF
        SELECT CASE INKEY$
                CASE CHR$(27): GOTO exfil
        END SELECT
LOOP UNTIL colno = 1

'behind FloodFill:
colno = 0
xp = 1
DO
     testCol = POINT(xPointer - xp, yPointer + (yp * ydiro))
     IF (testCol = underColr) THEN
          PSET (xPointer - xp, yPointer + (yp * ydiro)), yColr * 16 + xColr
          xp = xp + 1
     ELSE
          colno = 1
     END IF
        SELECT CASE INKEY$
                CASE CHR$(27): GOTO exfil
        END SELECT
LOOP UNTIL colno = 1

yp = yp + 1
testCol = POINT(xPointer, yPointer + (yp * ydiro))
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
PUT (xPointer - 2, yPointer - 2), pPointer!, XOR
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
colrnumb% = POINT(xPointer, yPointer)
yColr = INT(colrnumb% / 16)
xColr = colrnumb% - (INT(colrnumb% / 16) * 16)
seeSize
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

'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
IF (tipnum% = 1) THEN
'[arrows/mouse]Ämove cursor
LOCATE 2, 8
COLOR 123
PRINT "[";
COLOR 26
PRINT "arrows/mouse";
COLOR 123
PRINT "]Ä";
COLOR 54
PRINT "move cursor"
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ELSEIF (tipnum% = 2) THEN
'  Ú Home ¿
'Del End PgDn
'  ÀğPAINTÙ
LOCATE 1, 11
COLOR 123
PRINT "  Ú ";
COLOR 26
PRINT "Home ";
COLOR 123
PRINT "¿";

LOCATE 2, 11
COLOR 26
PRINT "Del End PgDn"

LOCATE 3, 11
COLOR 123
PRINT "  Àğ";
COLOR 54
PRINT "PAINT";
COLOR 123
PRINT "Ù"
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ELSEIF (tipnum% = 3) THEN
'[p]Äspot paint
LOCATE 2, 11
COLOR 123
PRINT "[";
COLOR 26
PRINT "p";
COLOR 123
PRINT "]Ä";
COLOR 54
PRINT "spot paint"
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ELSEIF (tipnum% = 4) THEN
' wÄÄ¿
'asdÄÁmove through palette
LOCATE 1, 10
COLOR 26
PRINT " w";
COLOR 123
PRINT "ÄÄ¿";

LOCATE 2, 10
COLOR 26
PRINT "asd";
COLOR 123
PRINT "ÄÁ";
COLOR 54
PRINT "move through palette"
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ELSEIF (tipnum% = 5) THEN
'[f,F]Äfill, Flood-FloodFill
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
PRINT "]Ä";
COLOR 54
PRINT "FloodFill, Flood-FloodFill";
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ELSEIF (tipnum% = 6) THEN
'[F1,F2]Äsave, load
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
PRINT "]Ä";
COLOR 54
PRINT "save, load"
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ELSEIF (tipnum% = 7) THEN
'[spacebar]Äclear drawing area
LOCATE 2, 6
COLOR 123
PRINT "[";
COLOR 26
PRINT "spacebar";
COLOR 123
PRINT "]Ä";
COLOR 54
PRINT "clear drawing area"
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ELSEIF (tipnum% = 8) THEN
'[g]Äget color under cursor
LOCATE 2, 9
COLOR 123
PRINT "[";
COLOR 26
PRINT "g";
COLOR 123
PRINT "]Ä";
COLOR 54
PRINT "get color under cursor"
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ELSEIF (tipnum% = 9) THEN
'[tab]Äsound on/off
LOCATE 2, 11
COLOR 123
PRINT "[";
COLOR 26
PRINT "tab";
COLOR 123
PRINT "]Ä";
COLOR 54
PRINT "sound on/off"
END IF
'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

LOCATE 25, 1
COLOR 123
PRINT "[";
COLOR 26
PRINT "h";
COLOR 123
PRINT "]Ä";
COLOR 54
PRINT "change help tip";
END SUB

SUB LoadJAG
PUT (xPointer - 2, yPointer - 2), pPointer!, XOR

COLOR 34
LOCATE 1, 7
PRINT "Load file:         "
'LOCATE 2, 7
'SHELL ("dir *.ba1")
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
CHAIN (filenam$ + ".ba1")

noLoad:
help
PUT (xPointer - 2, yPointer - 2), pPointer!, XOR
END SUB

SUB makezero
	'lets program know that the program
	'isn't restarting after loading a file
	OPEN "bloading.dat" FOR OUTPUT AS #2
	     PRINT #2, "0"
	CLOSE #2
END SUB

'start mouse functions
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

SUB MousePut (xMouseRaw%, yMouseRaw%)
	ax% = 4
	cx% = xMouseRaw%
	dx% = yMouseRaw%
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
	PUT (xMouseRaw / 2, yMouseRaw), pPointer!, XOR
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
SUB MovePointer (xm%, ym%)
	'manually move mouse cursor
	xPointer = xPointer + xm%
	yPointer = yPointer + ym%
	MousePut xMouseRaw + xm% * 2, yMouseRaw + ym%
	DrawWindow
END SUB

SUB MakePointer
	'get mouse cursor
	LINE (0, 0)-(4, 4), 0
	LINE (2, 0)-STEP(0, 1), 15
	LINE STEP(0, 2)-STEP(0, 1), 15
	LINE STEP(-3, -2)-STEP(2, 0), 15
	LINE STEP(2, 0)-STEP(1, 0), 15
	GET (0, 0)-(4, 4), pPointer!(1)
	LINE (0,0)-(4,4),0
END SUB
'end mouse functions

SUB SaveJAG
PUT (xMouseRaw / 2, yMouseRaw), pPointer!, XOR
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
OPEN (filenam$ + ".ba1") FOR OUTPUT AS #1
     PRINT #1, "SCREEN 13"
     FOR yMouseRaw% = 1 TO 75
          FOR xMouseRaw% = 1 TO 145
               IF (xMouseRaw% = 1) THEN
                    PRINT #1, "DATA "; POINT(xMouseRaw% + 9, yMouseRaw% + 35);
               ELSE
                    PRINT #1, ","; POINT(xMouseRaw% + 9, yMouseRaw% + 35);
               END IF
          NEXT xMouseRaw%
          PRINT #1,
     NEXT yMouseRaw%
     PRINT #1, "CHDIR "; qt$; progdir$; qt$
     PRINT #1, "FOR y = 1 TO 75"
     PRINT #1, "    FOR x = 1 TO 145"
     PRINT #1, "         READ z"
     PRINT #1, "         PSET (x + 9, y + 35), z"
     PRINT #1, "    NEXT"
     PRINT #1, "NEXT"
     PRINT #1, "OPEN "; qt$; "bloading.dat"; qt$; " FOR OUTPUT AS #1"
     PRINT #1, "     PRINT #1, "; qt$; "1"; qt$
     PRINT #1, "CLOSE"
     PRINT #1, "CHAIN "; qt$; filenam$; ".ba2"; qt$
CLOSE #1
ELSEIF (xmap = 1) AND (ymap = 2) THEN
OPEN (filenam$ + ".ba2") FOR OUTPUT AS #1
     PRINT #1, "SCREEN 13"
     FOR yMouseRaw% = 1 TO 75
          FOR xMouseRaw% = 1 TO 145
               IF (xMouseRaw% = 1) THEN
                    PRINT #1, "DATA "; POINT(xMouseRaw% + 154, yMouseRaw% + 35);
               ELSE
                    PRINT #1, ","; POINT(xMouseRaw% + 154, yMouseRaw% + 35);
               END IF
          NEXT xMouseRaw%
          PRINT #1,
     NEXT yMouseRaw%
     PRINT #1, "CHDIR "; qt$; progdir$; qt$
     PRINT #1, "FOR y = 1 TO 75"
     PRINT #1, "    FOR x = 1 TO 145"
     PRINT #1, "         READ z"
     PRINT #1, "         PSET (x + 154, y + 35), z"
     PRINT #1, "    NEXT"
     PRINT #1, "NEXT"
     PRINT #1, "OPEN "; qt$; "bloading.dat"; qt$; " FOR OUTPUT AS #1"
     PRINT #1, "     PRINT #1, "; qt$; "1"; qt$
     PRINT #1, "CLOSE"
     PRINT #1, "CHAIN "; qt$; filenam$; ".ba3"; qt$
CLOSE #1
ELSEIF (xmap = 2) AND (ymap = 1) THEN
OPEN (filenam$ + ".ba3") FOR OUTPUT AS #1
     PRINT #1, "SCREEN 13"
     FOR yMouseRaw% = 1 TO 75
          FOR xMouseRaw% = 1 TO 145
               IF (xMouseRaw% = 1) THEN
                    PRINT #1, "DATA "; POINT(xMouseRaw% + 9, yMouseRaw% + 110);
               ELSE
                    PRINT #1, ","; POINT(xMouseRaw% + 9, yMouseRaw% + 110);
               END IF
          NEXT xMouseRaw%
          PRINT #1,
     NEXT yMouseRaw%
     PRINT #1, "CHDIR "; qt$; progdir$; qt$
     PRINT #1, "FOR y = 1 TO 75"
     PRINT #1, "    FOR x = 1 TO 145"
     PRINT #1, "         READ z"
     PRINT #1, "         PSET (x + 9, y + 110), z"
     PRINT #1, "    NEXT"
     PRINT #1, "NEXT"
     PRINT #1, "OPEN "; qt$; "bloading.dat"; qt$; " FOR OUTPUT AS #1"
     PRINT #1, "     PRINT #1, "; qt$; "1"; qt$
     PRINT #1, "CLOSE"
     PRINT #1, "CHAIN "; qt$; filenam$; ".ba4"; qt$
CLOSE #1
ELSEIF (xmap = 2) AND (ymap = 2) THEN
OPEN (filenam$ + ".ba4") FOR OUTPUT AS #1
     PRINT #1, "SCREEN 13"
     FOR yMouseRaw% = 1 TO 75
          FOR xMouseRaw% = 1 TO 145
               IF (xMouseRaw% = 1) THEN
                    PRINT #1, "DATA "; POINT(xMouseRaw% + 154, yMouseRaw% + 110);
               ELSE
                    PRINT #1, ","; POINT(xMouseRaw% + 154, yMouseRaw% + 110);
               END IF
          NEXT xMouseRaw%
          PRINT #1,
     NEXT yMouseRaw%
     PRINT #1, "CHDIR "; qt$; progdir$; qt$
     PRINT #1, "FOR y = 1 TO 75"
     PRINT #1, "    FOR x = 1 TO 145"
     PRINT #1, "         READ z"
     PRINT #1, "         PSET (x + 154, y +110), z"
     PRINT #1, "    NEXT"
     PRINT #1, "NEXT"
     PRINT #1, "OPEN "; qt$; "bloading.dat"; qt$; " FOR OUTPUT AS #1"
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
PUT (xMouseRaw / 2, yMouseRaw), pPointer!, XOR
END SUB

SUB seeSize
LINE (10, 0)-(30, 20), 0, BF
SELECT CASE iBrushRad
     CASE 1: PSET (20, 10), yColr * 16 + xColr
     CASE ELSE: CIRCLE (20, 10), iBrushRad - 1, yColr * 16 + xColr: PAINT (20, 10), yColr * 16 + xColr
END SELECT
COLOR 54
LOCATE 4, 1
PRINT "size ";
COLOR 123
PRINT "[";
COLOR 26
PRINT "q";
COLOR 123
PRINT ",";
COLOR 26
PRINT "e";
COLOR 123
PRINT "] "; iBrushRad - 1;
END SUB

SUB SwitchSound

OPEN "bsound.dat" FOR OUTPUT AS #1
     SELECT CASE sound$
          CASE "0": PRINT #1, "1": sound$ = "1"
          CASE "1": PRINT #1, "0": sound$ = "0"
     END SELECT
CLOSE #1

END SUB


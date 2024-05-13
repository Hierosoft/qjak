'menu for Qjak Entertainment Pak 2.2
DECLARE SUB help ()
DECLARE SUB getSpheroid ()
DECLARE SUB getJaksound ()
DECLARE SUB getJakDraw ()
DECLARE SUB drawJakDraw ()
DECLARE SUB Enter ()
DECLARE SUB drawSpheroid ()
DECLARE SUB Rings ()
DECLARE SUB drawJaksound ()
DECLARE SUB refmenu ()
DECLARE SUB changeSel (x!)
DIM SHARED selGame
DIM SHARED pJakDraw(1 TO 1716)
DIM SHARED pJakSound(1 TO 1716)
DIM SHARED pSpheroid(1 TO 1716)
DIM SHARED sph$(1 TO 8)
DIM exitr$(0 TO 22)
OPEN "qjak.ini" FOR INPUT AS #1
          LINE INPUT #1, progdir$
CLOSE
FOR charnow = 1 TO LEN(progdir$)
        IF MID$(progdir$, charnow, 1) = "=" THEN GOTO SPLITHERE
NEXT charnow
SPLITHERE:
progdir$ = RIGHT$(progdir$, LEN(progdir$) - (charnow))  'this is correct since STARTS at right
CLS
SCREEN 13
LOCATE 1, 1
PRINT progdir$
CHDIR (progdir$)
selGame = 1

'check sound setting
OPEN "bsound.dat" FOR INPUT AS #1
          LINE INPUT #1, sound$
CLOSE

CLS
getJakDraw
CLS
getJaksound
CLS
getSpheroid
CLS
start:
drawSpheroid
drawJaksound
drawJakDraw


Rings
LOCATE 2, 7
COLOR 32
PRINT "QJak  Entertainment Pack 2.2"
refmenu
drawJaksound
drawSpheroid
drawJakDraw
changeSel (0)
selection:
DO
     SELECT CASE INKEY$
          CASE CHR$(0) + "K": changeSel (-1)
          CASE CHR$(0) + "M": changeSel (1)
          CASE "h": help: GOTO start
          CASE "H": help: GOTO start
          CASE CHR$(27): EXIT DO
          CASE CHR$(13): Enter
          CASE "": SLEEP 0
          CASE ELSE: GOTO selection
     END SELECT
LOOP

exitscreen:
CLS
COLOR 54
LOCATE 4, 9
PRINT "Thank you for using Qjak"
exitr$(0) = "S"
exitr$(1) = "e"
exitr$(2) = "e"
exitr$(3) = " "
exitr$(4) = "Y"
exitr$(5) = "o"
exitr$(6) = "u"
exitr$(7) = " "
exitr$(8) = "l"
exitr$(9) = "a"
exitr$(10) = "t"
exitr$(11) = "e"
exitr$(12) = "r"
LOCATE 12, 14

FOR i = 0 TO 12
     SELECT CASE sound$
          CASE "0": SOUND 20000, .5
          CASE "1": SOUND 100 + 7 * i, .5
     END SELECT
     COLOR i + 32
     PRINT exitr$(i);
NEXT i
SLEEP 2
SYSTEM

SUB changeSel (x)

LINE (50 + (selGame * 74), 50)-(121 + (selGame * 74), 149), 0, B

selGame = selGame + x
IF (selGame < 0) THEN
     selGame = 0
ELSEIF (selGame > 2) THEN
     selGame = 2
END IF
colo = ((RND * 247) + 1)
LINE (50 + (selGame * 74), 50)-(121 + (selGame * 74), 149), 40, B

END SUB

SUB drawJakDraw
PUT (51, 51), pJakDraw, PSET
END SUB

SUB drawJaksound

PUT (125, 51), pJakSound, PSET

END SUB

SUB drawSpheroid
PUT (201, 51), pSpheroid, PSET
END SUB

SUB Enter
IF (selGame = 0) THEN
     CHAIN ("jakdraw.bas")
ELSEIF (selGame = 1) THEN
     CHAIN ("jaksound.bas")
ELSEIF (selGame = 2) THEN
     CHAIN ("sphmenu.bas")
END IF
END SUB

SUB getJakDraw
COLOR 52
jdX = 0
jdY = 96

FOR i = 70 TO 139
LINE (0, 0)-(i - 70, 87), 16 + i
NEXT i

FOR i = 0 TO 69
LINE (i, 0)-(70, 97), 16 + i
NEXT i

'J
     LINE (jdX, jdY)-STEP(1, 1), 53
     LINE STEP(0, 0)-STEP(10, -2), 53
     LINE STEP(0, 0)-STEP(0, -15), 53
     LINE STEP(10, 0)-STEP(-20, 0), 53
LOCATE 12, 3
PRINT "ak"
'D
LOCATE 12, 6
PRINT "raw"
     LINE (jdX + 32, jdY - 2)-STEP(0, -17), 53
     CIRCLE STEP(-5, 10), 12, 53, 4.7, 1.5
GET (0, 0)-(69, 97), pJakDraw
END SUB

SUB getJaksound

COLOR 13
FOR i = 1 TO 7
     LINE (i * 4 - 4, 60 - i * 2)-(i * 4 - 2, 74), 5, B
     LINE (i * 4 - 3, 61 - i * 2)-(i * 4 - 3, 73), 13
NEXT i

FOR i = 8 TO 16
     LINE (i * 4 - 4, 10 + i * 3)-(i * 4 - 2, 74), 5, B
     LINE (i * 4 - 3, 11 + i * 3)-(i * 4 - 3, 73), 13
NEXT i

jdX = 0
jdY = 92
'J
     LINE (jdX, jdY)-STEP(5, 5), 5
     LINE STEP(0, 0)-STEP(10, -2), 5
     LINE STEP(0, 0)-STEP(0, -15), 5
     LINE STEP(10, 0)-STEP(-20, 0), 5
LOCATE 12, 3
PRINT "ak"
'S
     CIRCLE (jdX + 30, jdY - 1), 7, 5, 4.3, 1.5
     CIRCLE (jdX + 32, jdY - 11), 5, 5, .4, 4.7
LOCATE 12, 6
PRINT "ound"

COLOR 5
LOCATE 2, 3
PRINT "S"; "    ð";
LOCATE 3, 4
PRINT "t"; "   ";
LOCATE 4, 5
PRINT "u"; "  Ÿ";
LOCATE 5, 6
PRINT "d"; " ð";
LOCATE 6, 7
PRINT "i";
LOCATE 7, 8
PRINT "o";
'ðŸð
GET (0, 0)-(69, 97), pJakSound

END SUB

SUB getSpheroid
DIM xbomb(1 TO 10)
DIM ybomb(1 TO 10)
'Bombs
   RANDOMIZE TIMER
   FOR bomnum = 1 TO 10
       xbomb(bomnum) = INT((RND * 60) + 5)
       ybomb(bomnum) = INT((RND * 90) + 5)
   NEXT bomnum
FOR bomnum = 1 TO 10
    CIRCLE (xbomb(bomnum), ybomb(bomnum)), 2, 113
    CIRCLE (xbomb(bomnum), ybomb(bomnum)), 4, 113
    CIRCLE (xbomb(bomnum), ybomb(bomnum)), 3, 4
NEXT bomnum



'graphic
outness = 15
outadd = .9
centerx = 40
centery = 38
centeradd = 1
FOR colour = 21 TO 31 STEP 2
    CIRCLE (centerx, centery), outness, colour
    PAINT (centerx, centery), colour
    centerx = centerx - centeradd
    centery = centery - centeradd
    centeradd = centeradd - .3
    outness = outness - outadd
    outadd = outadd + .2
NEXT colour


'Text
sph$(1) = "S"
sph$(2) = "p"
sph$(3) = "h"
sph$(4) = "e"
sph$(5) = "r"
sph$(6) = "o"
sph$(7) = "i"
sph$(8) = "d"
LOCATE 12, 1
FOR i = 1 TO 8
     COLOR 23 + i
     PRINT sph$(i);
NEXT i

GET (0, 0)-(69, 97), pSpheroid
END SUB

SUB help
CLS
COLOR 15
PRINT "Qjak Entertainment Pack"
COLOR 32
PRINT "ORIGINAL idea by Jake Gustafson"
PRINT
COLOR 50
PRINT "   1. Use arrow keys to change"
PRINT "      selection.  Press [Enter]"
PRINT "      to enter program."
PRINT
PRINT "   2. [s] key toggles sound"
PRINT "     (from menu or from inside"
PRINT "      Spheroid or JakSound)."
PRINT "      In JakDraw, [tab] toggles"
PRINT "      sound."
PRINT
PRINT "   3. To insure correct program"
PRINT "      operation, maKE SURE THAT"
PRINT "     [CAPS LOCK] -OOPs- is off."
PRINT
PRINT "   4. To exit from this menu or"
PRINT "      any of the programs in"
PRINT "      Qjak Entertainment pack,"
PRINT "      press [Escape]."
COLOR 15
PRINT
PRINT "Press a key to continue..."
SLEEP 0
CLS
END SUB

SUB refmenu
FOR i = 0 TO 3
LINE (40 + i, 40 + i)-(279 - i, 159 - i), 18 + i, BF
NEXT i
FOR i = 4 TO 7
LINE (40 + i, 40 + i)-(279 - i, 159 - i), 26 - i, B
NEXT i
i = 8
LINE (40 + i, 40 + i)-(279 - i, 159 - i), 16, BF
LOCATE 21, 17
PRINT "Help [h]"
END SUB

SUB Rings
FOR i = 1 TO 200
     RANDOMIZE 9
     rad = INT(RND * 6) + 2
     col = INT(RND * 13) + 18
     xloc = INT((RND * 319) + 0)
     yloc = INT((RND * 199) + 0)
     CIRCLE (xloc, yloc), rad, col
'PRINT "xloc="; xloc; "   yloc="; yloc; "   radius="; rad; "   color="; col
NEXT i
END SUB


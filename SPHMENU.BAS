'revision 2.1
DECLARE SUB switchsound ()
DECLARE SUB laybombs ()
DECLARE SUB ChoseSoGo ()
DECLARE SUB usemenu ()
DECLARE SUB refreshmenubox ()
DECLARE SUB refreshmenu ()
DECLARE SUB intro ()
DECLARE SUB delaye ()
DIM SHARED tone
DIM SHARED menuitem$(1 TO 3)
DIM SHARED seltext AS INTEGER
DIM SHARED sound$
COMMON SHARED progdir$
CHDIR (progdir$)

OPEN "quiet.txt" FOR INPUT AS #1
          LINE INPUT #1, sound$
CLOSE

CLS

'colors #16-31 is grayscale black to white in 256 colors (screen 13 mode)

SCREEN 13

laybombs
intro
SLEEP 1
delaye

menuitem$(1) = "Play"
menuitem$(2) = "Help"
menuitem$(3) = "Quit"
usemenu

CHAIN ("qjakmenu.bas")
END

SUB ChoseSoGo
    SELECT CASE seltext
        CASE 1: CHAIN "spheroid.bas"
        CASE 2: CLS : PRINT "Made by Jake Gustafson": COLOR 3: PRINT : PRINT "1.  Use arrow keys to move sphere": PRINT "2.  Enter shoots when near land mine": PRINT "3.  Escape quits": PRINT : COLOR 15: PRINT "Press any other key to continue...":  _
SLEEP 0: CLS : laybombs: usemenu
        CASE 3: EXIT SUB
        CASE ELSE: RETURN
    END SELECT
END SUB

SUB delaye
SELECT CASE sound$
     CASE "2": SOUND tone, .4
     CASE "1": SOUND 20000, .4
END SELECT
tone = tone + colour

END SUB

SUB intro

tone = 40
outness = 30
outadd = .5
center = 150
centeradd = 3.4
SLEEP 1
SCREEN 13
FOR colour = 16 TO 31
    CIRCLE (center, center), outness, colour
    PAINT (center, center), colour
    center = center - centeradd
    centeradd = centeradd - .3
    outness = outness - outadd
    outadd = outadd + .2
    delaye
NEXT colour

END SUB

SUB laybombs

FOR i = 1 TO 30
     currentbombx = INT((RND * 319) + 1)
     currentbomby = INT((RND * 199) + 1)
     FOR radius = 1 TO 3
          SELECT CASE sound$
               CASE "2": SOUND 60 + (radius * 3), .3
               CASE ELSE: SOUND 20000, .3
          END SELECT
          CIRCLE (currentbombx, currentbomby), radius, 4
          CIRCLE (currentbombx, currentbomby), radius - 1, 16
     NEXT radius
          CIRCLE (currentbombx, currentbomby), 2, 113
          CIRCLE (currentbombx, currentbomby), 4, 113
          CIRCLE (currentbombx, currentbomby), 3, 4
NEXT i

END SUB

SUB refreshmenu

FOR drawchoices = 1 TO 3
    IF (seltext = drawchoices) THEN
      LOCATE 8 + drawchoices + drawchoices, 18
      COLOR 34
      PRINT menuitem$(drawchoices); "!"
    ELSE
      LOCATE 8 + drawchoices + drawchoices, 18
      COLOR 15
      PRINT menuitem$(drawchoices); " "
    END IF

NEXT drawchoices

END SUB

SUB refreshmenubox

bordlx = 99
bordly = 50
bordrx = 219
bordry = 150

FOR bordre = 17 TO 21
   LINE (bordlx, bordly)-(bordrx, bordry), bordre, BF
   bordlx = bordlx + 1
   bordly = bordly + 1
   bordrx = bordrx - 1
   bordry = bordry - 1
NEXT bordre
   bordlx = bordlx + 1
   bordly = bordly + 1
   bordrx = bordrx - 1
   bordry = bordry - 1
   LINE (bordlx, bordly)-(bordrx, bordry), 0, BF

END SUB

SUB switchsound

OPEN "quiet.txt" FOR OUTPUT AS #1
     SELECT CASE sound$
          CASE "1": PRINT #1, "2": sound$ = "2"
          CASE "2": PRINT #1, "1": sound$ = "1"
     END SELECT
CLOSE
END SUB

SUB usemenu

menuitem$(1) = "Play"
menuitem$(2) = "Help"
menuitem$(3) = "Quit"
seltext = 1

refreshmenubox
LOCATE 2, 11
PRINT "S P H E R O I D";
COLOR 43
PRINT "  2.1"
rechoose:
refreshmenu
SELECT CASE INKEY$
  CASE CHR$(0) + "H": seltext = seltext - 1: IF seltext < 1 THEN seltext = 3: refreshmenu
  CASE CHR$(0) + "P": seltext = seltext + 1: IF seltext > 3 THEN seltext = 1: refreshmenu
  CASE "s": switchsound:
  CASE CHR$(13): ChoseSoGo: EXIT SUB
  CASE "": SLEEP 0
  CASE ELSE: GOTO rechoose
END SELECT
GOTO rechoose
END SUB


'revision 2.0b
DECLARE SUB delay ()
DECLARE SUB switchsound ()
DECLARE SUB slide ()
DECLARE SUB laybombs ()
DECLARE SUB win ()
DECLARE SUB shoot ()
DECLARE SUB explode ()
DECLARE SUB checkbomb ()
DECLARE SUB moveup ()
DECLARE SUB movedown ()
DECLARE SUB moveright ()
DECLARE SUB moveleft ()
DECLARE SUB drawguy ()
DECLARE SUB drawbombs ()
DECLARE SUB setbombs ()
DIM SHARED xguy AS INTEGER
DIM SHARED yguy AS INTEGER
DIM SHARED bomount AS INTEGER
DIM SHARED xbomb(1 TO 20) AS INTEGER
DIM SHARED ybomb(1 TO 20) AS INTEGER
DIM SHARED bombsleft AS INTEGER
DIM SHARED lives AS INTEGER
DIM SHARED dirc$
DIM SHARED sound$
DIM SHARED exable%
DIM SHARED watime AS LONG
COMMON SHARED progdir$
CHDIR (progdir$)

OPEN "quiet.jak" FOR INPUT AS #1
          LINE INPUT #1, sound$
CLOSE

SCREEN 13
CLS

xguy = 10
yguy = 10
bombsleft = 20
lives = 5
watime = 0

setbombs
laybombs
drawguy
dirc$ = "right"
redo:
DO
  slide
  SELECT CASE INKEY$
     CASE CHR$(0) + "K": moveleft: checkbomb: dirc$ = "left"
     CASE CHR$(0) + "M": moveright: checkbomb: dirc$ = "right"
     CASE CHR$(0) + "H": moveup: checkbomb: dirc$ = "up"
     CASE CHR$(0) + "P": movedown: checkbomb: dirc$ = "down"
     CASE "s": switchsound
     CASE CHR$(13): shoot
     CASE CHR$(27): EXIT DO
     CASE ELSE: GOTO redo
  END SELECT
LOOP

CHAIN "sphmenu.bas"
END
exub:
exable% = 1
RETURN

SUB checkbomb

FOR bomnum = 1 TO 20
    IF (ABS(xguy - xbomb(bomnum)) < 15) AND (ABS(yguy - ybomb(bomnum)) < 13) THEN
       explode
    ELSE
    END IF
NEXT bomnum

IF (bombsleft < 1) THEN
   win
ELSE
END IF

END SUB

SUB delay
ON TIMER(3) GOSUB exub
TIMER ON
exable% = 0
DO
LOOP UNTIL exable% = 1
END SUB

SUB drawbombs
FOR bomnum = 1 TO 20
    CIRCLE (xbomb(bomnum), ybomb(bomnum)), 2, 113
    CIRCLE (xbomb(bomnum), ybomb(bomnum)), 4, 113
    CIRCLE (xbomb(bomnum), ybomb(bomnum)), 3, 4
NEXT bomnum
END SUB

SUB drawguy

outness = 10
outadd = .1
'LINE (xguy - 11, yguy - 11)-(xguy + 11, yguy + 11), 16, BF
CIRCLE (xguy, yguy), 11, 16
drawbombs
FOR i = 16 TO 31 STEP 3
    CIRCLE (xguy, yguy), INT(outness), i
    PAINT (xguy, yguy), i
    outness = outness - outadd
    outadd = outadd + .3
NEXT i

LOCATE 1, 20
PRINT lives; " lives left"

END SUB

SUB explode

'explode guy
colour = 40
FOR i = 1 TO 20
     SELECT CASE sound$
          CASE "2": SOUND 100 - i, .3
          CASE "1": SOUND 24000, .3
     END SELECT
    CIRCLE (xguy, yguy), i, INT(colour)
    colour = colour + .2
NEXT i
'erase explosion
FOR i = 20 TO 1 STEP -1
     SELECT CASE sound$
          CASE "2": SOUND 80 - i, .3
          CASE "1": SOUND 24000, .3
     END SELECT
    CIRCLE (xguy, yguy), i, 16   'color 16 is black
NEXT i


'lose life and if out of lives you lose
lives = lives - 1
IF (lives < 1) THEN
   SCREEN 0
   COLOR 20
   LOCATE 10, 15
   PRINT "YOU LOSE"
     SELECT CASE sound$
          CASE "2": SOUND 80, 10:  SOUND 60, 15
          CASE "1": SOUND 24000, 10:  SOUND 20000, 15
     END SELECT
     COLOR 15
     i = 0
     LOCATE 2, 1
     PRINT watime
     delay
   CHAIN "sphmenu.bas"
ELSE
END IF

'move guy to starting place
xguy = 10
yguy = 10
drawguy

END SUB

SUB laybombs
FOR bomnum = 1 TO 20
    xbomb(bomnum) = INT((RND * 224) + 25)
    ybomb(bomnum) = INT((RND * 174) + 25)
NEXT bomnum

FOR i = 1 TO 20
    FOR radius = 1 TO 3
     SELECT CASE sound$
          CASE "2": SOUND 60 + (radius * 3), .3
          CASE "1": SOUND 20000, .3
     END SELECT
       
       CIRCLE (xbomb(i), ybomb(i)), radius, 4
       CIRCLE (xbomb(i), ybomb(i)), radius - 1, 16
    NEXT radius
       CIRCLE (xbomb(i), ybomb(i)), 2, 113
       CIRCLE (xbomb(i), ybomb(i)), 4, 113
       CIRCLE (xbomb(i), ybomb(i)), 3, 4
NEXT i

END SUB

SUB movedown
yguy = yguy + 1: IF yguy > 189 THEN yguy = 189
drawguy
END SUB

SUB moveleft
xguy = xguy - 1: IF xguy < 10 THEN xguy = 10
drawguy
END SUB

SUB moveright
xguy = xguy + 1: IF xguy > 309 THEN xguy = 309
drawguy
END SUB

SUB moveup
yguy = yguy - 1: IF yguy < 10 THEN yguy = 10
drawguy
END SUB

SUB setbombs
   RANDOMIZE TIMER
   FOR bomnum = 1 TO 20
       xbomb(bomnum) = INT((RND * 224) + 25)
       ybomb(bomnum) = INT((RND * 174) + 25)
   NEXT bomnum
END SUB

SUB shoot

FOR locbomb = 1 TO 20
    IF (ABS(xguy - xbomb(locbomb)) < 20) AND (ABS(yguy - ybomb(locbomb)) < 20) THEN
       LINE (xguy, yguy)-(xbomb(locbomb), ybomb(locbomb)), 4
       FOR i = 1 TO 20
          SELECT CASE sound$
               CASE "2": SOUND 100 + i, .3
               CASE "1": SOUND 24000, .3
          END SELECT
       NEXT i
       LINE (xguy, yguy)-(xbomb(locbomb), ybomb(locbomb)), 16
       FOR i = 1 TO 20
           CIRCLE (xbomb(locbomb), ybomb(locbomb)), i, 4
           SELECT CASE sound$
               CASE "2": SOUND 100 + i, .3
               CASE "1": SOUND 24000, .3
           END SELECT
           
       NEXT i
   
       FOR i = 20 TO 1 STEP -1
           CIRCLE (xbomb(locbomb), ybomb(locbomb)), i, 16
           SELECT CASE sound$
               CASE "2": SOUND 110 - i, .3
               CASE "1": SOUND 24000, .3
           END SELECT
       NEXT i
       xbomb(locbomb) = -10
       ybomb(locbomb) = -10
       bombsleft = bombsleft - 1
       drawguy
    ELSE
    END IF
NEXT locbomb

END SUB

SUB slide
SELECT CASE sound$
     CASE "2": SOUND 40, .3
     CASE "1": SOUND 20000, .3
END SELECT

checkbomb
IF dirc$ = "left" THEN
     moveleft
ELSEIF dirc$ = "right" THEN
     moveright
ELSEIF dirc$ = "up" THEN
     moveup
ELSEIF dirc$ = "down" THEN
     movedown
ELSE EXIT SUB
END IF
END SUB

SUB switchsound

OPEN "quiet.jak" FOR OUTPUT AS #1
     SELECT CASE sound$
          CASE "1": PRINT #1, "2": sound$ = "2"
          CASE "2": PRINT #1, "1": sound$ = "1"
     END SELECT
CLOSE

END SUB

SUB win

SCREEN 0
COLOR 30
LOCATE 10, 15
PRINT "YOU  WIN"

FOR i = 1 TO 10
    FOR j = 700 TO 750
        SOUND j + (i * 8), .05
    NEXT j
NEXT i

soundpitch = 830

FOR k = 0 TO 20
     SELECT CASE sound$
          CASE "2": SOUND soundpitch, .2
          CASE "1": SOUND 24000, .2
     END SELECT
    soundpitch = soundpitch + k
NEXT k

SLEEP 3
CHAIN "sphmenu.bas"
END SUB


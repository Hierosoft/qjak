DECLARE SUB autofire ()
'current version: 1.1 (fixed sound off for end level sounds, modified cheat message to clarify, changed cheater game end screen, added autofire for autoplay)
DECLARE SUB winitmessage ()
DECLARE SUB automove ()
DECLARE SUB littlewinsound ()
DECLARE SUB winshow ()
DECLARE SUB firemissile ()
DECLARE SUB CheckIfHitBlockSide (sec%)
DECLARE SUB CheckIfHitBlock ()
DECLARE SUB loselife ()
DECLARE SUB CheckIfHit ()
DECLARE SUB bounce (wal%)
DECLARE SUB resetball ()
DECLARE SUB checkbal ()
DECLARE SUB winL1 ()
DECLARE SUB winL2 ()
DECLARE SUB winL3 ()
DECLARE SUB winL4 ()
DECLARE SUB setL1 ()
DECLARE SUB setL2 ()
DECLARE SUB setL3 ()
DECLARE SUB winit ()
DECLARE SUB firelaser ()
DECLARE SUB help ()
DECLARE SUB movePad (x%)
DECLARE SUB drawblocksfast ()
DECLARE SUB drawback ()
DECLARE SUB setL4 ()
DECLARE SUB drawpanel ()
DECLARE SUB drawblocks ()
DECLARE SUB printitle ()
SCREEN 13
DIM SHARED block(-5 TO 24) AS INTEGER
DIM SHARED block1x AS INTEGER
DIM SHARED block1y AS INTEGER
DIM SHARED padLoc AS INTEGER
DIM SHARED paddle
DIM SHARED missiles AS INTEGER
DIM SHARED lasers AS INTEGER
DIM SHARED levelnow AS INTEGER
DIM SHARED sector AS INTEGER
DIM SHARED balX
DIM SHARED balY
DIM SHARED balSpeed
DIM SHARED balDIR
DIM SHARED lives
DIM SHARED balPerspective
DIM SHARED item1icon(68)
DIM SHARED item2icon(68)
DIM SHARED item3icon(68)
DIM SHARED soundON
DIM SHARED sinklevel
DIM SHARED normalspeed
DIM SHARED won
DIM SHARED autoplay
block1x = 24
block1y = 30
soundON = 1
autoplay = 0
printitle
normalspeed = 1 'increases after beating level 4

Resetgame:
CLS
COLOR 53: LOCATE 12, 4: PRINT "             STAGE"; normalspeed
SLEEP 1
won = 0
LINE (24, 6)-(25, 17), 0, B 'erase edge of laser window
LOCATE 3, 24: COLOR 12: PRINT "                "   'erase item name
lives = 2
resetball
padLoc = 120
missiles = 0
lasers = 0
levelnow = 1
drawback
COLOR 15
setL1
RedrawAll:
IF helped = 1 THEN : helped = 0 : drawback
drawpanel
drawblocksfast
CALL movePad(0)

DO
  IF won = 1 GOTO Resetgame
  IF lives < 0 THEN GOTO deadend
  checkbal
  SELECT CASE INKEY$
     CASE CHR$(0) + "P": IF (balDIR < -180) OR (balDIR > 180) THEN resetball
     CASE CHR$(0) + "K": IF padLoc > 0 + (speedUP * 6) THEN movePad (-6 * (speedUP + 1))'move left
     CASE CHR$(0) + "M": IF padLoc < 240 - (speedUP * 6) THEN movePad (6 * (speedUP + 1))  'move right
     CASE CHR$(0) + "H": IF lasers > 0 THEN firelaser: drawblocksfast: movePad (0)
     CASE CHR$(177): autoplay = ABS(autoplay - 1): IF autoplay = 0 THEN padLoc = FIX(padLoc / 48) * 48
     CASE CHR$(178): speedUP = ABS(speedUP - 1): IF speedUP = 1 THEN LINE (block1x + padLoc, 180)-((block1x + 47) + padLoc, 191), 0, BF: padLoc = FIX(padLoc / 24) * 24: movePad (0)
     CASE "s": soundON = ABS(soundON - 1)
     CASE CHR$(13): IF missiles > 0 THEN firemissile: drawblocksfast
     CASE "h": GOSUB help
     CASE CHR$(8): GOTO Resetgame
     CASE CHR$(27): GOTO Ending
  END SELECT
LOOP

deadend:
LOCATE 20, 4: COLOR 4: PRINT "You died."
IF (soundON = 1) THEN
   SOUND 800, 3
   SOUND 700, 3
   SOUND 600, 3
   SOUND 700, 3
   SOUND 600, 3
   SOUND 500, 3
   SOUND 600, 3
   SOUND 500, 3
   SOUND 400, 6
ELSE
   SOUND 30000, 21
END IF
GOTO Resetgame

Ending:
LOCATE 23, 2
COLOR 15
PRINT "Press a key to exit"; : COLOR 9: PRINT " S."; : COLOR 12: PRINT "M."; : COLOR 10: PRINT "B."

LINE (7, 175)-(215, 184), 122, B
LINE (6, 174)-(216, 185), 74, B
LINE (5, 173)-(217, 186), 122, B
SLEEP 0
'game end from quitting
SYSTEM


COLOR 0
END
'secret code: hold down [ALT] and type "177" then let go
help:
COLOR 49: LOCATE 9, 4: PRINT "Right and left move Paddle."
COLOR 50: LOCATE 10, 4: PRINT "Up shoots laser, amount is shown on "
COLOR 50: LOCATE 11, 4: PRINT " panel in red when you get lasers.  "
COLOR 51: LOCATE 12, 4: PRINT "Enter shoots missile. # of missiles "
COLOR 51: LOCATE 13, 4: PRINT " appears on the panel in orange.    "
COLOR 52: LOCATE 14, 4: PRINT "Once you break a hole through the   "
COLOR 52: LOCATE 15, 4: PRINT " barrier, then send the ball through"
COLOR 52: LOCATE 16, 4: PRINT " to win the level and get the item. "
COLOR 53: LOCATE 17, 4: PRINT "In case of emergency, push [Down]   "
COLOR 54: LOCATE 18, 4: PRINT " (resets ball if ball gets stuck.)  "
COLOR 55: LOCATE 19, 4: PRINT "[s] turns sound off and on.         "
COLOR 56: LOCATE 20, 4: PRINT "If you beat the game 3 times you are"
COLOR 56: LOCATE 21, 4: PRINT "   the champion.                    "
COLOR 21: LOCATE 22, 4: PRINT "Press a key to return to game...";
SLEEP 0
helped = 1
GOTO RedrawAll
RETURN

SUB autofire
IF lasers > 0 THEN firelaser: GOTO skipmissile
IF missiles > 0 THEN firemissile
skipmissile:
END SUB

SUB automove
moveamount = (CINT(balX) - (padLoc + 48))
IF padLoc + moveamount < 0 THEN moveamount = 0
IF padLoc + moveamount > 240 THEN moveamount = 0
movePad (moveamount)
IF balDIR > 180 OR balDIR < -180 THEN resetball
IF balY <= 76 THEN autofire
END SUB

SUB bounce (wal%)

IF soundON = 1 THEN
  FOR pitch = 200 TO 300 STEP 10
    SOUND pitch * 10, .1
  NEXT pitch
ELSE
  SOUND 30000, 1
END IF

SELECT CASE balDIR
 CASE 0 TO 90: balDIR = 180 - balDIR - (wal% * 180)
 CASE -90 TO -1: balDIR = -180 - balDIR - (wal% * 180)
 CASE -180 TO -91: balDIR = ABS(balDIR) - (ABS(wal%) * 180) + 180
 CASE 91 TO 180: balDIR = -ABS(balDIR) + (wal% * 180) - 180
END SELECT
END SUB

SUB checkbal

IF autoplay = 1 THEN automove
IF INKEY$ = CHR$(0) + "P" THEN : IF (balDIR < -180) OR (balDIR > 180) THEN resetball
IF balX < 28 THEN bounce (-1) 'off left wall
IF balX > 308 THEN bounce (1) 'off right wall
IF balY <= 34 + (levelnow * 9) THEN CheckIfHitBlock
IF balY >= 176 - balSpeed THEN CheckIfHit

IF balY > 187 THEN loselife
 SOUND 30000, .2
CIRCLE (balX, balY), 3, 0, , , balPerspective 'erases old ball

IF balPerspective > 5 THEN balPerspective = 0
balPerspective = balPerspective + .5

IF balSpeed < normalspeed THEN balSpeed = balSpeed + .01

SELECT CASE balDIR
 CASE 180: balY = balY + balSpeed
 CASE -180: balY = balY + balSpeed
 CASE 0: balY = balY - balSpeed
 CASE -90: balX = balX - balSpeed
 CASE 90: balX = balX + balSpeed
 CASE -179 TO -91: balX = balX - (balSpeed * ((180 + balDIR) / 90)): balY = balY + (balSpeed * ((90 - (180 + balDIR)) / 90))
 CASE 91 TO 179:   balX = balX + (balSpeed * ((180 - balDIR) / 90)): balY = balY + (balSpeed * ((90 - (180 - balDIR)) / 90))
 CASE -89 TO -1:   balX = balX + (balSpeed * (balDIR / 90)):         balY = balY - (balSpeed * ((90 + balDIR) / 90))
 CASE 1 TO 89:     balX = balX + (balSpeed * (balDIR / 90)):         balY = balY - (balSpeed * ((90 - balDIR) / 90))
END SELECT
CIRCLE (balX, balY), 3, 53, , , balPerspective
END SUB

SUB CheckIfHit
SELECT CASE balX
CASE padLoc + 24 TO padLoc + 72: bounce (2) 'check if hit between ends of pad
CASE ELSE: loselife
END SELECT
END SUB

SUB CheckIfHitBlock
sector = FIX((balX - 24) / 48) + 1
'check for what block to smash:
IF sector < 1 THEN sector = 1
IF sector > 6 THEN sector = 6
IF (block(sector + 18) = 1) THEN
   sinklevel = 66
   shot = sector + 18
ELSEIF (block(sector + 12) = 1) THEN
   sinklevel = 57
   shot = sector + 12
ELSEIF (block(sector + 6) = 1) THEN
   sinklevel = 48
   shot = sector + 6
ELSEIF (block(sector) = 1) THEN
   sinklevel = 39
   shot = sector
ELSE
   sinklevel = 30
   IF balY <= 30 + balSpeed THEN winit
   shot = 0
   IF won = 1 THEN : resetball: GOTO skipbreak
END IF

IF balY >= sinklevel + 4 + balSpeed THEN GOTO skipbreak
CALL CheckIfHitBlockSide(sector)
IF shot = 0 GOTO skipbreak
IF balY < sinklevel + 4 + balSpeed THEN bounce (0) 'sees if ball hit a block (some errors)
IF soundON = 0 THEN cancelsound = 20000

FOR exblock = 24 TO 1 STEP -1
    LINE (25 - exblock + sector * 48, sinklevel - 9)-(25 - exblock + sector * 48, sinklevel - 1), 0
    SOUND 10000 - exblock + cancelsound, .1
    LINE (exblock - 24 + sector * 48, sinklevel - 9)-(exblock - 24 + sector * 48, sinklevel - 1), 0
    SOUND 22337, .05
NEXT exblock

IF shot <> 0 THEN block(shot) = 0
drawpanel
balSpeed = balSpeed + .4
drawblocksfast
skipbreak:
END SUB

SUB CheckIfHitBlockSide (sec%)
IF balY < sinklevel + 4 + balSpeed THEN GOTO skipsidebounce
IF balX <= ((sec% - 1) * 48) + 24 + balSpeed THEN bounce (-1) 'if hit right side of block, bounce off it
IF balX >= ((sec% - 1) * 48) + 72 - balSpeed THEN bounce (1)  'if hit right side of block, bounce off it
skipsidebounce:
END SUB

SUB drawback
LINE (24, 24)-(311, 191), 0, BF
END SUB

SUB drawblocks
IF soundON = 0 THEN cancelsound = 29040
blockcol = 31
blocknum = 0
 FOR blocky = 1 TO 4
     FOR blockx = 1 TO 6
         blockcol = blockcol + 1
         blocknum = blocknum + 1
         IF (block(blocknum) = 1) THEN
            SOUND 40 * blockx * blocky + cancelsound, 1
            LINE (((blockx - 1) * 48) + block1x, ((blocky - 1) * 9) + block1y)-((blockx * 48 - 1) + block1x, (blocky * 9) + block1y - 1), blockcol, BF     'medium colored box
            LINE (((blockx - 1) * 48) + block1x, ((blocky - 1) * 9) + block1y)-((blockx * 48 - 1) + block1x, (blocky * 9) + block1y - 1), blockcol + 96, B 'underlay of light outline
            LINE (((blockx - 1) * 48) + block1x, ((blocky - 1) * 9) + block1y)-(((blockx - 1) * 48) + block1x, (blocky * 9) + block1y - 2), blockcol + 48   'verticle dark line
            LINE (((blockx - 1) * 48) + block1x, ((blocky - 1) * 9) + block1y)-((blockx * 48) + block1x - 2, ((blocky - 1) * 9) + block1y), blockcol + 48 'horizontal dark line
         ELSE
            LINE (((blockx - 1) * 48) + block1x, ((blocky - 1) * 9) + block1y)-((blockx * 48 - 1) + block1x, (blocky * 9) + block1y - 1), 0, BF
         END IF
     NEXT blockx
 NEXT blocky
END SUB

SUB drawblocksfast
blockcol = 31
blocknum = 0
 FOR blocky = 1 TO 4
     FOR blockx = 1 TO 6
         blockcol = blockcol + 1
         blocknum = blocknum + 1
         IF (block(blocknum) = 1) THEN
            LINE (((blockx - 1) * 48) + block1x, ((blocky - 1) * 9) + block1y)-((blockx * 48 - 1) + block1x, (blocky * 9) + block1y - 1), blockcol, BF     'medium colored box
            LINE (((blockx - 1) * 48) + block1x, ((blocky - 1) * 9) + block1y)-((blockx * 48 - 1) + block1x, (blocky * 9) + block1y - 1), blockcol + 96, B 'underlay of light outline
            LINE (((blockx - 1) * 48) + block1x, ((blocky - 1) * 9) + block1y)-(((blockx - 1) * 48) + block1x, (blocky * 9) + block1y - 2), blockcol + 48   'verticle dark line
            LINE (((blockx - 1) * 48) + block1x, ((blocky - 1) * 9) + block1y)-((blockx * 48) + block1x - 2, ((blocky - 1) * 9) + block1y), blockcol + 48 'horizontal dark line
         ELSE
            LINE (((blockx - 1) * 48) + block1x, ((blocky - 1) * 9) + block1y)-((blockx * 48 - 1) + block1x, (blocky * 9) + block1y - 1), 0, BF
         END IF
     NEXT blockx
 NEXT blocky
END SUB

SUB drawpanel
'panel border and panel
  LINE (0, 0)-(319, 199), 21, B 'very outside
  LINE (1, 1)-(318, 198), 24, B 'outside
  LINE (2, 2)-(317, 5), 27, BF     '    top gray portion
  LINE (2, 6)-(21, 192), 27, BF    '   left "    "
  LINE (313, 6)-(317, 192), 27, BF '  right "    "
  LINE (2, 193)-(317, 197), 27, BF ' bottom "    "
  LINE (23, 6)-(312, 192), 21, B 'very inside
  LINE (22, 5)-(313, 193), 24, B 'inside

'controls on panel: (# of lasers, missiles, and the current level)
   IF levelnow >= 2 THEN LOCATE 1, 1: COLOR 12: PRINT lasers: LINE (1, -1)-(24, 8), 73, B: LINE (0, -1)-(25, 9), 121, B
   IF levelnow >= 3 THEN LOCATE 2, 1: COLOR 43: PRINT missiles: LINE (1, -1)-(24, 16), 73, B: LINE (0, -1)-(25, 17), 121, B
  COLOR 9: LOCATE 24, 1: PRINT levelnow; : COLOR 9: LOCATE 24, 1: PRINT "L";
   LINE (-1, 183)-(22, 192), 73, B  'box around level number inside
   LINE (-1, 182)-(23, 193), 121, B 'box around level number outside

'life counter below:
   lifecolor = 41 + lives * 3
   IF lives < 0 THEN lifecolor = 16
   COLOR lifecolor: LOCATE 22, 1: PRINT lives
    LINE (-1, 167)-(22, 176), 73, B  'box around lives inside border
    LINE (-1, 166)-(23, 177), 121, B 'box around lives outside border
END SUB

SUB firelaser
sector = FIX((padLoc + block1x) / 48) + 1
IF (block(sector + 18) = 1) THEN
   sinklevel = 66
   shot = sector + 18
ELSEIF (block(sector + 12) = 1) THEN
   sinklevel = 57
   shot = sector + 12
ELSEIF (block(sector + 6) = 1) THEN
   sinklevel = 48
   shot = sector + 6
ELSEIF (block(sector) = 1) THEN
   sinklevel = 39
   shot = sector
ELSE
   sinklevel = 7
   shot = 0
END IF

IF shot = 0 GOTO skipfire
IF soundON = 0 THEN cancelsound = 22300

FOR fire = 1 TO 8
    LINE (48 + padLoc, 179)-(48 + padLoc, sinklevel), 12
    SOUND 700 * (fire + 2) + cancelsound, .5
    LINE (48 + padLoc, 179)-(48 + padLoc, sinklevel), 0
    SOUND 37 + cancelsound, .1
NEXT fire
FOR exblock = 9 TO 1 STEP -1
    LINE (24 + (sector * 48) - 48, sinklevel - 10 + exblock)-(23 + (sector * 48), sinklevel - 10 + exblock), 12
    SOUND 700 * (exblock + 2) + cancelsound, .2
    LINE (24 + (sector * 48) - 48, sinklevel - 10 + exblock)-(23 + (sector * 48), sinklevel - 10 + exblock), 0
    SOUND 37 + cancelsound, .1
NEXT exblock
IF shot <> 0 THEN block(shot) = 0
lasers = lasers - 1
drawpanel
skipfire:
END SUB

SUB firemissile
sector = FIX((padLoc + block1x) / 48) + 1
IF (block(sector + 18) = 1) THEN
   sinklevel = 66
   shot = sector + 18
ELSEIF (block(sector + 12) = 1) THEN
   sinklevel = 57
   shot = sector + 12
ELSEIF (block(sector + 6) = 1) THEN
   sinklevel = 48
   shot = sector + 6
ELSEIF (block(sector) = 1) THEN
   sinklevel = 39
   shot = sector
ELSE
   sinklevel = 7
   shot = 0
END IF

IF shot = 0 GOTO skipfiremisl
IF soundON = 0 THEN cancelsound = 22300

'shoot missile:
FOR fire = 167 TO sinklevel - 18 STEP -1
    PUT (40 + padLoc, fire), item2icon, OR
    SOUND 47 + cancelsound, .2
    PUT (40 + padLoc, fire), item2icon, XOR
NEXT fire
 
    PUT (40 + padLoc, sinklevel - 18), item2icon, OR
    SOUND 700 + cancelsound, 1
    PUT (40 + padLoc, sinklevel - 18), item2icon, XOR

'explode 1st block:
FOR exblock = 24 TO 1 STEP -1
    LINE (exblock - 25 + sector * 48, sinklevel - 9)-(exblock - 25 + sector * 48, sinklevel - 1), 0
    SOUND (70 * (exblock + 2)) + cancelsound, .1
    LINE (24 - exblock + sector * 48, sinklevel - 9)-(24 - exblock + sector * 48, sinklevel - 1), 0
    SOUND exblock + 37 + cancelsound, .05
NEXT exblock
IF shot <> 0 THEN block(shot) = 0
IF block(shot - 6) <> 1 THEN : GOTO skip2ndBlock

'explode 2nd block:
FOR exblock = 24 TO 1 STEP -1
    LINE (exblock - 25 + sector * 48, sinklevel - 18)-(exblock - 25 + sector * 48, sinklevel - 10), 0
    SOUND (70 * (exblock + 2)) + cancelsound, .1
    LINE (24 - exblock + sector * 48, sinklevel - 18)-(24 - exblock + sector * 48, sinklevel - 10), 0
    SOUND exblock + 37 + cancelsound, .05
NEXT exblock
IF shot <> 0 THEN block(shot - 6) = 0 'if block is not gone, make it gone (the block 6 earlier than the current one is the block behind it)
skip2ndBlock:
missiles = missiles - 1
drawpanel
skipfiremisl:
END SUB

SUB littlewinsound
IF soundON = 0 THEN cancelsound = 30000
  SOUND 150 + cancelsound, 6
  SOUND 200 + cancelsound, 1
  SOUND 300 + cancelsound, 1
  SOUND 450 + cancelsound, 1
  SOUND 600 + cancelsound, 4
  SOUND 300 + cancelsound, 4
  SOUND 350 + cancelsound, 1
  SOUND 450 + cancelsound, 1
  SOUND 550 + cancelsound, 1
  SOUND 600 + cancelsound, 5
  SOUND 450 + cancelsound, 3
  SOUND 400 + cancelsound, 2
  SOUND 30000, 5
  SOUND 400 + cancelsound, 4
  SOUND 350 + cancelsound, 4
  SOUND 300 + cancelsound, 4
END SUB

SUB loselife
lives = lives - 1: resetball
LINE (block1x + padLoc, 180)-((block1x + 47) + padLoc, 191), 0, BF 'erase old
padLoc = 114
movePad (0)
'checkbal
IF soundON = 0 THEN cancelsound = 29953
SOUND 47 + cancelsound, 9
FOR pitch = 47 TO 37 STEP -1
   SOUND pitch + cancelsound, .1
NEXT pitch
drawpanel
SOUND 37 + cancelsound, 9
 IF autoplay = 1 THEN
   SLEEP 2
 ELSE
   SLEEP 0
 END IF
END SUB

SUB movePad (x%)
sector = FIX((padLoc + block1x) / 48) + 1'finds what block (sector) the paddle is under (1 to 6)
perspective = 6 - sector

LINE (block1x + padLoc, 180)-((block1x + 47) + padLoc, 191), 0, BF 'erase old
padLoc = padLoc + x%

LINE (block1x + padLoc + perspective, 180)-((block1x + 42) + padLoc + perspective, 188), 2, B  'back square
LINE (block1x + padLoc + perspective, 188)-(block1x + padLoc, 191), 2                           'left dark green line
LINE ((block1x + 42) + padLoc + perspective, 188)-((block1x + 47) + padLoc, 191), 2             'right dark green line
LINE (block1x + padLoc, 182)-((block1x + 47) + padLoc, 191), 10, B                              'front square
LINE (block1x + padLoc + perspective, 180)-((block1x + 42) + padLoc + perspective, 180), 4     'top red line
LINE (block1x + 1 + padLoc, 181)-((block1x + 46) + padLoc, 181), 12                             'bottom red line
END SUB

SUB printitle
'18.2 ticks is a second
sndRnd = 100
tisound = 0
LOCATE 14, 6: COLOR 15: PRINT "In game, press [h] for help"
COLOR 7
LOCATE 15, 8: PRINT "-press a key to start-"
fastmusic = 0
getfast = 0
DO
getfast = getfast + 1
IF getfast > 16 THEN fastmusic = 1
IF fastmusic = 0 THEN SLEEP 1
IF (sndRnd = 400) THEN
        SOUND 37, 1
ELSE
        SOUND 550 + sndRnd + tisound, 2.5
END IF
sndRnd = sndRnd + 100
IF sndRnd > 400 THEN sndRnd = 100
IF (tisound = 400) THEN
   tisound = 0
ELSE
   tisound = tisound + 100
END IF

   
    'first changes alternating color
    IF (ticol = 3) THEN
      ticol = 0
    ELSE
      ticol = ticol + 1
    END IF

    IF (ticol = 1) THEN
       LOCATE 5, 9: COLOR 9: PRINT "--Super Mega Break!-"
    ELSEIF (ticol = 2) THEN
       LOCATE 5, 9: COLOR 12: PRINT "--Super Mega Break!-"
    ELSE
       LOCATE 5, 9: COLOR 10: PRINT "--Super Mega Break!-"
    END IF
LOOP UNTIL INKEY$ <> ""
END SUB

SUB resetball
CIRCLE (balX, balY), 3, 0, , , balPerspective 'erases old ball
balPerspective = 0
balX = 162
balY = 150
balSpeed = 0
RANDOMIZE TIMER
direction = INT(RND * 2) + 1
angle = INT(RND * 44) + 11
IF direction = 1 THEN balDIR = angle
IF direction = 2 THEN balDIR = -angle
END SUB

SUB setL1
 FOR blocknum = 1 TO 6
        block(blocknum) = 1
    NEXT blocknum
    FOR blocknum = 7 TO 24
        block(blocknum) = 0
    NEXT blocknum
'Item to win below (laser)
  LINE (135 + block1x, 8)-(152 + block1x, 22), 0, BF  'black fill box
  LINE (135 + block1x, 8)-(152 + block1x, 22), 4, B  'outside box
  LINE (142 + block1x, 21)-(142 + block1x, 11), 12  'laser from bottom to top
     'shades of gray for laser gun icon:
       LINE (142 + block1x, 19)-(142 + block1x, 21), 8
       LINE (141 + block1x, 19)-(141 + block1x, 21), 24
       LINE (143 + block1x, 19)-(143 + block1x, 21), 7
       LINE (142 + block1x, 17)-(142 + block1x, 19), 7
  LOCATE 3, 24: COLOR 12: PRINT "laser"
drawblocks
END SUB

SUB setL2
lasers = 2
resetball
    FOR blocknum = 1 TO 12
        block(blocknum) = 1
    NEXT blocknum
    FOR blocknum = 13 TO 24
        block(blocknum) = 0
    NEXT blocknum
    drawpanel
  'item to win below (missile launcher, item 2)
  LINE (135 + block1x, 8)-(152 + block1x, 22), 139, B   'outside box
    'Missile body
     'Outer dark part
       PSET (144 + block1x, 9), 22
       LINE (141 + block1x, 11)-(147 + block1x, 19), 22, B
       LINE (142 + block1x, 10)-(146 + block1x, 20), 22, B
     'Inner light part
       PSET (142 + block1x, 11), 25
       PSET (146 + block1x, 11), 25
       PSET (144 + block1x, 10), 26
       LINE (142 + block1x, 11)-(146 + block1x, 19), 27, BF
       LINE (144 + block1x, 11)-(146 + block1x, 14), 29, BF
     'Fire on bottom
    'Missile fins
     'Left fin
       LINE (138 + block1x, 20)-(138 + block1x, 21), 20
       LINE (139 + block1x, 18)-(139 + block1x, 20), 20
       LINE (140 + block1x, 17)-(140 + block1x, 19), 20
     'Middle fin
       LINE (144 + block1x, 16)-(144 + block1x, 21), 20
     'Right fin
       LINE (148 + block1x, 17)-(148 + block1x, 19), 20
       LINE (149 + block1x, 18)-(149 + block1x, 20), 20
       LINE (150 + block1x, 20)-(150 + block1x, 21), 20
  LOCATE 3, 24: COLOR 43: PRINT "missile launcher"
drawblocks
END SUB

SUB setL3
missiles = 2
resetball
    FOR blocknum = 1 TO 18
        block(blocknum) = 1
    NEXT blocknum
    FOR blocknum = 19 TO 24
        block(blocknum) = 0
    NEXT blocknum
    drawpanel
  'item to win below (level warp)
  FOR lines = 0 TO 7
    LINE (144 + block1x + lines, 9)-(144 + block1x + lines, 22), (lines + 21)
  NEXT lines
  FOR lines = 15 TO 8 STEP -1
    LINE (127 + block1x + lines, 9)-(127 + block1x + lines, 22), (36 - lines)
  NEXT lines
  FOR circles = 0 TO 8 STEP 2
    CIRCLE (143 + block1x, 15), circles, circles + 20, , , -2.1
  NEXT circles
  LINE (135 + block1x, 8)-(152 + block1x, 22), 54, B  'outside

LOCATE 3, 24: COLOR 9: PRINT "Warp last level!"
drawblocks
END SUB

SUB setL4
resetball
    FOR blocknum = 1 TO 24
        block(blocknum) = 1
    NEXT blocknum
    drawpanel
  'item to win below (stage warp)
  FOR lines = 0 TO 7
    LINE (144 + block1x + lines, 9)-(144 + block1x + lines, 22), (lines + 21)
  NEXT lines
  FOR lines = 15 TO 8 STEP -1
    LINE (127 + block1x + lines, 9)-(127 + block1x + lines, 22), (36 - lines)
  NEXT lines
  FOR circles = 0 TO 8 STEP 2
    CIRCLE (143 + block1x, 15), circles, circles + 20, , , -2.1
  NEXT circles
  LINE (135 + block1x, 8)-(152 + block1x, 22), 54, B  'outside

IF normalspeed + 1 < 5 THEN
  LOCATE 3, 24: COLOR 9: PRINT "Warp to stage"; normalspeed + 1
ELSE
  LOCATE 3, 24: COLOR 9: PRINT "Win the Game!   "
END IF
drawblocks
END SUB

SUB winit
levelnow = levelnow + 1
 SELECT CASE levelnow
        CASE 2: winL1: setL2
        CASE 3: winL2: setL3
        CASE 4: winL3: setL4
        CASE ELSE: winL4: winitmessage: littlewinsound: normalspeed = normalspeed + 1: won = 1: IF normalspeed > 4 THEN winshow
 END SELECT
END SUB

SUB winitmessage
IF autoplay = 0 THEN
  COLOR 11
  LOCATE 12, 6
  PRINT "You win, good job!"
  LOCATE 13, 6
  PRINT " you're quick !!!!!            "
ELSE
  COLOR 11
  LOCATE 12, 6
  PRINT "You win, good job."
  LOCATE 13, 6
  PRINT "                Cheater!!!     "
END IF
END SUB

SUB winL1
GET (136 + block1x, 9)-(151 + block1x, 21), item1icon
LINE (136 + block1x, 9)-(151 + block1x, 21), 0, BF 'erase

FOR Yplace = 39 + (levelnow * 9) TO 165
 PUT (padLoc + 39, Yplace), item1icon
 SOUND 30000, .5
 LINE (padLoc + 39, Yplace)-(padLoc + 56, Yplace + 14), 0, BF
NEXT Yplace
END SUB

SUB winL2
GET (136 + block1x, 9)-(151 + block1x, 21), item2icon
LINE (136 + block1x, 9)-(151 + block1x, 21), 0, BF 'erase

FOR Yplace = 39 + (levelnow * 9) TO 165
 PUT (padLoc + 39, Yplace), item2icon
 SOUND 30000, .5
 LINE (padLoc + 39, Yplace)-(padLoc + 56, Yplace + 14), 0, BF
NEXT Yplace
END SUB

SUB winL3
GET (135 + block1x, 8)-(152 + block1x, 22), item3icon
LINE (135 + block1x, 8)-(152 + block1x, 22), 0, BF 'erase
PUT (150, 99), item3icon

IF normalspeed > 3 THEN
  LOCATE 7, 5: COLOR 9: PRINT "Get ready for the last   "
  LOCATE 8, 5: COLOR 9: PRINT "     level in the game!  "
ELSE
  LOCATE 7, 5: COLOR 9: PRINT "Here comes the last level"
  LOCATE 8, 5: COLOR 9: PRINT " of stage "; normalspeed; "!          "
END IF
  LINE (31, 47)-(232, 63), 73, B  'green border inside
  LINE (30, 46)-(233, 64), 121, B 'green border outside

 IF autoplay = 1 THEN
   SLEEP 2
 ELSE
   SLEEP 0
 END IF
IF soundON = 0 THEN cancelsound = 29447
'code for warp:
DO
factor = factor + 1
outness = outness + factor
  LINE (150 - outness, 99 - outness)-(167 + outness, 113 + outness), 54, B
  LINE (151 - outness, 100 - outness)-(166 + outness, 112 + outness), 0, BF
  CIRCLE (158, 106), outness, 21 + INT(factor / 2)
  CIRCLE (158, 106), INT(outness / 2), 21 + INT(factor / 2)
  CIRCLE (158, 106), INT(outness / 3), 21 + INT(factor / 3)
  CIRCLE (158, 106), INT(outness / 4), 21 + INT(factor / 4)
  CIRCLE (158, 106), INT(outness / 5), 21 + INT(factor / 5)
  CIRCLE (158, 106), INT(outness / 6), 21 + INT(factor / 6)
  SOUND 400 + outness + cancelsound, 1
  LINE (150 - outness, 99 - outness)-(167 + outness, 113 + outness), 0, B
LOOP UNTIL outness > 150
factor = 0
outness = 0
'erase circles:
DO
factor = factor + 1
outness = outness + factor
  CIRCLE (158, 106), outness, 0
  CIRCLE (158, 106), INT(outness / 2), 0
  CIRCLE (158, 106), INT(outness / 3), 0
  CIRCLE (158, 106), INT(outness / 4), 0
  CIRCLE (158, 106), INT(outness / 5), 0
  CIRCLE (158, 106), INT(outness / 6), 0
LOOP UNTIL outness > 150

END SUB

SUB winL4
GET (135 + block1x, 8)-(152 + block1x, 22), item3icon
LINE (135 + block1x, 8)-(152 + block1x, 22), 0, BF 'erase
PUT (150, 99), item3icon

IF soundON = 0 THEN cancelsound = 29447
'code for warp:
DO
factor = factor + 1
outness = outness + factor
  LINE (150 - outness, 99 - outness)-(167 + outness, 113 + outness), 54, B
  LINE (151 - outness, 100 - outness)-(166 + outness, 112 + outness), 0, BF
  CIRCLE (158, 106), outness, 21 + INT(factor / 2)
  CIRCLE (158, 106), INT(outness / 2), 21 + INT(factor / 2)
  CIRCLE (158, 106), INT(outness / 3), 21 + INT(factor / 3)
  CIRCLE (158, 106), INT(outness / 4), 21 + INT(factor / 4)
  CIRCLE (158, 106), INT(outness / 5), 21 + INT(factor / 5)
  CIRCLE (158, 106), INT(outness / 6), 21 + INT(factor / 6)
  SOUND 400 + outness + cancelsound, 1
  LINE (150 - outness, 99 - outness)-(167 + outness, 113 + outness), 0, B
LOOP UNTIL outness > 150
factor = 0
outness = 0
'erase circles:
DO
factor = factor + 1
outness = outness + factor
  CIRCLE (158, 106), outness, 0
  CIRCLE (158, 106), INT(outness / 2), 0
  CIRCLE (158, 106), INT(outness / 3), 0
  CIRCLE (158, 106), INT(outness / 4), 0
  CIRCLE (158, 106), INT(outness / 5), 0
  CIRCLE (158, 106), INT(outness / 6), 0
LOOP UNTIL outness > 150

END SUB

SUB winshow
CLS
COLOR 14
SOUND 30000, 30
PRINT "     YOU ARE THE ULTIMATE CHAMPION!     "
PRINT "                                        "
IF soundON = 1 THEN
   SOUND 400, 3: SOUND 600, 4: SOUND 450, 5: SOUND 600, 8: SOUND 300, .1: SOUND 200, 2
ELSE
   SOUND 30000, 30
END IF
PRINT
PRINT
PRINT
PRINT
PRINT
PRINT
PRINT
PRINT
PRINT
COLOR 9
PRINT "Tell Jake you won...                    "
PRINT "         and he might give you a nickel!"
IF soundON = 1 THEN
   SOUND 30000, 5
   SOUND 200, 2
   SOUND 30000, .5
   SOUND 200, 2
   SOUND 30000, .5
   SOUND 200, 2
   SOUND 30000, .5
   SOUND 200, 2
   SOUND 30000, 30
ELSE
   SOUND 30000, 30
END IF
IF autoplay = 0 THEN
  COLOR 8: LOCATE 3, 1: PRINT "Secret: during game, hold down ALT key  "
  COLOR 8: LOCATE 4, 1: PRINT " while typing 1 7 7 for autoplay. "
ELSE
  LOCATE 1, 1: COLOR 2: PRINT "     YOU ARE THE ULTIMATE CHAMPION "
  LOCATE 3, 1: COLOR 10: PRINT "...NOT! Try to beat it without cheating!"
  LOCATE 5, 1:  COLOR 8: PRINT "Except for this cheat: hold down ALT    "
  LOCATE 6, 1:  COLOR 8: PRINT "   key and type 1 7 8 for faster Paddle."
END IF
SLEEP 15

SYSTEM
END SUB


DECLARE SUB autofire ()
'current version: 1.1 (fixed sound off for end level sounds, modified cheat message to clarify, changed cheater game end screen, added autofire for autoplay)
DECLARE SUB winitmessage ()
DECLARE SUB automove ()
DECLARE SUB littlewinsound ()
DECLARE SUB winshow ()
DECLARE SUB FireMissile ()
DECLARE SUB CheckIfHitBlockSide (sec%)
DECLARE SUB CheckIfHitBlock ()
DECLARE SUB LoseLife ()
DECLARE SUB CheckIfHit ()
DECLARE SUB Bounce (wal%)
DECLARE SUB ResetBall ()
DECLARE SUB ResetBallAngle ()
DECLARE SUB CheckBall ()
'DECLARE SUB DrawParticles ()
'DECLARE SUB StartParticles (iBlockNow%)
DECLARE SUB winL1 ()
DECLARE SUB winL2 ()
DECLARE SUB winL3 ()
DECLARE SUB winL4 ()
DECLARE SUB setL1 ()
DECLARE SUB setL2 ()
DECLARE SUB setL3 ()
DECLARE SUB ForceWinLevel ()
DECLARE SUB FireLaser ()
DECLARE SUB ShowHelp ()
DECLARE SUB MoveBy (x%)
DECLARE SUB DrawBlocksFast ()
DECLARE SUB DrawBackg ()
DECLARE SUB setL4 ()
DECLARE SUB DrawPanel ()
DECLARE SUB DrawBlocks ()
DECLARE SUB ShowTitle ()
DECLARE FUNCTION SafeMod% (iNum%, iDiv%)
SCREEN 13
DIM SHARED block(-5 TO 24) AS INTEGER
DIM SHARED BlocksL AS INTEGER
DIM SHARED BlocksT AS INTEGER
DIM SHARED BlocksW AS INTEGER
DIM SHARED BlocksHeight AS INTEGER
DIM SHARED xPaddle AS INTEGER
DIM SHARED paddle
DIM SHARED missiles AS INTEGER
DIM SHARED lasers AS INTEGER
DIM SHARED iLevel AS INTEGER
DIM SHARED sector AS INTEGER
DIM SHARED xBall
DIM SHARED yBall
DIM SHARED balSpeed
DIM SHARED rBallAngle
DIM SHARED iLivesLeft
DIM SHARED balPerspective
DIM SHARED item1icon(68)
DIM SHARED item2icon(68)
DIM SHARED item3icon(68)
DIM SHARED bSound
DIM SHARED sinklevel
DIM SHARED normalspeed
DIM SHARED won
DIM SHARED autoplay
DIM SHARED MinPaddle
DIM SHARED MaxPaddle
DIM SHARED ExplosionDivisor
ExplosionDivisor = 4
'DIM SHARED yParticle(1 TO 24, 1 TO 108)'432 pixels in a block
'DIM SHARED xParticle(1 TO 24, 1 TO 108)
'DIM SHARED powParticle(1 TO 24, 1 TO 108)
'DIM SHARED basecolorParticle(1 TO 24, 1 TO 108)
'DIM SHARED barrParticleGroup(1 TO 24)
DIM SHARED xPixels
xPixels = 320
BlocksL = 24
BlocksW = xPixels - (BlocksL + 8)
BlocksHeight = 36
BlocksT = 30
bSound = 1
autoplay = 0
ShowTitle
normalspeed = 1 'increases after beating level 4

Resetgame:
CLS
COLOR 53: LOCATE 12, 4: PRINT "             STAGE"; normalspeed
SLEEP 1
won = 0
LINE (24, 6)-(25, 17), 0, B 'erase edge of laser window
LOCATE 3, 24: COLOR 12: PRINT "                "   'erase item name
iLivesLeft = 2
ResetBall
xPaddle = 120
MinPaddle = 0
MaxPaddle = 240
missiles = 0
lasers = 0
iLevel = 1
DrawBackg
COLOR 15
setL1
RedrawAll:
IF helped = 1 THEN : helped = 0: DrawBackg
DrawPanel
DrawBlocksFast
CALL MoveBy(0)

DO
  IF won = 1 GOTO Resetgame
  IF iLivesLeft < 0 THEN GOTO deadend
  CheckBall
  'DrawParticles
  smartr$ = INKEY$
  SELECT CASE smartr$
     CASE CHR$(0) + "P": IF (rBallAngle < -180) OR (rBallAngle > 180) THEN ResetBall
     CASE CHR$(0) + "K": IF xPaddle > MinPaddle + (speedUP * 12) THEN MoveBy (-12 * (speedUP + 1))'LEFT ARROW KEY
     CASE CHR$(0) + "M": IF xPaddle < MaxPaddle - (speedUP * 12) THEN MoveBy (12 * (speedUP + 1))  'RIGHT ARROW KEY
     CASE CHR$(0) + "H": IF lasers > 0 THEN FireLaser: DrawBlocksFast: MoveBy (0)
     CASE CHR$(177): autoplay = ABS(autoplay - 1): IF autoplay = 0 THEN xPaddle = FIX(xPaddle / 48) * 48
     CASE CHR$(178): speedUP = ABS(speedUP - 1): IF speedUP = 1 THEN LINE (BlocksL + xPaddle, 180)-((BlocksL + 47) + xPaddle, 191), 0, BF: xPaddle = FIX(xPaddle / 24) * 24: MoveBy (0)
     CASE "s": bSound = ABS(bSound - 1)
     CASE "S": bSound = ABS(bSound - 1)
     CASE CHR$(13): IF missiles > 0 THEN FireMissile: DrawBlocksFast
     CASE "h": GOSUB ShowHelp
     CASE "H": GOSUB ShowHelp
     CASE CHR$(8): GOTO Resetgame
     CASE CHR$(27): GOTO Ending
  END SELECT
LOOP

deadend:
LOCATE 20, 4: COLOR 4: PRINT "You died."
IF (bSound = 1) THEN
   SOUND 800, 3: SOUND 700, 3: SOUND 600, 3: SOUND 700, 3: SOUND 600, 3: SOUND 500, 3: SOUND 600, 3: SOUND 500, 3: SOUND 400, 6
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
ShowHelp:
COLOR 49: LOCATE 9, 4: PRINT "Right and left move Paddle."
COLOR 50: LOCATE 10, 4: PRINT "Up: fire laster - remaining shots   "
COLOR 50: LOCATE 11, 4: PRINT " appear on the left panel in red    "
COLOR 51: LOCATE 12, 4: PRINT "Enter: fire missile. # of missiles  "
COLOR 51: LOCATE 13, 4: PRINT " appears on the panel in orange.    "
COLOR 52: LOCATE 14, 4: PRINT "Once you break a hole through the   "
COLOR 52: LOCATE 15, 4: PRINT " barrier, then send the ball through"
COLOR 52: LOCATE 16, 4: PRINT " to win the level and get the item. "
COLOR 53: LOCATE 17, 4: PRINT "In case of emergency, push [Down]   "
COLOR 54: LOCATE 18, 4: PRINT " (resets ball if ball gets stuck.)  "
COLOR 55: LOCATE 19, 4: PRINT "s: toggle sound                     "
COLOR 56: LOCATE 20, 4: PRINT "Win 3 times using the codes from the"
COLOR 56: LOCATE 21, 4: PRINT "   previous wins to become champion!"
COLOR 21: LOCATE 22, 4: PRINT "Press a key to return...";
SLEEP 0
helped = 1
GOTO RedrawAll
RETURN

SUB autofire
IF lasers > 0 THEN FireLaser: GOTO skipmissile
IF missiles > 0 THEN FireMissile
skipmissile:
END SUB

SUB automove
moveamount = (CINT(xBall) - (xPaddle + 48))
IF xPaddle + moveamount < 0 THEN moveamount = 0
IF xPaddle + moveamount > 240 THEN moveamount = 0
MoveBy (moveamount)
IF rBallAngle > 180 OR rBallAngle < -180 THEN ResetBall
IF yBall <= 76 THEN autofire
END SUB

SUB Bounce (wal%)

IF bSound = 1 THEN
  FOR pitch = 200 TO 300 STEP 10
    SOUND pitch * 10, .1
  NEXT pitch
ELSE
  SOUND 30000, 1
END IF

SELECT CASE rBallAngle
 CASE 0 TO 90: rBallAngle = 180 - rBallAngle - (wal% * 180)
 CASE -90 TO -1: rBallAngle = -180 - rBallAngle - (wal% * 180)
 CASE -180 TO -91: rBallAngle = ABS(rBallAngle) - (ABS(wal%) * 180) + 180
 CASE 91 TO 180: rBallAngle = -ABS(rBallAngle) + (wal% * 180) - 180
END SELECT
END SUB

SUB CheckBall
	
	IF autoplay = 1 THEN automove
	IF INKEY$ = CHR$(0) + "P" THEN : IF (rBallAngle < -180) OR (rBallAngle > 180) THEN ResetBall
	IF xBall < 28 THEN Bounce (-1) 'off left wall
	IF xBall > 308 THEN Bounce (1) 'off right wall
	IF yBall <= 34 + (iLevel * 9) THEN CheckIfHitBlock
	IF yBall >= 176 - balSpeed THEN CheckIfHit
	
	IF yBall > 187 THEN LoseLife
	 SOUND 30000, .2
	CIRCLE (xBall, yBall), 3, 0, , , balPerspective 'erases old ball
	
	IF balPerspective > 5 THEN balPerspective = 0
	balPerspective = balPerspective + .5
	
	IF balSpeed < normalspeed THEN balSpeed = balSpeed + .01
	
	xBallPrev = xBall
	yBallPrev = yBall
	IF (rBallAngle < -180) THEN
		ResetBallAngle
	ELSEIF (rBallAngle > 180) THEN
		ResetBallAngle
	END IF
	SELECT CASE rBallAngle
	 CASE 180: yBall = yBall + balSpeed
	 CASE -180: yBall = yBall + balSpeed
	 CASE 0: yBall = yBall - balSpeed
	 CASE -90: xBall = xBall - balSpeed
	 CASE 90: xBall = xBall + balSpeed
	 CASE -179 TO -91: xBall = xBall - (balSpeed * ((180 + rBallAngle) / 90)): yBall = yBall + (balSpeed * ((90 - (180 + rBallAngle)) / 90))
	 CASE 91 TO 179:   xBall = xBall + (balSpeed * ((180 - rBallAngle) / 90)): yBall = yBall + (balSpeed * ((90 - (180 - rBallAngle)) / 90))
	 CASE -89 TO -1:   xBall = xBall + (balSpeed * (rBallAngle / 90)):         yBall = yBall - (balSpeed * ((90 + rBallAngle) / 90))
	 CASE 1 TO 89:     xBall = xBall + (balSpeed * (rBallAngle / 90)):         yBall = yBall - (balSpeed * ((90 - rBallAngle) / 90))
	END SELECT
	'IF xBal = xBallPrev OR yBal = yBallPrev THEN rBallAngle = 0
	
	CIRCLE (xBall, yBall), 3, 53, , , balPerspective
END SUB

SUB CheckIfHit
SELECT CASE xBall
CASE xPaddle + 24 TO xPaddle + 72: Bounce (2) 'check if hit between ends of pad
CASE ELSE: LoseLife
END SELECT
END SUB

SUB CheckIfHitBlock
sector = FIX((xBall - 24) / 48) + 1
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
   IF yBall <= 30 + balSpeed THEN ForceWinLevel
   shot = 0
   IF won = 1 THEN : ResetBall: GOTO skipbreak
END IF

IF yBall >= sinklevel + 4 + balSpeed THEN GOTO skipbreak
CALL CheckIfHitBlockSide(sector)
IF shot = 0 GOTO skipbreak
IF yBall < sinklevel + 4 + balSpeed THEN Bounce (0) 'sees if ball hit a block (some errors)
IF bSound = 0 THEN cancelsound = 20000

FOR iExploder = 24 TO 1 STEP -1
    LINE (25 - iExploder + sector * 48, sinklevel - 9)-(25 - iExploder + sector * 48, sinklevel - 1), 0
    SOUND 10000 - iExploder + cancelsound, .1
    LINE (iExploder - 24 + sector * 48, sinklevel - 9)-(iExploder - 24 + sector * 48, sinklevel - 1), 0
    SOUND 22337, .05
NEXT iExploder

IF shot <> 0 THEN block(shot) = 0
'StartParticles (shot)
DrawPanel
balSpeed = balSpeed + .4
DrawBlocksFast
skipbreak:
END SUB

SUB CheckIfHitBlockSide (sec%)
IF yBall < sinklevel + 4 + balSpeed THEN GOTO skipsidebounce
IF xBall <= ((sec% - 1) * 48) + 24 + balSpeed THEN Bounce (-1) 'if hit right side of block, Bounce off it
IF xBall >= ((sec% - 1) * 48) + 72 - balSpeed THEN Bounce (1)  'if hit right side of block, Bounce off it
skipsidebounce:
END SUB

SUB DrawBackg
LINE (24, 24)-(311, 191), 0, BF
END SUB

SUB DrawBlocks
IF bSound = 0 THEN cancelsound = 29040
blockcol = 31
blocknum = 0
 FOR blocky = 1 TO 4
     FOR blockx = 1 TO 6
	 blockcol = blockcol + 1
	 blocknum = blocknum + 1
	 IF (block(blocknum) = 1) THEN
	    SOUND 40 * blockx * blocky + cancelsound, 1
	    LINE (((blockx - 1) * 48) + BlocksL, ((blocky - 1) * 9) + BlocksT)-((blockx * 48 - 1) + BlocksL, (blocky * 9) + BlocksT - 1), blockcol, BF     'medium colored box
	    LINE (((blockx - 1) * 48) + BlocksL, ((blocky - 1) * 9) + BlocksT)-((blockx * 48 - 1) + BlocksL, (blocky * 9) + BlocksT - 1), blockcol + 96, B 'underlay of light outline
	    LINE (((blockx - 1) * 48) + BlocksL, ((blocky - 1) * 9) + BlocksT)-(((blockx - 1) * 48) + BlocksL, (blocky * 9) + BlocksT - 2), blockcol + 48   'verticle dark line
	    LINE (((blockx - 1) * 48) + BlocksL, ((blocky - 1) * 9) + BlocksT)-((blockx * 48) + BlocksL - 2, ((blocky - 1) * 9) + BlocksT), blockcol + 48 'horizontal dark line
	 ELSE
	    LINE (((blockx - 1) * 48) + BlocksL, ((blocky - 1) * 9) + BlocksT)-((blockx * 48 - 1) + BlocksL, (blocky * 9) + BlocksT - 1), 0, BF
	 END IF
     NEXT blockx
 NEXT blocky
END SUB

SUB DrawBlocksFast
blockcol = 31
blocknum = 0
 FOR blocky = 1 TO 4
     FOR blockx = 1 TO 6
	 blockcol = blockcol + 1
	 blocknum = blocknum + 1
	 IF (block(blocknum) = 1) THEN
	    LINE (((blockx - 1) * 48) + BlocksL, ((blocky - 1) * 9) + BlocksT)-((blockx * 48 - 1) + BlocksL, (blocky * 9) + BlocksT - 1), blockcol, BF     'medium colored box
	    LINE (((blockx - 1) * 48) + BlocksL, ((blocky - 1) * 9) + BlocksT)-((blockx * 48 - 1) + BlocksL, (blocky * 9) + BlocksT - 1), blockcol + 96, B 'underlay of light outline
	    LINE (((blockx - 1) * 48) + BlocksL, ((blocky - 1) * 9) + BlocksT)-(((blockx - 1) * 48) + BlocksL, (blocky * 9) + BlocksT - 2), blockcol + 48   'verticle dark line
	    LINE (((blockx - 1) * 48) + BlocksL, ((blocky - 1) * 9) + BlocksT)-((blockx * 48) + BlocksL - 2, ((blocky - 1) * 9) + BlocksT), blockcol + 48 'horizontal dark line
	 ELSE
	    LINE (((blockx - 1) * 48) + BlocksL, ((blocky - 1) * 9) + BlocksT)-((blockx * 48 - 1) + BlocksL, (blocky * 9) + BlocksT - 1), 0, BF
	 END IF
     NEXT blockx
 NEXT blocky
END SUB

SUB DrawPanel
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
   IF iLevel >= 2 THEN LOCATE 1, 1: COLOR 12: PRINT lasers: LINE (1, -1)-(24, 8), 73, B: LINE (0, -1)-(25, 9), 121, B
   IF iLevel >= 3 THEN LOCATE 2, 1: COLOR 43: PRINT missiles: LINE (1, -1)-(24, 16), 73, B: LINE (0, -1)-(25, 17), 121, B
  COLOR 9: LOCATE 24, 1: PRINT iLevel; : COLOR 9: LOCATE 24, 1: PRINT "L";
   LINE (-1, 183)-(22, 192), 73, B  'box around level number inside
   LINE (-1, 182)-(23, 193), 121, B 'box around level number outside

'life counter below:
   lifecolor = 41 + iLivesLeft * 3
   IF iLivesLeft < 0 THEN lifecolor = 16
   COLOR lifecolor: LOCATE 22, 1: PRINT iLivesLeft
    LINE (-1, 167)-(22, 176), 73, B  'box around iLivesLeft inside border
    LINE (-1, 166)-(23, 177), 121, B 'box around iLivesLeft outside border
END SUB

'SUB DrawParticles
'	FOR iGroup = 1 TO 24
'		IF barrParticleGroup(iGroup) THEN
'			iRemain = 0
'			FOR iParticle = 1 TO 108
'				'yParticle(iGroup,iParticle) '432 pixels in a block
'				'xParticle(iGroup,iParticle)
'				'powParticle(iGroup,iParticle)
'				'basecolorParticle(iGroup,iParticle)
'				'barrParticleGroup(iGroup)
'				IF powParticle(iGroup, iParticle) > 0 THEN
'					PSET (xParticle(iGroup, iParticle), yParticle(iGroup, iParticle)), (basecolorParticle(iGroup, iParticle) - ((1! - powParticle(iGroup, iParticle)) * 14!))
'					yParticle(iGroup, iParticle) = yParticle(iGroup, iParticle) + RND / 2
'					xParticle(iGroup, iParticle) = xParticle(iGroup, iParticle) + RND / 2 + .1'blows off to the side
'					powParticle(iGroup, iParticle) = powParticle(iGroup, iParticle) - (RND / 10 + .02)
'					iRemain = iRemain + 1
'					IF xParticle(iGroup, iParticle) >= xPixels OR yParticle(iGroup, iParticle) >= yPixels OR xParticle(iGroup, iParticle) < 0 OR yParticle(iGroup, iParticle) < 0 THEN
'						powParticle(iGroup, iParticle) = 0
'					END IF
'				END IF
'			NEXT iParticle
'			IF iRemain = 0 THEN
'				barrParticleGroup(iGroup) = 0
'			END IF
'		END IF
'	NEXT iGroup
'END SUB

SUB FireLaser
sector = FIX((xPaddle + BlocksL) / 48) + 1
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
IF bSound = 0 THEN cancelsound = 22300

FOR fire = 1 TO 8
    LINE (48 + xPaddle, 179)-(48 + xPaddle, sinklevel), 12
    SOUND 700 * (fire + 2) + cancelsound, .5
    LINE (48 + xPaddle, 179)-(48 + xPaddle, sinklevel), 0
    SOUND 37 + cancelsound, .1
NEXT fire
FOR iExploder = 9 TO 1 STEP -1
    LINE (24 + (sector * 48) - 48, sinklevel - 10 + iExploder)-(23 + (sector * 48), sinklevel - 10 + iExploder), 12
    SOUND 700 * (iExploder + 2) + cancelsound, .2
    LINE (24 + (sector * 48) - 48, sinklevel - 10 + iExploder)-(23 + (sector * 48), sinklevel - 10 + iExploder), 0
    SOUND 37 + cancelsound, .1
NEXT iExploder
IF shot <> 0 THEN block(shot) = 0
lasers = lasers - 1
DrawPanel
skipfire:
END SUB

SUB FireMissile
sector = FIX((xPaddle + BlocksL) / 48) + 1
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
IF bSound = 0 THEN cancelsound = 22300

'shoot missile:
FOR fire = 167 TO sinklevel - 18 STEP -1
    PUT (40 + xPaddle, fire), item2icon, OR
    SOUND 47 + cancelsound, .2
    PUT (40 + xPaddle, fire), item2icon, XOR
NEXT fire
 
    PUT (40 + xPaddle, sinklevel - 18), item2icon, OR
    SOUND 700 + cancelsound, 1
    PUT (40 + xPaddle, sinklevel - 18), item2icon, XOR

'explode 1st block:
FOR iExploder = 24 TO 1 STEP -1
    LINE (iExploder - 25 + sector * 48, sinklevel - 9)-(iExploder - 25 + sector * 48, sinklevel - 1), 0
    SOUND (70 * (iExploder + 2)) + cancelsound, .1
    LINE (24 - iExploder + sector * 48, sinklevel - 9)-(24 - iExploder + sector * 48, sinklevel - 1), 0
    SOUND iExploder + 37 + cancelsound, .05
NEXT iExploder
IF shot <> 0 THEN block(shot) = 0
IF block(shot - 6) <> 1 THEN : GOTO skip2ndBlock

'explode 2nd block:
FOR iExploder = 24 TO 1 STEP -1
    LINE (iExploder - 25 + sector * 48, sinklevel - 18)-(iExploder - 25 + sector * 48, sinklevel - 10), 0
    SOUND (70 * (iExploder + 2)) + cancelsound, .1
    LINE (24 - iExploder + sector * 48, sinklevel - 18)-(24 - iExploder + sector * 48, sinklevel - 10), 0
    SOUND iExploder + 37 + cancelsound, .05
NEXT iExploder
IF shot <> 0 THEN block(shot - 6) = 0 'if block is not gone, make it gone (the block 6 earlier than the current one is the block behind it)
skip2ndBlock:
missiles = missiles - 1
DrawPanel
skipfiremisl:
END SUB

SUB ForceWinLevel
iLevel = iLevel + 1
 SELECT CASE iLevel
	CASE 2: winL1: setL2
	CASE 3: winL2: setL3
	CASE 4: winL3: setL4
	CASE ELSE: winL4: winitmessage: littlewinsound: normalspeed = normalspeed + 1: won = 1: IF normalspeed > 4 THEN winshow
 END SELECT
END SUB

SUB littlewinsound
IF bSound = 0 THEN cancelsound = 30000
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

SUB LoseLife
iLivesLeft = iLivesLeft - 1: ResetBall
LINE (BlocksL + xPaddle, 180)-((BlocksL + 47) + xPaddle, 191), 0, BF 'erase old
xPaddle = 114
MoveBy (0)
'CheckBall
IF bSound = 0 THEN cancelsound = 29953
SOUND 47 + cancelsound, 9
FOR pitch = 47 TO 37 STEP -1
   SOUND pitch + cancelsound, .1
NEXT pitch
DrawPanel
SOUND 37 + cancelsound, 9
 IF autoplay = 1 THEN
   SLEEP 2
 ELSE
   SLEEP 0
 END IF
END SUB

SUB MoveBy (x%)
	sector = FIX((xPaddle + BlocksL) / 48) + 1'finds what block (sector) the paddle is under (1 to 6)
	perspective = 6 - sector

	LINE (BlocksL + xPaddle, 180)-((BlocksL + 47) + xPaddle, 191), 0, BF 'erase old
	xPaddle = xPaddle + x%
	IF xPaddle > MaxPaddle THEN xPaddle = MaxPaddle
	IF xPaddle < MinPaddle THEN xPaddle = MinPaddle
	
	LINE (BlocksL + xPaddle + perspective, 180)-((BlocksL + 42) + xPaddle + perspective, 188), 2, B  'back square
	LINE (BlocksL + xPaddle + perspective, 188)-(BlocksL + xPaddle, 191), 2                           'left dark green line
	LINE ((BlocksL + 42) + xPaddle + perspective, 188)-((BlocksL + 47) + xPaddle, 191), 2             'right dark green line
	LINE (BlocksL + xPaddle, 182)-((BlocksL + 47) + xPaddle, 191), 10, B                              'front square
	LINE (BlocksL + xPaddle + perspective, 180)-((BlocksL + 42) + xPaddle + perspective, 180), 4     'top red line
	LINE (BlocksL + 1 + xPaddle, 181)-((BlocksL + 46) + xPaddle, 181), 12                             'bottom red line
END SUB

SUB ResetBall
CIRCLE (xBall, yBall), 3, 0, , , balPerspective 'erases old ball
balPerspective = 0
xBall = 162
yBall = 150
balSpeed = 0
RANDOMIZE TIMER
direction = INT(RND * 2) + 1
angle = INT(RND * 44) + 11
IF direction = 1 THEN rBallAngle = angle
IF direction = 2 THEN rBallAngle = -angle
END SUB

SUB ResetBallAngle
CIRCLE (xBall, yBall), 3, 0, , , balPerspective 'erases old ball
balPerspective = 0
'xBall = 162
yBall = yBall + 20
balSpeed = 0
RANDOMIZE TIMER
direction = INT(RND * 2) + 1
angle = INT(RND * 44) + 11
IF direction = 1 THEN rBallAngle = angle
IF direction = 2 THEN rBallAngle = -angle
END SUB

FUNCTION SafeMod% (iNum%, iDiv%)
	IF iNum% > iDiv% THEN
		rTemp! = iNum% / iDiv% ' i.e. 18/10
		iTemp% = INT(rTemp!)
		rTest! = iTemp%
		IF rTest! > rTemp! THEN 'avoid any automatic rounding
			iTemp% = iTemp% - 1
		ELSE
			iTemp% = iTemp%
		END IF
		SafeMod% = iNum% - (iTemp% * iDiv%) 'i.e. 18 - 1*10 = 8
	ELSEIF iNum% = iDiv% THEN
		SafeMod% = 0
	ELSE
		SafeMod% = iNum%
	END IF
END FUNCTION

SUB setL1
 FOR blocknum = 1 TO 6
	block(blocknum) = 1
    NEXT blocknum
    FOR blocknum = 7 TO 24
	block(blocknum) = 0
    NEXT blocknum
'Item to win below (laser)
  LINE (135 + BlocksL, 8)-(152 + BlocksL, 22), 0, BF  'black fill box
  LINE (135 + BlocksL, 8)-(152 + BlocksL, 22), 4, B  'outside box
  LINE (142 + BlocksL, 21)-(142 + BlocksL, 11), 12  'laser from bottom to top
     'shades of gray for laser gun icon:
       LINE (142 + BlocksL, 19)-(142 + BlocksL, 21), 8
       LINE (141 + BlocksL, 19)-(141 + BlocksL, 21), 24
       LINE (143 + BlocksL, 19)-(143 + BlocksL, 21), 7
       LINE (142 + BlocksL, 17)-(142 + BlocksL, 19), 7
  LOCATE 3, 24: COLOR 12: PRINT "laser"
DrawBlocks
END SUB

SUB setL2
lasers = 2
ResetBall
    FOR blocknum = 1 TO 12
	block(blocknum) = 1
    NEXT blocknum
    FOR blocknum = 13 TO 24
	block(blocknum) = 0
    NEXT blocknum
    DrawPanel
  'item to win below (missile launcher, item 2)
  LINE (135 + BlocksL, 8)-(152 + BlocksL, 22), 139, B   'outside box
    'Missile body
     'Outer dark part
       PSET (144 + BlocksL, 9), 22
       LINE (141 + BlocksL, 11)-(147 + BlocksL, 19), 22, B
       LINE (142 + BlocksL, 10)-(146 + BlocksL, 20), 22, B
     'Inner light part
       PSET (142 + BlocksL, 11), 25
       PSET (146 + BlocksL, 11), 25
       PSET (144 + BlocksL, 10), 26
       LINE (142 + BlocksL, 11)-(146 + BlocksL, 19), 27, BF
       LINE (144 + BlocksL, 11)-(146 + BlocksL, 14), 29, BF
     'Fire on bottom
    'Missile fins
     'Left fin
       LINE (138 + BlocksL, 20)-(138 + BlocksL, 21), 20
       LINE (139 + BlocksL, 18)-(139 + BlocksL, 20), 20
       LINE (140 + BlocksL, 17)-(140 + BlocksL, 19), 20
     'Middle fin
       LINE (144 + BlocksL, 16)-(144 + BlocksL, 21), 20
     'Right fin
       LINE (148 + BlocksL, 17)-(148 + BlocksL, 19), 20
       LINE (149 + BlocksL, 18)-(149 + BlocksL, 20), 20
       LINE (150 + BlocksL, 20)-(150 + BlocksL, 21), 20
  LOCATE 3, 24: COLOR 43: PRINT "missile launcher"
DrawBlocks
END SUB

SUB setL3
missiles = 2
ResetBall
    FOR blocknum = 1 TO 18
	block(blocknum) = 1
    NEXT blocknum
    FOR blocknum = 19 TO 24
	block(blocknum) = 0
    NEXT blocknum
    DrawPanel
  'item to win below (level warp)
  FOR lines = 0 TO 7
    LINE (144 + BlocksL + lines, 9)-(144 + BlocksL + lines, 22), (lines + 21)
  NEXT lines
  FOR lines = 15 TO 8 STEP -1
    LINE (127 + BlocksL + lines, 9)-(127 + BlocksL + lines, 22), (36 - lines)
  NEXT lines
  FOR circles = 0 TO 8 STEP 2
    CIRCLE (143 + BlocksL, 15), circles, circles + 20, , , -2.1
  NEXT circles
  LINE (135 + BlocksL, 8)-(152 + BlocksL, 22), 54, B  'outside

LOCATE 3, 24: COLOR 9: PRINT "Warp last level!"
DrawBlocks
END SUB

SUB setL4
ResetBall
    FOR blocknum = 1 TO 24
	block(blocknum) = 1
    NEXT blocknum
    DrawPanel
  'item to win below (stage warp)
  FOR lines = 0 TO 7
    LINE (144 + BlocksL + lines, 9)-(144 + BlocksL + lines, 22), (lines + 21)
  NEXT lines
  FOR lines = 15 TO 8 STEP -1
    LINE (127 + BlocksL + lines, 9)-(127 + BlocksL + lines, 22), (36 - lines)
  NEXT lines
  FOR circles = 0 TO 8 STEP 2
    CIRCLE (143 + BlocksL, 15), circles, circles + 20, , , -2.1
  NEXT circles
  LINE (135 + BlocksL, 8)-(152 + BlocksL, 22), 54, B  'outside

IF normalspeed + 1 < 5 THEN
  LOCATE 3, 24: COLOR 9: PRINT "Warp to stage"; normalspeed + 1
ELSE
  LOCATE 3, 24: COLOR 9: PRINT "Win the Game!   "
END IF
DrawBlocks
END SUB

SUB ShowTitle
'18.2 ticks is a second
sndRnd = 100
tisound = 0
LOCATE 20, 6: COLOR 15: PRINT "H"; : COLOR 79: PRINT "elp"
COLOR 79
LOCATE 21, 8: PRINT "press a key..."
fastmusic = 0
getfast = 0
cancelsound = 0
IF bSound = 0 THEN cancelsound = 30000
DO
getfast = getfast + 1
IF getfast > 16 THEN fastmusic = 1
IF fastmusic = 0 THEN SLEEP 1
IF (sndRnd = 400) THEN
	SOUND 37 + cancelsound, 1
ELSE
	SOUND 550 + sndRnd + tisound + cancelsound, 2.5
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
       LOCATE 12, 9: COLOR 9: PRINT "--Super Mega Break!-"
    ELSEIF (ticol = 2) THEN
       LOCATE 12, 9: COLOR 12: PRINT "--Super Mega Break!-"
    ELSE
       LOCATE 12, 9: COLOR 10: PRINT "--Super Mega Break!-"
    END IF
LOOP UNTIL INKEY$ <> ""
END SUB

'SUB StartParticles (iBlockNow%)
'	RANDOMIZE TIMER
'	'blocks are 48x9 = 432 pixels in a block
'	'there are 6x4 (24) blocks possible
'	'xOff% = BlocksL
'	'RectWidth = BlocksW - BlocksL
'	xOff% = SafeMod%((iBlockNow * 48), BlocksW) + BlocksL
'	yOff% = (iBlockNow / 6 * 9) + BlocksT
'	xRel% = 0
'	yRel% = 0
'	FOR iParticle% = 1 TO 108
'		yParticle(iBlockNow%, iParticle%) = yRel + yOff
'		xParticle(iBlockNow%, iParticle%) = xRel + xOff
'		powParticle(iBlockNow%, iParticle%) = 1!
'		basecolorParticle(iBlockNow%, iParticle%) = 164'goes backward 14 while decaying
'		barrParticleGroup(iBlockNow%) = 1
'		xRel% = xRel% + 1
'		IF xRel% > 48 THEN
'			xRel% = 0
'			yRel% = yRel% + 9
'		END IF
'	NEXT iParticle%
'END SUB

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
GET (136 + BlocksL, 9)-(151 + BlocksL, 21), item1icon
LINE (136 + BlocksL, 9)-(151 + BlocksL, 21), 0, BF 'erase

FOR Yplace = 39 + (iLevel * 9) TO 165
 PUT (xPaddle + 39, Yplace), item1icon
 SOUND 30000, .5
 LINE (xPaddle + 39, Yplace)-(xPaddle + 56, Yplace + 14), 0, BF
NEXT Yplace
END SUB

SUB winL2
GET (136 + BlocksL, 9)-(151 + BlocksL, 21), item2icon
LINE (136 + BlocksL, 9)-(151 + BlocksL, 21), 0, BF 'erase

FOR Yplace = 39 + (iLevel * 9) TO 165
 PUT (xPaddle + 39, Yplace), item2icon
 SOUND 30000, .5
 LINE (xPaddle + 39, Yplace)-(xPaddle + 56, Yplace + 14), 0, BF
NEXT Yplace
END SUB

SUB winL3
GET (135 + BlocksL, 8)-(152 + BlocksL, 22), item3icon
LINE (135 + BlocksL, 8)-(152 + BlocksL, 22), 0, BF 'erase
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
IF bSound = 0 THEN cancelsound = 29447
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
GET (135 + BlocksL, 8)-(152 + BlocksL, 22), item3icon
LINE (135 + BlocksL, 8)-(152 + BlocksL, 22), 0, BF 'erase
PUT (150, 99), item3icon

IF bSound = 0 THEN cancelsound = 29447
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
IF bSound = 1 THEN
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
IF bSound = 1 THEN
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


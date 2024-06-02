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
Screen 13
Dim Shared block(-5 To 24) As Integer
Dim Shared BlocksL As Integer
Dim Shared BlocksT As Integer
Dim Shared BlocksW As Integer
Dim Shared BlocksHeight As Integer
Dim Shared xPaddle As Integer
Dim Shared paddle
Dim Shared missiles As Integer
Dim Shared lasers As Integer
Dim Shared iLevel As Integer
Dim Shared sector As Integer
Dim Shared xBall
Dim Shared yBall
Dim Shared balSpeed
Dim Shared rBallAngle
Dim Shared iLivesLeft
Dim Shared balPerspective
Dim Shared item1icon(68)
Dim Shared item2icon(68)
Dim Shared item3icon(68)
Dim Shared bSound
Dim Shared sinklevel
Dim Shared normalspeed
Dim Shared won
Dim Shared autoplay
Dim Shared MinPaddle
Dim Shared MaxPaddle
Dim Shared ExplosionDivisor
ExplosionDivisor = 4
'DIM SHARED yParticle(1 TO 24, 1 TO 108)'432 pixels in a block
'DIM SHARED xParticle(1 TO 24, 1 TO 108)
'DIM SHARED powParticle(1 TO 24, 1 TO 108)
'DIM SHARED basecolorParticle(1 TO 24, 1 TO 108)
'DIM SHARED barrParticleGroup(1 TO 24)
Dim Shared xPixels
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
Cls
Color 53: Locate 12, 4: Print "             STAGE"; normalspeed
Sleep 1
won = 0
Line (24, 6)-(25, 17), 0, B 'erase edge of laser window
Locate 3, 24: Color 12: Print "                " 'erase item name
iLivesLeft = 2
ResetBall
xPaddle = 120
MinPaddle = 0
MaxPaddle = 240
missiles = 0
lasers = 0
iLevel = 1
DrawBackg
Color 15
setL1
RedrawAll:
If helped = 1 Then: helped = 0: DrawBackg
DrawPanel
DrawBlocksFast
Call MoveBy(0)

Do
    If won = 1 GoTo Resetgame
    If iLivesLeft < 0 Then GoTo deadend
    CheckBall
    'DrawParticles
    smartr$ = InKey$
    Select Case smartr$
        Case Chr$(0) + "P": If (rBallAngle < -180) Or (rBallAngle > 180) Then ResetBall
        Case Chr$(0) + "K": If xPaddle > MinPaddle + (speedUP * 12) Then MoveBy (-12 * (speedUP + 1)) 'LEFT ARROW KEY
        Case Chr$(0) + "M": If xPaddle < MaxPaddle - (speedUP * 12) Then MoveBy (12 * (speedUP + 1)) 'RIGHT ARROW KEY
        Case Chr$(0) + "H": If lasers > 0 Then FireLaser: DrawBlocksFast: MoveBy (0)
        Case Chr$(177): autoplay = Abs(autoplay - 1): If autoplay = 0 Then xPaddle = Fix(xPaddle / 48) * 48
        Case Chr$(178): speedUP = Abs(speedUP - 1): If speedUP = 1 Then Line (BlocksL + xPaddle, 180)-((BlocksL + 47) + xPaddle, 191), 0, BF: xPaddle = Fix(xPaddle / 24) * 24: MoveBy (0)
        Case "s": bSound = Abs(bSound - 1)
        Case "S": bSound = Abs(bSound - 1)
        Case Chr$(13): If missiles > 0 Then FireMissile: DrawBlocksFast
        Case "h": GoSub ShowHelp
        Case "H": GoSub ShowHelp
        Case Chr$(8): GoTo Resetgame
        Case Chr$(27): GoTo Ending
    End Select
Loop

deadend:
Locate 20, 4: Color 4: Print "You died."
If (bSound = 1) Then
    Sound 800, 3: Sound 700, 3: Sound 600, 3: Sound 700, 3: Sound 600, 3: Sound 500, 3: Sound 600, 3: Sound 500, 3: Sound 400, 6
Else
    Sound 30000, 21
End If
GoTo Resetgame

Ending:
Locate 23, 2
Color 15
Print "Press a key to exit";: Color 9: Print " S.";: Color 12: Print "M.";: Color 10: Print "B."

Line (7, 175)-(215, 184), 122, B
Line (6, 174)-(216, 185), 74, B
Line (5, 173)-(217, 186), 122, B
Sleep 0
'game end from quitting
System


Color 0
End
'secret code: hold down [ALT] and type "177" then let go
ShowHelp:
Color 49: Locate 9, 4: Print "Right and left move Paddle."
Color 50: Locate 10, 4: Print "Up: fire laster - remaining shots   "
Color 50: Locate 11, 4: Print " appear on the left panel in red    "
Color 51: Locate 12, 4: Print "Enter: fire missile. # of missiles  "
Color 51: Locate 13, 4: Print " appears on the panel in orange.    "
Color 52: Locate 14, 4: Print "Once you break a hole through the   "
Color 52: Locate 15, 4: Print " barrier, then send the ball through"
Color 52: Locate 16, 4: Print " to win the level and get the item. "
Color 53: Locate 17, 4: Print "In case of emergency, push [Down]   "
Color 54: Locate 18, 4: Print " (resets ball if ball gets stuck.)  "
Color 55: Locate 19, 4: Print "s: toggle sound                     "
Color 56: Locate 20, 4: Print "Win 3 times using the codes from the"
Color 56: Locate 21, 4: Print "   previous wins to become champion!"
Color 21: Locate 22, 4: Print "Press a key to return...";
Sleep 0
helped = 1
GoTo RedrawAll
Return

Sub autofire
    If lasers > 0 Then FireLaser: GoTo skipmissile
    If missiles > 0 Then FireMissile
    skipmissile:
End Sub

Sub automove
    moveamount = (CInt(xBall) - (xPaddle + 48))
    If xPaddle + moveamount < 0 Then moveamount = 0
    If xPaddle + moveamount > 240 Then moveamount = 0
    MoveBy (moveamount)
    If rBallAngle > 180 Or rBallAngle < -180 Then ResetBall
    If yBall <= 76 Then autofire
End Sub

Sub Bounce (wal%)

    If bSound = 1 Then
        For pitch = 200 To 300 Step 10
            Sound pitch * 10, .1
        Next pitch
    Else
        Sound 30000, 1
    End If

    Select Case rBallAngle
        Case 0 To 90: rBallAngle = 180 - rBallAngle - (wal% * 180)
        Case -90 To -1: rBallAngle = -180 - rBallAngle - (wal% * 180)
        Case -180 To -91: rBallAngle = Abs(rBallAngle) - (Abs(wal%) * 180) + 180
        Case 91 To 180: rBallAngle = -Abs(rBallAngle) + (wal% * 180) - 180
    End Select
End Sub

Sub CheckBall
    
    If autoplay = 1 Then automove
    If InKey$ = Chr$(0) + "P" Then: If (rBallAngle < -180) Or (rBallAngle > 180) Then ResetBall
    If xBall < 28 Then Bounce (-1) 'off left wall
    If xBall > 308 Then Bounce (1) 'off right wall
    If yBall <= 34 + (iLevel * 9) Then CheckIfHitBlock
    If yBall >= 176 - balSpeed Then CheckIfHit
    
    If yBall > 187 Then LoseLife
    Sound 30000, .2
    Circle (xBall, yBall), 3, 0, , , balPerspective 'erases old ball
    
    If balPerspective > 5 Then balPerspective = 0
    balPerspective = balPerspective + .5
    
    If balSpeed < normalspeed Then balSpeed = balSpeed + .01
    
    xBallPrev = xBall
    yBallPrev = yBall
    If (rBallAngle < -180) Then
        ResetBallAngle
    ElseIf (rBallAngle > 180) Then
        ResetBallAngle
    End If
    Select Case rBallAngle
        Case 180: yBall = yBall + balSpeed
        Case -180: yBall = yBall + balSpeed
        Case 0: yBall = yBall - balSpeed
        Case -90: xBall = xBall - balSpeed
        Case 90: xBall = xBall + balSpeed
        Case -179 To -91: xBall = xBall - (balSpeed * ((180 + rBallAngle) / 90)): yBall = yBall + (balSpeed * ((90 - (180 + rBallAngle)) / 90))
        Case 91 To 179: xBall = xBall + (balSpeed * ((180 - rBallAngle) / 90)): yBall = yBall + (balSpeed * ((90 - (180 - rBallAngle)) / 90))
        Case -89 To -1: xBall = xBall + (balSpeed * (rBallAngle / 90)): yBall = yBall - (balSpeed * ((90 + rBallAngle) / 90))
        Case 1 To 89: xBall = xBall + (balSpeed * (rBallAngle / 90)): yBall = yBall - (balSpeed * ((90 - rBallAngle) / 90))
    End Select
    'IF xBal = xBallPrev OR yBal = yBallPrev THEN rBallAngle = 0
    
    Circle (xBall, yBall), 3, 53, , , balPerspective
End Sub

Sub CheckIfHit
    Select Case xBall
        Case xPaddle + 24 To xPaddle + 72: Bounce (2) 'check if hit between ends of pad
        Case Else: LoseLife
    End Select
End Sub

Sub CheckIfHitBlock
    sector = Fix((xBall - 24) / 48) + 1
    'check for what block to smash:
    If sector < 1 Then sector = 1
    If sector > 6 Then sector = 6
    If (block(sector + 18) = 1) Then
        sinklevel = 66
        shot = sector + 18
    ElseIf (block(sector + 12) = 1) Then
        sinklevel = 57
        shot = sector + 12
    ElseIf (block(sector + 6) = 1) Then
        sinklevel = 48
        shot = sector + 6
    ElseIf (block(sector) = 1) Then
        sinklevel = 39
        shot = sector
    Else
        sinklevel = 30
        If yBall <= 30 + balSpeed Then ForceWinLevel
        shot = 0
        If won = 1 Then: ResetBall: GoTo skipbreak
    End If

    If yBall >= sinklevel + 4 + balSpeed Then GoTo skipbreak
    Call CheckIfHitBlockSide(sector)
    If shot = 0 GoTo skipbreak
    If yBall < sinklevel + 4 + balSpeed Then Bounce (0) 'sees if ball hit a block (some errors)
    If bSound = 0 Then cancelsound = 20000

    For iExploder = 24 To 1 Step -1
        Line (25 - iExploder + sector * 48, sinklevel - 9)-(25 - iExploder + sector * 48, sinklevel - 1), 0
        Sound 10000 - iExploder + cancelsound, .1
        Line (iExploder - 24 + sector * 48, sinklevel - 9)-(iExploder - 24 + sector * 48, sinklevel - 1), 0
        Sound 22337, .05
    Next iExploder

    If shot <> 0 Then block(shot) = 0
    'StartParticles (shot)
    DrawPanel
    balSpeed = balSpeed + .4
    DrawBlocksFast
    skipbreak:
End Sub

Sub CheckIfHitBlockSide (sec%)
    If yBall < sinklevel + 4 + balSpeed Then GoTo skipsidebounce
    If xBall <= ((sec% - 1) * 48) + 24 + balSpeed Then Bounce (-1) 'if hit right side of block, Bounce off it
    If xBall >= ((sec% - 1) * 48) + 72 - balSpeed Then Bounce (1) 'if hit right side of block, Bounce off it
    skipsidebounce:
End Sub

Sub DrawBackg
    Line (24, 24)-(311, 191), 0, BF
End Sub

Sub DrawBlocks
    If bSound = 0 Then cancelsound = 29040
    blockcol = 31
    blocknum = 0
    For blocky = 1 To 4
        For blockx = 1 To 6
            blockcol = blockcol + 1
            blocknum = blocknum + 1
            If (block(blocknum) = 1) Then
                Sound 40 * blockx * blocky + cancelsound, 1
                Line (((blockx - 1) * 48) + BlocksL, ((blocky - 1) * 9) + BlocksT)-((blockx * 48 - 1) + BlocksL, (blocky * 9) + BlocksT - 1), blockcol, BF 'medium colored box
                Line (((blockx - 1) * 48) + BlocksL, ((blocky - 1) * 9) + BlocksT)-((blockx * 48 - 1) + BlocksL, (blocky * 9) + BlocksT - 1), blockcol + 96, B 'underlay of light outline
                Line (((blockx - 1) * 48) + BlocksL, ((blocky - 1) * 9) + BlocksT)-(((blockx - 1) * 48) + BlocksL, (blocky * 9) + BlocksT - 2), blockcol + 48 'verticle dark line
                Line (((blockx - 1) * 48) + BlocksL, ((blocky - 1) * 9) + BlocksT)-((blockx * 48) + BlocksL - 2, ((blocky - 1) * 9) + BlocksT), blockcol + 48 'horizontal dark line
            Else
                Line (((blockx - 1) * 48) + BlocksL, ((blocky - 1) * 9) + BlocksT)-((blockx * 48 - 1) + BlocksL, (blocky * 9) + BlocksT - 1), 0, BF
            End If
        Next blockx
    Next blocky
End Sub

Sub DrawBlocksFast
    blockcol = 31
    blocknum = 0
    For blocky = 1 To 4
        For blockx = 1 To 6
            blockcol = blockcol + 1
            blocknum = blocknum + 1
            If (block(blocknum) = 1) Then
                Line (((blockx - 1) * 48) + BlocksL, ((blocky - 1) * 9) + BlocksT)-((blockx * 48 - 1) + BlocksL, (blocky * 9) + BlocksT - 1), blockcol, BF 'medium colored box
                Line (((blockx - 1) * 48) + BlocksL, ((blocky - 1) * 9) + BlocksT)-((blockx * 48 - 1) + BlocksL, (blocky * 9) + BlocksT - 1), blockcol + 96, B 'underlay of light outline
                Line (((blockx - 1) * 48) + BlocksL, ((blocky - 1) * 9) + BlocksT)-(((blockx - 1) * 48) + BlocksL, (blocky * 9) + BlocksT - 2), blockcol + 48 'verticle dark line
                Line (((blockx - 1) * 48) + BlocksL, ((blocky - 1) * 9) + BlocksT)-((blockx * 48) + BlocksL - 2, ((blocky - 1) * 9) + BlocksT), blockcol + 48 'horizontal dark line
            Else
                Line (((blockx - 1) * 48) + BlocksL, ((blocky - 1) * 9) + BlocksT)-((blockx * 48 - 1) + BlocksL, (blocky * 9) + BlocksT - 1), 0, BF
            End If
        Next blockx
    Next blocky
End Sub

Sub DrawPanel
    'panel border and panel
    Line (0, 0)-(319, 199), 21, B 'very outside
    Line (1, 1)-(318, 198), 24, B 'outside
    Line (2, 2)-(317, 5), 27, BF '    top gray portion
    Line (2, 6)-(21, 192), 27, BF '   left "    "
    Line (313, 6)-(317, 192), 27, BF '  right "    "
    Line (2, 193)-(317, 197), 27, BF ' bottom "    "
    Line (23, 6)-(312, 192), 21, B 'very inside
    Line (22, 5)-(313, 193), 24, B 'inside

    'controls on panel: (# of lasers, missiles, and the current level)
    If iLevel >= 2 Then Locate 1, 1: Color 12: Print lasers: Line (1, -1)-(24, 8), 73, B: Line (0, -1)-(25, 9), 121, B
    If iLevel >= 3 Then Locate 2, 1: Color 43: Print missiles: Line (1, -1)-(24, 16), 73, B: Line (0, -1)-(25, 17), 121, B
    Color 9: Locate 24, 1: Print iLevel;: Color 9: Locate 24, 1: Print "L";
    Line (-1, 183)-(22, 192), 73, B 'box around level number inside
    Line (-1, 182)-(23, 193), 121, B 'box around level number outside

    'life counter below:
    lifecolor = 41 + iLivesLeft * 3
    If iLivesLeft < 0 Then lifecolor = 16
    Color lifecolor: Locate 22, 1: Print iLivesLeft
    Line (-1, 167)-(22, 176), 73, B 'box around iLivesLeft inside border
    Line (-1, 166)-(23, 177), 121, B 'box around iLivesLeft outside border
End Sub

'SUB DrawParticles
'   FOR iGroup = 1 TO 24
'       IF barrParticleGroup(iGroup) THEN
'           iRemain = 0
'           FOR iParticle = 1 TO 108
'               'yParticle(iGroup,iParticle) '432 pixels in a block
'               'xParticle(iGroup,iParticle)
'               'powParticle(iGroup,iParticle)
'               'basecolorParticle(iGroup,iParticle)
'               'barrParticleGroup(iGroup)
'               IF powParticle(iGroup, iParticle) > 0 THEN
'                   PSET (xParticle(iGroup, iParticle), yParticle(iGroup, iParticle)), (basecolorParticle(iGroup, iParticle) - ((1! - powParticle(iGroup, iParticle)) * 14!))
'                   yParticle(iGroup, iParticle) = yParticle(iGroup, iParticle) + RND / 2
'                   xParticle(iGroup, iParticle) = xParticle(iGroup, iParticle) + RND / 2 + .1'blows off to the side
'                   powParticle(iGroup, iParticle) = powParticle(iGroup, iParticle) - (RND / 10 + .02)
'                   iRemain = iRemain + 1
'                   IF xParticle(iGroup, iParticle) >= xPixels OR yParticle(iGroup, iParticle) >= yPixels OR xParticle(iGroup, iParticle) < 0 OR yParticle(iGroup, iParticle) < 0 THEN
'                       powParticle(iGroup, iParticle) = 0
'                   END IF
'               END IF
'           NEXT iParticle
'           IF iRemain = 0 THEN
'               barrParticleGroup(iGroup) = 0
'           END IF
'       END IF
'   NEXT iGroup
'END SUB

Sub FireLaser
    sector = Fix((xPaddle + BlocksL) / 48) + 1
    If (block(sector + 18) = 1) Then
        sinklevel = 66
        shot = sector + 18
    ElseIf (block(sector + 12) = 1) Then
        sinklevel = 57
        shot = sector + 12
    ElseIf (block(sector + 6) = 1) Then
        sinklevel = 48
        shot = sector + 6
    ElseIf (block(sector) = 1) Then
        sinklevel = 39
        shot = sector
    Else
        sinklevel = 7
        shot = 0
    End If

    If shot = 0 GoTo skipfire
    If bSound = 0 Then cancelsound = 22300

    For fire = 1 To 8
        Line (48 + xPaddle, 179)-(48 + xPaddle, sinklevel), 12
        Sound 700 * (fire + 2) + cancelsound, .5
        Line (48 + xPaddle, 179)-(48 + xPaddle, sinklevel), 0
        Sound 37 + cancelsound, .1
    Next fire
    For iExploder = 9 To 1 Step -1
        Line (24 + (sector * 48) - 48, sinklevel - 10 + iExploder)-(23 + (sector * 48), sinklevel - 10 + iExploder), 12
        Sound 700 * (iExploder + 2) + cancelsound, .2
        Line (24 + (sector * 48) - 48, sinklevel - 10 + iExploder)-(23 + (sector * 48), sinklevel - 10 + iExploder), 0
        Sound 37 + cancelsound, .1
    Next iExploder
    If shot <> 0 Then block(shot) = 0
    lasers = lasers - 1
    DrawPanel
    skipfire:
End Sub

Sub FireMissile
    sector = Fix((xPaddle + BlocksL) / 48) + 1
    If (block(sector + 18) = 1) Then
        sinklevel = 66
        shot = sector + 18
    ElseIf (block(sector + 12) = 1) Then
        sinklevel = 57
        shot = sector + 12
    ElseIf (block(sector + 6) = 1) Then
        sinklevel = 48
        shot = sector + 6
    ElseIf (block(sector) = 1) Then
        sinklevel = 39
        shot = sector
    Else
        sinklevel = 7
        shot = 0
    End If

    If shot = 0 GoTo skipfiremisl
    If bSound = 0 Then cancelsound = 22300

    'shoot missile:
    For fire = 167 To sinklevel - 18 Step -1
        Put (40 + xPaddle, fire), item2icon(), Or
        Sound 47 + cancelsound, .2
        Put (40 + xPaddle, fire), item2icon(), Xor
    Next fire
 
    Put (40 + xPaddle, sinklevel - 18), item2icon(), Or
    Sound 700 + cancelsound, 1
    Put (40 + xPaddle, sinklevel - 18), item2icon(), Xor

    'explode 1st block:
    For iExploder = 24 To 1 Step -1
        Line (iExploder - 25 + sector * 48, sinklevel - 9)-(iExploder - 25 + sector * 48, sinklevel - 1), 0
        Sound (70 * (iExploder + 2)) + cancelsound, .1
        Line (24 - iExploder + sector * 48, sinklevel - 9)-(24 - iExploder + sector * 48, sinklevel - 1), 0
        Sound iExploder + 37 + cancelsound, .05
    Next iExploder
    If shot <> 0 Then block(shot) = 0
    If block(shot - 6) <> 1 Then: GoTo skip2ndBlock

    'explode 2nd block:
    For iExploder = 24 To 1 Step -1
        Line (iExploder - 25 + sector * 48, sinklevel - 18)-(iExploder - 25 + sector * 48, sinklevel - 10), 0
        Sound (70 * (iExploder + 2)) + cancelsound, .1
        Line (24 - iExploder + sector * 48, sinklevel - 18)-(24 - iExploder + sector * 48, sinklevel - 10), 0
        Sound iExploder + 37 + cancelsound, .05
    Next iExploder
    If shot <> 0 Then block(shot - 6) = 0 'if block is not gone, make it gone (the block 6 earlier than the current one is the block behind it)
    skip2ndBlock:
    missiles = missiles - 1
    DrawPanel
    skipfiremisl:
End Sub

Sub ForceWinLevel
    iLevel = iLevel + 1
    Select Case iLevel
        Case 2: winL1: setL2
        Case 3: winL2: setL3
        Case 4: winL3: setL4
        Case Else: winL4: winitmessage: littlewinsound: normalspeed = normalspeed + 1: won = 1: If normalspeed > 4 Then winshow
    End Select
End Sub

Sub littlewinsound
    If bSound = 0 Then cancelsound = 30000
    Sound 150 + cancelsound, 6
    Sound 200 + cancelsound, 1
    Sound 300 + cancelsound, 1
    Sound 450 + cancelsound, 1
    Sound 600 + cancelsound, 4
    Sound 300 + cancelsound, 4
    Sound 350 + cancelsound, 1
    Sound 450 + cancelsound, 1
    Sound 550 + cancelsound, 1
    Sound 600 + cancelsound, 5
    Sound 450 + cancelsound, 3
    Sound 400 + cancelsound, 2
    Sound 30000, 5
    Sound 400 + cancelsound, 4
    Sound 350 + cancelsound, 4
    Sound 300 + cancelsound, 4
End Sub

Sub LoseLife
    iLivesLeft = iLivesLeft - 1: ResetBall
    Line (BlocksL + xPaddle, 180)-((BlocksL + 47) + xPaddle, 191), 0, BF 'erase old
    xPaddle = 114
    MoveBy (0)
    'CheckBall
    If bSound = 0 Then cancelsound = 29953
    Sound 47 + cancelsound, 9
    For pitch = 47 To 37 Step -1
        Sound pitch + cancelsound, .1
    Next pitch
    DrawPanel
    Sound 37 + cancelsound, 9
    If autoplay = 1 Then
        Sleep 2
    Else
        Sleep 0
    End If
End Sub

Sub MoveBy (x%)
    sector = Fix((xPaddle + BlocksL) / 48) + 1 'finds what block (sector) the paddle is under (1 to 6)
    perspective = 6 - sector

    Line (BlocksL + xPaddle, 180)-((BlocksL + 47) + xPaddle, 191), 0, BF 'erase old
    xPaddle = xPaddle + x%
    If xPaddle > MaxPaddle Then xPaddle = MaxPaddle
    If xPaddle < MinPaddle Then xPaddle = MinPaddle
    
    Line (BlocksL + xPaddle + perspective, 180)-((BlocksL + 42) + xPaddle + perspective, 188), 2, B 'back square
    Line (BlocksL + xPaddle + perspective, 188)-(BlocksL + xPaddle, 191), 2 'left dark green line
    Line ((BlocksL + 42) + xPaddle + perspective, 188)-((BlocksL + 47) + xPaddle, 191), 2 'right dark green line
    Line (BlocksL + xPaddle, 182)-((BlocksL + 47) + xPaddle, 191), 10, B 'front square
    Line (BlocksL + xPaddle + perspective, 180)-((BlocksL + 42) + xPaddle + perspective, 180), 4 'top red line
    Line (BlocksL + 1 + xPaddle, 181)-((BlocksL + 46) + xPaddle, 181), 12 'bottom red line
End Sub

Sub ResetBall
    Circle (xBall, yBall), 3, 0, , , balPerspective 'erases old ball
    balPerspective = 0
    xBall = 162
    yBall = 150
    balSpeed = 0
    Randomize Timer
    direction = Int(Rnd * 2) + 1
    angle = Int(Rnd * 44) + 11
    If direction = 1 Then rBallAngle = angle
    If direction = 2 Then rBallAngle = -angle
End Sub

Sub ResetBallAngle
    Circle (xBall, yBall), 3, 0, , , balPerspective 'erases old ball
    balPerspective = 0
    'xBall = 162
    yBall = yBall + 20
    balSpeed = 0
    Randomize Timer
    direction = Int(Rnd * 2) + 1
    angle = Int(Rnd * 44) + 11
    If direction = 1 Then rBallAngle = angle
    If direction = 2 Then rBallAngle = -angle
End Sub

Function SafeMod% (iNum%, iDiv%)
    If iNum% > iDiv% Then
        rTemp! = iNum% / iDiv% ' i.e. 18/10
        iTemp% = Int(rTemp!)
        rTest! = iTemp%
        If rTest! > rTemp! Then 'avoid any automatic rounding
            iTemp% = iTemp% - 1
        Else
            iTemp% = iTemp%
        End If
        SafeMod% = iNum% - (iTemp% * iDiv%) 'i.e. 18 - 1*10 = 8
    ElseIf iNum% = iDiv% Then
        SafeMod% = 0
    Else
        SafeMod% = iNum%
    End If
End Function

Sub setL1
    For blocknum = 1 To 6
        block(blocknum) = 1
    Next blocknum
    For blocknum = 7 To 24
        block(blocknum) = 0
    Next blocknum
    'Item to win below (laser)
    Line (135 + BlocksL, 8)-(152 + BlocksL, 22), 0, BF 'black fill box
    Line (135 + BlocksL, 8)-(152 + BlocksL, 22), 4, B 'outside box
    Line (142 + BlocksL, 21)-(142 + BlocksL, 11), 12 'laser from bottom to top
    'shades of gray for laser gun icon:
    Line (142 + BlocksL, 19)-(142 + BlocksL, 21), 8
    Line (141 + BlocksL, 19)-(141 + BlocksL, 21), 24
    Line (143 + BlocksL, 19)-(143 + BlocksL, 21), 7
    Line (142 + BlocksL, 17)-(142 + BlocksL, 19), 7
    Locate 3, 24: Color 12: Print "laser"
    DrawBlocks
End Sub

Sub setL2
    lasers = 2
    ResetBall
    For blocknum = 1 To 12
        block(blocknum) = 1
    Next blocknum
    For blocknum = 13 To 24
        block(blocknum) = 0
    Next blocknum
    DrawPanel
    'item to win below (missile launcher, item 2)
    Line (135 + BlocksL, 8)-(152 + BlocksL, 22), 139, B 'outside box
    'Missile body
    'Outer dark part
    PSet (144 + BlocksL, 9), 22
    Line (141 + BlocksL, 11)-(147 + BlocksL, 19), 22, B
    Line (142 + BlocksL, 10)-(146 + BlocksL, 20), 22, B
    'Inner light part
    PSet (142 + BlocksL, 11), 25
    PSet (146 + BlocksL, 11), 25
    PSet (144 + BlocksL, 10), 26
    Line (142 + BlocksL, 11)-(146 + BlocksL, 19), 27, BF
    Line (144 + BlocksL, 11)-(146 + BlocksL, 14), 29, BF
    'Fire on bottom
    'Missile fins
    'Left fin
    Line (138 + BlocksL, 20)-(138 + BlocksL, 21), 20
    Line (139 + BlocksL, 18)-(139 + BlocksL, 20), 20
    Line (140 + BlocksL, 17)-(140 + BlocksL, 19), 20
    'Middle fin
    Line (144 + BlocksL, 16)-(144 + BlocksL, 21), 20
    'Right fin
    Line (148 + BlocksL, 17)-(148 + BlocksL, 19), 20
    Line (149 + BlocksL, 18)-(149 + BlocksL, 20), 20
    Line (150 + BlocksL, 20)-(150 + BlocksL, 21), 20
    Locate 3, 24: Color 43: Print "missile launcher"
    DrawBlocks
End Sub

Sub setL3
    missiles = 2
    ResetBall
    For blocknum = 1 To 18
        block(blocknum) = 1
    Next blocknum
    For blocknum = 19 To 24
        block(blocknum) = 0
    Next blocknum
    DrawPanel
    'item to win below (level warp)
    For lines = 0 To 7
        Line (144 + BlocksL + lines, 9)-(144 + BlocksL + lines, 22), (lines + 21)
    Next lines
    For lines = 15 To 8 Step -1
        Line (127 + BlocksL + lines, 9)-(127 + BlocksL + lines, 22), (36 - lines)
    Next lines
    For circles = 0 To 8 Step 2
        Circle (143 + BlocksL, 15), circles, circles + 20, , , -2.1
    Next circles
    Line (135 + BlocksL, 8)-(152 + BlocksL, 22), 54, B 'outside

    Locate 3, 24: Color 9: Print "Warp last level!"
    DrawBlocks
End Sub

Sub setL4
    ResetBall
    For blocknum = 1 To 24
        block(blocknum) = 1
    Next blocknum
    DrawPanel
    'item to win below (stage warp)
    For lines = 0 To 7
        Line (144 + BlocksL + lines, 9)-(144 + BlocksL + lines, 22), (lines + 21)
    Next lines
    For lines = 15 To 8 Step -1
        Line (127 + BlocksL + lines, 9)-(127 + BlocksL + lines, 22), (36 - lines)
    Next lines
    For circles = 0 To 8 Step 2
        Circle (143 + BlocksL, 15), circles, circles + 20, , , -2.1
    Next circles
    Line (135 + BlocksL, 8)-(152 + BlocksL, 22), 54, B 'outside

    If normalspeed + 1 < 5 Then
        Locate 3, 24: Color 9: Print "Warp to stage"; normalspeed + 1
    Else
        Locate 3, 24: Color 9: Print "Win the Game!   "
    End If
    DrawBlocks
End Sub

Sub ShowTitle
    '18.2 ticks is a second
    sndRnd = 100
    tisound = 0
    Locate 20, 6: Color 15: Print "H";: Color 79: Print "elp"
    Color 79
    Locate 21, 8: Print "press a key..."
    fastmusic = 0
    getfast = 0
    cancelsound = 0
    If bSound = 0 Then cancelsound = 30000
    Do
        getfast = getfast + 1
        If getfast > 16 Then fastmusic = 1
        If fastmusic = 0 Then Sleep 1
        If (sndRnd = 400) Then
            Sound 37 + cancelsound, 1
        Else
            Sound 550 + sndRnd + tisound + cancelsound, 2.5
        End If
        sndRnd = sndRnd + 100
        If sndRnd > 400 Then sndRnd = 100
        If (tisound = 400) Then
            tisound = 0
        Else
            tisound = tisound + 100
        End If

   
        'first changes alternating color
        If (ticol = 3) Then
            ticol = 0
        Else
            ticol = ticol + 1
        End If

        If (ticol = 1) Then
            Locate 12, 9: Color 9: Print "--Super Mega Break!-"
        ElseIf (ticol = 2) Then
            Locate 12, 9: Color 12: Print "--Super Mega Break!-"
        Else
            Locate 12, 9: Color 10: Print "--Super Mega Break!-"
        End If
    Loop Until InKey$ <> ""
End Sub

'SUB StartParticles (iBlockNow%)
'   RANDOMIZE TIMER
'   'blocks are 48x9 = 432 pixels in a block
'   'there are 6x4 (24) blocks possible
'   'xOff% = BlocksL
'   'RectWidth = BlocksW - BlocksL
'   xOff% = SafeMod%((iBlockNow * 48), BlocksW) + BlocksL
'   yOff% = (iBlockNow / 6 * 9) + BlocksT
'   xRel% = 0
'   yRel% = 0
'   FOR iParticle% = 1 TO 108
'       yParticle(iBlockNow%, iParticle%) = yRel + yOff
'       xParticle(iBlockNow%, iParticle%) = xRel + xOff
'       powParticle(iBlockNow%, iParticle%) = 1!
'       basecolorParticle(iBlockNow%, iParticle%) = 164'goes backward 14 while decaying
'       barrParticleGroup(iBlockNow%) = 1
'       xRel% = xRel% + 1
'       IF xRel% > 48 THEN
'           xRel% = 0
'           yRel% = yRel% + 9
'       END IF
'   NEXT iParticle%
'END SUB

Sub winitmessage
    If autoplay = 0 Then
        Color 11
        Locate 12, 6
        Print "You win, good job!"
        Locate 13, 6
        Print " you're quick !!!!!            "
    Else
        Color 11
        Locate 12, 6
        Print "You win, good job."
        Locate 13, 6
        Print "                Cheater!!!     "
    End If
End Sub

Sub winL1
    Get (136 + BlocksL, 9)-(151 + BlocksL, 21), item1icon()
    Line (136 + BlocksL, 9)-(151 + BlocksL, 21), 0, BF 'erase

    For Yplace = 39 + (iLevel * 9) To 165
        Put (xPaddle + 39, Yplace), item1icon()
        Sound 30000, .5
        Line (xPaddle + 39, Yplace)-(xPaddle + 56, Yplace + 14), 0, BF
    Next Yplace
End Sub

Sub winL2
    Get (136 + BlocksL, 9)-(151 + BlocksL, 21), item2icon()
    Line (136 + BlocksL, 9)-(151 + BlocksL, 21), 0, BF 'erase

    For Yplace = 39 + (iLevel * 9) To 165
        Put (xPaddle + 39, Yplace), item2icon()
        Sound 30000, .5
        Line (xPaddle + 39, Yplace)-(xPaddle + 56, Yplace + 14), 0, BF
    Next Yplace
End Sub

Sub winL3
    Get (135 + BlocksL, 8)-(152 + BlocksL, 22), item3icon()
    Line (135 + BlocksL, 8)-(152 + BlocksL, 22), 0, BF 'erase
    Put (150, 99), item3icon()

    If normalspeed > 3 Then
        Locate 7, 5: Color 9: Print "Get ready for the last   "
        Locate 8, 5: Color 9: Print "     level in the game!  "
    Else
        Locate 7, 5: Color 9: Print "Here comes the last level"
        Locate 8, 5: Color 9: Print " of stage "; normalspeed; "!          "
    End If
    Line (31, 47)-(232, 63), 73, B 'green border inside
    Line (30, 46)-(233, 64), 121, B 'green border outside

    If autoplay = 1 Then
        Sleep 2
    Else
        Sleep 0
    End If
    If bSound = 0 Then cancelsound = 29447
    'code for warp:
    Do
        factor = factor + 1
        outness = outness + factor
        Line (150 - outness, 99 - outness)-(167 + outness, 113 + outness), 54, B
        Line (151 - outness, 100 - outness)-(166 + outness, 112 + outness), 0, BF
        Circle (158, 106), outness, 21 + Int(factor / 2)
        Circle (158, 106), Int(outness / 2), 21 + Int(factor / 2)
        Circle (158, 106), Int(outness / 3), 21 + Int(factor / 3)
        Circle (158, 106), Int(outness / 4), 21 + Int(factor / 4)
        Circle (158, 106), Int(outness / 5), 21 + Int(factor / 5)
        Circle (158, 106), Int(outness / 6), 21 + Int(factor / 6)
        Sound 400 + outness + cancelsound, 1
        Line (150 - outness, 99 - outness)-(167 + outness, 113 + outness), 0, B
    Loop Until outness > 150
    factor = 0
    outness = 0
    'erase circles:
    Do
        factor = factor + 1
        outness = outness + factor
        Circle (158, 106), outness, 0
        Circle (158, 106), Int(outness / 2), 0
        Circle (158, 106), Int(outness / 3), 0
        Circle (158, 106), Int(outness / 4), 0
        Circle (158, 106), Int(outness / 5), 0
        Circle (158, 106), Int(outness / 6), 0
    Loop Until outness > 150

End Sub

Sub winL4
    Get (135 + BlocksL, 8)-(152 + BlocksL, 22), item3icon()
    Line (135 + BlocksL, 8)-(152 + BlocksL, 22), 0, BF 'erase
    Put (150, 99), item3icon()

    If bSound = 0 Then cancelsound = 29447
    'code for warp:
    Do
        factor = factor + 1
        outness = outness + factor
        Line (150 - outness, 99 - outness)-(167 + outness, 113 + outness), 54, B
        Line (151 - outness, 100 - outness)-(166 + outness, 112 + outness), 0, BF
        Circle (158, 106), outness, 21 + Int(factor / 2)
        Circle (158, 106), Int(outness / 2), 21 + Int(factor / 2)
        Circle (158, 106), Int(outness / 3), 21 + Int(factor / 3)
        Circle (158, 106), Int(outness / 4), 21 + Int(factor / 4)
        Circle (158, 106), Int(outness / 5), 21 + Int(factor / 5)
        Circle (158, 106), Int(outness / 6), 21 + Int(factor / 6)
        Sound 400 + outness + cancelsound, 1
        Line (150 - outness, 99 - outness)-(167 + outness, 113 + outness), 0, B
    Loop Until outness > 150
    factor = 0
    outness = 0
    'erase circles:
    Do
        factor = factor + 1
        outness = outness + factor
        Circle (158, 106), outness, 0
        Circle (158, 106), Int(outness / 2), 0
        Circle (158, 106), Int(outness / 3), 0
        Circle (158, 106), Int(outness / 4), 0
        Circle (158, 106), Int(outness / 5), 0
        Circle (158, 106), Int(outness / 6), 0
    Loop Until outness > 150

End Sub

Sub winshow
    Cls
    Color 14
    Sound 30000, 30
    Print "     YOU ARE THE ULTIMATE CHAMPION!     "
    Print "                                        "
    If bSound = 1 Then
        Sound 400, 3: Sound 600, 4: Sound 450, 5: Sound 600, 8: Sound 300, .1: Sound 200, 2
    Else
        Sound 30000, 30
    End If
    Print
    Print
    Print
    Print
    Print
    Print
    Print
    Print
    Print
    Color 9
    Print "Tell Jake you won...                    "
    Print "         and he might give you a nickel!"
    If bSound = 1 Then
        Sound 30000, 5
        Sound 200, 2
        Sound 30000, .5
        Sound 200, 2
        Sound 30000, .5
        Sound 200, 2
        Sound 30000, .5
        Sound 200, 2
        Sound 30000, 30
    Else
        Sound 30000, 30
    End If
    If autoplay = 0 Then
        Color 8: Locate 3, 1: Print "Secret: during game, hold down ALT key  "
        Color 8: Locate 4, 1: Print " while typing 1 7 7 for autoplay. "
    Else
        Locate 1, 1: Color 2: Print "     YOU ARE THE ULTIMATE CHAMPION "
        Locate 3, 1: Color 10: Print "...NOT! Try to beat it without cheating!"
        Locate 5, 1: Color 8: Print "Except for this cheat: hold down ALT    "
        Locate 6, 1: Color 8: Print "   key and type 1 7 8 for faster Paddle."
    End If
    Sleep 15

    System
End Sub


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
Dim Shared xguy As Integer
Dim Shared yguy As Integer
Dim Shared bomount As Integer
Dim Shared xbomb(1 To 20) As Integer
Dim Shared ybomb(1 To 20) As Integer
Dim Shared bombsleft As Integer
Dim Shared lives As Integer
Dim Shared dirc$
Dim Shared sound$
Dim Shared exable%
Dim Shared watime As Long
Open "qjak.ini" For Input As #1
Line Input #1, progdir$
Close
For charnow = 1 To Len(progdir$)
    If Mid$(progdir$, charnow, 1) = "=" Then GoTo SPLITHERE
Next charnow
SPLITHERE:
progdir$ = Right$(progdir$, Len(progdir$) - (charnow)) 'this is correct since STARTS at right
ChDir (progdir$)

Open "BSOUND.DAT" For Input As #1
Line Input #1, sound$
Close

Screen 13
Cls

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
Do
    slide
    Select Case InKey$
        Case Chr$(0) + "K": moveleft: checkbomb: dirc$ = "left"
        Case Chr$(0) + "M": moveright: checkbomb: dirc$ = "right"
        Case Chr$(0) + "H": moveup: checkbomb: dirc$ = "up"
        Case Chr$(0) + "P": movedown: checkbomb: dirc$ = "down"
        Case "s": switchsound
        Case Chr$(13): shoot
        Case Chr$(27): Exit Do
        Case Else: GoTo redo
    End Select
Loop

Chain "SPHMENU.BAS"
End
exub:
exable% = 1
Return

Sub checkbomb

    For bomnum = 1 To 20
        If (Abs(xguy - xbomb(bomnum)) < 15) And (Abs(yguy - ybomb(bomnum)) < 13) Then
            explode
        Else
        End If
    Next bomnum

    If (bombsleft < 1) Then
        win
    Else
    End If

End Sub

Sub delay
    On Timer(3) GoSub exub
    Timer On
    exable% = 0
    Do
    Loop Until exable% = 1
End Sub

Sub drawbombs
    For bomnum = 1 To 20
        Circle (xbomb(bomnum), ybomb(bomnum)), 2, 113
        Circle (xbomb(bomnum), ybomb(bomnum)), 4, 113
        Circle (xbomb(bomnum), ybomb(bomnum)), 3, 4
    Next bomnum
End Sub

Sub drawguy

    outness = 10
    outadd = .1
    'LINE (xguy - 11, yguy - 11)-(xguy + 11, yguy + 11), 16, BF
    Circle (xguy, yguy), 11, 16
    drawbombs
    For i = 16 To 31 Step 3
        Circle (xguy, yguy), Int(outness), i
        Paint (xguy, yguy), i
        outness = outness - outadd
        outadd = outadd + .3
    Next i

    Locate 1, 20
    Print lives; " lives left"

End Sub

Sub explode

    'explode guy
    colour = 40
    For i = 1 To 20
        Select Case sound$
            Case "1": Sound 100 - i, .3
            Case "0": Sound 24000, .3
        End Select
        Circle (xguy, yguy), i, Int(colour)
        colour = colour + .2
    Next i
    'erase explosion
    For i = 20 To 1 Step -1
        Select Case sound$
            Case "1": Sound 80 - i, .3
            Case "0": Sound 24000, .3
        End Select
        Circle (xguy, yguy), i, 16 'color 16 is black
    Next i


    'lose life and if out of lives you lose
    lives = lives - 1
    If (lives < 1) Then
        Screen 0
        Color 20
        Locate 10, 15
        Print "YOU LOSE"
        Select Case sound$
            Case "1": Sound 80, 10: Sound 60, 15
            Case "0": Sound 24000, 10: Sound 20000, 15
        End Select
        Color 15
        i = 0
        Locate 2, 1
        Print watime
        delay
        Chain "SPHMENU.BAS"
    Else
    End If

    'move guy to starting place
    xguy = 10
    yguy = 10
    drawguy

End Sub

Sub laybombs
    For bomnum = 1 To 20
        xbomb(bomnum) = Int((Rnd * 224) + 25)
        ybomb(bomnum) = Int((Rnd * 174) + 25)
    Next bomnum

    For i = 1 To 20
        For radius = 1 To 3
            Select Case sound$
                Case "1": Sound 60 + (radius * 3), .3
                Case "0": Sound 20000, .3
            End Select
       
            Circle (xbomb(i), ybomb(i)), radius, 4
            Circle (xbomb(i), ybomb(i)), radius - 1, 16
        Next radius
        Circle (xbomb(i), ybomb(i)), 2, 113
        Circle (xbomb(i), ybomb(i)), 4, 113
        Circle (xbomb(i), ybomb(i)), 3, 4
    Next i

End Sub

Sub movedown
    yguy = yguy + 1: If yguy > 189 Then yguy = 189
    drawguy
End Sub

Sub moveleft
    xguy = xguy - 1: If xguy < 10 Then xguy = 10
    drawguy
End Sub

Sub moveright
    xguy = xguy + 1: If xguy > 309 Then xguy = 309
    drawguy
End Sub

Sub moveup
    yguy = yguy - 1: If yguy < 10 Then yguy = 10
    drawguy
End Sub

Sub setbombs
    Randomize Timer
    For bomnum = 1 To 20
        xbomb(bomnum) = Int((Rnd * 224) + 25)
        ybomb(bomnum) = Int((Rnd * 174) + 25)
    Next bomnum
End Sub

Sub shoot

    For locbomb = 1 To 20
        If (Abs(xguy - xbomb(locbomb)) < 20) And (Abs(yguy - ybomb(locbomb)) < 20) Then
            Line (xguy, yguy)-(xbomb(locbomb), ybomb(locbomb)), 4
            For i = 1 To 20
                Select Case sound$
                    Case "1": Sound 100 + i, .3
                    Case "0": Sound 24000, .3
                End Select
            Next i
            Line (xguy, yguy)-(xbomb(locbomb), ybomb(locbomb)), 16
            For i = 1 To 20
                Circle (xbomb(locbomb), ybomb(locbomb)), i, 4
                Select Case sound$
                    Case "1": Sound 100 + i, .3
                    Case "0": Sound 24000, .3
                End Select
           
            Next i
   
            For i = 20 To 1 Step -1
                Circle (xbomb(locbomb), ybomb(locbomb)), i, 16
                Select Case sound$
                    Case "1": Sound 110 - i, .3
                    Case "0": Sound 24000, .3
                End Select
            Next i
            xbomb(locbomb) = -10
            ybomb(locbomb) = -10
            bombsleft = bombsleft - 1
            drawguy
        Else
        End If
    Next locbomb

End Sub

Sub slide
    Select Case sound$
        Case "1": Sound 40, .3
        Case "0": Sound 20000, .3
    End Select

    checkbomb
    If dirc$ = "left" Then
        moveleft
    ElseIf dirc$ = "right" Then
        moveright
    ElseIf dirc$ = "up" Then
        moveup
    ElseIf dirc$ = "down" Then
        movedown
    Else Exit Sub
    End If
End Sub

Sub switchsound

    Open "BSOUND.DAT" For Output As #1
    Select Case sound$
        Case "0": Print #1, "1": sound$ = "1"
        Case "1": Print #1, "0": sound$ = "0"
    End Select
    Close

End Sub

Sub win

    Screen 0
    Color 30
    Locate 10, 15
    Print "YOU  WIN"

    For i = 1 To 10
        For j = 700 To 750
            Sound j + (i * 8), .05
        Next j
    Next i

    soundpitch = 830

    For k = 0 To 20
        Select Case sound$
            Case "1": Sound soundpitch, .2
            Case "0": Sound 24000, .2
        End Select
        soundpitch = soundpitch + k
    Next k

    Sleep 3
    Chain "SPHMENU.BAS"
End Sub


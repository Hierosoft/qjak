'revision 2.1
DECLARE SUB switchsound ()
DECLARE SUB laybombs ()
DECLARE SUB ChoseSoGo ()
DECLARE SUB usemenu ()
DECLARE SUB refreshmenubox ()
DECLARE SUB refreshmenu ()
DECLARE SUB intro ()
DECLARE SUB delaye ()
Dim Shared tone
Dim Shared menuitem$(1 To 3)
Dim Shared seltext As Integer
Dim Shared sound$
Open "qjak.ini" For Input As #1
Line Input #1, progdir$
Close
For charnow = 1 To Len(progdir$)
    If Mid$(progdir$, charnow, 1) = "=" Then GoTo SPLITHERE
Next charnow
SPLITHERE:
progdir$ = Right$(progdir$, Len(progdir$) - (charnow)) 'this is correct since STARTS at right
ChDir (progdir$)

Open "bsound.dat" For Input As #1
Line Input #1, sound$
Close

Cls

'colors #16-31 is grayscale black to white in 256 colors (screen 13 mode)

Screen 13

laybombs
intro
Sleep 1
delaye

menuitem$(1) = "Play"
menuitem$(2) = "Help"
menuitem$(3) = "Quit"
usemenu

Chain ("QJAKMENU.BAS")
End

Sub ChoseSoGo
    Select Case seltext
        Case 1: Chain "SPHEROID.BAS"
        CASE 2: CLS : PRINT "Made by Jake Gustafson": COLOR 3: PRINT : PRINT "1.  Use arrow keys to move sphere": PRINT "2.  Enter shoots when near land mine": PRINT "3.  Escape quits": PRINT : COLOR 15: PRINT "Press any other key to continue...":  _
SLEEP 0: CLS : laybombs: usemenu
        Case 3: Exit Sub
        Case Else: Return
    End Select
End Sub

Sub delaye
    Select Case sound$
        Case "1": Sound tone, .4
        Case "0": Sound 20000, .4
    End Select
    tone = tone + colour

End Sub

Sub intro

    tone = 40
    outness = 30
    outadd = .5
    center = 150
    centeradd = 3.4
    Sleep 1
    Screen 13
    For colour = 16 To 31
        Circle (center, center), outness, colour
        Paint (center, center), colour
        center = center - centeradd
        centeradd = centeradd - .3
        outness = outness - outadd
        outadd = outadd + .2
        delaye
    Next colour

End Sub

Sub laybombs

    For i = 1 To 30
        currentbombx = Int((Rnd * 319) + 1)
        currentbomby = Int((Rnd * 199) + 1)
        For radius = 1 To 3
            Select Case sound$
                Case "1": Sound 60 + (radius * 3), .3
                Case Else: Sound 20000, .3
            End Select
            Circle (currentbombx, currentbomby), radius, 4
            Circle (currentbombx, currentbomby), radius - 1, 16
        Next radius
        Circle (currentbombx, currentbomby), 2, 113
        Circle (currentbombx, currentbomby), 4, 113
        Circle (currentbombx, currentbomby), 3, 4
    Next i

End Sub

Sub refreshmenu

    For drawchoices = 1 To 3
        If (seltext = drawchoices) Then
            Locate 8 + drawchoices + drawchoices, 18
            Color 34
            Print menuitem$(drawchoices); "!"
        Else
            Locate 8 + drawchoices + drawchoices, 18
            Color 15
            Print menuitem$(drawchoices); " "
        End If

    Next drawchoices

End Sub

Sub refreshmenubox

    bordlx = 99
    bordly = 50
    bordrx = 219
    bordry = 150

    For bordre = 17 To 21
        Line (bordlx, bordly)-(bordrx, bordry), bordre, BF
        bordlx = bordlx + 1
        bordly = bordly + 1
        bordrx = bordrx - 1
        bordry = bordry - 1
    Next bordre
    bordlx = bordlx + 1
    bordly = bordly + 1
    bordrx = bordrx - 1
    bordry = bordry - 1
    Line (bordlx, bordly)-(bordrx, bordry), 0, BF

End Sub

Sub switchsound

    Open "bsound.dat" For Output As #1
    Select Case sound$
        Case "0": Print #1, "1": sound$ = "1"
        Case "1": Print #1, "0": sound$ = "0"
    End Select
    Close
End Sub

Sub usemenu

    menuitem$(1) = "Play"
    menuitem$(2) = "Help"
    menuitem$(3) = "Quit"
    seltext = 1

    refreshmenubox
    Locate 2, 11
    Print "S P H E R O I D";
    Color 43
    Print "  2.1"
    rechoose:
    refreshmenu
    Select Case InKey$
        Case Chr$(0) + "H": seltext = seltext - 1: If seltext < 1 Then seltext = 3: refreshmenu
        Case Chr$(0) + "P": seltext = seltext + 1: If seltext > 3 Then seltext = 1: refreshmenu
        Case "s": switchsound:
        Case Chr$(13): ChoseSoGo: Exit Sub
        Case "": Sleep 0
        Case Else: GoTo rechoose
    End Select
    GoTo rechoose
End Sub


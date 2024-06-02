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
Dim Shared selGame
Dim Shared pJakDraw(1 To 1716)
Dim Shared pJakSound(1 To 1716)
Dim Shared pSpheroid(1 To 1716)
Dim Shared sph$(1 To 8)
Dim exitr$(0 To 22)
Open "qjak.ini" For Input As #1
Line Input #1, progdir$
Close
For charnow = 1 To Len(progdir$)
    If Mid$(progdir$, charnow, 1) = "=" Then GoTo SPLITHERE
Next charnow
SPLITHERE:
progdir$ = Right$(progdir$, Len(progdir$) - (charnow)) 'this is correct since STARTS at right
Cls
Screen 13
Locate 1, 1
Print progdir$
ChDir (progdir$)
selGame = 1

'check sound setting
Open "bsound.dat" For Input As #1
Line Input #1, sound$
Close

Cls
getJakDraw
Cls
getJaksound
Cls
getSpheroid
Cls
start:
drawSpheroid
drawJaksound
drawJakDraw


Rings
Locate 2, 7
Color 32
Print "QJak  Entertainment Pack 2.2"
refmenu
drawJaksound
drawSpheroid
drawJakDraw
changeSel (0)
selection:
Do
    Select Case InKey$
        Case Chr$(0) + "K": changeSel (-1)
        Case Chr$(0) + "M": changeSel (1)
        Case "h": help: GoTo start
        Case "H": help: GoTo start
        Case Chr$(27): Exit Do
        Case Chr$(13): Enter
        Case "": Sleep 0
        Case Else: GoTo selection
    End Select
Loop

exitscreen:
Cls
Color 54
Locate 4, 9
Print "Thank you for using Qjak"
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
Locate 12, 14

For i = 0 To 12
    Select Case sound$
        Case "0": Sound 20000, .5
        Case "1": Sound 100 + 7 * i, .5
    End Select
    Color i + 32
    Print exitr$(i);
Next i
Sleep 2
System

Sub changeSel (x)

    Line (50 + (selGame * 74), 50)-(121 + (selGame * 74), 149), 0, B

    selGame = selGame + x
    If (selGame < 0) Then
        selGame = 0
    ElseIf (selGame > 2) Then
        selGame = 2
    End If
    colo = ((Rnd * 247) + 1)
    Line (50 + (selGame * 74), 50)-(121 + (selGame * 74), 149), 40, B

End Sub

Sub drawJakDraw
    Put (51, 51), pJakDraw(), PSet
End Sub

Sub drawJaksound

    Put (125, 51), pJakSound(), PSet

End Sub

Sub drawSpheroid
    Put (201, 51), pSpheroid(), PSet
End Sub

Sub Enter
    If (selGame = 0) Then
        Chain ("jakdraw.bas")
    ElseIf (selGame = 1) Then
        Chain ("jaksound.bas")
    ElseIf (selGame = 2) Then
        Chain ("sphmenu.bas")
    End If
End Sub

Sub getJakDraw
    Color 52
    jdX = 0
    jdY = 96

    For i = 70 To 139
        Line (0, 0)-(i - 70, 87), 16 + i
    Next i

    For i = 0 To 69
        Line (i, 0)-(70, 97), 16 + i
    Next i

    'J
    Line (jdX, jdY)-Step(1, 1), 53
    Line Step(0, 0)-Step(10, -2), 53
    Line Step(0, 0)-Step(0, -15), 53
    Line Step(10, 0)-Step(-20, 0), 53
    Locate 12, 3
    Print "ak"
    'D
    Locate 12, 6
    Print "raw"
    Line (jdX + 32, jdY - 2)-Step(0, -17), 53
    Circle Step(-5, 10), 12, 53, 4.7, 1.5
    Get (0, 0)-(69, 97), pJakDraw()
End Sub

Sub getJaksound

    Color 13
    For i = 1 To 7
        Line (i * 4 - 4, 60 - i * 2)-(i * 4 - 2, 74), 5, B
        Line (i * 4 - 3, 61 - i * 2)-(i * 4 - 3, 73), 13
    Next i

    For i = 8 To 16
        Line (i * 4 - 4, 10 + i * 3)-(i * 4 - 2, 74), 5, B
        Line (i * 4 - 3, 11 + i * 3)-(i * 4 - 3, 73), 13
    Next i

    jdX = 0
    jdY = 92
    'J
    Line (jdX, jdY)-Step(5, 5), 5
    Line Step(0, 0)-Step(10, -2), 5
    Line Step(0, 0)-Step(0, -15), 5
    Line Step(10, 0)-Step(-20, 0), 5
    Locate 12, 3
    Print "ak"
    'S
    Circle (jdX + 30, jdY - 1), 7, 5, 4.3, 1.5
    Circle (jdX + 32, jdY - 11), 5, 5, .4, 4.7
    Locate 12, 6
    Print "ound"

    Color 5
    Locate 2, 3
    Print "S"; "    ð";
    Locate 3, 4
    Print "t"; "   ";
    Locate 4, 5
    Print "u"; "  Ÿ";
    Locate 5, 6
    Print "d"; " ð";
    Locate 6, 7
    Print "i";
    Locate 7, 8
    Print "o";
    'ðŸð
    Get (0, 0)-(69, 97), pJakSound()

End Sub

Sub getSpheroid
    Dim xbomb(1 To 10)
    Dim ybomb(1 To 10)
    'Bombs
    Randomize Timer
    For bomnum = 1 To 10
        xbomb(bomnum) = Int((Rnd * 60) + 5)
        ybomb(bomnum) = Int((Rnd * 90) + 5)
    Next bomnum
    For bomnum = 1 To 10
        Circle (xbomb(bomnum), ybomb(bomnum)), 2, 113
        Circle (xbomb(bomnum), ybomb(bomnum)), 4, 113
        Circle (xbomb(bomnum), ybomb(bomnum)), 3, 4
    Next bomnum



    'graphic
    outness = 15
    outadd = .9
    centerx = 40
    centery = 38
    centeradd = 1
    For colour = 21 To 31 Step 2
        Circle (centerx, centery), outness, colour
        Paint (centerx, centery), colour
        centerx = centerx - centeradd
        centery = centery - centeradd
        centeradd = centeradd - .3
        outness = outness - outadd
        outadd = outadd + .2
    Next colour


    'Text
    sph$(1) = "S"
    sph$(2) = "p"
    sph$(3) = "h"
    sph$(4) = "e"
    sph$(5) = "r"
    sph$(6) = "o"
    sph$(7) = "i"
    sph$(8) = "d"
    Locate 12, 1
    For i = 1 To 8
        Color 23 + i
        Print sph$(i);
    Next i

    Get (0, 0)-(69, 97), pSpheroid()
End Sub

Sub help
    Cls
    Color 15
    Print "Qjak Entertainment Pack"
    Color 32
    Print "ORIGINAL idea by Jake Gustafson"
    Print
    Color 50
    Print "   1. Use arrow keys to change"
    Print "      selection.  Press [Enter]"
    Print "      to enter program."
    Print
    Print "   2. [s] key toggles sound"
    Print "     (from menu or from inside"
    Print "      Spheroid or JakSound)."
    Print "      In JakDraw, [tab] toggles"
    Print "      sound."
    Print
    Print "   3. To insure correct program"
    Print "      operation, maKE SURE THAT"
    Print "     [CAPS LOCK] -OOPs- is off."
    Print
    Print "   4. To exit from this menu or"
    Print "      any of the programs in"
    Print "      Qjak Entertainment pack,"
    Print "      press [Escape]."
    Color 15
    Print
    Print "Press a key to continue..."
    Sleep 0
    Cls
End Sub

Sub refmenu
    For i = 0 To 3
        Line (40 + i, 40 + i)-(279 - i, 159 - i), 18 + i, BF
    Next i
    For i = 4 To 7
        Line (40 + i, 40 + i)-(279 - i, 159 - i), 26 - i, B
    Next i
    i = 8
    Line (40 + i, 40 + i)-(279 - i, 159 - i), 16, BF
    Locate 21, 17
    Print "Help [h]"
End Sub

Sub Rings
    For i = 1 To 200
        Randomize 9
        rad = Int(Rnd * 6) + 2
        col = Int(Rnd * 13) + 18
        xloc = Int((Rnd * 319) + 0)
        yloc = Int((Rnd * 199) + 0)
        Circle (xloc, yloc), rad, col
        'PRINT "xloc="; xloc; "   yloc="; yloc; "   radius="; rad; "   color="; col
    Next i
End Sub


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
Common Shared progdir$
Open "qjak.ini" For Input As #1
Line Input #1, progdir$
Close
For charnow = 1 To Len(progdir$)
    If Mid$(progdir$, charnow, 1) = "=" Then GoTo SPLITHERE
Next charnow
SPLITHERE:
progdir$ = Right$(progdir$, Len(progdir$) - (charnow)) 'this is correct since STARTS at right
ChDir (progdir$)


'start mouse initialization
DefInt A-Z: Def Seg = &HA000:
Dim Shared mouse$: mouse$ = Space$(57)
Screen 13
For i% = 1 To 57: Read a$: H$ = Chr$(Val("&H" + a$))
Mid$(mouse$, i%, 1) = H$: Next i%
Data 55,89,E5,8B,5E,0C,8B,07,50,8B,5E,0A,8B,07,50,8B
Data 5E,08,8B,0F,8B,5E,06,8B,17,5B,58,1E,07,CD,33,53
Data 8B,5E,0C,89,07,58,8B,5E,0A,89,07,8B,5E,08,89,0F
Data 8B,5E,06,89,17,5D,CA,08,00
Restore
ms% = MouseInit%
If Not ms% Then
    Print "Mouse not found"
    Sound 40, 2
    End
End If
Locate 1, 1
MousePut 26, 38
MouseRange 16, 34, 594, 183
'mouse extra stuff:
Dim Shared xMouseRaw
Dim Shared yMouseRaw
Dim Shared pPointer!(1 To 8)
Dim Shared xPointer
Dim Shared yPointer
'end mouse initialization

Dim Shared sarrDigit(0 To 9) As String
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



Dim Shared pJakDraw(1 To 1716)
Dim Shared iBrushRad As Integer
Dim Shared xColr
Dim Shared yColr
Dim Shared sound$
Dim Shared qt$
Dim Shared letters%
Dim Shared tipnum%
qt$ = Chr$(34)

'Check sound setting
Open "bsound.dat" For Input As #2
Line Input #2, sound$
Close #2

'See if user just loaded a file
Open "bloading.dat" For Input As #1
Line Input #1, didit$
Close #1
If didit$ = "1" Then
    GoTo postinit
Else
End If

Screen 13
getJakDraw
Cls
drawJakdraw
Sleep 2
Cls

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
Call colchange(0, 0)
help
seeSize
start:
Do
    xMouseRawPrev = xMouseRaw
    yMouseRawPrev = yMouseRaw
    MouseStatus Lb, Rb, xMouseRaw, yMouseRaw
    xPointer = xMouseRaw / 2 + 2
    yPointer = yMouseRaw + 2
    Select Case Lb%
        Case -1: Put (xMouseRawPrev / 2, yMouseRawPrev), pPointer!(), Xor: OnMouseDownOver: Put (xMouseRaw / 2, yMouseRaw), pPointer!(), Xor
        Case Else: Put (xMouseRawPrev / 2, yMouseRawPrev), pPointer!(), Xor: Put (xMouseRaw / 2, yMouseRaw), pPointer!(), Xor
    End Select
    Select Case InKey$
        Case Chr$(0) + "K": Call MovePointer(-1, 0)
        Case Chr$(0) + "M": Call MovePointer(1, 0)
        Case Chr$(0) + "H": Call MovePointer(0, -1)
        Case Chr$(0) + "P": Call MovePointer(0, 1)
        Case "a": Call colchange(-1, 0): seeSize
        Case "d": Call colchange(1, 0): seeSize
        Case "w": Call colchange(0, -1): seeSize
        Case "s": Call colchange(0, 1): seeSize
        Case Chr$(0) + "G": Call MovePointer(0, -1): brush
        Case Chr$(0) + "O": Call MovePointer(0, 1): brush
        Case Chr$(0) + "S": Call MovePointer(-1, 0): brush
        Case Chr$(0) + "Q": Call MovePointer(1, 0): brush
        Case "p": brush
        Case "f": FloodFill
        Case "F": ColorReplace
        Case "h": tipnum% = tipnum% + 1: help: If tipnum% > 8 Then tipnum% = 0
        Case "g": getcol: colFresh: Call colchange(0, 0)
        Case "+": iBrushRad = iBrushRad + 1: checkSize: Call MovePointer(0, 0): seeSize
        Case "-": iBrushRad = iBrushRad - 1: checkSize: Call MovePointer(0, 0): seeSize
        Case "e": iBrushRad = iBrushRad + 1: checkSize: Call MovePointer(0, 0): seeSize
        Case "q": iBrushRad = iBrushRad - 1: checkSize: Call MovePointer(0, 0): seeSize
        Case Chr$(32): Line (10, 36)-(299, 185), 0, BF: FreshWindow: Put (xMouseRaw / 2, yMouseRaw), pPointer!(), Xor: GoTo afterclear
        Case Chr$(0) + ";": SaveJAG: GoTo afterclear 'F1 Saves
        Case Chr$(0) + "<": LoadJAG: GoTo afterclear 'F2 Loads
        Case Chr$(9): SwitchSound
        Case Chr$(27): Exit Do
        Case Else
    End Select
Loop

endit:
Chain ("qjakmenu.bas")
End

Sub brush
    Put (xMouseRaw / 2, yMouseRaw), pPointer!(), Xor
    Select Case iBrushRad
        Case 1: PSet (xPointer, yPointer), yColr * 16 + xColr
        Case 2: PSet (xPointer, yPointer), yColr * 16 + xColr
            Circle (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
        Case 3: Line (xPointer - 1, yPointer - 1)-(xPointer + 1, yPointer + 1), yColr * 16 + xColr, BF
            Circle (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
        Case 4: Circle (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
            Line (xPointer - 1, yPointer)-(xPointer + 1, yPointer), yColr * 16 + xColr
            Line (xPointer - 2, yPointer - 1)-(xPointer + 2, yPointer + 1), yColr * 16 + xColr, BF
        Case 5: Circle (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
            Line (xPointer - 3, yPointer - 1)-(xPointer + 3, yPointer + 1), yColr * 16 + xColr, BF
            Line (xPointer - 1, yPointer - 2)-(xPointer + 1, yPointer + 2), yColr * 16 + xColr, BF
        Case 6: Circle (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
            Line (xPointer - 2, yPointer - 3)-(xPointer + 2, yPointer + 3), yColr * 16 + xColr, BF
            Line (xPointer - 4, yPointer - 1)-(xPointer + 4, yPointer + 1), yColr * 16 + xColr, BF
            Line (xPointer - 3, yPointer - 2)-(xPointer + 3, yPointer + 2), yColr * 16 + xColr, B
        Case 7: Circle (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
            Line (xPointer - 5, yPointer - 1)-(xPointer + 5, yPointer + 1), yColr * 16 + xColr, BF
            Line (xPointer - 2, yPointer - 4)-(xPointer + 2, yPointer + 4), yColr * 16 + xColr, BF
            Line (xPointer - 3, yPointer - 3)-(xPointer + 3, yPointer + 3), yColr * 16 + xColr, B
            Line (xPointer - 4, yPointer - 2)-(xPointer + 4, yPointer + 2), yColr * 16 + xColr, B
        Case 8: Circle (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
            Line (xPointer - 2, yPointer - 5)-(xPointer + 2, yPointer + 5), yColr * 16 + xColr, BF
            Line (xPointer - 6, yPointer - 1)-(xPointer + 6, yPointer + 1), yColr * 16 + xColr, BF
            Line (xPointer - 5, yPointer - 3)-(xPointer + 5, yPointer + 3), yColr * 16 + xColr, BF
            Line (xPointer - 4, yPointer - 4)-(xPointer + 4, yPointer + 4), yColr * 16 + xColr, B
        Case 9: Circle (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
            Line (xPointer - 2, yPointer - 6)-(xPointer + 2, yPointer + 6), yColr * 16 + xColr, BF
            Line (xPointer - 7, yPointer - 1)-(xPointer + 7, yPointer + 1), yColr * 16 + xColr, BF
            Line (xPointer - 4, yPointer - 5)-(xPointer + 4, yPointer + 5), yColr * 16 + xColr, BF
            Line (xPointer - 6, yPointer - 3)-(xPointer + 6, yPointer + 3), yColr * 16 + xColr, BF
            Line (xPointer - 5, yPointer - 4)-(xPointer + 5, yPointer + 4), yColr * 16 + xColr, B
        Case 10: Circle (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
            Line (xPointer - 4, yPointer - 6)-(xPointer + 4, yPointer + 6), yColr * 16 + xColr, BF
            Line (xPointer - 8, yPointer - 1)-(xPointer + 8, yPointer + 1), yColr * 16 + xColr, BF
            Line (xPointer - 6, yPointer - 5)-(xPointer + 6, yPointer + 5), yColr * 16 + xColr, BF
            Line (xPointer - 7, yPointer - 3)-(xPointer + 7, yPointer + 3), yColr * 16 + xColr, B
    End Select
    DrawWindow
    Put (xMouseRaw / 2, yMouseRaw), pPointer!(), Xor
    'end brush
End Sub

Sub OnMouseDownOver
    Select Case iBrushRad
        Case 1: PSet (xPointer, yPointer), yColr * 16 + xColr
        Case 2: PSet (xPointer, yPointer), yColr * 16 + xColr
            Circle (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
        Case 3: Line (xPointer - 1, yPointer - 1)-(xPointer + 1, yPointer + 1), yColr * 16 + xColr, BF
            Circle (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
        Case 4: Circle (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
            Line (xPointer - 1, yPointer)-(xPointer + 1, yPointer), yColr * 16 + xColr
            Line (xPointer - 2, yPointer - 1)-(xPointer + 2, yPointer + 1), yColr * 16 + xColr, BF
        Case 5: Circle (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
            Line (xPointer - 3, yPointer - 1)-(xPointer + 3, yPointer + 1), yColr * 16 + xColr, BF
            Line (xPointer - 1, yPointer - 2)-(xPointer + 1, yPointer + 2), yColr * 16 + xColr, BF
        Case 6: Circle (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
            Line (xPointer - 2, yPointer - 3)-(xPointer + 2, yPointer + 3), yColr * 16 + xColr, BF
            Line (xPointer - 4, yPointer - 1)-(xPointer + 4, yPointer + 1), yColr * 16 + xColr, BF
            Line (xPointer - 3, yPointer - 2)-(xPointer + 3, yPointer + 2), yColr * 16 + xColr, B
        Case 7: Circle (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
            Line (xPointer - 5, yPointer - 1)-(xPointer + 5, yPointer + 1), yColr * 16 + xColr, BF
            Line (xPointer - 2, yPointer - 4)-(xPointer + 2, yPointer + 4), yColr * 16 + xColr, BF
            Line (xPointer - 3, yPointer - 3)-(xPointer + 3, yPointer + 3), yColr * 16 + xColr, B
            Line (xPointer - 4, yPointer - 2)-(xPointer + 4, yPointer + 2), yColr * 16 + xColr, B
        Case 8: Circle (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
            Line (xPointer - 2, yPointer - 5)-(xPointer + 2, yPointer + 5), yColr * 16 + xColr, BF
            Line (xPointer - 6, yPointer - 1)-(xPointer + 6, yPointer + 1), yColr * 16 + xColr, BF
            Line (xPointer - 5, yPointer - 3)-(xPointer + 5, yPointer + 3), yColr * 16 + xColr, BF
            Line (xPointer - 4, yPointer - 4)-(xPointer + 4, yPointer + 4), yColr * 16 + xColr, B
        Case 9: Circle (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
            Line (xPointer - 2, yPointer - 6)-(xPointer + 2, yPointer + 6), yColr * 16 + xColr, BF
            Line (xPointer - 7, yPointer - 1)-(xPointer + 7, yPointer + 1), yColr * 16 + xColr, BF
            Line (xPointer - 4, yPointer - 5)-(xPointer + 4, yPointer + 5), yColr * 16 + xColr, BF
            Line (xPointer - 6, yPointer - 3)-(xPointer + 6, yPointer + 3), yColr * 16 + xColr, BF
            Line (xPointer - 5, yPointer - 4)-(xPointer + 5, yPointer + 4), yColr * 16 + xColr, B
        Case 10: Circle (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
            Line (xPointer - 4, yPointer - 6)-(xPointer + 4, yPointer + 6), yColr * 16 + xColr, BF
            Line (xPointer - 8, yPointer - 1)-(xPointer + 8, yPointer + 1), yColr * 16 + xColr, BF
            Line (xPointer - 6, yPointer - 5)-(xPointer + 6, yPointer + 5), yColr * 16 + xColr, BF
            Line (xPointer - 7, yPointer - 3)-(xPointer + 7, yPointer + 3), yColr * 16 + xColr, B
    End Select
    DrawWindow
End Sub

Sub checkSize
    If (iBrushRad > 10) Then
        iBrushRad = 10
    ElseIf (iBrushRad < 1) Then
        iBrushRad = 1
    End If
End Sub

Sub cletter (iAdder%)
    letters% = letters% + iAdder%
    If (letters% < 0) Then
        letters% = 0
    ElseIf (letters% > 8) Then
        letters% = 8
    End If
End Sub

Sub colchange (xc%, yc%)
    Line (xColr * 2 + 272, yColr * 2 - 1)-(xColr * 2 + 274, yColr * 2 + 1), 0, B
    xColr = xColr + xc%
    yColr = yColr + yc%
    If (xColr < 0) Then
        xColr = 15
    ElseIf (xColr > 15) Then
        xColr = 0
    ElseIf (yColr < 0) Then
        yColr = 15
    ElseIf (yColr > 15) Then
        yColr = 0
    End If

    For yo = 0 To 15
        For xo = 0 To 15
            PSet (xo * 2 + 273, yo * 2), yo * 16 + xo
        Next xo
    Next yo

    Line (xColr * 2 + 272, yColr * 2 - 1)-(xColr * 2 + 274, yColr * 2 + 1), 28, B
    Select Case sound$
        Case "0": If (xc% <> 0) Or (yc% <> 0) Then Sound 20000, .2
        Case "1": If (xc% <> 0) Or (yc% <> 0) Then Sound 1000, .2
    End Select
    Color 154
    Locate 25, 31
    Print "          ";
    Locate 25, 31
    Print "color"; yColr * 16 + xColr;
End Sub

Sub colFresh
    For xco = 0 To 15
        For yco = 0 To 15
            Line (xco * 2 + 272, yco * 2 - 1)-(xco * 2 + 274, yco * 2 + 1), 0, B
        Next yco
    Next xco
End Sub

Sub drawJakdraw

    For i = 77 To 51 Step -1
        Put (51, i), pJakDraw(), PSet
        Sound i + 20000, .2
        Put (51, i), pJakDraw(), Xor
    Next i
    For i = 51 To 0 Step -1
        Put (i, i), pJakDraw(), PSet
        Sound i + 20000, .2
        Put (i, i), pJakDraw(), Xor
    Next i
    Put (0, 0), pJakDraw(), PSet

    Color 9
    Locate 2, 11
    Print "2.7"
End Sub

Sub DrawWindow
    'window
    Line (10, 35)-Step(290, 0), 8
    Line Step(-291, 0)-Step(0, 151), 8
    Line Step(291, -150)-Step(0, 150), 7
    Line Step(-290, 0)-Step(289, 0), 7

    Line Step(2, -151)-Step(0, 152), 15
    Line Step(-1, 0)-Step(-291, 0), 15
    Line Step(-1, -153)-Step(294, 154), 24, B
    Line Step(1, 1)-Step(-296, -156), 24, B

    Line Step(0, -1)-Step(296, 0), 15
    Line Step(-297, 0)-Step(0, 157), 15
    Line Step(0, 1)-Step(298, 0), 8
    Line Step(0, -1)-Step(0, -157), 8

End Sub

Sub ColorReplace
    Put (xPointer - 2, yPointer - 2), pPointer!(), Xor
    Color 34
    Locate 1, 7
    Print "Filling...  [escape]Äcancels"

    colno = 0
    xp = 0
    yp = 0
    underColr = Point(xPointer, yPointer)
    For xfi = 0 To 289
        For yfi = 0 To 149
            testCol = Point(xfi + 10, yfi + 36)
            If (testCol = underColr) Then
                PSet (xfi + 10, yfi + 36), yColr * 16 + xColr
            Else
            End If
            Select Case InKey$
                Case Chr$(27): GoTo stopFfill
            End Select
        Next yfi
    Next xfi

    stopFfill:
    Locate 1, 7
    Print "                            "
    help
    Put (xPointer - 2, yPointer - 2), pPointer!(), Xor
End Sub

Sub FloodFill
    Put (xPointer - 2, yPointer - 2), pPointer!(), Xor
    Color 34
    Locate 1, 7
    Print "filling...  [escape]Äcancels"

    ydiro = 1
    yp = 0
    underColr = Point(xPointer, yPointer)

    aheadfilup:
    yp = 0
    aheadfill:
    colno = 0
    xp = 0
    Do
        testCol = Point(xPointer + xp, yPointer + (yp * ydiro))
        If (testCol = underColr) Then
            PSet (xPointer + xp, yPointer + (yp * ydiro)), yColr * 16 + xColr
            xp = xp + 1
        Else
            colno = 1
        End If
        Select Case InKey$
            Case Chr$(27): GoTo exfil
        End Select
    Loop Until colno = 1

    'behind FloodFill:
    colno = 0
    xp = 1
    Do
        testCol = Point(xPointer - xp, yPointer + (yp * ydiro))
        If (testCol = underColr) Then
            PSet (xPointer - xp, yPointer + (yp * ydiro)), yColr * 16 + xColr
            xp = xp + 1
        Else
            colno = 1
        End If
        Select Case InKey$
            Case Chr$(27): GoTo exfil
        End Select
    Loop Until colno = 1

    yp = yp + 1
    testCol = Point(xPointer, yPointer + (yp * ydiro))
    If (testCol = underColr) Then
        GoTo aheadfill
    Else
    End If
    Select Case InKey$
        Case Chr$(27): GoTo exfil
    End Select

    If (ydiro = -1) Then
        GoTo exfil
    Else
        ydiro = -1
        GoTo aheadfilup
    End If
    exfil:
    Locate 1, 7
    Print "                            "
    help
    Put (xPointer - 2, yPointer - 2), pPointer!(), Xor
End Sub

Sub FreshWindow
    'black outside
    Line (1, 32)-(5, 190), 0, BF 'left
    Line (112, 29)-(308, 31), 0, BF 'top
    Line (1, 191)-(308, 192), 0, BF 'bottom
    Line (305, 32)-(308, 190), 0, BF 'right

    'pallette
    Call colchange(0, 0)

    'window
    Line (10, 35)-Step(290, 0), 8
    Line Step(-291, 0)-Step(0, 151), 8
    Line Step(291, -150)-Step(0, 150), 7
    Line Step(-290, 0)-Step(289, 0), 7

    Line Step(2, -151)-Step(0, 152), 15
    Line Step(-1, 0)-Step(-291, 0), 15
    Line Step(-1, -153)-Step(294, 154), 24, B
    Line Step(1, 1)-Step(-296, -156), 24, B

    Line Step(0, -1)-Step(296, 0), 15
    Line Step(-297, 0)-Step(0, 157), 15
    Line Step(0, 1)-Step(298, 0), 8
    Line Step(0, -1)-Step(0, -157), 8

End Sub

Sub getcol
    colrnumb% = Point(xPointer, yPointer)
    yColr = Int(colrnumb% / 16)
    xColr = colrnumb% - (Int(colrnumb% / 16) * 16)
    seeSize
End Sub

Sub getJakDraw

    Color 52
    jdX = 0
    jdY = 96

    '"J" in Jak
    Line (jdX, jdY)-Step(1, 1), 53
    Line Step(0, 0)-Step(10, -2), 53
    Line Step(0, 0)-Step(0, -15), 53
    Line Step(10, 0)-Step(-20, 0), 53
    Locate 12, 3
    Print "ak"

    '"D" in Draw
    Locate 12, 7
    Print "raw"
    Line (jdX + 40, jdY - 2)-Step(0, -17), 53
    Circle Step(-5, 10), 12, 53, 4.7, 1.5
    Get (0, 77)-(75, 97), pJakDraw()

End Sub

Sub getloc
    colnum = yColr * 16 + xColr
    Color 15
    Locate 23, 28
    Print colnum
End Sub

Sub help
    'clear the help tip area
    Color 0
    Locate 1, 5
    Print "                              "
    Locate 2, 5
    Print "                              "
    Locate 3, 5
    Print "                              "

    'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    If (tipnum% = 1) Then
        '[arrows/mouse]Ämove cursor
        Locate 2, 8
        Color 123
        Print "[";
        Color 26
        Print "arrows/mouse";
        Color 123
        Print "]Ä";
        Color 54
        Print "move cursor"
        'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    ElseIf (tipnum% = 2) Then
        '  Ú Home ¿
        'Del End PgDn
        '  ÀğPAINTÙ
        Locate 1, 11
        Color 123
        Print "  Ú ";
        Color 26
        Print "Home ";
        Color 123
        Print "¿";

        Locate 2, 11
        Color 26
        Print "Del End PgDn"

        Locate 3, 11
        Color 123
        Print "  Àğ";
        Color 54
        Print "PAINT";
        Color 123
        Print "Ù"
        'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    ElseIf (tipnum% = 3) Then
        '[p]Äspot paint
        Locate 2, 11
        Color 123
        Print "[";
        Color 26
        Print "p";
        Color 123
        Print "]Ä";
        Color 54
        Print "spot paint"
        'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    ElseIf (tipnum% = 4) Then
        ' wÄÄ¿
        'asdÄÁmove through palette
        Locate 1, 10
        Color 26
        Print " w";
        Color 123
        Print "ÄÄ¿";

        Locate 2, 10
        Color 26
        Print "asd";
        Color 123
        Print "ÄÁ";
        Color 54
        Print "move through palette"
        'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    ElseIf (tipnum% = 5) Then
        '[f,F]Äfill, Flood-FloodFill
        Locate 2, 11
        Color 123
        Print "[";
        Color 26
        Print "f";
        Color 123
        Print ",";
        Color 26
        Print "F";
        Color 123
        Print "]Ä";
        Color 54
        Print "FloodFill, Flood-FloodFill";
        'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    ElseIf (tipnum% = 6) Then
        '[F1,F2]Äsave, load
        Locate 2, 11
        Color 123
        Print "[";
        Color 26
        Print "F1";
        Color 123
        Print ",";
        Color 26
        Print "F2";
        Color 123
        Print "]Ä";
        Color 54
        Print "save, load"
        'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    ElseIf (tipnum% = 7) Then
        '[spacebar]Äclear drawing area
        Locate 2, 6
        Color 123
        Print "[";
        Color 26
        Print "spacebar";
        Color 123
        Print "]Ä";
        Color 54
        Print "clear drawing area"
        'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    ElseIf (tipnum% = 8) Then
        '[g]Äget color under cursor
        Locate 2, 9
        Color 123
        Print "[";
        Color 26
        Print "g";
        Color 123
        Print "]Ä";
        Color 54
        Print "get color under cursor"
        'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    ElseIf (tipnum% = 9) Then
        '[tab]Äsound on/off
        Locate 2, 11
        Color 123
        Print "[";
        Color 26
        Print "tab";
        Color 123
        Print "]Ä";
        Color 54
        Print "sound on/off"
    End If
    'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

    Locate 25, 1
    Color 123
    Print "[";
    Color 26
    Print "h";
    Color 123
    Print "]Ä";
    Color 54
    Print "change help tip";
End Sub

Sub LoadJAG
    Put (xPointer - 2, yPointer - 2), pPointer!(), Xor

    Color 34
    Locate 1, 7
    Print "Load file:         "
    'LOCATE 2, 7
    'SHELL ("dir *.ba1")
    letters% = 0

    resa:
    Color 0
    Locate 1, 18
    Print "        ";
    Color 34
    Locate 1, 18
    Print filenam$;
    Sleep 0
    Do
        dumr$ = InKey$
        Select Case dumr$
            Case "": GoTo resa
            Case Chr$(8): Call cletter(-1): filenam$ = Mid$(filenam$, 1, letters%): GoTo resa
            Case Chr$(32): GoTo resa
            Case Chr$(9): GoTo resa
            Case "/": GoTo resa
            Case "\": GoTo resa
            Case Chr$(9): GoTo resa
            Case Chr$(27): letters% = 0: Exit Do
            Case Chr$(13): Exit Do
            Case Else: filenam$ = filenam$ + dumr$: Call cletter(1): filenam$ = Mid$(filenam$, 1, letters%): GoTo resa
        End Select
    Loop

    Color 0
    Locate 1, 7
    Print "                   "
    Select Case letters%
        Case 0: GoTo noLoad
        Case Else
    End Select
    Color 34
    Locate 1, 7
    Print "loading...        "
    Chain (filenam$ + ".ba1")

    noLoad:
    help
    Put (xPointer - 2, yPointer - 2), pPointer!(), Xor
End Sub

Sub makezero
    'lets program know that the program
    'isn't restarting after loading a file
    Open "bloading.dat" For Output As #2
    Print #2, "0"
    Close #2
End Sub

'start mouse functions
DefLng A-Z
Sub MouseDriver (ax%, bx%, cx%, dx%)
    Def Seg = VarSeg(mouse$)
    mouse% = SAdd(mouse$)
    Call Absolute(ax%, bx%, cx%, dx%, mouse%)
End Sub

Sub MouseHide
    ax% = 2
    MouseDriver ax%, 0, 0, 0
End Sub

Function MouseInit%
    ax% = 0
    MouseDriver ax%, 0, 0, 0
    MouseInit% = ax%
End Function

Sub MousePut (xMouseRaw%, yMouseRaw%)
    ax% = 4
    cx% = xMouseRaw%
    dx% = yMouseRaw%
    MouseDriver ax%, 0, cx%, dx%
End Sub

Sub MouseRange (X1%, Y1%, x2%, Y2%)
    ax% = 7
    cx% = X1%
    dx% = x2%
    MouseDriver ax%, 0, cx%, dx%
    ax% = 8
    cx% = Y1%
    dx% = Y2%
    MouseDriver ax%, 0, cx%, dx%
End Sub

Sub MouseShow
    Put (xMouseRaw / 2, yMouseRaw), pPointer!(), Xor
End Sub

Sub MouseStatus (Lb%, Rb%, xMouse%, yMouse%)
    ax% = 3
    MouseDriver ax%, bx%, cx%, dx%
    Lb% = ((bx% And 1) <> 0)
    Rb% = ((bx% And 2) <> 0)
    xMouse% = cx%
    yMouse% = dx%
End Sub

DefInt A-Z
Sub MovePointer (xm%, ym%)
    'manually move mouse cursor
    xPointer = xPointer + xm%
    yPointer = yPointer + ym%
    MousePut xMouseRaw + xm% * 2, yMouseRaw + ym%
    DrawWindow
End Sub

Sub MakePointer
    'get mouse cursor
    Line (0, 0)-(4, 4), 0
    Line (2, 0)-Step(0, 1), 15
    Line Step(0, 2)-Step(0, 1), 15
    Line Step(-3, -2)-Step(2, 0), 15
    Line Step(2, 0)-Step(1, 0), 15
    Get (0, 0)-(4, 4), pPointer!(1)
    Line (0, 0)-(4, 4), 0
End Sub
'end mouse functions

Sub SaveJAG
    Put (xMouseRaw / 2, yMouseRaw), pPointer!(), Xor
    Color 34
    Locate 1, 7
    Print "Save as:          "
    letters% = 0
    resab:
    Color 0
    Locate 1, 16
    Print "        ";
    Color 34
    Locate 1, 16
    Print filenam$;
    Sleep 0
    Do
        dumr$ = InKey$
        Select Case dumr$
            Case "": GoTo resab
            Case Chr$(8): Call cletter(-1): filenam$ = Mid$(filenam$, 1, letters%): GoTo resab
            Case Chr$(32): GoTo resab
            Case Chr$(9): GoTo resab
            Case "/": GoTo resab
            Case "\": GoTo resab
            Case Chr$(9): GoTo resab
            Case Chr$(27): letters% = 0: Exit Do
            Case Chr$(13): Exit Do
            Case Else: filenam$ = filenam$ + dumr$: Call cletter(1): filenam$ = Mid$(filenam$, 1, letters%): GoTo resab
        End Select
    Loop
    Locate 1, 7
    Color 0
    Print "                  "
    Select Case letters%
        Case 0: GoTo noSave
        Case Else
    End Select
    Color 34
    Locate 1, 7
    Print "saving...         "


    For xmap = 1 To 2
        For ymap = 1 To 2

            If (xmap = 1) And (ymap = 1) Then
                Open (filenam$ + ".ba1") For Output As #1
                Print #1, "SCREEN 13"
                For yMouseRaw% = 1 To 75
                    For xMouseRaw% = 1 To 145
                        If (xMouseRaw% = 1) Then
                            Print #1, "DATA "; Point(xMouseRaw% + 9, yMouseRaw% + 35);
                        Else
                            Print #1, ","; Point(xMouseRaw% + 9, yMouseRaw% + 35);
                        End If
                    Next xMouseRaw%
                    Print #1,
                Next yMouseRaw%
                Print #1, "CHDIR "; qt$; progdir$; qt$
                Print #1, "FOR y = 1 TO 75"
                Print #1, "    FOR x = 1 TO 145"
                Print #1, "         READ z"
                Print #1, "         PSET (x + 9, y + 35), z"
                Print #1, "    NEXT"
                Print #1, "NEXT"
                Print #1, "OPEN "; qt$; "bloading.dat"; qt$; " FOR OUTPUT AS #1"
                Print #1, "     PRINT #1, "; qt$; "1"; qt$
                Print #1, "CLOSE"
                Print #1, "CHAIN "; qt$; filenam$; ".ba2"; qt$
                Close #1
            ElseIf (xmap = 1) And (ymap = 2) Then
                Open (filenam$ + ".ba2") For Output As #1
                Print #1, "SCREEN 13"
                For yMouseRaw% = 1 To 75
                    For xMouseRaw% = 1 To 145
                        If (xMouseRaw% = 1) Then
                            Print #1, "DATA "; Point(xMouseRaw% + 154, yMouseRaw% + 35);
                        Else
                            Print #1, ","; Point(xMouseRaw% + 154, yMouseRaw% + 35);
                        End If
                    Next xMouseRaw%
                    Print #1,
                Next yMouseRaw%
                Print #1, "CHDIR "; qt$; progdir$; qt$
                Print #1, "FOR y = 1 TO 75"
                Print #1, "    FOR x = 1 TO 145"
                Print #1, "         READ z"
                Print #1, "         PSET (x + 154, y + 35), z"
                Print #1, "    NEXT"
                Print #1, "NEXT"
                Print #1, "OPEN "; qt$; "bloading.dat"; qt$; " FOR OUTPUT AS #1"
                Print #1, "     PRINT #1, "; qt$; "1"; qt$
                Print #1, "CLOSE"
                Print #1, "CHAIN "; qt$; filenam$; ".ba3"; qt$
                Close #1
            ElseIf (xmap = 2) And (ymap = 1) Then
                Open (filenam$ + ".ba3") For Output As #1
                Print #1, "SCREEN 13"
                For yMouseRaw% = 1 To 75
                    For xMouseRaw% = 1 To 145
                        If (xMouseRaw% = 1) Then
                            Print #1, "DATA "; Point(xMouseRaw% + 9, yMouseRaw% + 110);
                        Else
                            Print #1, ","; Point(xMouseRaw% + 9, yMouseRaw% + 110);
                        End If
                    Next xMouseRaw%
                    Print #1,
                Next yMouseRaw%
                Print #1, "CHDIR "; qt$; progdir$; qt$
                Print #1, "FOR y = 1 TO 75"
                Print #1, "    FOR x = 1 TO 145"
                Print #1, "         READ z"
                Print #1, "         PSET (x + 9, y + 110), z"
                Print #1, "    NEXT"
                Print #1, "NEXT"
                Print #1, "OPEN "; qt$; "bloading.dat"; qt$; " FOR OUTPUT AS #1"
                Print #1, "     PRINT #1, "; qt$; "1"; qt$
                Print #1, "CLOSE"
                Print #1, "CHAIN "; qt$; filenam$; ".ba4"; qt$
                Close #1
            ElseIf (xmap = 2) And (ymap = 2) Then
                Open (filenam$ + ".ba4") For Output As #1
                Print #1, "SCREEN 13"
                For yMouseRaw% = 1 To 75
                    For xMouseRaw% = 1 To 145
                        If (xMouseRaw% = 1) Then
                            Print #1, "DATA "; Point(xMouseRaw% + 154, yMouseRaw% + 110);
                        Else
                            Print #1, ","; Point(xMouseRaw% + 154, yMouseRaw% + 110);
                        End If
                    Next xMouseRaw%
                    Print #1,
                Next yMouseRaw%
                Print #1, "CHDIR "; qt$; progdir$; qt$
                Print #1, "FOR y = 1 TO 75"
                Print #1, "    FOR x = 1 TO 145"
                Print #1, "         READ z"
                Print #1, "         PSET (x + 154, y +110), z"
                Print #1, "    NEXT"
                Print #1, "NEXT"
                Print #1, "OPEN "; qt$; "bloading.dat"; qt$; " FOR OUTPUT AS #1"
                Print #1, "     PRINT #1, "; qt$; "1"; qt$
                Print #1, "CLOSE"
                Print #1, "COLOR 34"
                Print #1, "LOCATE 1, 7"
                Print #1, "PRINT "; qt$; "                  "; qt$
                Print #1, "CHAIN "; qt$; "JAKDRAW.BAS"; qt$
                Close #1
            End If

        Next ymap
    Next xmap

    Locate 1, 7
    Color 0
    Print "                  "

    noSave:
    help
    Put (xMouseRaw / 2, yMouseRaw), pPointer!(), Xor
End Sub

Sub seeSize
    Line (10, 0)-(30, 20), 0, BF
    Select Case iBrushRad
        Case 1: PSet (20, 10), yColr * 16 + xColr
        Case Else: Circle (20, 10), iBrushRad - 1, yColr * 16 + xColr: Paint (20, 10), yColr * 16 + xColr
    End Select
    Color 54
    Locate 4, 1
    Print "size ";
    Color 123
    Print "[";
    Color 26
    Print "q";
    Color 123
    Print ",";
    Color 26
    Print "e";
    Color 123
    Print "] "; iBrushRad - 1;
End Sub

Sub SwitchSound

    Open "bsound.dat" For Output As #1
    Select Case sound$
        Case "0": Print #1, "1": sound$ = "1"
        Case "1": Print #1, "0": sound$ = "0"
    End Select
    Close #1

End Sub


DECLARE SUB OnDragEnd ()
DECLARE SUB OnDragStart ()
DECLARE SUB OnDragging ()
DECLARE FUNCTION MouseInit% ()
DECLARE SUB MouseStatus (Lb%, Rb%, xMouse%, yMouse%)
DECLARE SUB MouseRange (X1%, Y1%, x2%, Y2%)
DECLARE SUB MousePut (xAt%, yAt%)
DECLARE SUB MouseHide ()
DECLARE SUB MouseDriver (ax%, bx%, cx%, dx%)
DECLARE SUB MouseShow ()
DECLARE SUB MovePointer (xm%, ym%)
DECLARE SUB MakePointer ()
DECLARE SUB DrawPointer ()
DECLARE SUB OnMouseDown ()
DECLARE SUB OnMouseUp ()

DECLARE SUB UndrawPointer ()
DECLARE SUB LINESAFEH (xStart%, yStart%, xEnd%, yEnd%, iColor%)
DECLARE SUB LINESAFEV (xStart%, yStart%, xEnd%, yEnd%, iColor%)

DECLARE FUNCTION PointerFromMouseX% (xMouse%)
DECLARE FUNCTION PointerFromMouseY% (yMouse%)
DECLARE FUNCTION PointerCroppedX% (xMouse%)
DECLARE FUNCTION PointerCroppedY% (yMouse%)
DECLARE FUNCTION SafeMod% (iNum%, iDiv%)
DECLARE FUNCTION ToString$ (iNow%)
DECLARE FUNCTION ToDouble# (iNow%)
DECLARE FUNCTION StringToInt% (sNow$)
DECLARE FUNCTION CharToInt% (sNow$)

DECLARE FUNCTION GetUserEntry$ (sCaption$)
DECLARE SUB MoveTextCursor (iAdder%)

DECLARE FUNCTION SaveAs% (sFile$)
DECLARE FUNCTION LoadAs% (sFile$)
DECLARE FUNCTION YToBarNotch% (yNow%)
DECLARE SUB LoadArchaicJAS ()

DECLARE SUB SetBarByPointer (bInTune%)

'revision 2.5
'DECLARE FUNCTION SAFEPOW% (base1,exp1)
DECLARE FUNCTION WrapNote12% (NoteX%)
DECLARE FUNCTION WrapNote07% (NoteX%)
DECLARE FUNCTION IsInKey% (NoteX%)
DECLARE FUNCTION NoteInKey% (NoteX%)
DECLARE FUNCTION KeyToString$ ()
DECLARE FUNCTION KeyToStringCustom$ (iKeyX%, iModeX%)
DECLARE SUB SwitchSound ()
DECLARE SUB help ()
DECLARE SUB ScriptBars ()
DECLARE SUB SpeedChange (iBy%)
DECLARE SUB OctaveChange (iBy%)
DECLARE SUB KeyChange (iBy%)
DECLARE SUB ModeChange (iBy%)
DECLARE SUB PitchChange (yBy%)
DECLARE SUB BarChange (xBy%)
DECLARE SUB LoadBars ()
DECLARE SUB SaveBars ()
DECLARE SUB DrawBar (xNow%)
DECLARE SUB RandomBars ()
DECLARE SUB PlayAll ()
DECLARE SUB DrawSelector ()
DECLARE SUB DrawSelectorCustom (iMid%, iDark%, iLight%)
DECLARE SUB DrawSelectorCustomHue (iBaseColor%)
DECLARE SUB EraseSelector ()
DECLARE SUB DrawBars ()
DECLARE SUB ShowMenu ()
DECLARE SUB refmenu ()


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
MousePut 320 / 2, 200 / 2
MouseRange 0, 0, 320 * 2, 200
'extra mouse stuff:
Dim Shared xMouseRaw As Integer
Dim Shared yMouseRaw As Integer
Dim Shared xDragStart As Integer
Dim Shared yDragStart As Integer
Dim Shared xMouseRawPrev As Integer
xMouseRawPrev = -1
Dim Shared yMouseRawPrev As Integer
yMouseRawPrev = -1
Dim Shared LbPrev As Integer
LbPrev = 0
Dim Shared RbPrev As Integer
RbPrev = 0
Dim Shared bMouseMoved As Integer
bMouseMoved = 0
Dim Shared pPointer!(1 To 8)
Dim Shared pUnderPointer!(1 To 8)
Dim Shared bUnderPointer As Integer
bUnderPointer = 0
Dim Shared xPointer As Integer
Dim Shared yPointer As Integer
Dim Shared xPointerPrev As Integer
xPointerPrev = -1 'must start out negative
Dim Shared yPointerPrev As Integer
xPointerPrev = -1 'must start out negative

Dim Shared iPointerWidth As Integer
Dim Shared iPointerHeight As Integer
Dim Shared iPointerRad As Integer
iPointerRad = 2
iPointerWidth = iPointerRad * 2 + 1
iPointerHeight = iPointerRad * 2 + 1
Dim Shared xPointerCropped As Integer
xPointerCropped = -1
Dim Shared yPointerCropped As Integer
xPointerCropped = -1
Dim Shared bPointerShowing As Integer
bPointerShowing = 0
MakePointer 'sets pPointer
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
'end common & mouse functions



Dim Shared selText As Integer
Dim Shared iSelectBar As Integer
Dim Shared bars(1 To 32) As Integer
Dim Shared bPlaying As Integer
Dim Shared rowAt
rowAt = 3 'user input location
Dim Shared colAt
colAt = 1 'user input location
bPlaying = 0

Dim Shared iKey As Integer
iKey = 8 '8 is E, 1 is A
Dim Shared iMode As Integer
iMode = 1 'index of modestartabs
Dim Shared IonianDistAtStep(0 To 7) As Integer
IonianDistAtStep(0) = 0
IonianDistAtStep(1) = 2
IonianDistAtStep(2) = 4
IonianDistAtStep(3) = 5
IonianDistAtStep(4) = 7
IonianDistAtStep(5) = 9
IonianDistAtStep(6) = 11
IonianDistAtStep(7) = 12
Dim Shared modestartrel(1 To 7) As Integer 'where the mode starts in the ionian scale
modestartrel(1) = 0
modestartrel(2) = 1
modestartrel(3) = 2
modestartrel(4) = 3
modestartrel(5) = 4
modestartrel(6) = 5
modestartrel(7) = 6
Dim Shared modestartabs(1 To 7) As Integer 'where the mode starts in the ionian range
modestartabs(1) = 0
modestartabs(2) = 2
modestartabs(3) = 4
modestartabs(4) = 5
modestartabs(5) = 7
modestartabs(6) = 9
modestartabs(7) = 11
Dim Shared scale(8, 12) As Integer
rPrev = 0!
For iOv = 1 To 8
    For iStep = 1 To 12
        If rPrev = 0! Then
            scale(iOv, iStep) = 55!
            rPrev = 55!
        Else
            scale(iOv, iStep) = rPrev * 2! ^ (1! / 12!)
            rPrev = scale(iOv, iStep)
        End If
    Next iStep
Next iOv



'below is from http://logic-users.org/forums/L-OT/thread/234 8/8/2007
'A 55.00 110.00 220.00 440.00 880.00 1760.00 3520.00 7040.00
'Bb 58.27 116.54 233.08 466.16 932.33 1864.66 3729.31 7458.62
'B 61.74 123.47 246.94 493.88 987.77 1975.53 3951.07 7902.13
'C 65.41 130.81 261.63 523.25 1046.50 2093.00 4186.01 8372.02
'C# 69.30 138.59 277.18 554.37 1108.73 2217.46 4434.92 8869.84
'D 73.42 146.83 293.66 587.33 1174.66 2349.32 4698.64 9397.27
'Eb 77.78 155.56 311.13 622.25 1244.51 2489.02 4978.03 9956.06
'E 82.41 164.81 329.63 659.26 1318.51 2637.02 5274.04
'F 87.31 174.61 349.23 698.46 1396.91 2793.83 5587.65
'F# 92.50 185.00 369.99 739.99 1479.98 2959.96 5919.91
'G 98.00 196.00 392.00 783.99 1567.98 3135.96 6271.93
'G# 103.83 207.65 415.30 830.61 1661.22 3322.44 6644.88
'converted by macro to:
'scale(1,1) =55.00 : scale(2,1)=110.00 : scale(3,1)=220.00 : scale(4,1)=440.00 : scale(5,1)=880.00  : scale(6,1)=1760.00 : scale(7,1)=3520.00 : scale(8,1)=7040.00
'scale(1,2) =58.27 : scale(2,2)=116.54 : scale(3,2)=233.08 : scale(4,2)=466.16 : scale(5,2)=932.33  : scale(6,2)=1864.66 : scale(7,2)=3729.31 : scale(8,2)=7458.62
'scale(1,3) =61.74 : scale(2,3)=123.47 : scale(3,3)=246.94 : scale(4,3)=493.88 : scale(5,3)=987.77  : scale(6,3)=1975.53 : scale(7,3)=3951.07 : scale(8,3)=7902.13
'scale(1,4) =65.41 : scale(2,4)=130.81 : scale(3,4)=261.63 : scale(4,4)=523.25 : scale(5,4)=1046.50 : scale(6,4)=2093.00 : scale(7,4)=4186.01 : scale(8,4)=8372.02
'scale(1,5) =69.30 : scale(2,5)=138.59 : scale(3,5)=277.18 : scale(4,5)=554.37 : scale(5,5)=1108.73 : scale(6,5)=2217.46 : scale(7,5)=4434.92 : scale(8,5)=8869.84
'scale(1,6) =73.42 : scale(2,6)=146.83 : scale(3,6)=293.66 : scale(4,6)=587.33 : scale(5,6)=1174.66 : scale(6,6)=2349.32 : scale(7,6)=4698.64 : scale(8,6)=9397.27
'scale(1,7) =77.78 : scale(2,7)= 155.56: scale(3,7)= 311.13: scale(4,7)=622.25 : scale(5,7)=1244.51 : scale(6,7)=2489.02 : scale(7,7)=4978.03 : scale(8,7)=9956.06
'scale(1,8) =82.41 : scale(2,8)=164.81 : scale(3,8)= 329.63: scale(4,8)=659.26 : scale(5,8)=1318.51 : scale(6,8)=2637.02 : scale(7,8)=5274.04 : scale(8,8)=0.0
'scale(1,9) =87.31 : scale(2,9)=174.61 : scale(3,9)=349.23 : scale(4,9)=698.46 : scale(5,9)=1396.91 : scale(6,9)=2793.83 : scale(7,9)=5587.65 : scale(8,9)=0.0
'scale(1,10) =92.50: scale(2,10)=185.00: scale(3,10)=369.99: scale(4,10)=739.99: scale(5,10)=1479.98: scale(6,10)=2959.96: scale(7,10)=5919.91: scale(8,10)=0.0
'scale(1,11) =98.00: scale(2,11)=196.00: scale(3,11)=392.00: scale(4,11)=783.99: scale(5,11)=1567.98: scale(6,11)=3135.96: scale(7,11)=6271.93: scale(8,11)=0.0
'scale(1,12)=103.83: scale(2,12)=207.65: scale(3,12)=415.30: scale(4,12)=830.61: scale(5,12)=1661.22: scale(6,12)=3322.44: scale(7,12)=6644.88: scale(8,12)=0.0

Dim Shared iBeats
Dim Shared iBeatsMin
BarTimMin = 15 'i.e. each eighth-note bar is 1 second at 15 bpm
Dim Shared iBeatsMax
iBeatsMax = 960 ' i.e. 960 could play the whole thing 4 times per second
Dim Shared iBars As Integer
iBars = 32
Dim Shared xPixels As Integer
xPixels = 320
Dim Shared yPixels As Integer
yPixels = 200
Dim Shared iNotches As Integer 'was 20
iNotches = 24
Dim Shared TopMargin As Integer 'was 0
TopMargin = 16
Dim Shared BottomMargin As Integer 'was 20
BottomMargin = 28
Dim Shared iNotchH As Integer 'was 10 (height of bar per notch)
iNotchH = (yPixels - BottomMargin - TopMargin) / iNotches
Dim Shared iBarSpacing As Integer 'was 10
iBarSpacing = Int(xPixels / (iBars + 2)) '+2 for margin
Dim Shared iBarW As Integer 'was 9
iBarW = iBarSpacing - 1
Dim Shared Octave As Integer
Dim Shared OctaveMin As Integer
OctaveMin = 1
Dim Shared OctaveMax As Integer
OctaveMax = 7
Dim Shared sound$
Dim Shared iLettersTyping As Integer
Randomize 2000
Open "qjak.ini" For Input As #1
Line Input #1, progdir$
Close
For charnow = 1 To Len(progdir$)
    If Mid$(progdir$, charnow, 1) = "=" Then GoTo SPLITHERE
Next charnow
SPLITHERE:
progdir$ = Right$(progdir$, Len(progdir$) - (charnow)) 'this is correct since STARTS at right
ChDir (progdir$)
Color 30
Cls



Open "bsound.dat" For Input As #1
Line Input #1, sound$
Close

iBeats = 90
Octave = 3 'C3 is middle c on grand staff.  A4 is 440hz
selText = 1
iSelectBar = 15
For checkbar = 1 To iBars
    bars(checkbar) = 8
Next checkbar

bTest = LoadAs%("oj1")

Screen 13
menu:
Select Case sound$
    Case "0": Sound 30000, 5
    Case "1": Sound 800, 1
End Select

Locate 3, 4
Color 15
Print "Welcome to ";
Color 40
Print "JakSound ";
Color 15
Print "studio 2.5"

Select Case sound$
    Case "0": Sound 30000, 5
    Case "1": Sound 300, 1
End Select

Cls
Locate 3, 4
Color 15
Print "Welcome to ";
Color 55
Print "JakSound ";
Color 15
Print "studio 2.5"
Select Case sound$
    Case "0": Sound 30000, 5
    Case "1": Sound 400, 1: Sound 250, 1: Sound 450, 1: Sound 600, 1: Sound 400, 1: Sound 250, 1: Sound 100, 1: Sound 150, 1: Sound 900, 1: Sound 600, 1
End Select

redomenu:
refmenu
Do
    Select Case InKey$
        Case Chr$(0) + "H": selText = selText - 1: refmenu
        Case Chr$(0) + "P": selText = selText + 1: refmenu
        Case "": Sleep 0
        Case "s": SwitchSound
        Case Chr$(13): GoSub ChoseSoGo
        Case Else: GoTo redomenu
    End Select
Loop



program:
DrawBars
ShowMenu
DrawSelector
bMouseMoved = 0
Do 'main event loop
    MouseStatus Lb, Rb, xMouseRaw, yMouseRaw
    If xMouseRawPrev <> xMouseRaw Or yMouseRawPrev <> yMouseRaw Or LbPrev <> Lb Or RbPrev <> Rb Then
        bFirst = 0
        If xPointerPrev < 0 Or yPointerPrev < 0 Then
            bFirst = 1
            xPointer = PointerFromMouseX%(xMouseRaw)
            yPointer = PointerFromMouseY%(yMouseRaw)
            xPointerPrev = xPointer
            yPointerPrev = yPointer
            xPointerCropped = PointerCroppedX%(xPointer)
            yPointerCropped = PointerCroppedY%(yPointer)
            Get (xPointerCropped - iPointerRad, yPointerCropped - iPointerRad)-(xPointerCropped + iPointerRad, yPointerCropped + iPointerRad), pUnderPointer!(1)
            bUnderPointer = 1
        End If
        xPointer = PointerFromMouseX%(xMouseRaw)
        yPointer = PointerFromMouseY%(yMouseRaw)
        If xMouseRawPrev <> xMouseRaw Or yMouseRawPrev <> yMouseRaw Then
            bMouseMoved = 1
        Else
            bMouseMoved = 0
        End If
        'IF bFirst = 0 THEN
        UndrawPointer 'PUT (xPointerPrev, yPointerPrev), pPointer!, XOR
        If Lb = -1 Then
            If LbPrev = -1 Then
                If bMouseMoved = 1 Then
                    If bDragging = 1 Then
                        OnDragging
                    Else
                        OnDragStart 'DOES set xDragStart and yDragStart
                    End If
                    bDragging = 1
                End If
            Else
                OnMouseDown
            End If
        ElseIf LbPrev = -1 Then
            OnMouseUp
            If bDragging = 1 Then OnDragEnd
            bDragging = 0
        End If
        If Rb = -1 Then
            If RbPrev = -1 Then
                If bMouseMoved = 1 Then
                    If bDragging = 1 Then
                        OnDragging
                    Else
                        OnDragStart 'DOES set xDragStart and yDragStart
                    End If
                    bDragging = 1
                End If
            Else
                OnMouseDown
            End If
        ElseIf RbPrev = -1 Then
            OnMouseUp
            If bDragging = 1 Then OnDragEnd
            bDragging = 0
        End If
        DrawPointer 'PUT (xPointer, yPointer), pPointer!, XOR
        xMouseRawPrev% = xMouseRaw
        yMouseRawPrev = yMouseRaw
        LbPrev = Lb
        RbPrev = Rb
        If bMouseMoved = 1 Then
            yPointerPrev = yPointer
            xPointerPrev = xPointer
        End If
    End If
    Select Case InKey$
        Case Chr$(0) + "K": BarChange (-1): DrawSelector 'LEFT ARROW
        Case Chr$(0) + "M": BarChange (1): DrawSelector 'RIGHT ARROW
        Case Chr$(0) + "H": PitchChange (1): DrawBar (iSelectBar): DrawSelector 'UP ARROW
        Case Chr$(0) + "P": PitchChange (-1): DrawBar (iSelectBar): DrawSelector 'DOWN ARROW
        Case "p": PlayAll
        Case "P": PlayAll
            'CASE CHR$(0) + ";": SaveBars: DrawBars: ShowMenu'F1 Saves
        Case Chr$(0) + "<": LoadArchaicJAS: DrawBars: ShowMenu 'F2 Loads archaic JAS file
            'CASE CHR$(0) + "=": ScriptBars: DrawBars: ShowMenu'F3 Saves As QB
        Case "S": SaveBars: DrawBars: ShowMenu 'F1 Saves
        Case "L": LoadBars: DrawBars: ShowMenu 'F2 Loads
        Case "E": ScriptBars: DrawBars: ShowMenu 'F3 Saves As QB
        Case "s": SaveBars: DrawBars: ShowMenu 'F1 Saves
        Case "l": LoadBars: DrawBars: ShowMenu 'F2 Loads
        Case "e": ScriptBars: DrawBars: ShowMenu 'F3 Saves As QB
        Case "-": SpeedChange (-1)
        Case "+": SpeedChange (1)
        Case "D": SpeedChange (-1)
        Case "U": SpeedChange (1)
        Case "d": SpeedChange (-1)
        Case "u": SpeedChange (1)
        Case "o": OctaveChange (-1)
        Case "O": OctaveChange (1)
        Case "M": ModeChange (1)
        Case "m": ModeChange (-1)
        Case "K": KeyChange (1)
        Case "k": KeyChange (-1)
        Case "r": RandomBars: DrawBars: ShowMenu
        Case "R": RandomBars: DrawBars: ShowMenu
            'CASE "": IF bMouseMoved = 0 THEN SLEEP 0
        Case Chr$(27): GoTo menu
    End Select
Loop


endit:
Chain ("QJAKMENU.BAS")
End

ChoseSoGo:

If (selText = 1) Then
    GoTo program
ElseIf (selText = 2) Then
    help
    GoTo menu
ElseIf (selText = 3) Then
    GoTo endit
End If
Return

'FUNCTION SAFEPOW% (base1,exp1)
'       bNegEx=0
'       rTotal = base1
'       IF exp1 = 0 THEN
'               rTotal = 1
'       ELSE
'               IF exp1 < 0 THEN
'                       exp1 = exp1 * -1
'                       bNegEx=1
'               END IF
'               FOR iNow = 1 TO exp1 - 1 ' - 1 since exp1=1 does nothing
'                       rTotal*=base1
'               NEXT iNow
'               IF bNegEx <> 0 THEN
'                       IF rTotal <> 0 THEN
'                               rTotal = 1 / rTotal
'                       END IF
'               END IF
'       END IF
'       SAFEPOW% = rTotal
'END FUNCTION
'end mouse functions
'end mouse functions

Sub BarChange (xBy%)
    'PSET (iSelectBar * 10 + 3, 190), 16
    EraseSelector 'LINE (iSelectBar * iBarSpacing - 1, (yPixels - BottomMargin) + 4)-(iSelectBar * iBarSpacing + 9, (yPixels - BottomMargin) + 8), 16, BF
    iSelectBar = iSelectBar + xBy%
    If (iSelectBar < 1) Then
        iSelectBar = 1
    ElseIf (iSelectBar > iBars) Then
        iSelectBar = iBars
    End If
    'ShowMenu
End Sub


Sub DrawBar (xNow%)
    'LINE (xNow% * 10, (yPixels-BottomMargin))-(xNow% * 10 + 8, 0), 16, BF 'erase first
    'LINE (xNow% * 10, (yPixels-BottomMargin))-(xNow% * 10 + 8, (yPixels-BottomMargin) - bars(xNow%) * 10), 5, BF
    'LINE (xNow% * 10 + 1, (yPixels-BottomMargin) - 1)-(xNow% * 10 + 7, 181 - bars(xNow%) * 10), 13, BF
    UndrawPointer
    iBaseColor = 55 - (bars(xNow%) / 1.6)
    LeftNow = xNow% * iBarSpacing
    BottomNow = yPixels - BottomMargin
    RightNow = xNow% * iBarSpacing + iBarW
    TopNow = (BottomNow) - bars(xNow%) * iNotchH 'TopMargin '(BottomNow) - (iNotchH * iNotches)
    Line (LeftNow, (BottomNow) - iNotches * iNotchH)-(RightNow, BottomNow), 16, BF 'erase first
    Line (LeftNow, BottomNow)-(RightNow, (BottomNow) - bars(xNow%) * iNotchH), iBaseColor + 72 + 24, BF 'lower
    Line (LeftNow + 1, (BottomNow) - 1)-(RightNow, (BottomNow) - bars(xNow%) * iNotchH), iBaseColor + 24, BF 'upper
    Line (LeftNow + 1, (BottomNow) - 1)-(RightNow - 1, ((BottomNow)) - bars(xNow%) * iNotchH + 1), iBaseColor, BF 'inner
    If IsInKey%(bars(xNow%)) = 0 Then
        Line (LeftNow + iBarW / 2 - 1, TopNow + 2)-(LeftNow + iBarW / 2 - 1, TopNow + 6), 15 'down 1
        Line (LeftNow + iBarW / 2 + 1, TopNow + 2)-(LeftNow + iBarW / 2 + 1, TopNow + 6), 15 'down 2
        Line (LeftNow + iBarW / 2 - 2, TopNow + 3)-(LeftNow + iBarW / 2 + 2, TopNow + 3), 15 'across 1
        Line (LeftNow + iBarW / 2 - 2, TopNow + 5)-(LeftNow + iBarW / 2 + 2, TopNow + 5), 15 'across 2
    End If
    DrawPointer
End Sub

Sub DrawBars
    Cls
    For iBarNow% = 1 To iBars
        DrawBar (iBarNow%)
        'LINE (iBarNow% * 10, BottomMargin)-(iBarNow% * 10 + 8, BottomMargin - bars(iBarNow%) * 10), 5, BF
        'LINE (iBarNow% * 10 + 1, BottomMargin - 1)-(iBarNow% * 10 + 7, 181 - bars(iBarNow%) * 10), 13, BF
    Next iBarNow%
End Sub


Sub DrawSelector
    DrawSelectorCustomHue 1
End Sub

Sub DrawSelectorCustom (iMid%, iDark%, iLight%)
    xbarnow = iSelectBar * iBarSpacing + 3
    Line (xbarnow, (yPixels - BottomMargin) + 4)-(xbarnow + 1, (yPixels - BottomMargin) + 4), iMid% '2px right (outer top)
    Line Step(0, 0)-Step(3, 3), iLight% '3px down-right (outer upper right)
    Line Step(0, 0)-Step(-7, 0), iDark% '8px left (outer bottom)
    Line Step(0, 0)-Step(3, -3), iMid% '3px up-right (outer upper left)
    Line (xbarnow, (yPixels - BottomMargin) + 5)-(xbarnow + 1, (yPixels - BottomMargin) + 5), iLight% '2px right (inner top)
    Line (xbarnow - 1, (yPixels - BottomMargin) + 6)-(xbarnow + 2, (yPixels - BottomMargin) + 6), iLight% '4px right (inner bottom)
End Sub

Sub DrawSelectorCustomHue (iBaseColor%)
    iLight% = iBaseColor%
    iMid% = iBaseColor% + 72 'recommended base color is 32 to 103 so that this works well
    iDark% = iBaseColor% = 144
    If iBaseColor% = 1 Then
        iLight% = 1
        iMid% = 9
        iDark% = 1
    ElseIf iBaseColor% = 0 Then
        iLight% = 0
        iMid% = 0
        iDark = 0
    End If
    DrawSelectorCustom iMid%, iDark%, iLight%
End Sub

Sub EraseSelector
    DrawSelectorCustomHue 0
End Sub

Function GetUserEntry$ (sCaption$)
    sReturn$ = ""
    Locate rowAt, colAt
    Color 0
    Print "                                       ";
    iLettersTyping% = 0
    
    refreshinput:
    Color 34
    Locate rowAt, colAt
    Print sCaption$; ":        ";
    Print "                                       ";
    Locate rowAt, colAt + Len(sCaption$) + 1
    Print sReturn$;
    Sleep 0
    Do
        keyNow$ = InKey$
        Select Case keyNow$
            Case "": GoTo refreshinput
            Case Chr$(8): Call MoveTextCursor(-1): sReturn$ = Mid$(sReturn$, 1, iLettersTyping%): GoTo refreshinput
            Case Chr$(32): GoTo refreshinput
            Case Chr$(9): GoTo refreshinput
            Case "/": GoTo refreshinput
            Case "\": GoTo refreshinput
            Case ":": GoTo refreshinput
            Case Chr$(9): GoTo refreshinput
            Case Chr$(27): iLettersTyping% = 0: Exit Do
            Case Chr$(13): Exit Do
            Case Else: sReturn$ = sReturn$ + keyNow$: Call MoveTextCursor(1): sReturn$ = Mid$(sReturn$, 1, iLettersTyping%): GoTo refreshinput
        End Select
    Loop
    
    Color 0
    Locate rowAt, colAt
    Print "                                       ";

    GetUserEntry$ = sReturn$
End Function

Sub help
    Cls
    Color 15
    Print "JakSound Studio 2.4" '
    Color 115
    Print "   1.   Arrow keys left and right move"
    Print "        between bars."
    Color 116
    Print "   2.   Arrow keys up and down change"
    Print "        bar height.  Height of bars"
    Print "        adjusts pitch of sound."
    Color 115
    Print "   3.   Highlighted letters on screen"
    Print "        control other settings."
    Color 116
    Color 115
    Print "        Save: saves to a jks file."
    Print "           Type 8 or less letters"
    Print "            for a filename."
    Color 116
    Print "        Load: loads from jks file."
    Print "            type in 8 or less letters"
    Print "            the name of a previously"
    Print "            saved file."
    Color 115
    Print "        Export QB: writes qbasic code"
    Print "            (.QB file) YOU can paste"
    Print "            into your QBasic programs."
    Color 15
    Print "Press a key to continue..."
    Sleep 0
End Sub

Function IsInKey% (NoteX%)
    NoteCooked% = NoteX%
    bHigh = 0
    If NoteCooked% > 12 Then
        bHigh = 1
        NoteCooked% = NoteCooked% - 12
    End If
    bMatch% = 0
    For iStep = 0 To 7
        If IonianDistAtStep(WrapNote07%(iStep + modestartrel(iMode%))) = NoteCooked% Then
            bMatch% = 1
            Exit For
        End If
    Next iStep
    IsInKey% = bMatch%
End Function

Sub KeyChange (iBy%)
    iKey = iKey + iBy%
    If (iKey < 1) Then
        iKey = 1
    ElseIf (iKey > 12) Then
        OctaveChange 1
        iKey = 1
    End If
    ShowMenu
End Sub

Function KeyToString$
    KeyToString$ = KeyToStringCustom$(iKey, iMode)
End Function

Function KeyToStringCustom$ (iKeyX%, iModeX%)
    sReturn$ = ""
    Select Case iKeyX%
        Case 1: sReturn$ = sReturn$ + "A"
        Case 2: sReturn$ = sReturn$ + "Bb"
        Case 3: sReturn$ = sReturn$ + "B"
        Case 4: sReturn$ = sReturn$ + "C"
        Case 5: sReturn$ = sReturn$ + "C#"
        Case 6: sReturn$ = sReturn$ + "D"
        Case 7: sReturn$ = sReturn$ + "Eb"
        Case 8: sReturn$ = sReturn$ + "E"
        Case 9: sReturn$ = sReturn$ + "F"
        Case 10: sReturn$ = sReturn$ + "F#"
        Case 11: sReturn$ = sReturn$ + "G"
        Case 12: sReturn$ = sReturn$ + "G#"
        Case Else: sReturn$ = sReturn$ + "nokey#" + ToString$(iKeyX%)
    End Select
    sReturn$ = sReturn$ + "-"
    Select Case iModeX%
        'reference: http://www.wisegeek.com/what-are-the-seven-modes-of-music.htm 8/8/2007
        Case 1: sReturn$ = sReturn$ + "Ionian" 'Major
        Case 2: sReturn$ = sReturn$ + "Dorian" 'Celtic and early Irish-Influenced American folk
        Case 3: sReturn$ = sReturn$ + "Phrygian" 'good for guitar solos in IonianDistAtStep songs
        Case 4: sReturn$ = sReturn$ + "Lydian" 'sounds unpredictable, jazz etc
        Case 5: sReturn$ = sReturn$ + "Myxolydian" 'sometimes good for guitar solos in IonianDistAtStep songs
        Case 6: sReturn$ = sReturn$ + "Aeolian" 'sometimes called minor; even darker than Dorian
        Case 7: sReturn$ = sReturn$ + "Locrian" 'hard to work with, sometimes considered theoretical
        Case Else: sReturn$ = sReturn$ + "no"
    End Select
    sReturn$ = sReturn$ + " mode:" + ToString$(iModeX%) + "  RelToMajor:" + ToString(modestartrel(iModeX%))
    KeyToStringCustom$ = sReturn$
End Function

Sub LoadArchaicJAS
    sFile$ = GetUserEntry$("Old JakSound JAS file")
    If Len(sFile$) > 0 Then
        Open sFile$ + ".jas" For Input As #1
        Do Until (EOF(1))
            barnum = barnum + 1
            Line Input #1, temp$
            bars(barnum) = Asc(temp$)
            bars(barnum) = bars(barnum) - 40
        Loop
        Close
        Locate rowAt, colAt
        Color 0
        Print "Loaded "; sFile$; ".jas";
    Else
        Locate rowAt, colAt
        Color 0
        Print "Canceled Load.";
    End If
End Sub

Function LoadAs% (sFile$)
    LoadAs% = 0
    iBarNow% = 0
    bGood = 0
    iBarsSpecified% = 0
    Color 89 ' a pale red
    iLine% = 0
    Open sFile$ + ".jks" For Input As #1
    If (EOF(1)) Then
        Print "[empty file!]"
    Else
        Line Input #1, temp$ 'note count as saved in file
        iBarsSpecified% = StringToInt(temp$)
        iLine% = iLine% + 1
        For iBarNow% = 1 To iBarsSpecified%
            If (EOF(1)) Then
                Exit For
            Else
                Line Input #1, temp$
                If iBarNow% <= iBars Then bars(iBarNow%) = StringToInt%(temp$)
                iLine% = iLine% + 1
            End If
        Next iBarNow%
            
        If iLine% - 1 < iBars Then
            Print "(File missing some of " + ToString$(iBarsSpecified%) + " notes specified"
            Print " ending at line "; iLine%; "."
            Print " If old, rename to JAS and press F2 in JakSound)";
        Else
            If (EOF(1)) Then
                Print "[file missing BPM]";
            Else
                Line Input #1, temp$ 'BPM
                iBeats = StringToInt%(temp$)
                iLine% = iLine% + 1
                If (EOF(1)) Then
                    Print "[file missing KEY]";
                Else
                    Line Input #1, temp$ 'KEY
                    iKey = StringToInt%(temp$)
                    iLine% = iLine% + 1
                    If (EOF(1)) Then
                        Print "[file missing MODE]";
                    Else
                        Line Input #1, temp$ 'MODE
                        iMode = StringToInt%(temp$)
                        iLine% = iLine% + 1
                        bGood = 1
                    End If
                End If
            End If
        End If
    End If
    Close
    If bGood = 1 Then LoadAs% = 1
End Function

Sub LoadBars
    sFile$ = GetUserEntry$("Load File")
    If Len(sFile$) > 0 Then
        Locate rowAt, colAt
        bTest = LoadAs%(sFile$)
        Color 15
        If bTest = 1 Then
            Print "  Finished "; sFile$; ".jks"
        Else
            Color 41 '1 notch away from most saturated red
            Print "  Failed loading "; sFile$; ".jks"
        End If
        Print "Press any key."
        Sleep 0
    Else
        Locate rowAt, colAt
        Color 15
        Print "Canceled Load.";
    End If
End Sub

Sub ModeChange (iBy%)
    iMode = iMode + iBy%
    If (iMode < 1) Then
        iMode = 1
    ElseIf (iMode > 7) Then
        iMode = 1
    End If
    ShowMenu
End Sub

Sub MoveTextCursor (iAdder%)
    iLettersTyping% = iLettersTyping% + iAdder%
    If (iLettersTyping% < 0) Then
        iLettersTyping% = 0
    ElseIf (iLettersTyping% > 8) Then
        iLettersTyping% = 8
    End If

End Sub

Function NoteInKey% (NoteX%)
    NoteCooked% = NoteX%
    'bHigh = 0
    'IF NoteInKey% > 12 THEN
    '       bHigh = 1
    '       NoteInKey% = NoteInKey% - 12
    'END IF
    If IsInKey%(NoteX%) = 0 Then NoteCooked% = NoteCooked% + 1
    'FOR iStep = 1 TO 12
    'NEXT iStep
    'IF bHigh = 1 THEN NoteInKey% = InInKey% + 12
    NoteInKey% = NoteCooked%
End Function

Sub OctaveChange (iBy%)
    Octave = Octave + iBy%
    If (Octave < OctaveMin) Then
        Octave = OctaveMin
    ElseIf (Octave > OctaveMax) Then
        Octave = OctaveMax
    End If
    ShowMenu
End Sub


Sub PitchChange (yBy%)
    bars(iSelectBar) = bars(iSelectBar) + yBy%
    If (bars(iSelectBar) < 0) Then
        bars(iSelectBar) = 0
    ElseIf (bars(iSelectBar) > iNotches) Then
        bars(iSelectBar) = iNotches
    End If
    'ShowMenu
End Sub

Sub PlayAll
    EraseSelector
    bPlaying = 1
    ShowMenu
    iPrev = iSelectBar
    For iBarNow% = 1 To iBars
        iSelectBar = iBarNow%
        DrawSelectorCustomHue 47
        'OctaveNow = Octave
        'NotchNow = bars(iBarNow%)
        If bars(iBarNow%) > 12 Then
            Sound scale(Octave + 1, bars(iBarNow%) - 12), ((60 / iBeats) / 8) * (18.2) '1sec is about 18.2 ticks; /8 since 4/8 timing
            'NotchNow = NotchNow - 12
            'OctaveNow = OctaveNow + 1
            If InKey$ = "x" Then iBarNow% = iBars
        ElseIf bars(iBarNow%) = 0 Then
            Sound 22000, ((60 / iBeats) / 8) * (18.2)
        Else
            Sound scale(Octave, bars(iBarNow%)), ((60 / iBeats) / 8) * (18.2) '1sec is about 18.2 ticks; /8 since 4/8 timing
        End If
        ShowMenu
        EraseSelector
    Next iBarNow%
    iSelectBar = iPrev
    DrawSelector
    bPlaying = 0
    ShowMenu
End Sub


Sub RandomBars
    'up
    'bars(iSelectBar) = bars(iSelectBar) + 1
    'IF bars(iSelectBar) > 18 THEN
    '       bars(iSelectBar) = 18
    'END IF
    'down
    'bars(iSelectBar) = bars(iSelectBar) - 1
    'IF bars(iSelectBar) < 1 THEN
    '       bars(iSelectBar) = 1
    'END IF
    For iBar = 1 To iBars
        bars(iBar) = Rnd * iNotches
    Next iBar
    iBeats = Int((Rnd * (90) + iBeatsMin))
    If iBeats > iBeatsMax Then iBeats = iBeatsMax
End Sub

Sub refmenu
    If (selText < 1) Then
        selText = 1
    ElseIf (selText > 3) Then
        selText = 3
    End If
    Color 16
    Locate 12, 16
    Print ""
    Locate 13, 16
    Print ""
    Locate 14, 16
    Print ""
    Color 11
    If (selText = 1) Then
        Locate 12, 16
        Print ""
        Color 3
        Locate 12, 17
        Print "Studio"
        Color 125
        Locate 13, 17
        Print "Help"
        Color 125
        Locate 14, 17
        Print "Quit"
    ElseIf (selText = 2) Then
        Locate 13, 16
        Print ""
        Color 125
        Locate 12, 17
        Print "Studio"
        Color 3
        Locate 13, 17
        Print "Help"
        Color 125
        Locate 14, 17
        Print "Quit"
    ElseIf (selText = 3) Then
        Locate 14, 16
        Print ""
        Color 125
        Locate 12, 17
        Print "Studio"
        Color 125
        Locate 13, 17
        Print "Help"
        Color 3
        Locate 14, 17
        Print "Quit"
    End If
End Sub


Function SaveAs% (sFile$)
    Open sFile$ + ".jks" For Output As #1
    Print #1, ToString(iBars)
    'PRINT #1, CHR$(13);
    For iBarNow% = 1 To iBars
        Print #1, ToString(bars(iBarNow%))
        'PRINT #1, CHR$(13);
    Next iBarNow%
    Print #1, ToString(iBeats)
    'PRINT #1, CHR$(13);
    Print #1, ToString(iKey)
    'PRINT #1, CHR$(13);
    Print #1, ToString(iMode)
    'PRINT #1, CHR$(13);
    Close
    SaveAs% = 1
End Function

Sub SaveBars
    sFile$ = GetUserEntry("Save File")
    If Len(sFile$) > 0 Then
        bTest = SaveAs%(sFile$)
        Locate rowAt, colAt
        Color 0
        Print "Saved "; sFile$; ".jks";
    Else
        Locate rowAt, colAt
        Color 0
        Print "Canceled Save.";
    End If
End Sub

Sub ScriptBars
    sFile$ = GetUserEntry$("Export QB")
    If Len(sFile$) > 0 Then
        Open sFile$ + ".bas" For Output As #1
        Print "DIM SHARED scale(8,12)"
        Print "rPrev=0.0"
        Print "FOR iOv = 1 to 8"
        Print "     FOR iStep = 1 to 12"
        Print "          IF rPrev = 0.0 THEN"
        Print "             scale (iOv,iStep) = 55.0"
        Print "             rPrev=55.0"
        Print "          ELSE"
        Print "             scale (iOv,iStep) = rPrev * 2.0^(1.0/12.0)"
        Print "             rPrev = scale(iOv,iStep)"
        Print "          END IF"
        Print "     NEXT iStep"
        Print "NEXT iOv"
        For iBarNow% = 1 To iBars
            If bars(iBarNow%) > 12 Then
                Print #1, "SOUND "; scale(Octave + 1, bars(iBarNow%) - 12); ", "; ((60 / iBeats) / 8) * (18.2); "' 1sec is about 18.2 ticks; /8 since 4/8 timing"
                'NotchNow = NotchNow - 12
                'OctaveNow = OctaveNow + 1
            ElseIf bars(iBarNow%) = 0 Then
                Print #1, "SOUND 22000, "; ((60 / iBeats) / 8) * (18.2)
            Else
                Print #1, "SOUND "; scale(Octave, bars(iBarNow%)); ", "; ((60 / iBeats) / 8) * (18.2); "' 1sec is about 18.2 ticks; /8 since 4/8 timing"
            End If
        
            '               PRINT #1, "SOUND "; bars(iBarNow%) * 50; ", "; iBeats / 10
        Next iBarNow%
        Close
        Locate rowAt, colAt
        Color 0
        Print "Exported "; sFile$; ".bas";
    Else
        Locate rowAt, colAt
        Color 0
        Print "Canceled Export.";
    End If
End Sub

Sub SetBarByPointer (bInTune%)
    UndrawPointer
    Dim iCheckBar As Integer
    BottomNow = yPixels - BottomMargin
    TopNow = TopMargin + 1 '(BottomNow) - (iNotchH * iNotches)
    If yPointer <= BottomNow And yPointer >= TopNow Then
        For iCheckBar = 1 To iBars
            LeftNow = iCheckBar * iBarSpacing
            RightNow = iCheckBar * iBarSpacing + iBarW
            If xPointer >= LeftNow And xPointer <= RightNow Then
                If iCheckBar <> iSelectBar Then
                    BarChange iCheckBar - iSelectBar
                    DrawSelector
                End If
                If YToBarNotch%(yPointer) <> bars(iCheckBar) Then
                    If bInTune% = 1 Then
                        PitchChange NoteInKey%(YToBarNotch%(yPointer)) - bars(iCheckBar)
                    Else
                        PitchChange YToBarNotch%(yPointer) - bars(iCheckBar)
                    End If
                    DrawBar (iSelectBar)
                End If
                Exit For
            End If
        Next iCheckBar
    End If
    DrawPointer
End Sub

Sub ShowMenu
    iLight = 15
    iDark = 35
    If bPlaying = 0 Then
        Color 16
        'LOCATE 24, 1
        'PRINT "                                       ";
        Locate 1, 1
        Print "                                       ";
        Locate 2, 1
        Print "                                       ";
        Locate 3, 1
        Print "                                       ";
        Locate 24, 1
        Color 35
        ' semicolon keeps it on the same line!!!!!!!!!!!!!!!!!!!!
        Locate 24, 1
        Print "(4/8)BPM:";
        Color 39
        Print iBeats;
        Color 39
        Print "Octave: ";
        Color 39
        Print Octave;
        Color 39
        Print "-";
        Color 39
        Print Octave + 1;
        Locate 3, 1
        Print "Key:";
        Print KeyToString$;
        
        Locate 1, 1
        Print "";
        Color iLight: Print "S";
        Color iDark: Print "ave ";
        Color iLight: Print "L";
        Color iDark: Print "oad ";
        Color iLight: Print "E";
        Color iDark: Print "xportQB ";
        Color iLight: Print "K";
        Color iDark: Print "ey ";
        Color iLight: Print "O";
        Color iDark: Print "ctave ";
        Color iLight: Print "M";
        Color iDark: Print "ode "
        Print " Speed ";
        Color iLight: Print "U";
        Color iDark: Print "p ";
        Print " Speed ";
        Color iLight: Print "D";
        Color iDark: Print "own ";
        Color iLight: Print " P";
        Color iDark: Print "lay ";
        Color iLight: Print " R";
        Color iDark: Print "andomize"
    Else
        Color 16
        Locate 24, 1
        Print "                                       ";
        Locate 1, 1
        Print "                                       ";
        Locate 2, 1
        Print "                                       ";
        Locate 3, 1
        Print "                                       ";
        Locate 24, 1
        Color 10
        Print "              playing                  ";
        Locate 1, 1
        rSpeed = 60 / iBeats * 1000 / 8
        rHz = 0
        If bars(iSelectBar%) > 12 Then
            rHz = scale(Octave + 1, bars(iSelectBar%) - 12)
        Else
            rHz = scale(Octave, bars(iSelectBar%))
        End If
        Print iBeats
        Print "BPM     ";
        Print rSpeed;
        Print "ms      "
        Print rHz;
        Print "Hz     ";
    End If
End Sub

Sub SpeedChange (iBy%)
    iBeats = iBeats + iBy%
    If (iBeats < 1) Then
        iBeats = 1
    ElseIf (iBeats > iBeatsMax) Then
        iBeats = iBeatsMax
    End If
    ShowMenu
End Sub


Sub SwitchSound

    Open "bsound.dat" For Output As #1
    Select Case sound$
        Case "0": Print #1, "1": sound$ = "1": Color 38: Locate 15, 15: Print "MUTE OFF";
        Case "1": Print #1, "0": sound$ = "0": Color 40: Locate 15, 15: Print "  MUTE  ";
    End Select
    Close

End Sub


Function WrapNote07% (NoteX%)
    NoteCooked% = NoteX%
    Do While NoteCooked% > 7
        NoteCooked% = NoteCooked% - 8 'sends it back to zero since 8va isn't indexed as a note
    Loop
    Do While NoteCooked% < 0 '0 is allowed since zero is indexed as a note
        NoteCooked% = NoteCooked% + 8 'i.e. -1 is 7 (a 7th, actually)
    Loop
    WrapNote07% = NoteCooked%
End Function

Function WrapNote12% (NoteX%)
    NoteCooked% = NoteX%
    Do While NoteCooked% > 12
        NoteCooked% = NoteCooked% - 12 'i.e. 13 is actually 1 on an octave of 0-12 since 12 is the same note as zero
    Loop
    Do While NoteCooked% < 1
        NoteCooked% = NoteCooked% + 12 'i.e. -1 is 11 (Major 7th)
    Loop
    WrapNote12% = NoteCooked%
End Function

Function YToBarNotch% (yNow%)
    YToBarNotch% = ((yPixels - BottomMargin) - yNow%) / iNotchH
End Function

'start common & mouse functions
Function CharToInt% (sNow$)
    iReturn% = 0
    For iVal% = 0 To 9
        If sarrDigit(iVal%) = sNow$ Then
            iReturn% = iVal%
            Exit For
        End If
    Next iVal%
    CharToInt% = iReturn%
End Function
Sub DrawPointer
    If bPointerShowing = 0 Then
        'draw mouse cursor manually
        xPointerCropped = PointerCroppedX%(xPointer)
        yPointerCropped = PointerCroppedY%(yPointer)
        Get (xPointerCropped - iPointerRad, yPointerCropped - iPointerRad)-(xPointerCropped + iPointerRad, yPointerCropped + iPointerRad), pUnderPointer!(1)
        bUnderPointer = 1
        LINESAFEH xPointer - (iPointerRad - 1), yPointer - 1, xPointer - 1, yPointer - 1, 0
        LINESAFEH xPointer - iPointerRad, yPointer, xPointer - 1, yPointer, 15 'LEFT
        LINESAFEH xPointer - (iPointerRad - 1), yPointer + 1, xPointer - 1, yPointer + 1, 0
           
        LINESAFEH xPointer + (iPointerRad - 1), yPointer - 1, xPointer + 1, yPointer - 1, 0
        LINESAFEH xPointer + iPointerRad, yPointer, xPointer + 1, yPointer, 15 'RIGHT
        LINESAFEH xPointer + (iPointerRad - 1), yPointer + 1, xPointer + 1, yPointer + 1, 0
           
        LINESAFEV xPointer, yPointer - 1, xPointer, yPointer - iPointerRad, 15 'TOP
           
        LINESAFEV xPointer, yPointer + 1, xPointer, yPointer + iPointerRad, 15 'BOTTOM
        bPointerShowing = 1
    End If
End Sub

Sub LINESAFEH (xStart%, yStart%, xEnd%, yEnd%, iColor%)
    iStep% = 1
    If xStart > xEnd Then iStep% = -1
    If yStart < yPixels And yStart >= 0 Then
        For xNow% = xStart% To xEnd% Step iStep%
            If xNow >= 0 And xNow < xPixels Then PSet (xNow%, yStart%), iColor%
        Next xNow%
    End If
End Sub

Sub LINESAFEV (xStart%, yStart%, xEnd%, yEnd%, iColor%)
    iStep% = 1
    If yStart > yEnd Then iStep% = -1
    
    If xStart < xPixels And xStart >= 0 Then
        For yNow% = yStart% To yEnd% Step iStep%
            If yNow >= 0 And yNow < yPixels Then PSet (xStart%, yNow%), iColor%
        Next yNow%
    End If
End Sub

DefLng A-Z
'start mouse functions
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

Sub MousePut (xAt%, yAt%)
    ax% = 4
    cx% = xAt%
    dx% = yAt%
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
    Put (xPointer, yPointer), pPointer!(), Xor
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
    'DrawWindow
End Sub

Sub OnDragEnd
    SetBarByPointer 1
End Sub

Sub OnDragging
    SetBarByPointer 1
End Sub

Sub OnDragStart
    xDragStart = xPointer
    yDragStart = yPointer
    'SetBarByPointer
End Sub

Sub OnMouseDown
    SetBarByPointer 0
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
    'DrawWindow
End Sub

Sub OnMouseUp
    'SetBarByPointer
End Sub

Function PointerCroppedX% (xMouse%)
    'DIM xPointerCropped AS INTEGER
    xPointerCropped = xMouse%
    Dim xMax As Integer
    xMax = xPixels - 1
    If xMouse% - iPointerRad < 0 Then
        xPointerCropped = iPointerRad
    ElseIf xMouse% + iPointerRad >= xMax Then
        xPointerCropped = xMax - iPointerRad
    End If
    PointerCroppedX% = xPointerCropped
End Function

Function PointerCroppedY% (yMouse%)
    'DIM yPointerCropped AS INTEGER
    yPointerCropped = yMouse%
    Dim yMax As Integer
    yMax = yPixels - 1
    If yMouse% - iPointerRad < 0 Then
        yPointerCropped = iPointerRad
    ElseIf yMouse% + iPointerRad >= yMax Then
        yPointerCropped = yMax - iPointerRad
    End If
    PointerCroppedY% = yPointerCropped
End Function

Function PointerFromMouseX% (xMouse%)
    PointerFromMouseX% = Int(ToDouble#(xMouse%) / 2! + .5)
End Function

Function PointerFromMouseY% (yMouse%)
    PointerFromMouseY% = yMouse% 'yMouse%+2
End Function
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
Function StringToInt% (sNow$)
    iReturn% = 0
    iMultiplier% = 1
    For iChar% = Len(sNow$) To 1 Step -1
        iReturn% = iReturn% + iMultiplier% * CharToInt%(Mid$(sNow$, iChar%, 1))
        iMultiplier% = iMultiplier% * 10
    Next iChar%
    StringToInt% = iReturn%
End Function
Function ToDouble# (iNow%)
    ToDouble# = iNow%
End Function

Function ToString$ (iNow%)
    bNeg = 0
    If iNow% < 0 Then
        bNeg = 1
        iNow% = iNow% * -1
    End If
    sReturn$ = ""
    'iDivisor% = 1
    iValDigit% = 0
    iRemaining% = iNow%
    'rHighDivisor% = 1
    'DO WHILE iNow% / rHighDivisor >= 1
    '        rHighDivisor% = rHighDivisor% * 10
    'LOOP
    'rHighDivisor% = rHighDivisor% / 10

    Do While iRemaining% > 0 'AND rHighDivisor >= 1
        iValDigit% = SafeMod%(iRemaining%, 10)
        'iRemaining% = iRemaining% - iValDigit% * iDivisor%
        'iRemaining% = iRemaining% / 10
        sReturn$ = sarrDigit(iValDigit%) + sReturn$
        iRemaining% = iRemaining% / 10 - .4 '-.4 to avoid automatic rounding up
        'rHighDivisor = rHighDivisor / 10
        'iDivisor% = iDivisor% * 10
    Loop
    If bNeg = 1 Then sReturn$ = "-" + sReturn$
    ToString$ = sReturn$
End Function

Sub UndrawPointer
    If bUnderPointer = 1 Then
        If bPointerShowing = 1 Then
            Put (PointerCroppedX%(xPointerPrev) - iPointerRad, PointerCroppedY%(yPointerPrev) - iPointerRad), pUnderPointer!(), PSet
            bPointerShowing = 0
        End If
    End If
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


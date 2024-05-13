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
DEFINT A-Z: DEF SEG = &HA000:
DIM SHARED mouse$: mouse$ = SPACE$(57)
SCREEN 13
FOR i% = 1 TO 57:  READ a$:  H$ = CHR$(VAL("&H" + a$))
MID$(mouse$, i%, 1) = H$: NEXT i%
DATA 55,89,E5,8B,5E,0C,8B,07,50,8B,5E,0A,8B,07,50,8B
DATA 5E,08,8B,0F,8B,5E,06,8B,17,5B,58,1E,07,CD,33,53
DATA 8B,5E,0C,89,07,58,8B,5E,0A,89,07,8B,5E,08,89,0F
DATA 8B,5E,06,89,17,5D,CA,08,00
RESTORE
ms% = MouseInit%
IF NOT ms% THEN
  PRINT "Mouse not found"
  SOUND 40, 2
  END
END IF
LOCATE 1, 1
MousePut 320 / 2, 200 / 2
MouseRange 0, 0, 320 * 2, 200
'extra mouse stuff:
DIM SHARED xMouseRaw AS INTEGER
DIM SHARED yMouseRaw AS INTEGER
DIM SHARED xDragStart AS INTEGER
DIM SHARED yDragStart AS INTEGER
DIM SHARED xMouseRawPrev AS INTEGER
xMouseRawPrev = -1
DIM SHARED yMouseRawPrev AS INTEGER
yMouseRawPrev = -1
DIM SHARED LbPrev AS INTEGER
LbPrev = 0
DIM SHARED RbPrev AS INTEGER
RbPrev = 0
DIM SHARED bMouseMoved AS INTEGER
bMouseMoved = 0
DIM SHARED pPointer!(1 TO 8)
DIM SHARED pUnderPointer!(1 TO 8)
DIM SHARED bUnderPointer AS INTEGER
bUnderPointer = 0
DIM SHARED xPointer AS INTEGER
DIM SHARED yPointer AS INTEGER
DIM SHARED xPointerPrev AS INTEGER
xPointerPrev = -1 'must start out negative
DIM SHARED yPointerPrev AS INTEGER
xPointerPrev = -1 'must start out negative

DIM SHARED iPointerWidth AS INTEGER
DIM SHARED iPointerHeight AS INTEGER
DIM SHARED iPointerRad AS INTEGER
iPointerRad = 2
iPointerWidth = iPointerRad * 2 + 1
iPointerHeight = iPointerRad * 2 + 1
DIM SHARED xPointerCropped AS INTEGER
xPointerCropped = -1
DIM SHARED yPointerCropped AS INTEGER
xPointerCropped = -1
DIM SHARED bPointerShowing AS INTEGER
bPointerShowing = 0
MakePointer 'sets pPointer
'end mouse initialization
DIM SHARED sarrDigit(0 TO 9) AS STRING
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



DIM SHARED selText AS INTEGER
DIM SHARED iSelectBar AS INTEGER
DIM SHARED bars(1 TO 32) AS INTEGER
DIM SHARED bPlaying AS INTEGER
DIM SHARED rowAt
rowAt = 3 'user input location
DIM SHARED colAt
colAt = 1 'user input location
bPlaying = 0

DIM SHARED iKey AS INTEGER
iKey = 8 '8 is E, 1 is A
DIM SHARED iMode AS INTEGER
iMode = 1 'index of modestartabs
DIM SHARED IonianDistAtStep(0 TO 7) AS INTEGER
IonianDistAtStep(0) = 0
IonianDistAtStep(1) = 2
IonianDistAtStep(2) = 4
IonianDistAtStep(3) = 5
IonianDistAtStep(4) = 7
IonianDistAtStep(5) = 9
IonianDistAtStep(6) = 11
IonianDistAtStep(7) = 12
DIM SHARED modestartrel(1 TO 7) AS INTEGER 'where the mode starts in the ionian scale
modestartrel(1) = 0
modestartrel(2) = 1
modestartrel(3) = 2
modestartrel(4) = 3
modestartrel(5) = 4
modestartrel(6) = 5
modestartrel(7) = 6
DIM SHARED modestartabs(1 TO 7) AS INTEGER 'where the mode starts in the ionian range
modestartabs(1) = 0
modestartabs(2) = 2
modestartabs(3) = 4
modestartabs(4) = 5
modestartabs(5) = 7
modestartabs(6) = 9
modestartabs(7) = 11
DIM SHARED scale(8, 12) AS INTEGER
rPrev = 0!
FOR iOv = 1 TO 8
	FOR iStep = 1 TO 12
		IF rPrev = 0! THEN
			scale(iOv, iStep) = 55!
			rPrev = 55!
		ELSE
			scale(iOv, iStep) = rPrev * 2! ^ (1! / 12!)
			rPrev = scale(iOv, iStep)
		END IF
	NEXT iStep
NEXT iOv



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

DIM SHARED iBeats
DIM SHARED iBeatsMin
BarTimMin = 15'i.e. each eighth-note bar is 1 second at 15 bpm
DIM SHARED iBeatsMax
iBeatsMax = 960' i.e. 960 could play the whole thing 4 times per second
DIM SHARED iBars AS INTEGER
iBars = 32
DIM SHARED xPixels AS INTEGER
xPixels = 320
DIM SHARED yPixels AS INTEGER
yPixels = 200
DIM SHARED iNotches AS INTEGER 'was 20
iNotches = 24
DIM SHARED TopMargin AS INTEGER 'was 0
TopMargin = 16
DIM SHARED BottomMargin AS INTEGER 'was 20
BottomMargin = 28
DIM SHARED iNotchH AS INTEGER 'was 10 (height of bar per notch)
iNotchH = (yPixels - BottomMargin - TopMargin) / iNotches
DIM SHARED iBarSpacing AS INTEGER 'was 10
iBarSpacing = INT(xPixels / (iBars + 2))'+2 for margin
DIM SHARED iBarW AS INTEGER 'was 9
iBarW = iBarSpacing - 1
DIM SHARED Octave AS INTEGER
DIM SHARED OctaveMin AS INTEGER
OctaveMin = 1
DIM SHARED OctaveMax AS INTEGER
OctaveMax = 7
DIM SHARED sound$
DIM SHARED iLettersTyping AS INTEGER
RANDOMIZE 2000
OPEN "qjak.ini" FOR INPUT AS #1
	  LINE INPUT #1, progdir$
CLOSE
FOR charnow = 1 TO LEN(progdir$)
	IF MID$(progdir$, charnow, 1) = "=" THEN GOTO SPLITHERE
NEXT charnow
SPLITHERE:
progdir$ = RIGHT$(progdir$, LEN(progdir$) - (charnow))  'this is correct since STARTS at right
CHDIR (progdir$)
COLOR 30
CLS



OPEN "bsound.dat" FOR INPUT AS #1
	  LINE INPUT #1, sound$
CLOSE

iBeats = 90
Octave = 3 'C3 is middle c on grand staff.  A4 is 440hz
selText = 1
iSelectBar = 15
FOR checkbar = 1 TO iBars
	bars(checkbar) = 8
NEXT checkbar

bTest = LoadAs%("oj1")

SCREEN 13
menu:
SELECT CASE sound$
	CASE "0": SOUND 30000, 5
	CASE "1": SOUND 800, 1
END SELECT

LOCATE 3, 4
COLOR 15
PRINT "Welcome to ";
COLOR 40
PRINT "JakSound ";
COLOR 15
PRINT "studio 2.5"

SELECT CASE sound$
	CASE "0": SOUND 30000, 5
	CASE "1": SOUND 300, 1
END SELECT

CLS
LOCATE 3, 4
COLOR 15
PRINT "Welcome to ";
COLOR 55
PRINT "JakSound ";
COLOR 15
PRINT "studio 2.5"
SELECT CASE sound$
	CASE "0": SOUND 30000, 5
	CASE "1": SOUND 400, 1: SOUND 250, 1: SOUND 450, 1: SOUND 600, 1: SOUND 400, 1: SOUND 250, 1: SOUND 100, 1: SOUND 150, 1: SOUND 900, 1: SOUND 600, 1
END SELECT

redomenu:
refmenu
DO
SELECT CASE INKEY$
	CASE CHR$(0) + "H": selText = selText - 1: refmenu
	CASE CHR$(0) + "P": selText = selText + 1: refmenu
	CASE "": SLEEP 0
	CASE "s": SwitchSound
	CASE CHR$(13): GOSUB ChoseSoGo
	CASE ELSE: GOTO redomenu
END SELECT
LOOP



program:
DrawBars
ShowMenu
DrawSelector
bMouseMoved = 0
DO 'main event loop
	MouseStatus Lb, Rb, xMouseRaw, yMouseRaw
	IF xMouseRawPrev <> xMouseRaw OR yMouseRawPrev <> yMouseRaw OR LbPrev <> Lb OR RbPrev <> Rb THEN
		bFirst = 0
		IF xPointerPrev < 0 OR yPointerPrev < 0 THEN
			bFirst = 1
			xPointer = PointerFromMouseX%(xMouseRaw)
			yPointer = PointerFromMouseY%(yMouseRaw)
			xPointerPrev = xPointer
			yPointerPrev = yPointer
			xPointerCropped = PointerCroppedX%(xPointer)
			yPointerCropped = PointerCroppedY%(yPointer)
			GET (xPointerCropped - iPointerRad, yPointerCropped - iPointerRad)-(xPointerCropped + iPointerRad, yPointerCropped + iPointerRad), pUnderPointer!(1)
			bUnderPointer = 1
		END IF
		xPointer = PointerFromMouseX%(xMouseRaw)
		yPointer = PointerFromMouseY%(yMouseRaw)
		IF xMouseRawPrev <> xMouseRaw OR yMouseRawPrev <> yMouseRaw THEN
			bMouseMoved = 1
		ELSE
			bMouseMoved = 0
		END IF
		'IF bFirst = 0 THEN 
		UndrawPointer 'PUT (xPointerPrev, yPointerPrev), pPointer!, XOR
		IF Lb = -1 THEN
			IF LbPrev = -1 THEN
				IF bMouseMoved = 1 THEN
					IF bDragging = 1 THEN
						OnDragging
					ELSE
						OnDragStart 'DOES set xDragStart and yDragStart
					END IF
					bDragging = 1
				END IF
			ELSE
				OnMouseDown
			END IF
		ELSEIF LbPrev = -1 THEN
			OnMouseUp
			IF bDragging = 1 THEN OnDragEnd
			bDragging = 0
		END IF
		IF Rb = -1 THEN
			IF RbPrev = -1 THEN
				IF bMouseMoved = 1 THEN
					IF bDragging = 1 THEN
						OnDragging
					ELSE
						OnDragStart 'DOES set xDragStart and yDragStart
					END IF
					bDragging = 1
				END IF
			ELSE
				OnMouseDown
			END IF
		ELSEIF RbPrev = -1 THEN
			OnMouseUp
			IF bDragging = 1 THEN OnDragEnd
			bDragging = 0
		END IF
		DrawPointer 'PUT (xPointer, yPointer), pPointer!, XOR
		xMouseRawPrev% = xMouseRaw
		yMouseRawPrev = yMouseRaw
		LbPrev = Lb
		RbPrev = Rb
		IF bMouseMoved = 1 THEN
			yPointerPrev = yPointer
			xPointerPrev = xPointer
		END IF
	END IF
	SELECT CASE INKEY$
		CASE CHR$(0) + "K": BarChange (-1): DrawSelector 'LEFT ARROW
		CASE CHR$(0) + "M": BarChange (1): DrawSelector 'RIGHT ARROW
		CASE CHR$(0) + "H": PitchChange (1): DrawBar (iSelectBar): DrawSelector'UP ARROW
		CASE CHR$(0) + "P": PitchChange (-1): DrawBar (iSelectBar): DrawSelector'DOWN ARROW
		CASE "p": PlayAll
		CASE "P": PlayAll
		'CASE CHR$(0) + ";": SaveBars: DrawBars: ShowMenu'F1 Saves
		CASE CHR$(0) + "<": LoadArchaicJAS: DrawBars: ShowMenu'F2 Loads archaic JAS file
		'CASE CHR$(0) + "=": ScriptBars: DrawBars: ShowMenu'F3 Saves As QB
		CASE "S": SaveBars: DrawBars: ShowMenu'F1 Saves
		CASE "L": LoadBars: DrawBars: ShowMenu'F2 Loads
		CASE "E": ScriptBars: DrawBars: ShowMenu'F3 Saves As QB
		CASE "s": SaveBars: DrawBars: ShowMenu'F1 Saves
		CASE "l": LoadBars: DrawBars: ShowMenu'F2 Loads
		CASE "e": ScriptBars: DrawBars: ShowMenu'F3 Saves As QB
		CASE "-": SpeedChange (-1)
		CASE "+": SpeedChange (1)
		CASE "D": SpeedChange (-1)
		CASE "U": SpeedChange (1)
		CASE "d": SpeedChange (-1)
		CASE "u": SpeedChange (1)
		CASE "o": OctaveChange (-1)
		CASE "O": OctaveChange (1)
		CASE "M": ModeChange (1)
		CASE "m": ModeChange (-1)
		CASE "K": KeyChange (1)
		CASE "k": KeyChange (-1)
		CASE "r": RandomBars: DrawBars: ShowMenu
		CASE "R": RandomBars: DrawBars: ShowMenu
		'CASE "": IF bMouseMoved = 0 THEN SLEEP 0
		CASE CHR$(27): GOTO menu
	END SELECT
LOOP


endit:
CHAIN ("qjakmenu.bas")
END

ChoseSoGo:

IF (selText = 1) THEN
	GOTO program
ELSEIF (selText = 2) THEN
	help
	GOTO menu
ELSEIF (selText = 3) THEN
	GOTO endit
END IF
RETURN

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

SUB BarChange (xBy%)
	'PSET (iSelectBar * 10 + 3, 190), 16
	EraseSelector 'LINE (iSelectBar * iBarSpacing - 1, (yPixels - BottomMargin) + 4)-(iSelectBar * iBarSpacing + 9, (yPixels - BottomMargin) + 8), 16, BF
	iSelectBar = iSelectBar + xBy%
	IF (iSelectBar < 1) THEN
		iSelectBar = 1
	ELSEIF (iSelectBar > iBars) THEN
		iSelectBar = iBars
	END IF
	'ShowMenu
END SUB


SUB DrawBar (xNow%)
	'LINE (xNow% * 10, (yPixels-BottomMargin))-(xNow% * 10 + 8, 0), 16, BF 'erase first
	'LINE (xNow% * 10, (yPixels-BottomMargin))-(xNow% * 10 + 8, (yPixels-BottomMargin) - bars(xNow%) * 10), 5, BF
	'LINE (xNow% * 10 + 1, (yPixels-BottomMargin) - 1)-(xNow% * 10 + 7, 181 - bars(xNow%) * 10), 13, BF
	UndrawPointer
	iBaseColor = 55 - (bars(xNow%) / 1.6)
	LeftNow = xNow% * iBarSpacing
	BottomNow = yPixels - BottomMargin
	RightNow = xNow% * iBarSpacing + iBarW
	TopNow = (BottomNow) - bars(xNow%) * iNotchH 'TopMargin '(BottomNow) - (iNotchH * iNotches)
	LINE (LeftNow, (BottomNow) - iNotches * iNotchH)-(RightNow, BottomNow), 16, BF       'erase first
	LINE (LeftNow, BottomNow)-(RightNow, (BottomNow) - bars(xNow%) * iNotchH), iBaseColor + 72 + 24, BF   'lower
	LINE (LeftNow + 1, (BottomNow) - 1)-(RightNow, (BottomNow) - bars(xNow%) * iNotchH), iBaseColor + 24, BF'upper
	LINE (LeftNow + 1, (BottomNow) - 1)-(RightNow - 1, ((BottomNow)) - bars(xNow%) * iNotchH + 1), iBaseColor, BF'inner
	IF IsInKey%(bars(xNow%)) = 0 THEN
		LINE (LeftNow + iBarW / 2 - 1, TopNow + 2)-(LeftNow + iBarW / 2 - 1, TopNow + 6), 15  'down 1
		LINE (LeftNow + iBarW / 2 + 1, TopNow + 2)-(LeftNow + iBarW / 2 + 1, TopNow + 6), 15  'down 2
		LINE (LeftNow + iBarW / 2 - 2, TopNow + 3)-(LeftNow + iBarW / 2 + 2, TopNow + 3), 15 'across 1
		LINE (LeftNow + iBarW / 2 - 2, TopNow + 5)-(LeftNow + iBarW / 2 + 2, TopNow + 5), 15 'across 2
	END IF
	DrawPointer
END SUB

SUB DrawBars
CLS
FOR iBarNow% = 1 TO iBars
	DrawBar (iBarNow%)
	 'LINE (iBarNow% * 10, BottomMargin)-(iBarNow% * 10 + 8, BottomMargin - bars(iBarNow%) * 10), 5, BF
	 'LINE (iBarNow% * 10 + 1, BottomMargin - 1)-(iBarNow% * 10 + 7, 181 - bars(iBarNow%) * 10), 13, BF
NEXT iBarNow%
END SUB


SUB DrawSelector
	DrawSelectorCustomHue 1
END SUB

SUB DrawSelectorCustom (iMid%, iDark%, iLight%)
	xbarnow = iSelectBar * iBarSpacing + 3
	LINE (xbarnow, (yPixels - BottomMargin) + 4)-(xbarnow + 1, (yPixels - BottomMargin) + 4), iMid%'2px right (outer top)
	LINE STEP(0, 0)-STEP(3, 3), iLight% '3px down-right (outer upper right)
	LINE STEP(0, 0)-STEP(-7, 0), iDark% '8px left (outer bottom)
	LINE STEP(0, 0)-STEP(3, -3), iMid% '3px up-right (outer upper left)
	LINE (xbarnow, (yPixels - BottomMargin) + 5)-(xbarnow + 1, (yPixels - BottomMargin) + 5), iLight%'2px right (inner top)
	LINE (xbarnow - 1, (yPixels - BottomMargin) + 6)-(xbarnow + 2, (yPixels - BottomMargin) + 6), iLight%'4px right (inner bottom)
END SUB

SUB DrawSelectorCustomHue (iBaseColor%)
	iLight% = iBaseColor%
	iMid% = iBaseColor% + 72'recommended base color is 32 to 103 so that this works well
	iDark% = iBaseColor% = 144
	IF iBaseColor% = 1 THEN
		iLight% = 1
		iMid% = 9
		iDark% = 1
	ELSEIF iBaseColor% = 0 THEN
		iLight% = 0
		iMid% = 0
		iDark = 0
	END IF
	DrawSelectorCustom iMid%, iDark%, iLight%
END SUB

SUB EraseSelector
	DrawSelectorCustomHue 0
END SUB

FUNCTION GetUserEntry$ (sCaption$)
	sReturn$ = ""
	LOCATE rowAt, colAt
	COLOR 0
	PRINT "                                       ";
	iLettersTyping% = 0
	
refreshinput:
	COLOR 34
	LOCATE rowAt, colAt
	PRINT sCaption$; ":        ";
	PRINT "                                       ";
	LOCATE rowAt, colAt + LEN(sCaption$) + 1
	PRINT sReturn$;
	SLEEP 0
	DO
		keyNow$ = INKEY$
		SELECT CASE keyNow$
		  CASE "": GOTO refreshinput
		  CASE CHR$(8): CALL MoveTextCursor(-1): sReturn$ = MID$(sReturn$, 1, iLettersTyping%): GOTO refreshinput
		  CASE CHR$(32): GOTO refreshinput
		  CASE CHR$(9): GOTO refreshinput
		  CASE "/": GOTO refreshinput
		  CASE "\": GOTO refreshinput
		  CASE ":": GOTO refreshinput
		  CASE CHR$(9): GOTO refreshinput
		  CASE CHR$(27): iLettersTyping% = 0: EXIT DO
		  CASE CHR$(13): EXIT DO
		  CASE ELSE: sReturn$ = sReturn$ + keyNow$: CALL MoveTextCursor(1): sReturn$ = MID$(sReturn$, 1, iLettersTyping%): GOTO refreshinput
		END SELECT
	LOOP
	
	COLOR 0
	LOCATE rowAt, colAt
	PRINT "                                       ";

	GetUserEntry$ = sReturn$
END FUNCTION

SUB help
	CLS
	COLOR 15
	PRINT "JakSound Studio 2.4"                             '
	COLOR 115
	PRINT "   1.   Arrow keys left and right move"
	PRINT "        between bars."
	COLOR 116
	PRINT "   2.   Arrow keys up and down change"
	PRINT "        bar height.  Height of bars"
	PRINT "        adjusts pitch of sound."
	COLOR 115
	PRINT "   3.   Highlighted letters on screen"
	PRINT "        control other settings."
	COLOR 116
	COLOR 115
	PRINT "        Save: saves to a jks file."
	PRINT "     	  Type 8 or less letters"
	PRINT "            for a filename."
	COLOR 116
	PRINT "        Load: loads from jks file."
	PRINT "            type in 8 or less letters"
	PRINT "            the name of a previously"
	PRINT "            saved file."
	COLOR 115
	PRINT "        Export QB: writes qbasic code"
	PRINT "            (.QB file) YOU can paste"
	PRINT "            into your QBasic programs."
	COLOR 15
	PRINT "Press a key to continue..."
	SLEEP 0
END SUB

FUNCTION IsInKey% (NoteX%)
	NoteCooked% = NoteX%
	bHigh = 0
	IF NoteCooked% > 12 THEN
		bHigh = 1
		NoteCooked% = NoteCooked% - 12
	END IF
	bMatch% = 0
	FOR iStep = 0 TO 7
		IF IonianDistAtStep(WrapNote07%(iStep + modestartrel(iMode%))) = NoteCooked% THEN
			bMatch% = 1
			EXIT FOR
		END IF
	NEXT iStep
	IsInKey% = bMatch%
END FUNCTION

SUB KeyChange (iBy%)
	iKey = iKey + iBy%
	IF (iKey < 1) THEN
		iKey = 1
	ELSEIF (iKey > 12) THEN
		OctaveChange 1
		iKey = 1
	END IF
	ShowMenu
END SUB

FUNCTION KeyToString$
	KeyToString$ = KeyToStringCustom$(iKey, iMode)
END FUNCTION

FUNCTION KeyToStringCustom$ (iKeyX%, iModeX%)
	sReturn$ = ""
	SELECT CASE iKeyX%
		CASE 1: sReturn$ = sReturn$ + "A"
		CASE 2: sReturn$ = sReturn$ + "Bb"
		CASE 3: sReturn$ = sReturn$ + "B"
		CASE 4: sReturn$ = sReturn$ + "C"
		CASE 5: sReturn$ = sReturn$ + "C#"
		CASE 6: sReturn$ = sReturn$ + "D"
		CASE 7: sReturn$ = sReturn$ + "Eb"
		CASE 8: sReturn$ = sReturn$ + "E"
		CASE 9: sReturn$ = sReturn$ + "F"
		CASE 10: sReturn$ = sReturn$ + "F#"
		CASE 11: sReturn$ = sReturn$ + "G"
		CASE 12: sReturn$ = sReturn$ + "G#"
		CASE ELSE: sReturn$ = sReturn$ + "nokey#" + ToString$(iKeyX%)
	END SELECT
	sReturn$ = sReturn$ + "-"
	SELECT CASE iModeX%
		'reference: http://www.wisegeek.com/what-are-the-seven-modes-of-music.htm 8/8/2007
		CASE 1: sReturn$ = sReturn$ + "Ionian"  'Major
		CASE 2: sReturn$ = sReturn$ + "Dorian"  'Celtic and early Irish-Influenced American folk
		CASE 3: sReturn$ = sReturn$ + "Phrygian"  'good for guitar solos in IonianDistAtStep songs
		CASE 4: sReturn$ = sReturn$ + "Lydian"  'sounds unpredictable, jazz etc
		CASE 5: sReturn$ = sReturn$ + "Myxolydian"  'sometimes good for guitar solos in IonianDistAtStep songs
		CASE 6: sReturn$ = sReturn$ + "Aeolian"  'sometimes called minor; even darker than Dorian
		CASE 7: sReturn$ = sReturn$ + "Locrian"  'hard to work with, sometimes considered theoretical
		CASE ELSE: sReturn$ = sReturn$ + "no"
	END SELECT
	sReturn$ = sReturn$ + " mode:" + ToString$(iModeX%) + "  RelToMajor:" + ToString(modestartrel(iModeX%))
	KeyToStringCustom$ = sReturn$
END FUNCTION

SUB LoadArchaicJAS
	sFile$ = GetUserEntry$("Old JakSound JAS file")
	IF LEN(sFile$) > 0 THEN
		OPEN sFile$ + ".jas" FOR INPUT AS #1
		     DO UNTIL (EOF(1))
			  barnum = barnum + 1
			  LINE INPUT #1, temp$
			  bars(barnum) = ASC(temp$)
			  bars(barnum) = bars(barnum) - 40
		     LOOP
		CLOSE
		LOCATE rowAt, colAt
		COLOR 0
		PRINT "Loaded "; sFile$; ".jas";
	ELSE
		LOCATE rowAt, colAt
		COLOR 0
		PRINT "Canceled Load.";
	END IF
END SUB

FUNCTION LoadAs% (sFile$)
	LoadAs% = 0
	iBarNow% = 0
	bGood = 0
	iBarsSpecified% = 0
	COLOR 89 ' a pale red
	iLine% = 0
	OPEN sFile$ + ".jks" FOR INPUT AS #1
		IF (EOF(1)) THEN
			PRINT "[empty file!]"
		ELSE
			LINE INPUT #1, temp$ 'note count as saved in file
			iBarsSpecified% = StringToInt(temp$)
			iLine% = iLine% + 1
			FOR iBarNow% = 1 TO iBarsSpecified%
				IF (EOF(1)) THEN
					EXIT FOR
				ELSE
					LINE INPUT #1, temp$
					IF iBarNow% <= iBars THEN bars(iBarNow%) = StringToInt%(temp$)
					iLine% = iLine% + 1
				END IF
			NEXT iBarNow%
			
			IF iLine% - 1 < iBars THEN
				PRINT "(File missing some of " + ToString$(iBarsSpecified%) + " notes specified"
				PRINT " ending at line "; iLine%; "."
				PRINT " If old, rename to JAS and press F2 in JakSound)";
			ELSE
				IF (EOF(1)) THEN
					PRINT "[file missing BPM]";
				ELSE
					LINE INPUT #1, temp$ 'BPM
					iBeats = StringToInt%(temp$)
					iLine% = iLine% + 1
					IF (EOF(1)) THEN
						PRINT "[file missing KEY]";
					ELSE
						LINE INPUT #1, temp$ 'KEY
						iKey = StringToInt%(temp$)
						iLine% = iLine% + 1
						IF (EOF(1)) THEN
							PRINT "[file missing MODE]";
						ELSE
							LINE INPUT #1, temp$ 'MODE
							iMode = StringToInt%(temp$)
							iLine% = iLine% + 1
							bGood = 1
						END IF
					END IF
				END IF
			END IF
		END IF
	CLOSE
	IF bGood = 1 THEN LoadAs% = 1
END FUNCTION

SUB LoadBars
	sFile$ = GetUserEntry$("Load File")
	IF LEN(sFile$) > 0 THEN
		LOCATE rowAt, colAt
		bTest = LoadAs%(sFile$)
		COLOR 15
		IF bTest = 1 THEN
			PRINT "  Finished "; sFile$; ".jks"
		ELSE
			COLOR 41 '1 notch away from most saturated red
			PRINT "  Failed loading "; sFile$; ".jks"
		END IF
		PRINT "Press any key."
		SLEEP 0
	ELSE
		LOCATE rowAt, colAt
		COLOR 15
		PRINT "Canceled Load.";
	END IF
END SUB

SUB ModeChange (iBy%)
iMode = iMode + iBy%
IF (iMode < 1) THEN
	iMode = 1
ELSEIF (iMode > 7) THEN
	iMode = 1
END IF
ShowMenu
END SUB

SUB MoveTextCursor (iAdder%)
iLettersTyping% = iLettersTyping% + iAdder%
IF (iLettersTyping% < 0) THEN
	iLettersTyping% = 0
ELSEIF (iLettersTyping% > 8) THEN
	iLettersTyping% = 8
END IF

END SUB

FUNCTION NoteInKey% (NoteX%)
	NoteCooked% = NoteX%
	'bHigh = 0
	'IF NoteInKey% > 12 THEN
	'       bHigh = 1
	'       NoteInKey% = NoteInKey% - 12
	'END IF
	IF IsInKey%(NoteX%) = 0 THEN NoteCooked% = NoteCooked% + 1
	'FOR iStep = 1 TO 12
	'NEXT iStep
	'IF bHigh = 1 THEN NoteInKey% = InInKey% + 12
	NoteInKey% = NoteCooked%
END FUNCTION

SUB OctaveChange (iBy%)
Octave = Octave + iBy%
IF (Octave < OctaveMin) THEN
	Octave = OctaveMin
ELSEIF (Octave > OctaveMax) THEN
	Octave = OctaveMax
END IF
ShowMenu
END SUB


SUB PitchChange (yBy%)
bars(iSelectBar) = bars(iSelectBar) + yBy%
IF (bars(iSelectBar) < 0) THEN
	bars(iSelectBar) = 0
ELSEIF (bars(iSelectBar) > iNotches) THEN
	bars(iSelectBar) = iNotches
END IF
'ShowMenu
END SUB

SUB PlayAll
	EraseSelector
	bPlaying = 1
	ShowMenu
	iPrev = iSelectBar
	FOR iBarNow% = 1 TO iBars
		iSelectBar = iBarNow%
		DrawSelectorCustomHue 47
		'OctaveNow = Octave
		'NotchNow = bars(iBarNow%)
		IF bars(iBarNow%) > 12 THEN
			SOUND scale(Octave + 1, bars(iBarNow%) - 12), ((60 / iBeats) / 8) * (18.2)'1sec is about 18.2 ticks; /8 since 4/8 timing
			'NotchNow = NotchNow - 12
			'OctaveNow = OctaveNow + 1
			IF INKEY$ = "x" THEN iBarNow% = iBars
		ELSEIF bars(iBarNow%) = 0 THEN
			SOUND 22000, ((60 / iBeats) / 8) * (18.2)
		ELSE
			SOUND scale(Octave, bars(iBarNow%)), ((60 / iBeats) / 8) * (18.2)'1sec is about 18.2 ticks; /8 since 4/8 timing
		END IF
		ShowMenu
		EraseSelector
	NEXT iBarNow%
	iSelectBar = iPrev
	DrawSelector
	bPlaying = 0
	ShowMenu
END SUB


SUB RandomBars
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
	FOR iBar = 1 TO iBars
		bars(iBar) = RND * iNotches
	NEXT iBar
	iBeats = INT((RND * (90) + iBeatsMin))
	IF iBeats > iBeatsMax THEN iBeats = iBeatsMax
END SUB

SUB refmenu
	IF (selText < 1) THEN
		selText = 1
	ELSEIF (selText > 3) THEN
		selText = 3
	END IF
	COLOR 16
	LOCATE 12, 16
	PRINT ""
	LOCATE 13, 16
	PRINT ""
	LOCATE 14, 16
	PRINT ""
	COLOR 11
	IF (selText = 1) THEN
		LOCATE 12, 16
		PRINT ""
		COLOR 3
		LOCATE 12, 17
		PRINT "Studio"
		COLOR 125
		LOCATE 13, 17
		PRINT "Help"
		COLOR 125
		LOCATE 14, 17
		PRINT "Quit"
	ELSEIF (selText = 2) THEN
		LOCATE 13, 16
		PRINT ""
		COLOR 125
		LOCATE 12, 17
		PRINT "Studio"
		COLOR 3
		LOCATE 13, 17
		PRINT "Help"
		COLOR 125
		LOCATE 14, 17
		PRINT "Quit"
	ELSEIF (selText = 3) THEN
		LOCATE 14, 16
		PRINT ""
		COLOR 125
		LOCATE 12, 17
		PRINT "Studio"
		COLOR 125
		LOCATE 13, 17
		PRINT "Help"
		COLOR 3
		LOCATE 14, 17
		PRINT "Quit"
	END IF
END SUB


FUNCTION SaveAs% (sFile$)
	OPEN sFile$ + ".jks" FOR OUTPUT AS #1
		PRINT #1, ToString(iBars)
		'PRINT #1, CHR$(13);
		FOR iBarNow% = 1 TO iBars
			PRINT #1, ToString(bars(iBarNow%))
			'PRINT #1, CHR$(13);
		NEXT iBarNow%
		PRINT #1, ToString(iBeats)
		'PRINT #1, CHR$(13);
		PRINT #1, ToString(iKey)
		'PRINT #1, CHR$(13);
		PRINT #1, ToString(iMode)
		'PRINT #1, CHR$(13);
	CLOSE
	SaveAs% = 1
END FUNCTION

SUB SaveBars
	sFile$ = GetUserEntry("Save File")
	IF LEN(sFile$) > 0 THEN
		bTest = SaveAs%(sFile$)
		LOCATE rowAt, colAt
		COLOR 0
		PRINT "Saved "; sFile$; ".jks";
	ELSE
		LOCATE rowAt, colAt
		COLOR 0
		PRINT "Canceled Save.";
	END IF
END SUB

SUB ScriptBars
	sFile$ = GetUserEntry$("Export QB")
	IF LEN(sFile$) > 0 THEN
		OPEN sFile$ + ".bas" FOR OUTPUT AS #1
			PRINT "DIM SHARED scale(8,12)"
			PRINT "rPrev=0.0"
			PRINT "FOR iOv = 1 to 8"
			PRINT "     FOR iStep = 1 to 12"
			PRINT "          IF rPrev = 0.0 THEN"
			PRINT "          	scale (iOv,iStep) = 55.0"
			PRINT "          	rPrev=55.0"
			PRINT "          ELSE"
			PRINT "          	scale (iOv,iStep) = rPrev * 2.0^(1.0/12.0)"
			PRINT "          	rPrev = scale(iOv,iStep)"
			PRINT "          END IF"
			PRINT "     NEXT iStep"
			PRINT "NEXT iOv"
			FOR iBarNow% = 1 TO iBars
				IF bars(iBarNow%) > 12 THEN
					PRINT #1, "SOUND "; scale(Octave + 1, bars(iBarNow%) - 12); ", "; ((60 / iBeats) / 8) * (18.2); "' 1sec is about 18.2 ticks; /8 since 4/8 timing"
					'NotchNow = NotchNow - 12
					'OctaveNow = OctaveNow + 1
				ELSEIF bars(iBarNow%) = 0 THEN
					PRINT #1, "SOUND 22000, "; ((60 / iBeats) / 8) * (18.2)
				ELSE
					PRINT #1, "SOUND "; scale(Octave, bars(iBarNow%)); ", "; ((60 / iBeats) / 8) * (18.2); "' 1sec is about 18.2 ticks; /8 since 4/8 timing"
				END IF
		
		'               PRINT #1, "SOUND "; bars(iBarNow%) * 50; ", "; iBeats / 10
			NEXT iBarNow%
		CLOSE
		LOCATE rowAt, colAt
		COLOR 0
		PRINT "Exported "; sFile$; ".bas";
	ELSE
		LOCATE rowAt, colAt
		COLOR 0
		PRINT "Canceled Export.";
	END IF
END SUB

SUB SetBarByPointer (bInTune%)
	UndrawPointer
	DIM iCheckBar AS INTEGER
	BottomNow = yPixels - BottomMargin
	TopNow = TopMargin + 1'(BottomNow) - (iNotchH * iNotches)
	IF yPointer <= BottomNow AND yPointer >= TopNow THEN
		FOR iCheckBar = 1 TO iBars
			LeftNow = iCheckBar * iBarSpacing
			RightNow = iCheckBar * iBarSpacing + iBarW
			IF xPointer >= LeftNow AND xPointer <= RightNow THEN
				IF iCheckBar <> iSelectBar THEN
					BarChange iCheckBar - iSelectBar
					DrawSelector
				END IF
				IF YToBarNotch%(yPointer) <> bars(iCheckBar) THEN
					IF bInTune% = 1 THEN
						PitchChange NoteInKey%(YToBarNotch%(yPointer)) - bars(iCheckBar)
					ELSE
						PitchChange YToBarNotch%(yPointer) - bars(iCheckBar)
					END IF
					DrawBar (iSelectBar)
				END IF
				EXIT FOR
			END IF
		NEXT iCheckBar
	END IF
	DrawPointer
END SUB

SUB ShowMenu
	iLight = 15
	iDark = 35
	IF bPlaying = 0 THEN
		COLOR 16
		'LOCATE 24, 1
		'PRINT "                                       ";
		LOCATE 1, 1
		PRINT "                                       ";
		LOCATE 2, 1
		PRINT "                                       ";
		LOCATE 3, 1
		PRINT "                                       ";
		LOCATE 24, 1
		COLOR 35
		' semicolon keeps it on the same line!!!!!!!!!!!!!!!!!!!!
		LOCATE 24, 1
		PRINT "(4/8)BPM:";
		COLOR 39
		PRINT iBeats;
		COLOR 39
		PRINT "Octave: ";
		COLOR 39
		PRINT Octave;
		COLOR 39
		PRINT "-";
		COLOR 39
		PRINT Octave + 1;
		LOCATE 3, 1
		PRINT "Key:";
		PRINT KeyToString$;
		
		LOCATE 1, 1
		PRINT "";
		COLOR iLight: PRINT "S";
		COLOR iDark: PRINT "ave ";
		COLOR iLight: PRINT "L";
		COLOR iDark: PRINT "oad ";
		COLOR iLight: PRINT "E";
		COLOR iDark: PRINT "xportQB ";
		COLOR iLight: PRINT "K";
		COLOR iDark: PRINT "ey ";
		COLOR iLight: PRINT "O";
		COLOR iDark: PRINT "ctave ";
		COLOR iLight: PRINT "M";
		COLOR iDark: PRINT "ode "
		PRINT " Speed ";
		COLOR iLight: PRINT "U";
		COLOR iDark: PRINT "p ";
		PRINT " Speed ";
		COLOR iLight: PRINT "D";
		COLOR iDark: PRINT "own ";
		COLOR iLight: PRINT " P";
		COLOR iDark: PRINT "lay ";
		COLOR iLight: PRINT " R";
		COLOR iDark: PRINT "andomize"
	ELSE
		COLOR 16
		LOCATE 24, 1
		PRINT "                                       ";
		LOCATE 1, 1
		PRINT "                                       ";
		LOCATE 2, 1
		PRINT "                                       ";
		LOCATE 3, 1
		PRINT "                                       ";
		LOCATE 24, 1
		COLOR 10
		PRINT "              playing                  ";
		LOCATE 1, 1
		rSpeed = 60 / iBeats * 1000 / 8
		rHz = 0
		IF bars(iSelectBar%) > 12 THEN
			rHz = scale(Octave + 1, bars(iSelectBar%) - 12)
		ELSE
			rHz = scale(Octave, bars(iSelectBar%))
		END IF
		PRINT iBeats
		PRINT "BPM     ";
		PRINT rSpeed;
		PRINT "ms      "
		PRINT rHz;
		PRINT "Hz     ";
	END IF
END SUB

SUB SpeedChange (iBy%)
	iBeats = iBeats + iBy%
	IF (iBeats < 1) THEN
		iBeats = 1
	ELSEIF (iBeats > iBeatsMax) THEN
		iBeats = iBeatsMax
	END IF
	ShowMenu
END SUB


SUB SwitchSound

	OPEN "bsound.dat" FOR OUTPUT AS #1
		SELECT CASE sound$
		  CASE "0": PRINT #1, "1": sound$ = "1" : COLOR 38 : LOCATE 15,15 : PRINT "MUTE OFF";
		  CASE "1": PRINT #1, "0": sound$ = "0" : COLOR 40 : LOCATE 15,15 : PRINT "  MUTE  ";
		END SELECT
	CLOSE

END SUB


FUNCTION WrapNote07% (NoteX%)
	NoteCooked% = NoteX%
	DO WHILE NoteCooked% > 7
		NoteCooked% = NoteCooked% - 8 'sends it back to zero since 8va isn't indexed as a note
	LOOP
	DO WHILE NoteCooked% < 0 '0 is allowed since zero is indexed as a note
		NoteCooked% = NoteCooked% + 8 'i.e. -1 is 7 (a 7th, actually)
	LOOP
	WrapNote07% = NoteCooked%
END FUNCTION

FUNCTION WrapNote12% (NoteX%)
	NoteCooked% = NoteX%
	DO WHILE NoteCooked% > 12
		NoteCooked% = NoteCooked% - 12 'i.e. 13 is actually 1 on an octave of 0-12 since 12 is the same note as zero
	LOOP
	DO WHILE NoteCooked% < 1
		NoteCooked% = NoteCooked% + 12 'i.e. -1 is 11 (Major 7th)
	LOOP
	WrapNote12% = NoteCooked%
END FUNCTION

FUNCTION YToBarNotch% (yNow%)
	YToBarNotch% = ((yPixels - BottomMargin) - yNow%) / iNotchH
END FUNCTION

'start common & mouse functions
FUNCTION CharToInt% (sNow$)
	iReturn% = 0
	FOR iVal% = 0 TO 9
		IF sarrDigit(iVal%) = sNow$ THEN
			iReturn% = iVal%
			EXIT FOR
		END IF
	NEXT iVal%
	CharToInt% = iReturn%
END FUNCTION
SUB DrawPointer
	IF bPointerShowing = 0 THEN
		'draw mouse cursor manually
		xPointerCropped = PointerCroppedX%(xPointer)
		yPointerCropped = PointerCroppedY%(yPointer)
		GET (xPointerCropped - iPointerRad, yPointerCropped - iPointerRad)-(xPointerCropped + iPointerRad, yPointerCropped + iPointerRad), pUnderPointer!(1)
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
	END IF
END SUB

SUB LINESAFEH (xStart%, yStart%, xEnd%, yEnd%, iColor%)
	iStep% = 1
	IF xStart > xEnd THEN iStep% = -1
	IF yStart < yPixels AND yStart >= 0 THEN
		FOR xNow% = xStart% TO xEnd% STEP iStep%
			IF xNow >= 0 AND xNow < xPixels THEN PSET (xNow%, yStart%), iColor%
		NEXT xNow%
	END IF
END SUB

SUB LINESAFEV (xStart%, yStart%, xEnd%, yEnd%, iColor%)
	iStep% = 1
	IF yStart > yEnd THEN iStep% = -1
	
	IF xStart < xPixels AND xStart >= 0 THEN
		FOR yNow% = yStart% TO yEnd% STEP iStep%
			IF yNow >= 0 AND yNow < yPixels THEN PSET (xStart%, yNow%), iColor%
		NEXT yNow%
	END IF
END SUB

DEFLNG A-Z
'start mouse functions
SUB MouseDriver (ax%, bx%, cx%, dx%)
	DEF SEG = VARSEG(mouse$)
	mouse% = SADD(mouse$)
	CALL Absolute(ax%, bx%, cx%, dx%, mouse%)
END SUB

SUB MouseHide
 ax% = 2
 MouseDriver ax%, 0, 0, 0
END SUB

FUNCTION MouseInit%
	ax% = 0
	MouseDriver ax%, 0, 0, 0
	MouseInit% = ax%
END FUNCTION

SUB MousePut (xAt%, yAt%)
	ax% = 4
	cx% = xAt%
	dx% = yAt%
	MouseDriver ax%, 0, cx%, dx%
END SUB

SUB MouseRange (X1%, Y1%, x2%, Y2%)
	ax% = 7
	cx% = X1%
	dx% = x2%
	MouseDriver ax%, 0, cx%, dx%
	ax% = 8
	cx% = Y1%
	dx% = Y2%
	MouseDriver ax%, 0, cx%, dx%
END SUB

SUB MouseShow
	PUT (xPointer, yPointer), pPointer!, XOR
END SUB

SUB MouseStatus (Lb%, Rb%, xMouse%, yMouse%)
	ax% = 3
	MouseDriver ax%, bx%, cx%, dx%
	Lb% = ((bx% AND 1) <> 0)
	Rb% = ((bx% AND 2) <> 0)
	xMouse% = cx%
	yMouse% = dx%
END SUB

DEFINT A-Z
SUB MovePointer (xm%, ym%)
	'manually move mouse cursor
	xPointer = xPointer + xm%
	yPointer = yPointer + ym%
	MousePut xMouseRaw + xm% * 2, yMouseRaw + ym%
	'DrawWindow
END SUB

SUB OnDragEnd
SetBarByPointer 1
END SUB

SUB OnDragging
	SetBarByPointer 1
END SUB

SUB OnDragStart
	xDragStart = xPointer
	yDragStart = yPointer
	'SetBarByPointer
END SUB

SUB OnMouseDown
SetBarByPointer 0
SELECT CASE iBrushRad
     CASE 1: PSET (xPointer, yPointer), yColr * 16 + xColr
     CASE 2: PSET (xPointer, yPointer), yColr * 16 + xColr
	  CIRCLE (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
     CASE 3: LINE (xPointer - 1, yPointer - 1)-(xPointer + 1, yPointer + 1), yColr * 16 + xColr, BF
	  CIRCLE (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
     CASE 4: CIRCLE (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
	  LINE (xPointer - 1, yPointer)-(xPointer + 1, yPointer), yColr * 16 + xColr
	  LINE (xPointer - 2, yPointer - 1)-(xPointer + 2, yPointer + 1), yColr * 16 + xColr, BF
     CASE 5: CIRCLE (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
	  LINE (xPointer - 3, yPointer - 1)-(xPointer + 3, yPointer + 1), yColr * 16 + xColr, BF
	  LINE (xPointer - 1, yPointer - 2)-(xPointer + 1, yPointer + 2), yColr * 16 + xColr, BF
     CASE 6: CIRCLE (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
	  LINE (xPointer - 2, yPointer - 3)-(xPointer + 2, yPointer + 3), yColr * 16 + xColr, BF
	  LINE (xPointer - 4, yPointer - 1)-(xPointer + 4, yPointer + 1), yColr * 16 + xColr, BF
	  LINE (xPointer - 3, yPointer - 2)-(xPointer + 3, yPointer + 2), yColr * 16 + xColr, B
     CASE 7: CIRCLE (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
	  LINE (xPointer - 5, yPointer - 1)-(xPointer + 5, yPointer + 1), yColr * 16 + xColr, BF
	  LINE (xPointer - 2, yPointer - 4)-(xPointer + 2, yPointer + 4), yColr * 16 + xColr, BF
	  LINE (xPointer - 3, yPointer - 3)-(xPointer + 3, yPointer + 3), yColr * 16 + xColr, B
	  LINE (xPointer - 4, yPointer - 2)-(xPointer + 4, yPointer + 2), yColr * 16 + xColr, B
     CASE 8: CIRCLE (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
	  LINE (xPointer - 2, yPointer - 5)-(xPointer + 2, yPointer + 5), yColr * 16 + xColr, BF
	  LINE (xPointer - 6, yPointer - 1)-(xPointer + 6, yPointer + 1), yColr * 16 + xColr, BF
	  LINE (xPointer - 5, yPointer - 3)-(xPointer + 5, yPointer + 3), yColr * 16 + xColr, BF
	  LINE (xPointer - 4, yPointer - 4)-(xPointer + 4, yPointer + 4), yColr * 16 + xColr, B
     CASE 9: CIRCLE (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
	  LINE (xPointer - 2, yPointer - 6)-(xPointer + 2, yPointer + 6), yColr * 16 + xColr, BF
	  LINE (xPointer - 7, yPointer - 1)-(xPointer + 7, yPointer + 1), yColr * 16 + xColr, BF
	  LINE (xPointer - 4, yPointer - 5)-(xPointer + 4, yPointer + 5), yColr * 16 + xColr, BF
	  LINE (xPointer - 6, yPointer - 3)-(xPointer + 6, yPointer + 3), yColr * 16 + xColr, BF
	  LINE (xPointer - 5, yPointer - 4)-(xPointer + 5, yPointer + 4), yColr * 16 + xColr, B
     CASE 10: CIRCLE (xPointer, yPointer), iBrushRad - 1, yColr * 16 + xColr
	  LINE (xPointer - 4, yPointer - 6)-(xPointer + 4, yPointer + 6), yColr * 16 + xColr, BF
	  LINE (xPointer - 8, yPointer - 1)-(xPointer + 8, yPointer + 1), yColr * 16 + xColr, BF
	  LINE (xPointer - 6, yPointer - 5)-(xPointer + 6, yPointer + 5), yColr * 16 + xColr, BF
	  LINE (xPointer - 7, yPointer - 3)-(xPointer + 7, yPointer + 3), yColr * 16 + xColr, B
END SELECT
	'DrawWindow
END SUB

SUB OnMouseUp
	'SetBarByPointer
END SUB

FUNCTION PointerCroppedX% (xMouse%)
	'DIM xPointerCropped AS INTEGER
	xPointerCropped = xMouse%
	DIM xMax AS INTEGER
	xMax = xPixels - 1
	IF xMouse% - iPointerRad < 0 THEN
		xPointerCropped = iPointerRad
	ELSEIF xMouse% + iPointerRad >= xMax THEN
		xPointerCropped = xMax - iPointerRad
	END IF
	PointerCroppedX% = xPointerCropped
END FUNCTION

FUNCTION PointerCroppedY% (yMouse%)
	'DIM yPointerCropped AS INTEGER
	yPointerCropped = yMouse%
	DIM yMax AS INTEGER
	yMax = yPixels - 1
	IF yMouse% - iPointerRad < 0 THEN
		yPointerCropped = iPointerRad
	ELSEIF yMouse% + iPointerRad >= yMax THEN
		yPointerCropped = yMax - iPointerRad
	END IF
	PointerCroppedY% = yPointerCropped
END FUNCTION

FUNCTION PointerFromMouseX% (xMouse%)
	PointerFromMouseX% = INT(ToDouble#(xMouse%) / 2! + .5)
END FUNCTION

FUNCTION PointerFromMouseY% (yMouse%)
	PointerFromMouseY% = yMouse% 'yMouse%+2
END FUNCTION
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
FUNCTION StringToInt% (sNow$)
	iReturn% = 0
	iMultiplier% = 1
	FOR iChar% = LEN(sNow$) TO 1 STEP -1
		iReturn% = iReturn% + iMultiplier% * CharToInt%(MID$(sNow$, iChar%, 1))
		iMultiplier% = iMultiplier% * 10
	NEXT iChar%
	StringToInt% = iReturn%
END FUNCTION
FUNCTION ToDouble# (iNow%)
	ToDouble# = iNow%
END FUNCTION

FUNCTION ToString$ (iNow%)
	bNeg = 0
	IF iNow% < 0 THEN
		bNeg = 1
		iNow% = iNow% * -1
	END IF
	sReturn$ = ""
	'iDivisor% = 1
	iValDigit% = 0
	iRemaining% = iNow%
	'rHighDivisor% = 1
	'DO WHILE iNow% / rHighDivisor >= 1
	'        rHighDivisor% = rHighDivisor% * 10
	'LOOP
	'rHighDivisor% = rHighDivisor% / 10

	DO WHILE iRemaining% > 0 'AND rHighDivisor >= 1
		iValDigit% = SafeMod%(iRemaining%, 10)
		'iRemaining% = iRemaining% - iValDigit% * iDivisor%
		'iRemaining% = iRemaining% / 10
		sReturn$ = sarrDigit(iValDigit%) + sReturn$
		iRemaining% = iRemaining% / 10 - .4'-.4 to avoid automatic rounding up
		'rHighDivisor = rHighDivisor / 10
		'iDivisor% = iDivisor% * 10
	LOOP
	IF bNeg = 1 THEN sReturn$ = "-" + sReturn$
	ToString$ = sReturn$
END FUNCTION

SUB UndrawPointer
	IF bUnderPointer = 1 THEN
		IF bPointerShowing = 1 THEN
			PUT (PointerCroppedX%(xPointerPrev) - iPointerRad, PointerCroppedY%(yPointerPrev) - iPointerRad), pUnderPointer!, PSET
			bPointerShowing = 0
		END IF
	END IF
END SUB

SUB MakePointer
	'get mouse cursor
	LINE (0, 0)-(4, 4), 0
	LINE (2, 0)-STEP(0, 1), 15
	LINE STEP(0, 2)-STEP(0, 1), 15
	LINE STEP(-3, -2)-STEP(2, 0), 15
	LINE STEP(2, 0)-STEP(1, 0), 15
	GET (0, 0)-(4, 4), pPointer!(1)
	LINE (0, 0)-(4, 4), 0
END SUB


DECLARE SUB PaintAtPointer ()
'revision 2.7 (new with mouse)
DECLARE FUNCTION MouseInit% ()
DECLARE SUB MouseStatus (LbX%, RbX%, xMouse%, yMouse%)
DECLARE SUB MouseRange (X1%, Y1%, x2%, Y2%)
DECLARE SUB MousePut (xMouseRaw%, yMouseRaw%)
DECLARE SUB MouseHideDEPRECATED ()
DECLARE SUB MouseDriver (ax%, bx%, cx%, dx%)
DECLARE SUB MouseShowDEPRECATED ()
DECLARE SUB MovePointerBy (xm%, ym%)              'note: does not call OnMouse functions
DECLARE SUB MakePointerDEPRECATED ()

DECLARE SUB DrawPointer ()
DECLARE SUB UndrawPointer ()
DECLARE SUB OnDragEnd ()
DECLARE SUB OnDragStart ()
DECLARE SUB OnDragging ()
DECLARE SUB OnMouseDown ()
DECLARE SUB OnMouseUp ()
DECLARE SUB LINESAFEH (xStart%, yStart%, xEnd%, yEnd%, iColor%)
DECLARE SUB LINESAFEV (xStart%, yStart%, xEnd%, yEnd%, iColor%)
DECLARE FUNCTION PointerFromMouseX% (xMouse%)
DECLARE FUNCTION PointerFromMouseY% (yMouse%)
DECLARE FUNCTION PointerCroppedX% (xMouse%)
DECLARE FUNCTION PointerCroppedY% (yMouse%)
DECLARE FUNCTION SafeMod% (iNum%, iDiv%)
DECLARE FUNCTION SafeToString$ (iNow%)
DECLARE FUNCTION SafeToDouble# (iNow%)
DECLARE FUNCTION SafeStringToInt% (sNow$)
DECLARE FUNCTION SafeCharToInt% (sNow$)


DECLARE SUB OnMouseOver ()
DECLARE SUB BrushSizeToBounds ()
DECLARE SUB PickColorAtPointer ()
DECLARE SUB ColorReplace ()
DECLARE SUB FloodFill ()
DECLARE SUB ShowHelp ()
DECLARE SUB FreshWindow ()
DECLARE SUB cletter (iAdder%)
DECLARE SUB PrintLit (sText$, iLitChar%)
DECLARE SUB PrintLitCustom (sText$, iLitChar%, iDark%, iLight%)
DECLARE SUB PalHideCurDEPRECATED ()
DECLARE SUB makezero ()
DECLARE SUB ShowBrushViewer ()
DECLARE SUB SaveBA ()
DECLARE SUB LoadBA ()
DECLARE SUB SwitchSound ()
DECLARE SUB PalShowNumDEPRECATED ()
DECLARE SUB PalMoveByDEPRECATED (xc%, yc%)
DECLARE SUB DrawDotAtPointer ()
DECLARE SUB DrawWindowFrame ()
DECLARE SUB drawJakdraw ()
DECLARE SUB getJakDraw ()
DECLARE FUNCTION IsInPic% (xNow%, yNow%)
DECLARE FUNCTION PalContainsLocation% (xNow%, yNow%)

DECLARE SUB PalMoveBy (xBy%, yBy%)
DECLARE SUB PalMoveTo (xSet%, ySet%)
DECLARE SUB PalShowNum ()
DECLARE SUB PalShowCursor ()
DECLARE SUB PalHideCursor ()
DECLARE SUB PalShowCursorCustom (iColrX%)
DECLARE SUB PalShow ()
DECLARE SUB PalHide ()
DECLARE SUB PalXYFromPalColor ()
DECLARE SUB PalGetCursorRect (GetLeft%, GetTop%, GetRight%, GetBottom%)
DECLARE SUB PalCoordsToRect (GetLeft%, GetTop%, GetRight%, GetBottom%, xAt%, yAt%)
DIM SHARED PalXPrev AS INTEGER
DIM SHARED PalYPrev AS INTEGER
DIM SHARED PalX AS INTEGER
DIM SHARED PalY AS INTEGER
DIM SHARED PalColorDefault AS INTEGER
DIM SHARED PalColor AS INTEGER
DIM SHARED PalComponentsX AS INTEGER
DIM SHARED PalComponentsY AS INTEGER
DIM SHARED PalLeft AS INTEGER
DIM SHARED PalTop AS INTEGER
DIM SHARED PalComponentW AS INTEGER
DIM SHARED PalComponentH AS INTEGER
DIM SHARED PalComponentSpacingW AS INTEGER
DIM SHARED PalComponentSpacingH AS INTEGER
DIM SHARED PalWidth AS INTEGER
DIM SHARED PalHeight AS INTEGER


COMMON SHARED progdir$
OPEN "qjak.ini" FOR INPUT AS #1
		LINE INPUT #1, progdir$
CLOSE
FOR charnow = 1 TO LEN(progdir$)
	IF MID$(progdir$, charnow, 1) = "=" THEN GOTO SPLITHERE
NEXT charnow
SPLITHERE:
progdir$ = RIGHT$(progdir$, LEN(progdir$) - (charnow))  'this is correct since STARTS at right
CHDIR (progdir$)


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
MousePut 320 / 2, 200 / 2'MousePut 26, 38
MouseRange 1, 1, 320 * 2, 240 'MouseRange 16, 34, 594, 183
'DEFSNG A-Z 'TODO: why can't this be done now?
'extra mouse stuff:
DIM SHARED xPixels AS INTEGER
xPixels = 320
DIM SHARED yPixels AS INTEGER
yPixels = 200
DIM SHARED xMouseRaw AS INTEGER
DIM SHARED yMouseRaw AS INTEGER
DIM SHARED xDragStart AS INTEGER
DIM SHARED yDragStart AS INTEGER
DIM SHARED xMouseRawPrev AS INTEGER
xMouseRawPrev = -1
DIM SHARED yMouseRawPrev AS INTEGER
yMouseRawPrev = -1
DIM SHARED Lb AS INTEGER
Lb = 0
DIM SHARED Rb AS INTEGER
Rb = 0
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
DIM SHARED xPointerDrawn AS INTEGER
xPointerDrawn = -1 'must start out negative
DIM SHARED yPointerDrawn AS INTEGER
xPointerDrawn = -1 'must start out negative
DIM SHARED xPointerPrev AS INTEGER
DIM SHARED yPointerPrev AS INTEGER
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
'MakePointerDEPRECATED 'sets pPointer
'end mouse initialization
DIM SHARED sarrSafeDigit(0 TO 9) AS STRING
sarrSafeDigit(0) = "0"
sarrSafeDigit(1) = "1"
sarrSafeDigit(2) = "2"
sarrSafeDigit(3) = "3"
sarrSafeDigit(4) = "4"
sarrSafeDigit(5) = "5"
sarrSafeDigit(6) = "6"
sarrSafeDigit(7) = "7"
sarrSafeDigit(8) = "8"
sarrSafeDigit(9) = "9"
'end common & mouse functions

DIM SHARED PicLeft AS INTEGER
DIM SHARED PicWidth AS INTEGER
DIM SHARED PicTop AS INTEGER
DIM SHARED PicHeight AS INTEGER
'PicRect: 16, 34, 297, 183
PicLeft = 16
PicTop = 34
PicWidth = 297 - PicLeft'(xPixels - 297) - PicLeft
PicHeight = 183 - PicTop'(xPixels - 183) - PicTop

'DIM SHARED PalLeft AS INTEGER
'DIM SHARED PalWidth AS INTEGER
'DIM SHARED PalTop AS INTEGER
'DIM SHARED PalHeight AS INTEGER
'PalLeft = 273
'PalTop = 0
'DIM SHARED PalComponentWDEPRECATED AS INTEGER
'DIM SHARED PalComponentHDEPRECATED AS INTEGER
'PalComponentWDEPRECATED = 2
'PalComponentHDEPRECATED = 2
'PalWidth = 16 * PalComponentWDEPRECATED
'PalHeight = 16 * PalComponentHDEPRECATED

'xPixels = 320 'already done above
'yPixels = 200 'already done above
PalComponentsX = 24
PalComponentsY = 11 'the remaining unused slots are skipped.
PalLeft = 319 - 48'was 273
PalTop = 0
PalWidth = 48 'xPixels - 40
PalHeight = 22 'yPixels - 40
PalComponentSpacingW = 2'INT(PalWidth / PalComponentsX)
PalComponentSpacingH = 2'INT(PalHeight / PalComponentsY)
PalComponentW = 2' PalComponentSpacingW - 1
PalComponentH = 2'PalComponentSpacingH - 1
PalWidth = PalComponentSpacingW * PalComponentsX
PalHeight = PalComponentSpacingH * PalComponentsY
PalColorDefault = 9
PalColor = PalColorDefault ' set to PalColorDefault again at postinit
PalXYFromPalColor 'fix PalX and PalY to match PalColor!
PalXPrev = -1
PalYPrev = -1



DIM SHARED pJakDraw(1 TO 1716)
DIM SHARED iBrushRad AS INTEGER
DIM SHARED sSound$
DIM SHARED qt$
DIM SHARED letters%
DIM SHARED tipnum%
qt$ = CHR$(34)

'Check sound setting
OPEN "bsound.dat" FOR INPUT AS #2
		LINE INPUT #2, sSound$
CLOSE #2

'See if user just loaded a file
OPEN "bloading.dat" FOR INPUT AS #1
		LINE INPUT #1, didit$
CLOSE #1
IF didit$ = "1" THEN
		GOTO postinit
		ELSE
END IF

SCREEN 13
getJakDraw
CLS
drawJakdraw
SLEEP 2
CLS

postinit:
iBrushRad = 3
xPointer = 14
yPointer = 40
PalColor = PalColorDefault
PalXYFromPalColor
'PalX = 9
'PalY = 0

tipnum% = 1
makezero
DrawWindowFrame
'MakePointerDEPRECATED 'sets pPointer - already done earlier
afterclear:

'PalHideCurDEPRECATED
'CALL PalMoveByDEPRECATED(0, 0)
'PalShow 'DOES PalShowNum
'PalShowCursor
'ShowBrushViewer
ShowHelp
ShowBrushViewer
PalShow
PalShowCursor
start:
bMouseMoved = 0
DO
'xMouseRawPrev = xMouseRaw
'yMouseRawPrev = yMouseRaw
' MouseStatus Lb, Rb, xMouseRaw, yMouseRaw
'xPointer = xMouseRaw / 2 + 2
'yPointer = yMouseRaw + 2
' SELECT CASE Lb
'       'CASE -1: PUT (xMouseRawPrev / 2, yMouseRawPrev), pPointer!, XOR: CALL OnMouseOver(Lb,Rb): PUT (xMouseRaw / 2, yMouseRaw), pPointer!, XOR
'       'CASE ELSE: PUT (xMouseRawPrev / 2, yMouseRawPrev), pPointer!, XOR: PUT (xMouseRaw / 2, yMouseRaw), pPointer!, XOR
'       CASE -1: UndrawPointer: CALL OnMouseOver(Lb,Rb): DrawPointer
'       CASE ELSE: UndrawPointer: DrawPointer
' END SELECT
	MouseStatus Lb, Rb, xMouseRaw, yMouseRaw
	IF xMouseRawPrev <> xMouseRaw OR yMouseRawPrev <> yMouseRaw OR LbPrev <> Lb OR RbPrev <> Rb THEN
		bFirst = 0
		'IF xPointerDrawn < 0 OR yPointerDrawn < 0 THEN
		'       bFirst = 1
		'       xPointer = PointerFromMouseX%(xMouseRaw)
		'       yPointer = PointerFromMouseY%(yMouseRaw)
		'       xPointerDrawn = xPointer
		'       yPointerDrawn = yPointer
		'       xPointerCropped = PointerCroppedX%(xPointer)
		'       yPointerCropped = PointerCroppedY%(yPointer)
		'       GET (xPointerCropped - iPointerRad, yPointerCropped - iPointerRad)-(xPointerCropped + iPointerRad, yPointerCropped + iPointerRad), pUnderPointer!(1)
		'       bUnderPointer = 1
		'END IF
		IF xPointerDrawn >= 0 THEN UndrawPointer
		yPointerPrev = yPointer
		xPointerPrev = xPointer
		xPointer = PointerFromMouseX%(xMouseRaw)
		yPointer = PointerFromMouseY%(yMouseRaw)
		IF xMouseRawPrev <> xMouseRaw OR yMouseRawPrev <> yMouseRaw THEN
			bMouseMoved = 1
			OnMouseOver
		ELSE
			bMouseMoved = 0
		END IF
		'IF bFirst = 0 THEN
		'UndrawPointer 'PUT (xPointerPrev, yPointerPrev), pPointer!, XOR
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
		'IF bMouseMoved = 1 THEN
		'       yPointerDrawn = yPointer
		'       xPointerDrawn = xPointer
		'END IF
	END IF

		SELECT CASE INKEY$
		CASE CHR$(0) + "H": CALL PalMoveBy(0, -1): PalShowCursor': DOES PalShow and ShowBrushViewer 'UP ARROW KEY 'was PalMoveByDEPRECATED
		CASE CHR$(0) + "P": CALL PalMoveBy(0, 1): PalShowCursor': DOES PalShow and ShowBrushViewer 'DOWN ARROW KEY 'was PalMoveByDEPRECATED
		CASE CHR$(0) + "K": CALL PalMoveBy(-1, 0): PalShowCursor': DOES PalShow and ShowBrushViewer'LEFT ARROW KEY 'was PalMoveByDEPRECATED
		CASE CHR$(0) + "M": CALL PalMoveBy(1, 0): PalShowCursor': DOES PalShow and ShowBrushViewer 'RIGHT ARROW KEY 'was PalMoveByDEPRECATED
		CASE "U": DrawDotAtPointer: CALL MovePointerBy(0, -1)
		CASE "J": DrawDotAtPointer: CALL MovePointerBy(0, 1)
		CASE "H": DrawDotAtPointer: CALL MovePointerBy(-1, 0)
		CASE "K": DrawDotAtPointer: CALL MovePointerBy(1, 0)
		CASE "u": DrawDotAtPointer: CALL MovePointerBy(0, -1)
		CASE "j": DrawDotAtPointer: CALL MovePointerBy(0, 1)
		CASE "h": DrawDotAtPointer: CALL MovePointerBy(-1, 0)
		CASE "k": DrawDotAtPointer: CALL MovePointerBy(1, 0)
		CASE CHR$(0) + "G": CALL MovePointerBy(0, -1)'[End] as UP
		CASE CHR$(0) + "O": CALL MovePointerBy(0, 1) '[Home] as DOWN
		CASE CHR$(0) + "S": CALL MovePointerBy(-1, 0)'[Delete] as LEFT
		CASE CHR$(0) + "Q": CALL MovePointerBy(1, 0) '[PgDn] as RIGHT
		CASE "R": CALL MovePointerBy(0, -1)
		CASE "F": CALL MovePointerBy(0, 1)
		CASE "D": CALL MovePointerBy(-1, 0)
		CASE "G": CALL MovePointerBy(1, 0)
		CASE "r": CALL MovePointerBy(0, -1)
		CASE "f": CALL MovePointerBy(0, 1)
		CASE "d": CALL MovePointerBy(-1, 0)
		CASE "g": CALL MovePointerBy(1, 0)

		CASE "d": DrawDotAtPointer
		CASE "D": DrawDotAtPointer
		CASE "A": FloodFill
		CASE "a": FloodFill
		CASE "M": ColorReplace
		CASE "m": ColorReplace
		'CASE "h": tipnum% = tipnum% + 1: ShowHelp: IF tipnum% > 8 THEN tipnum% = 0
		CASE "p": PickColorAtPointer': PalShow : ShowBrushViewer 'PalShow DOES PalShowNum PalHideCurDEPRECATED: CALL PalMoveByDEPRECATED(0, 0)
		CASE "P": PickColorAtPointer': PalShow : ShowBrushViewer' PalHideCurDEPRECATED: CALL PalMoveByDEPRECATED(0, 0)
		CASE "+": iBrushRad = iBrushRad + 1: BrushSizeToBounds: PalShow: PalShowCursor: ShowBrushViewer
		CASE "-": iBrushRad = iBrushRad - 1: BrushSizeToBounds: PalShow: PalShowCursor: ShowBrushViewer
		CASE "W": iBrushRad = iBrushRad + 1: BrushSizeToBounds: PalShow: PalShowCursor: ShowBrushViewer
		CASE "w": iBrushRad = iBrushRad - 1: BrushSizeToBounds: PalShow: PalShowCursor: ShowBrushViewer
		'CASE CHR$(32): LINE (10, 36)-(299, 185), 0, BF: FreshWindow:  GOTO afterclear 'PUT (xMouseRaw / 2, yMouseRaw), pPointer!, XOR: GOTO afterclear
		CASE "C": LINE (10, 36)-(299, 185), 0, BF: FreshWindow:  GOTO afterclear 'PUT (xMouseRaw / 2, yMouseRaw), pPointer!, XOR: GOTO afterclear
		CASE "c": LINE (10, 36)-(299, 185), 0, BF: FreshWindow:  GOTO afterclear 'PUT (xMouseRaw / 2, yMouseRaw), pPointer!, XOR: GOTO afterclear
		'CASE CHR$(0) + ";": SaveBA: GOTO afterclear 'F1 Saves
		'CASE CHR$(0) + "<": LoadBA: GOTO afterclear 'F2 Loads
		CASE "s": SaveBA: GOTO afterclear 'F1 Saves
		CASE "S": SaveBA: GOTO afterclear 'F1 Saves
		CASE "l": LoadBA: GOTO afterclear 'F2 Loads
		CASE "L": LoadBA: GOTO afterclear 'F2 Loads
		CASE CHR$(9): SwitchSound
		CASE CHR$(27): EXIT DO
		CASE ELSE
		END SELECT
LOOP

endit:
CHAIN ("qjakmenu.bas")
END
'end mouse functions
DEFSNG A-Z

'SUB PaintAtPointer
'       SELECT CASE iBrushRad
'       CASE 1: PSET (xPointer, yPointer), PalY * 16 + PalX
'       CASE 2: PSET (xPointer, yPointer), PalY * 16 + PalX
'               CIRCLE (xPointer, yPointer), iBrushRad - 1, PalY * 16 + PalX
'       CASE 3: LINE (xPointer - 1, yPointer - 1)-(xPointer + 1, yPointer + 1), PalY * 16 + PalX, BF
'               CIRCLE (xPointer, yPointer), iBrushRad - 1, PalY * 16 + PalX
'       CASE 4: CIRCLE (xPointer, yPointer), iBrushRad - 1, PalY * 16 + PalX
'               LINE (xPointer - 1, yPointer)-(xPointer + 1, yPointer), PalY * 16 + PalX
'               LINE (xPointer - 2, yPointer - 1)-(xPointer + 2, yPointer + 1), PalY * 16 + PalX, BF
'       CASE 5: CIRCLE (xPointer, yPointer), iBrushRad - 1, PalY * 16 + PalX
'               LINE (xPointer - 3, yPointer - 1)-(xPointer + 3, yPointer + 1), PalY * 16 + PalX, BF
'               LINE (xPointer - 1, yPointer - 2)-(xPointer + 1, yPointer + 2), PalY * 16 + PalX, BF
'       CASE 6: CIRCLE (xPointer, yPointer), iBrushRad - 1, PalY * 16 + PalX
'               LINE (xPointer - 2, yPointer - 3)-(xPointer + 2, yPointer + 3), PalY * 16 + PalX, BF
'               LINE (xPointer - 4, yPointer - 1)-(xPointer + 4, yPointer + 1), PalY * 16 + PalX, BF
'               LINE (xPointer - 3, yPointer - 2)-(xPointer + 3, yPointer + 2), PalY * 16 + PalX, B
'       CASE 7: CIRCLE (xPointer, yPointer), iBrushRad - 1, PalY * 16 + PalX
'               LINE (xPointer - 5, yPointer - 1)-(xPointer + 5, yPointer + 1), PalY * 16 + PalX, BF
'               LINE (xPointer - 2, yPointer - 4)-(xPointer + 2, yPointer + 4), PalY * 16 + PalX, BF
'               LINE (xPointer - 3, yPointer - 3)-(xPointer + 3, yPointer + 3), PalY * 16 + PalX, B
'               LINE (xPointer - 4, yPointer - 2)-(xPointer + 4, yPointer + 2), PalY * 16 + PalX, B
'       CASE 8: CIRCLE (xPointer, yPointer), iBrushRad - 1, PalY * 16 + PalX
'               LINE (xPointer - 2, yPointer - 5)-(xPointer + 2, yPointer + 5), PalY * 16 + PalX, BF
'               LINE (xPointer - 6, yPointer - 1)-(xPointer + 6, yPointer + 1), PalY * 16 + PalX, BF
'               LINE (xPointer - 5, yPointer - 3)-(xPointer + 5, yPointer + 3), PalY * 16 + PalX, BF
'               LINE (xPointer - 4, yPointer - 4)-(xPointer + 4, yPointer + 4), PalY * 16 + PalX, B
'       CASE 9: CIRCLE (xPointer, yPointer), iBrushRad - 1, PalY * 16 + PalX
'               LINE (xPointer - 2, yPointer - 6)-(xPointer + 2, yPointer + 6), PalY * 16 + PalX, BF
'               LINE (xPointer - 7, yPointer - 1)-(xPointer + 7, yPointer + 1), PalY * 16 + PalX, BF
'               LINE (xPointer - 4, yPointer - 5)-(xPointer + 4, yPointer + 5), PalY * 16 + PalX, BF
'               LINE (xPointer - 6, yPointer - 3)-(xPointer + 6, yPointer + 3), PalY * 16 + PalX, BF
'               LINE (xPointer - 5, yPointer - 4)-(xPointer + 5, yPointer + 4), PalY * 16 + PalX, B
'       CASE 10: CIRCLE (xPointer, yPointer), iBrushRad - 1, PalY * 16 + PalX
'               LINE (xPointer - 4, yPointer - 6)-(xPointer + 4, yPointer + 6), PalY * 16 + PalX, BF
'               LINE (xPointer - 8, yPointer - 1)-(xPointer + 8, yPointer + 1), PalY * 16 + PalX, BF
'               LINE (xPointer - 6, yPointer - 5)-(xPointer + 6, yPointer + 5), PalY * 16 + PalX, BF
'               LINE (xPointer - 7, yPointer - 3)-(xPointer + 7, yPointer + 3), PalY * 16 + PalX, B
'       END SELECT
'       DrawWindowFrame
'END SUB

DEFINT A-Z
SUB BrushSizeToBounds
IF (iBrushRad > 10) THEN
		iBrushRad = 1
ELSEIF (iBrushRad < 1) THEN
		iBrushRad = 10
END IF
END SUB

SUB cletter (iAdder%)
letters% = letters% + iAdder%
IF (letters% < 0) THEN
		letters% = 0
ELSEIF (letters% > 8) THEN
		letters% = 8
END IF
END SUB

SUB ColorReplace
	UndrawPointer 'PUT (xPointer - 2, yPointer - 2), pPointer!, XOR
	COLOR 34
	LOCATE 1, 7
	PRINT "Filling...  [escape]Äcancels"

	colno = 0
	xp = 0
	yp = 0
	underColr = POINT(xPointer, yPointer)
	FOR xfi = 0 TO 289
			FOR yfi = 0 TO 149
			testCol = POINT(xfi + 10, yfi + 36)
			IF (testCol = underColr) THEN
			PSET (xfi + 10, yfi + 36), PalY * 16 + PalX
			ELSE
			END IF
			SELECT CASE INKEY$
		CASE CHR$(27): GOTO stopFfill
			END SELECT
			NEXT yfi
	NEXT xfi

stopFfill:
	LOCATE 1, 7
	PRINT "                                "
	ShowHelp
	DrawPointer 'PUT (xPointer - 2, yPointer - 2), pPointer!, XOR
END SUB

SUB DrawDotAtPointer
	'PUT (xMouseRaw / 2, yMouseRaw), pPointer!, XOR
	UndrawPointer
	SELECT CASE iBrushRad
		'IF PalColor < 0 THEN PalMoveTo(0, 0)'PalColor = PalY * 16 + PalX
		CASE 1: PSET (xPointer, yPointer), PalColor
		CASE 2: PSET (xPointer, yPointer), PalColor
		CIRCLE (xPointer, yPointer), iBrushRad - 1, PalColor
		CASE 3: LINE (xPointer - 1, yPointer - 1)-(xPointer + 1, yPointer + 1), PalColor, BF
		CIRCLE (xPointer, yPointer), iBrushRad - 1, PalColor
		CASE 4: CIRCLE (xPointer, yPointer), iBrushRad - 1, PalColor
		LINE (xPointer - 1, yPointer)-(xPointer + 1, yPointer), PalColor
		LINE (xPointer - 2, yPointer - 1)-(xPointer + 2, yPointer + 1), PalColor, BF
		CASE 5: CIRCLE (xPointer, yPointer), iBrushRad - 1, PalColor
		LINE (xPointer - 3, yPointer - 1)-(xPointer + 3, yPointer + 1), PalColor, BF
		LINE (xPointer - 1, yPointer - 2)-(xPointer + 1, yPointer + 2), PalColor, BF
		CASE 6: CIRCLE (xPointer, yPointer), iBrushRad - 1, PalColor
		LINE (xPointer - 2, yPointer - 3)-(xPointer + 2, yPointer + 3), PalColor, BF
		LINE (xPointer - 4, yPointer - 1)-(xPointer + 4, yPointer + 1), PalColor, BF
		LINE (xPointer - 3, yPointer - 2)-(xPointer + 3, yPointer + 2), PalColor, B
		CASE 7: CIRCLE (xPointer, yPointer), iBrushRad - 1, PalColor
		LINE (xPointer - 5, yPointer - 1)-(xPointer + 5, yPointer + 1), PalColor, BF
		LINE (xPointer - 2, yPointer - 4)-(xPointer + 2, yPointer + 4), PalColor, BF
		LINE (xPointer - 3, yPointer - 3)-(xPointer + 3, yPointer + 3), PalColor, B
		LINE (xPointer - 4, yPointer - 2)-(xPointer + 4, yPointer + 2), PalColor, B
		CASE 8: CIRCLE (xPointer, yPointer), iBrushRad - 1, PalColor
		LINE (xPointer - 2, yPointer - 5)-(xPointer + 2, yPointer + 5), PalColor, BF
		LINE (xPointer - 6, yPointer - 1)-(xPointer + 6, yPointer + 1), PalColor, BF
		LINE (xPointer - 5, yPointer - 3)-(xPointer + 5, yPointer + 3), PalColor, BF
		LINE (xPointer - 4, yPointer - 4)-(xPointer + 4, yPointer + 4), PalColor, B
		CASE 9: CIRCLE (xPointer, yPointer), iBrushRad - 1, PalColor
		LINE (xPointer - 2, yPointer - 6)-(xPointer + 2, yPointer + 6), PalColor, BF
		LINE (xPointer - 7, yPointer - 1)-(xPointer + 7, yPointer + 1), PalColor, BF
		LINE (xPointer - 4, yPointer - 5)-(xPointer + 4, yPointer + 5), PalColor, BF
		LINE (xPointer - 6, yPointer - 3)-(xPointer + 6, yPointer + 3), PalColor, BF
		LINE (xPointer - 5, yPointer - 4)-(xPointer + 5, yPointer + 4), PalColor, B
		CASE 10: CIRCLE (xPointer, yPointer), iBrushRad - 1, PalColor
		LINE (xPointer - 4, yPointer - 6)-(xPointer + 4, yPointer + 6), PalColor, BF
		LINE (xPointer - 8, yPointer - 1)-(xPointer + 8, yPointer + 1), PalColor, BF
		LINE (xPointer - 6, yPointer - 5)-(xPointer + 6, yPointer + 5), PalColor, BF
		LINE (xPointer - 7, yPointer - 3)-(xPointer + 7, yPointer + 3), PalColor, B
	END SELECT
	DrawWindowFrame
	DrawPointer'PUT (xMouseRaw / 2, yMouseRaw), pPointer!, XOR
	'end DrawDotAtPointer
END SUB

SUB drawJakdraw

FOR i = 77 TO 51 STEP -1
		PUT (51, i), pJakDraw, PSET
		SOUND i + 20000, .2
		PUT (51, i), pJakDraw, XOR
NEXT i
FOR i = 51 TO 0 STEP -1
		PUT (i, i), pJakDraw, PSET
		SOUND i + 20000, .2
		PUT (i, i), pJakDraw, XOR
NEXT i
PUT (0, 0), pJakDraw, PSET

COLOR 9
LOCATE 2, 11
PRINT "2.7"
END SUB

SUB DrawPointer
	IF bPointerShowing = 0 THEN
		'draw mouse cursor manually
		xPointerCropped = PointerCroppedX%(xPointer)
		yPointerCropped = PointerCroppedY%(yPointer)
		GET (xPointerCropped - iPointerRad, yPointerCropped - iPointerRad)-(xPointerCropped + iPointerRad, yPointerCropped + iPointerRad), pUnderPointer!(1)
		bUnderPointer = 1
		LINESAFEH xPointer - (iPointerRad - 1), yPointer - 1, xPointer - 1, yPointer - 1, 0 'black dot
		LINESAFEH xPointer - iPointerRad, yPointer, xPointer - 1, yPointer, 15 'LEFT
		LINESAFEH xPointer - (iPointerRad - 1), yPointer + 1, xPointer - 1, yPointer + 1, 0 'black dot

		LINESAFEH xPointer + (iPointerRad - 1), yPointer - 1, xPointer + 1, yPointer - 1, 0 'black dot
		LINESAFEH xPointer + iPointerRad, yPointer, xPointer + 1, yPointer, 15 'RIGHT
		LINESAFEH xPointer + (iPointerRad - 1), yPointer + 1, xPointer + 1, yPointer + 1, 0 'black dot

		LINESAFEV xPointer, yPointer - 1, xPointer, yPointer - iPointerRad, 15 'TOP

		LINESAFEV xPointer, yPointer + 1, xPointer, yPointer + iPointerRad, 15 'BOTTOM
		bPointerShowing = 1
		yPointerDrawn = yPointer
		xPointerDrawn = xPointer
	END IF
END SUB

SUB DrawWindowFrame
	'window
	LINE (10, 35)-STEP(290, 0), 8
	LINE STEP(-291, 0)-STEP(0, 151), 8
	LINE STEP(291, -150)-STEP(0, 150), 7
	LINE STEP(-290, 0)-STEP(289, 0), 7
	LINE STEP(2, -151)-STEP(0, 152), 15
	LINE STEP(-1, 0)-STEP(-291, 0), 15
	LINE STEP(-1, -153)-STEP(294, 154), 24, B
	LINE STEP(1, 1)-STEP(-296, -156), 24, B
	LINE STEP(0, -1)-STEP(296, 0), 15
	LINE STEP(-297, 0)-STEP(0, 157), 15
	LINE STEP(0, 1)-STEP(298, 0), 8
	LINE STEP(0, -1)-STEP(0, -157), 8
END SUB

SUB FloodFill
	UndrawPointer 'PUT (xPointer - 2, yPointer - 2), pPointer!, XOR
	COLOR 34
	LOCATE 1, 7
	PRINT "filling...  [escape]Äcancels"

	ydiro = 1
	yp = 0
	underColr = POINT(xPointer, yPointer)

aheadfilup:
	yp = 0
aheadfill:
	colno = 0
	xp = 0
	DO

		testCol = POINT(xPointer + xp, yPointer + (yp * ydiro))
		IF (testCol = underColr) THEN
			PSET (xPointer + xp, yPointer + (yp * ydiro)), PalY * 16 + PalX
			xp = xp + 1
		ELSE
			colno = 1
		END IF
		SELECT CASE INKEY$
			CASE CHR$(27): GOTO exfil
		END SELECT
	LOOP UNTIL colno = 1
	
	'behind FloodFill:
	colno = 0
	xp = 1
	DO
		testCol = POINT(xPointer - xp, yPointer + (yp * ydiro))
		IF (testCol = underColr) THEN
			PSET (xPointer - xp, yPointer + (yp * ydiro)), PalY * 16 + PalX
			xp = xp + 1
		ELSE
			colno = 1
		END IF
		SELECT CASE INKEY$
			CASE CHR$(27): GOTO exfil
		END SELECT
	LOOP UNTIL colno = 1

	yp = yp + 1
	testCol = POINT(xPointer, yPointer + (yp * ydiro))
	IF (testCol = underColr) THEN
			GOTO aheadfill
	ELSE
	END IF
		SELECT CASE INKEY$
			CASE CHR$(27): GOTO exfil
		END SELECT

	IF (ydiro = -1) THEN
			GOTO exfil
	ELSE
			ydiro = -1
			GOTO aheadfilup
	END IF
exfil:
	LOCATE 1, 7
	PRINT "                                "
	ShowHelp
	DrawPointer 'PUT (xPointer - 2, yPointer - 2), pPointer!, XOR
	'end sub FloodFill
END SUB

SUB FreshWindow
'black outside
LINE (1, 32)-(5, 190), 0, BF     'left
LINE (112, 29)-(308, 31), 0, BF 'top
LINE (1, 191)-(308, 192), 0, BF 'bottom
LINE (305, 32)-(308, 190), 0, BF 'right

'palette
PalShow: PalShowCursor: ShowBrushViewer

'window
LINE (10, 35)-STEP(290, 0), 8
LINE STEP(-291, 0)-STEP(0, 151), 8
LINE STEP(291, -150)-STEP(0, 150), 7
LINE STEP(-290, 0)-STEP(289, 0), 7

LINE STEP(2, -151)-STEP(0, 152), 15
LINE STEP(-1, 0)-STEP(-291, 0), 15
LINE STEP(-1, -153)-STEP(294, 154), 24, B
LINE STEP(1, 1)-STEP(-296, -156), 24, B

LINE STEP(0, -1)-STEP(296, 0), 15
LINE STEP(-297, 0)-STEP(0, 157), 15
LINE STEP(0, 1)-STEP(298, 0), 8
LINE STEP(0, -1)-STEP(0, -157), 8

END SUB

SUB getJakDraw

COLOR 52
jdX = 0
jdY = 96

'"J" in Jak
		LINE (jdX, jdY)-STEP(1, 1), 53
		LINE STEP(0, 0)-STEP(10, -2), 53
		LINE STEP(0, 0)-STEP(0, -15), 53
		LINE STEP(10, 0)-STEP(-20, 0), 53
LOCATE 12, 3
PRINT "ak"

'"D" in Draw
LOCATE 12, 7
PRINT "raw"
		LINE (jdX + 40, jdY - 2)-STEP(0, -17), 53
		CIRCLE STEP(-5, 10), 12, 53, 4.7, 1.5
GET (0, 77)-(75, 97), pJakDraw

END SUB

FUNCTION IsInPic% (xNow%, yNow%)
	bCheck = 0
	IF xNow% >= PicLeft AND xNow% <= PicLeft + PicWidth AND yNow% >= PicTop AND yNow% <= PicTop + PicHeight THEN
		bCheck = 1
	END IF
	IsInPic% = bCheck
END FUNCTION

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

SUB LoadBA
UndrawPointer 'PUT (xPointer - 2, yPointer - 2), pPointer!, XOR

COLOR 34
LOCATE 1, 7
PRINT "Load file:                "
'LOCATE 2, 7
'SHELL ("dir *.ba1")
letters% = 0

resa:
COLOR 0
LOCATE 1, 18
PRINT "                        ";
COLOR 34
LOCATE 1, 18
PRINT filenam$;
SLEEP 0
DO
		dumr$ = INKEY$
		SELECT CASE dumr$
		CASE "": GOTO resa
		CASE CHR$(8): CALL cletter(-1): filenam$ = MID$(filenam$, 1, letters%): GOTO resa
		CASE CHR$(32): GOTO resa
		CASE CHR$(9): GOTO resa
		CASE "/": GOTO resa
		CASE "\": GOTO resa
		CASE CHR$(9): GOTO resa
		CASE CHR$(27): letters% = 0: EXIT DO
		CASE CHR$(13): EXIT DO
		CASE ELSE: filenam$ = filenam$ + dumr$: CALL cletter(1): filenam$ = MID$(filenam$, 1, letters%): GOTO resa
		END SELECT
LOOP

COLOR 0
LOCATE 1, 7
PRINT "                        "
SELECT CASE letters%
		CASE 0: GOTO noLoad
		CASE ELSE
END SELECT
COLOR 34
LOCATE 1, 7
PRINT "loading...	"
CHAIN (filenam$ + ".ba1")

noLoad:
ShowHelp
'PUT (xPointer - 2, yPointer - 2), pPointer!, XOR
DrawPointer
END SUB

SUB MakePointerDEPRECATED
	'get mouse cursor
	'LINE (0, 0)-(4, 4), 0
	'LINE (2, 0)-STEP(0, 1), 15
	'LINE STEP(0, 2)-STEP(0, 1), 15
	'LINE STEP(-3, -2)-STEP(2, 0), 15
	'LINE STEP(2, 0)-STEP(1, 0), 15
	'GET (0, 0)-(4, 4), pPointer!(1)
	'LINE (0, 0)-(4, 4), 0
END SUB

SUB makezero
	'lets program know that the program
	'isn't restarting after loading a file
	OPEN "bloading.dat" FOR OUTPUT AS #2
			PRINT #2, "0"
	CLOSE #2
END SUB

'start mouse functions
SUB MouseDriver (ax%, bx%, cx%, dx%)
DEFLNG A-Z
	DEF SEG = VARSEG(mouse$)
	mouse% = SADD(mouse$)
	CALL Absolute(ax%, bx%, cx%, dx%, mouse%)
DEFSNG A-Z
END SUB

SUB MouseHideDEPRECATED
 'ax% = 2
 'MouseDriver ax%, 0, 0, 0
END SUB

FUNCTION MouseInit%
	ax% = 0
	MouseDriver ax%, 0, 0, 0
	MouseInit% = ax%
END FUNCTION

SUB MousePut (xMouseRaw%, yMouseRaw%)
	ax% = 4
	cx% = xMouseRaw%
	dx% = yMouseRaw%
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

SUB MouseShowDEPRECATED
	'PUT (xMouseRaw / 2, yMouseRaw), pPointer!, XOR
END SUB

SUB MouseStatus (LbX%, RbX%, xMouse%, yMouse%)
	ax% = 3
	MouseDriver ax%, bx%, cx%, dx%
	LbX% = ((bx% AND 1) <> 0)
	RbX% = ((bx% AND 2) <> 0)
	xMouse% = cx%
	yMouse% = dx%
END SUB

SUB MovePointerBy (xm%, ym%)
DEFINT A-Z
	UndrawPointer
	'manually move mouse cursor
	'xPointer = xPointer + xm%
	'yPointer = yPointer + ym%
	MousePut xMouseRaw + xm% * 2, yMouseRaw + ym%
	'bMouseMoved = 1
	xPointer = PointerFromMouseX%(xMouseRaw)
	yPointer = PointerFromMouseY%(yMouseRaw)
	DrawWindowFrame
	DrawPointer
DEFSNG A-Z
END SUB

SUB OnDragEnd

END SUB

SUB OnDragging

END SUB

SUB OnDragStart
	xDragStart = xPointer
	yDragStart = yPointer
END SUB

SUB OnMouseDown
	IF Lb = -1 THEN 'button down
		IF IsInPic%(xPointer, yPointer) = 1 THEN
			DrawDotAtPointer'PaintAtPointer
		ELSEIF PalContainsLocation%(xPointer, yPointer) = 1 THEN
			PickColorAtPointer
		END IF
		'SELECT CASE iBrushRad
		'       CASE 1: PSET (xPointer, yPointer), PalY * 16 + PalX
		'       CASE 2: PSET (xPointer, yPointer), PalY * 16 + PalX
		'       CIRCLE (xPointer, yPointer), iBrushRad - 1, PalY * 16 + PalX
		'       CASE 3: LINE (xPointer - 1, yPointer - 1)-(xPointer + 1, yPointer + 1), PalY * 16 + PalX, BF
		'       CIRCLE (xPointer, yPointer), iBrushRad - 1, PalY * 16 + PalX
		'       CASE 4: CIRCLE (xPointer, yPointer), iBrushRad - 1, PalY * 16 + PalX
		'       LINE (xPointer - 1, yPointer)-(xPointer + 1, yPointer), PalY * 16 + PalX
		'       LINE (xPointer - 2, yPointer - 1)-(xPointer + 2, yPointer + 1), PalY * 16 + PalX, BF
		'       CASE 5: CIRCLE (xPointer, yPointer), iBrushRad - 1, PalY * 16 + PalX
		'       LINE (xPointer - 3, yPointer - 1)-(xPointer + 3, yPointer + 1), PalY * 16 + PalX, BF
		'       LINE (xPointer - 1, yPointer - 2)-(xPointer + 1, yPointer + 2), PalY * 16 + PalX, BF
		'       CASE 6: CIRCLE (xPointer, yPointer), iBrushRad - 1, PalY * 16 + PalX
		'       LINE (xPointer - 2, yPointer - 3)-(xPointer + 2, yPointer + 3), PalY * 16 + PalX, BF
		'       LINE (xPointer - 4, yPointer - 1)-(xPointer + 4, yPointer + 1), PalY * 16 + PalX, BF
		'       LINE (xPointer - 3, yPointer - 2)-(xPointer + 3, yPointer + 2), PalY * 16 + PalX, B
		'       CASE 7: CIRCLE (xPointer, yPointer), iBrushRad - 1, PalY * 16 + PalX
		'       LINE (xPointer - 5, yPointer - 1)-(xPointer + 5, yPointer + 1), PalY * 16 + PalX, BF
		'       LINE (xPointer - 2, yPointer - 4)-(xPointer + 2, yPointer + 4), PalY * 16 + PalX, BF
		'       LINE (xPointer - 3, yPointer - 3)-(xPointer + 3, yPointer + 3), PalY * 16 + PalX, B
		'       LINE (xPointer - 4, yPointer - 2)-(xPointer + 4, yPointer + 2), PalY * 16 + PalX, B
		'       CASE 8: CIRCLE (xPointer, yPointer), iBrushRad - 1, PalY * 16 + PalX
		'       LINE (xPointer - 2, yPointer - 5)-(xPointer + 2, yPointer + 5), PalY * 16 + PalX, BF
		'       LINE (xPointer - 6, yPointer - 1)-(xPointer + 6, yPointer + 1), PalY * 16 + PalX, BF
		'       LINE (xPointer - 5, yPointer - 3)-(xPointer + 5, yPointer + 3), PalY * 16 + PalX, BF
		'       LINE (xPointer - 4, yPointer - 4)-(xPointer + 4, yPointer + 4), PalY * 16 + PalX, B
		'       CASE 9: CIRCLE (xPointer, yPointer), iBrushRad - 1, PalY * 16 + PalX
		'       LINE (xPointer - 2, yPointer - 6)-(xPointer + 2, yPointer + 6), PalY * 16 + PalX, BF
		'       LINE (xPointer - 7, yPointer - 1)-(xPointer + 7, yPointer + 1), PalY * 16 + PalX, BF
		'       LINE (xPointer - 4, yPointer - 5)-(xPointer + 4, yPointer + 5), PalY * 16 + PalX, BF
		'       LINE (xPointer - 6, yPointer - 3)-(xPointer + 6, yPointer + 3), PalY * 16 + PalX, BF
		'       LINE (xPointer - 5, yPointer - 4)-(xPointer + 5, yPointer + 4), PalY * 16 + PalX, B
		'       CASE 10: CIRCLE (xPointer, yPointer), iBrushRad - 1, PalY * 16 + PalX
		'       LINE (xPointer - 4, yPointer - 6)-(xPointer + 4, yPointer + 6), PalY * 16 + PalX, BF
		'       LINE (xPointer - 8, yPointer - 1)-(xPointer + 8, yPointer + 1), PalY * 16 + PalX, BF
		'       LINE (xPointer - 6, yPointer - 5)-(xPointer + 6, yPointer + 5), PalY * 16 + PalX, BF
		'       LINE (xPointer - 7, yPointer - 3)-(xPointer + 7, yPointer + 3), PalY * 16 + PalX, B
		'END SELECT
	ELSEIF Rb = -1 THEN 'button down
		PickColorAtPointer
	END IF
	'DrawWindowFrame
END SUB

SUB OnMouseOver
	IF Lb = -1 THEN
		IF IsInPic%(xPointer, yPointer) = 1 THEN
			DrawDotAtPointer'PaintAtPointer
		ELSEIF PalContainsLocation%(xPointer, yPointer) = 1 THEN
			PickColorAtPointer
		END IF
	END IF
END SUB

SUB OnMouseUp

END SUB

DEFINT A-Z
FUNCTION PalContainsLocation% (xNow%, yNow%)
	bCheck = 0
	IF xNow% >= PalLeft AND xNow% <= PalLeft + PalWidth AND yNow% >= PalTop AND yNow% <= PalTop + PalHeight THEN
		bCheck = 1
	END IF
	PalContainsLocation% = bCheck
END FUNCTION

DEFSNG A-Z
SUB PalCoordsToRect (GetLeft%, GetTop%, GetRight%, GetBottom%, xAt%, yAt%)
	GetLeft% = xAt% * PalComponentSpacingW + PalLeft
	GetTop% = yAt% * PalComponentSpacingH + PalTop
	GetRight% = xAt% * PalComponentSpacingW + PalLeft + PalComponentW - 1
	GetBottom% = yAt% * PalComponentSpacingH + PalTop + PalComponentH - 1
END SUB

SUB PalGetCursorRect (GetLeft%, GetTop%, GetRight%, GetBottom%)
	CALL PalCoordsToRect(GetLeft%, GetTop%, GetRight%, GetBottom%, PalX, PalY)
	GetLeft% = GetLeft% - 1
	GetTop% = GetTop% - 1
	GetRight% = GetRight% + 1
	GetBottom% = GetBottom% + 1
END SUB

SUB PalHide
	LINE (PalLeft, PalTop)-(PalLeft + PalWidth, PalTop + PalHeight), 0, BF
END SUB

SUB PalHideCurDEPRECATED
FOR xco = 0 TO 15
		FOR yco = 0 TO 15
		LINE (xco * 2 + 272, yco * 2 - 1)-(xco * 2 + 274, yco * 2 + 1), 0, B
		NEXT yco
NEXT xco
END SUB

SUB PalHideCursor
	CALL PalShowCursorCustom(0)
	PalShow
END SUB

SUB PalMoveBy (xBy%, yBy%)
	CALL PalMoveTo(PalX + xBy%, PalY + yBy%)
END SUB

SUB PalMoveByDEPRECATED (xc%, yc%)
	PalHide 'LINE (PalX * 2 + 272, PalY * 2 - 1)-(PalX * 2 + 274, PalY * 2 + 1), 0, B

	'move
	PalX = PalX + xc%
	PalY = PalY + yc%
	'wrap
	IF (PalX < 0) THEN
			PalX = 15
	ELSEIF (PalX > 15) THEN
			PalX = 0
	ELSEIF (PalY < 0) THEN
			PalY = 15
	ELSEIF (PalY > 15) THEN
			PalY = 0
	END IF
	iNow = 0
	'draw palette
	FOR yPalNow = 0 TO 15
			FOR xPalNow = 0 TO 15
			'PSET (xPalNow * 2 + 273, yPalNow * 2), yPalNow * 16 + xPalNow
			LINE (xPalNow * 2 + PalLeft, yPalNow * 2 + PalTop)-(xPalNow * 2 + PalLeft + PalComponentWDEPRECATED, yPalNow * 2 + PalTop + PalComponentHDEPRECATED), iNow, BF
			'IF yPalNow > 1 THEN
				iNow = iNow + 1
			'ELSEIF xPalNow < 16 THEN
			'       iNow = iNow + 1
			'END IF
			NEXT xPalNow
	NEXT yPalNow

	PalShowCursor   'LINE (PalX * 2 + 272, PalY * 2 - 1)-(PalX * 2 + 274, PalY * 2 + 1), 28, B
	'play sound
	SELECT CASE sSound$
		CASE "0": IF (xc% <> 0) OR (yc% <> 0) THEN SOUND 20000, .2
		CASE "1": IF (xc% <> 0) OR (yc% <> 0) THEN SOUND 1000, .2
	END SELECT
	ShowBrushViewer
	'COLOR 154
	'LOCATE 25, 31
	'PRINT "         ";
	'LOCATE 25, 31
	'PRINT "color"; PalY * 16 + PalX;
END SUB

SUB PalMoveTo (xSet%, ySet%)
	bOk = 0
	DIM xNew AS INTEGER
	DIM yNew AS INTEGER
	xNew = 0
	yNew = 0
	IF xSet% > 15 AND xSet% <= PalComponentsX AND xSet% = PalX THEN 'PalX <= 15 AND PalY >= 2  THEN 'IF xSet% > 16 AND xSet% <= PalComponentsX THEN '>16 intentionally
		IF ySet% >= 0 AND ySet% < 2 THEN
			yNew = ySet% + (PalComponentsY - 2)
		ELSEIF ySet% = PalComponentsY THEN 'ySet%>=PalComponentsY AND ySet% < PalComponentsY+1 THEN
			yNew = 2 'ySet% - (PalComponentsY - 2)
		ELSE
			yNew = ySet%
		END IF
	ELSE
		yNew = ySet%
	END IF
	xNew = xSet%
	DO WHILE bOk = 0
		IF yNew >= PalComponentsY THEN
			yNew = yNew - PalComponentsY
		ELSEIF yNew < 0 THEN
			yNew = yNew + PalComponentsY
		ELSE
			bOk = 1
		END IF
	LOOP
	bOk = 0
	DO WHILE bOk = 0
		IF yNew >= 2 THEN
			IF xNew >= PalComponentsX THEN
				xNew = xNew - PalComponentsX
			ELSEIF xNew < 0 THEN
				xNew = xNew + PalComponentsX
			ELSE
				bOk = 1
			END IF
		ELSE
			IF xNew >= 16 THEN
				xNew = xNew - 16
			ELSEIF xNew < 0 THEN
				xNew = xNew + 16
			ELSE
				bOk = 1
			END IF
		END IF
	LOOP
	'LINE (PalX * 16 - 1, PalY * 12 - 1)-(PalX * 16 + 15, PalY * 12 + 11), 0, B
	'LINE (xNew * PalComponentSpacingW + PalLeft - 1, yNew * PalComponentSpacingH+PalTop - 1)-(xPalNow * PalComponentSpacingW + PalLeft + PalComponentW + 1, yPalNow * PalComponentSpacingH+PalTop+PalComponentH + 1), 0, B
	PalYPrev = PalY
	PalY = yNew
	PalXPrev = PalX
	PalX = xNew
	iReturn = -1
	iNow = 0
	FOR yPalNow = 0 TO PalComponentsY - 1
			FOR xPalNow = 0 TO PalComponentsX - 1
				'PSET (xPalNow * 2 + 273, yPalNow * 2), yPalNow * 16 + xPalNow
				IF xPalNow = xNew AND yPalNow = yNew THEN
					iReturn = iNow
					EXIT FOR
				END IF
				IF yPalNow >= 2 THEN
					iNow = iNow + 1
				ELSEIF xPalNow < 16 THEN
					iNow = iNow + 1
				END IF
			NEXT xPalNow
			IF iReturn <> -1 THEN EXIT FOR
	NEXT yPalNow
	PalColor = iReturn

	PalShow
	PalShowCursor
	'PalShowCursor  'LINE (PalX * 2 + 272, PalY * 2 - 1)-(PalX * 2 + 274, PalY * 2 + 1), 28, B
	'play sound
	SELECT CASE sSound$
		CASE "0": IF (xc% <> 0) OR (yc% <> 0) THEN SOUND 20000, .2
		CASE "1": IF (xc% <> 0) OR (yc% <> 0) THEN SOUND 1000, .2
	END SELECT
	ShowBrushViewer
END SUB

SUB PalShow
	iNow = 0
	DIM GetLeft AS INTEGER
	DIM GetTop AS INTEGER
	DIM GetRight AS INTEGER
	DIM GetBottom AS INTEGER
	DIM xPalNow AS INTEGER
	DIM yPalNow AS INTEGER
	FOR yPalNow = 0 TO PalComponentsY - 1
			FOR xPalNow = 0 TO PalComponentsX - 1
			'PSET (xPalNow * 2 + 273, yPalNow * 2), yPalNow * 16 + xPalNow
			CALL PalCoordsToRect(GetLeft, GetTop, GetRight, GetBottom, xPalNow, yPalNow)
			IF yPalNow >= 2 THEN
				'LINE (xPalNow * PalComponentSpacingW + PalLeft, yPalNow * PalComponentSpacingH+PalTop)-(xPalNow * PalComponentSpacingW + PalLeft + PalComponentW, yPalNow * PalComponentSpacingH+PalTop+PalComponentH), iNow, BF
				LINE (GetLeft, GetTop)-(GetRight, GetBottom), iNow, BF
				iNow = iNow + 1
			ELSEIF xPalNow < 16 THEN
				'LINE (xPalNow * PalComponentSpacingW + PalLeft, yPalNow * PalComponentSpacingH+PalTop)-(xPalNow * PalComponentSpacingW + PalLeft + PalComponentW, yPalNow * PalComponentSpacingH+PalTop+PalComponentH), iNow, BF
				LINE (GetLeft, GetTop)-(GetRight, GetBottom), iNow, BF
				iNow = iNow + 1
			ELSE
				'LINE (xPalNow * PalComponentSpacingW + PalLeft, yPalNow * PalComponentSpacingH+PalTop)-(xPalNow * PalComponentSpacingW + PalLeft + PalComponentW, yPalNow * PalComponentSpacingH+PalTop+PalComponentH), 0, BF
				LINE (GetLeft, GetTop)-(GetRight, GetBottom), 0, BF
			END IF
			NEXT xPalNow
	NEXT yPalNow
	PalShowCursor
	PalShowNum
END SUB

SUB PalShowCursor
	CALL PalShowCursorCustom(15)
END SUB

SUB PalShowCursorCustom (iColrX%)
	DIM GetLeft AS INTEGER
	DIM GetTop AS INTEGER
	DIM GetRight AS INTEGER
	DIM GetBottom AS INTEGER
	CALL PalGetCursorRect(GetLeft, GetTop, GetRight, GetBottom)
	'LINE (PalX * 16 - 1, PalY * 12 - 1)-(PalX * 16 + 15, PalY * 12 + 11), 15, B
	LINE (GetLeft, GetTop)-(GetRight, GetBottom), iColrX, B
END SUB

SUB PalShowNum
	'LOCATE 23, 28
	'LOCATE 24, 31
	COLOR 154
	LOCATE 25, 14 'LOCATE 23, 28
	PRINT "         ";
	LOCATE 25, 14 'LOCATE 23, 28
	PRINT "Color["; PalColor; "]   "; 'PalY * 16 + PalX;

	'
	'COLOR 15
	'PRINT PalColor; ' " ("; PalX; ","; PalY; ")     ";
END SUB

SUB PalShowNumDEPRECATED
		iColrDEPRECATED = PalY * 16 + PalX
		COLOR 15
		LOCATE 23, 28
		PRINT iColrDEPRECATED
END SUB

SUB PalXYFromPalColor
	iNow = 0
	bFound = 0
	FOR yPalNow = 0 TO PalComponentsY - 1
			FOR xPalNow = 0 TO PalComponentsX - 1
				'PSET (xPalNow * 2 + 273, yPalNow * 2), yPalNow * 16 + xPalNow
				IF PalColor = iNow THEN 'xPalNow = xNew AND yPalNow = yNew THEN
					PalX = xPalNow
					PalY = yPalNow
					bFound = 1
					EXIT FOR
				END IF
				IF yPalNow >= 2 THEN
					iNow = iNow + 1
				ELSEIF xPalNow < 16 THEN
					iNow = iNow + 1
				END IF
			NEXT xPalNow
			IF bFound <> 0 THEN EXIT FOR
	NEXT yPalNow
END SUB

SUB PickColorAtPointer
	PalHideCursor
	'PalShow
	'color picker, formerly getcol
	PalColor = POINT(xPointer, yPointer)
	PalXYFromPalColor
	'PalY = INT(colrnumb% / 16)
	'PalX = colrnumb% - (INT(colrnumb% / 16) * 16)
	PalShow
	PalShowCursor
	ShowBrushViewer 'DOES PalShowNum
END SUB

FUNCTION PointerCroppedX% (xMouse%)
	DIM xNow AS INTEGER
	xNow = xMouse%
	DIM xMax AS INTEGER
	xMax = xPixels - 1
	IF xMouse% - iPointerRad < 0 THEN
		xNow = iPointerRad
	ELSEIF xMouse% + iPointerRad >= xMax THEN
		xNow = xMax - iPointerRad
	END IF
	PointerCroppedX% = xNow
END FUNCTION

FUNCTION PointerCroppedY% (yMouse%)
	DIM yNow AS INTEGER
	yNow = yMouse%
	DIM yMax AS INTEGER
	yMax = yPixels - 1
	IF yMouse% - iPointerRad < 0 THEN
		yNow = iPointerRad
	ELSEIF yMouse% + iPointerRad >= yMax THEN
		yNow = yMax - iPointerRad
	END IF
	PointerCroppedY% = yNow
END FUNCTION

FUNCTION PointerFromMouseX% (xMouse%)
	PointerFromMouseX% = INT(SafeToDouble#(xMouse%) / 2! + .5)
END FUNCTION

FUNCTION PointerFromMouseY% (yMouse%)
	PointerFromMouseY% = yMouse% 'yMouse%+2
END FUNCTION

SUB PrintLit (sText$, iLitChar%)
	CALL PrintLitCustom(sText$, iLitChar%, 123, 26)
END SUB

SUB PrintLitCustom (sText$, iLitChar%, iDark%, iLight%)
	FOR iChar% = 1 TO LEN(sText$)
	IF iChar% = iLitChar% THEN
		COLOR iLight%
	ELSE
		COLOR iDark%
	END IF
	PRINT MID$(sText$, iChar%, 1);
	NEXT iChar%
END SUB

FUNCTION SafeCharToInt% (sNow$)
	iReturn% = 0
	FOR iVal% = 0 TO 9
		IF sarrSafeDigit(iVal%) = sNow$ THEN
			iReturn% = iVal%
			EXIT FOR
		END IF
	NEXT iVal%
	SafeCharToInt% = iReturn%
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

FUNCTION SafeStringToInt% (sNow$)
	iReturn% = 0
	iMultiplier% = 1
	FOR iChar% = LEN(sNow$) TO 1 STEP -1
		iReturn% = iReturn% + iMultiplier% * SafeCharToInt%(MID$(sNow$, iChar%, 1))
		iMultiplier% = iMultiplier% * 10
	NEXT iChar%
	SafeStringToInt% = iReturn%
END FUNCTION

FUNCTION SafeToDouble# (iNow%)
	SafeToDouble# = iNow%
END FUNCTION

FUNCTION SafeToString$ (iNow%)
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
		sReturn$ = sarrSafeDigit(iValDigit%) + sReturn$
		iRemaining% = iRemaining% / 10 - .4'-.4 to avoid automatic rounding up
		'rHighDivisor = rHighDivisor / 10
		'iDivisor% = iDivisor% * 10
	LOOP
	IF bNeg = 1 THEN sReturn$ = "-" + sReturn$
	IF sReturn$ = "" THEN sReturn$ = "0" 'ok to have logic resulting in this since parser starts at right
	SafeToString$ = sReturn$
END FUNCTION

SUB SaveBA
'PUT (xMouseRaw / 2, yMouseRaw), pPointer!, XOR
UndrawPointer
COLOR 34
LOCATE 1, 7
PRINT "Save as:	"
letters% = 0
resab:
COLOR 0
LOCATE 1, 16
PRINT "                        ";
COLOR 34
LOCATE 1, 16
PRINT filenam$;
SLEEP 0
DO
		dumr$ = INKEY$
		SELECT CASE dumr$
		CASE "": GOTO resab
		CASE CHR$(8): CALL cletter(-1): filenam$ = MID$(filenam$, 1, letters%): GOTO resab
		CASE CHR$(32): GOTO resab
		CASE CHR$(9): GOTO resab
		CASE "/": GOTO resab
		CASE "\": GOTO resab
		CASE CHR$(9): GOTO resab
		CASE CHR$(27): letters% = 0: EXIT DO
		CASE CHR$(13): EXIT DO
		CASE ELSE: filenam$ = filenam$ + dumr$: CALL cletter(1): filenam$ = MID$(filenam$, 1, letters%): GOTO resab
		END SELECT
LOOP
LOCATE 1, 7
COLOR 0
PRINT "                 "
SELECT CASE letters%
		CASE 0: GOTO noSave
		CASE ELSE
END SELECT
COLOR 34
LOCATE 1, 7
PRINT "saving...	"


FOR xmap = 1 TO 2
FOR ymap = 1 TO 2

IF (xmap = 1) AND (ymap = 1) THEN
OPEN (filenam$ + ".ba1") FOR OUTPUT AS #1
		PRINT #1, "SCREEN 13"
		FOR yMouseRaw% = 1 TO 75
		FOR xMouseRaw% = 1 TO 145
			IF (xMouseRaw% = 1) THEN
			PRINT #1, "DATA "; POINT(xMouseRaw% + 9, yMouseRaw% + 35);
			ELSE
			PRINT #1, ","; POINT(xMouseRaw% + 9, yMouseRaw% + 35);
			END IF
		NEXT xMouseRaw%
		PRINT #1,
		NEXT yMouseRaw%
		PRINT #1, "CHDIR "; qt$; progdir$; qt$
		PRINT #1, "FOR y = 1 TO 75"
		PRINT #1, "                FOR x = 1 TO 145"
		PRINT #1, "         READ z"
		PRINT #1, "         PSET (x + 9, y + 35), z"
		PRINT #1, "                NEXT"
		PRINT #1, "NEXT"
		PRINT #1, "OPEN "; qt$; "bloading.dat"; qt$; " FOR OUTPUT AS #1"
		PRINT #1, "                PRINT #1, "; qt$; "1"; qt$
		PRINT #1, "CLOSE"
		PRINT #1, "CHAIN "; qt$; filenam$; ".ba2"; qt$
CLOSE #1
ELSEIF (xmap = 1) AND (ymap = 2) THEN
OPEN (filenam$ + ".ba2") FOR OUTPUT AS #1
		PRINT #1, "SCREEN 13"
		FOR yMouseRaw% = 1 TO 75
		FOR xMouseRaw% = 1 TO 145
			IF (xMouseRaw% = 1) THEN
			PRINT #1, "DATA "; POINT(xMouseRaw% + 154, yMouseRaw% + 35);
			ELSE
			PRINT #1, ","; POINT(xMouseRaw% + 154, yMouseRaw% + 35);
			END IF
		NEXT xMouseRaw%
		PRINT #1,
		NEXT yMouseRaw%
		PRINT #1, "CHDIR "; qt$; progdir$; qt$
		PRINT #1, "FOR y = 1 TO 75"
		PRINT #1, "                FOR x = 1 TO 145"
		PRINT #1, "         READ z"
		PRINT #1, "         PSET (x + 154, y + 35), z"
		PRINT #1, "                NEXT"
		PRINT #1, "NEXT"
		PRINT #1, "OPEN "; qt$; "bloading.dat"; qt$; " FOR OUTPUT AS #1"
		PRINT #1, "                PRINT #1, "; qt$; "1"; qt$
		PRINT #1, "CLOSE"
		PRINT #1, "CHAIN "; qt$; filenam$; ".ba3"; qt$
CLOSE #1
ELSEIF (xmap = 2) AND (ymap = 1) THEN
OPEN (filenam$ + ".ba3") FOR OUTPUT AS #1
		PRINT #1, "SCREEN 13"
		FOR yMouseRaw% = 1 TO 75
		FOR xMouseRaw% = 1 TO 145
			IF (xMouseRaw% = 1) THEN
			PRINT #1, "DATA "; POINT(xMouseRaw% + 9, yMouseRaw% + 110);
			ELSE
			PRINT #1, ","; POINT(xMouseRaw% + 9, yMouseRaw% + 110);
			END IF
		NEXT xMouseRaw%
		PRINT #1,
		NEXT yMouseRaw%
		PRINT #1, "CHDIR "; qt$; progdir$; qt$
		PRINT #1, "FOR y = 1 TO 75"
		PRINT #1, "                FOR x = 1 TO 145"
		PRINT #1, "         READ z"
		PRINT #1, "         PSET (x + 9, y + 110), z"
		PRINT #1, "                NEXT"
		PRINT #1, "NEXT"
		PRINT #1, "OPEN "; qt$; "bloading.dat"; qt$; " FOR OUTPUT AS #1"
		PRINT #1, "                PRINT #1, "; qt$; "1"; qt$
		PRINT #1, "CLOSE"
		PRINT #1, "CHAIN "; qt$; filenam$; ".ba4"; qt$
CLOSE #1
ELSEIF (xmap = 2) AND (ymap = 2) THEN
OPEN (filenam$ + ".ba4") FOR OUTPUT AS #1
		PRINT #1, "SCREEN 13"
		FOR yMouseRaw% = 1 TO 75
		FOR xMouseRaw% = 1 TO 145
			IF (xMouseRaw% = 1) THEN
			PRINT #1, "DATA "; POINT(xMouseRaw% + 154, yMouseRaw% + 110);
			ELSE
			PRINT #1, ","; POINT(xMouseRaw% + 154, yMouseRaw% + 110);
			END IF
		NEXT xMouseRaw%
		PRINT #1,
		NEXT yMouseRaw%
		PRINT #1, "CHDIR "; qt$; progdir$; qt$
		PRINT #1, "FOR y = 1 TO 75"
		PRINT #1, "                FOR x = 1 TO 145"
		PRINT #1, "         READ z"
		PRINT #1, "         PSET (x + 154, y +110), z"
		PRINT #1, "                NEXT"
		PRINT #1, "NEXT"
		PRINT #1, "OPEN "; qt$; "bloading.dat"; qt$; " FOR OUTPUT AS #1"
		PRINT #1, "                PRINT #1, "; qt$; "1"; qt$
		PRINT #1, "CLOSE"
		PRINT #1, "COLOR 34"
		PRINT #1, "LOCATE 1, 7"
		PRINT #1, "PRINT "; qt$; "                 "; qt$
		PRINT #1, "CHAIN "; qt$; "JAKDRAW.BAS"; qt$
CLOSE #1
END IF

NEXT ymap
NEXT xmap

LOCATE 1, 7
COLOR 0
PRINT "                 "

noSave:
ShowHelp
DrawPointer 'PUT (xMouseRaw / 2, yMouseRaw), pPointer!, XOR
END SUB

SUB ShowBrushViewer
	LINE (10, 0)-(30, 20), 0, BF
	SELECT CASE iBrushRad
			CASE 1: PSET (20, 10), PalColor'PalY * 16 + PalX
			CASE ELSE: CIRCLE (20, 10), iBrushRad - 1, PalColor: PAINT (20, 10), PalColor
	END SELECT
	COLOR 54
	LOCATE 4, 1
	CALL PrintLit("Width:", 1)
	COLOR 15
	LOCATE 4, 7
	PRINT (iBrushRad - 1) * 2;
	PalShowNum
	'COLOR 123
	'PRINT "[";
	'COLOR 26
	'PRINT "q";
	'COLOR 123
	'PRINT ",";
	'COLOR 26
	'PRINT "e";
	'COLOR 123
	'PRINT "] ";
END SUB

SUB ShowHelp
	'clear the ShowHelp tip area
	COLOR 0
	LOCATE 1, 5
	PRINT "                                        "
	LOCATE 2, 5
	PRINT "                                        "
	LOCATE 3, 5
	PRINT "                                        "
	COLOR 15
	LOCATE 1, 5
	CALL PrintLit("Save ", 1): CALL PrintLit("Load ", 1): CALL PrintLit("Clear", 1) 'PRINT "Save Load Clear"
	LOCATE 2, 5
	CALL PrintLit("Spot  ", 3): CALL PrintLit("Pick  ", 1): CALL PrintLit("AreaFill  ", 1): CALL PrintLit("MoreFill", 1)'PRINT "Spot  Pick  AreaFill  MoreFill"
	LOCATE 3, 5
	PRINT "Color:";
	CALL PrintLit(CHR$(24), 1)
	CALL PrintLit(CHR$(25), 1)
	CALL PrintLit(CHR$(27), 1)
	CALL PrintLit(CHR$(26), 1)
	PRINT " ";
	CALL PrintLit("Move:", 0)
	CALL PrintLit("r", 1)
	CALL PrintLit("f", 1)
	CALL PrintLit("d", 1)
	CALL PrintLit("g", 1)
	LOCATE 4, 14

	CALL PrintLit("Stroke:", 0)
	CALL PrintLit("u", 1)
	CALL PrintLit("j", 1)
	CALL PrintLit("h", 1)
	CALL PrintLit("k", 1)


	'
	''ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	'IF (tipnum% = 1) THEN
	''[arrows/mouse]Ämove cursor
	'LOCATE 2, 8
	'COLOR 123
	'PRINT "[";
	'COLOR 26
	'PRINT "arrows/mouse";
	'COLOR 123
	'PRINT "]Ä";
	'COLOR 54
	'PRINT "move cursor"
	''ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	'ELSEIF (tipnum% = 2) THEN
	''       Ú Home ¿
	''Del End PgDn
	''       ÀğPAINTÙ
	'LOCATE 1, 11
	'COLOR 123
	'PRINT "        Ú ";
	'COLOR 26
	'PRINT "Home ";
	'COLOR 123
	'PRINT "¿";
	'
	'LOCATE 2, 11
	'COLOR 26
	'PRINT "Del End PgDn"
	'
	'LOCATE 3, 11
	'COLOR 123
	'PRINT "        Àğ";
	'COLOR 54
	'PRINT "PAINT";
	'COLOR 123
	'PRINT "Ù"
	''ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	'ELSEIF (tipnum% = 3) THEN
	''[p]Äspot paint
	'LOCATE 2, 11
	'COLOR 123
	'PRINT "[";
	'COLOR 26
	'PRINT "p";
	'COLOR 123
	'PRINT "]Ä";
	'COLOR 54
	'PRINT "spot paint"
	''ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	'ELSEIF (tipnum% = 4) THEN
	'' wÄÄ¿
	''asdÄÁmove through palette
	'LOCATE 1, 10
	'COLOR 26
	'PRINT " w";
	'COLOR 123
	'PRINT "ÄÄ¿";
	'
	'LOCATE 2, 10
	'COLOR 26
	'PRINT "asd";
	'COLOR 123
	'PRINT "ÄÁ";
	'COLOR 54
	'PRINT "move through palette"
	''ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	'ELSEIF (tipnum% = 5) THEN
	''[f,F]Äfill, Flood-FloodFill
	'LOCATE 2, 11
	'COLOR 123
	'PRINT "[";
	'COLOR 26
	'PRINT "f";
	'COLOR 123
	'PRINT ",";
	'COLOR 26
	'PRINT "F";
	'COLOR 123
	'PRINT "]Ä";
	'COLOR 54
	'PRINT "FloodFill, Flood-FloodFill";
	''ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	'ELSEIF (tipnum% = 6) THEN
	''[F1,F2]Äsave, load
	'LOCATE 2, 11
	'COLOR 123
	'PRINT "[";
	'COLOR 26
	'PRINT "F1";
	'COLOR 123
	'PRINT ",";
	'COLOR 26
	'PRINT "F2";
	'COLOR 123
	'PRINT "]Ä";
	'COLOR 54
	'PRINT "save, load"
	''ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	'ELSEIF (tipnum% = 7) THEN
	''[spacebar]Äclear drawing area
	'LOCATE 2, 6
	'COLOR 123
	'PRINT "[";
	'COLOR 26
	'PRINT "spacebar";
	'COLOR 123
	'PRINT "]Ä";
	'COLOR 54
	'PRINT "clear drawing area"
	''ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	'ELSEIF (tipnum% = 8) THEN
	''[g]Äget color under cursor
	'LOCATE 2, 9
	'COLOR 123
	'PRINT "[";
	'COLOR 26
	'PRINT "g";
	'COLOR 123
	'PRINT "]Ä";
	'COLOR 54
	'PRINT "get color under cursor"
	''ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	'ELSEIF (tipnum% = 9) THEN
	''[tab]Äsound on/off
	'LOCATE 2, 11
	'COLOR 123
	'PRINT "[";
	'COLOR 26
	'PRINT "tab";
	'COLOR 123
	'PRINT "]Ä";
	'COLOR 54
	'PRINT "sound on/off"
	'END IF
	''ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	'
	'LOCATE 25, 1
	'COLOR 123
	'PRINT "[";
	'COLOR 26
	'PRINT "h";
	'COLOR 123
	'PRINT "]Ä";
	'COLOR 54
	'PRINT "change ShowHelp tip";
END SUB

SUB SwitchSound

OPEN "bsound.dat" FOR OUTPUT AS #1
		SELECT CASE sSound$
		CASE "0": PRINT #1, "1": sSound$ = "1"
		CASE "1": PRINT #1, "0": sSound$ = "0"
		END SELECT
CLOSE #1

END SUB

SUB UndrawPointer
	IF bUnderPointer = 1 THEN
		IF bPointerShowing = 1 THEN
			PUT (PointerCroppedX%(xPointerDrawn) - iPointerRad, PointerCroppedY%(yPointerDrawn) - iPointerRad), pUnderPointer!, PSET
			bPointerShowing = 0
		END IF
	END IF
END SUB


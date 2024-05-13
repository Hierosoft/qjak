'revision 2.3: changed to staggered layout to show the purposeful layout of the qbasic default palette

DECLARE SUB PalMoveBy (xBy%, yBy%)
DECLARE SUB PalMoveTo (xSet%, ySet%)
DECLARE SUB PalShowNum ()
DECLARE SUB PalShowCursor ()
DECLARE SUB PalHideCursor ()
DECLARE SUB PalShowCursorCustom (iColrX%)
DECLARE SUB PalShow ()
DECLARE SUB PalGetCursorRect (GetLeft%, GetTop%, GetRight%, GetBottom%)
DECLARE SUB PalCoordsToRect (GetLeft%, GetTop%, GetRight%, GetBottom%, xAt%, yAt%)
DIM SHARED PalXPrev AS INTEGER
DIM SHARED PalYPrev AS INTEGER
DIM SHARED PalX AS INTEGER
DIM SHARED PalY AS INTEGER
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


intro:
CLS
SCREEN 13
'72 to 79 is green to blue in SCREEN 13 mode
startext$(0) = "2"
startext$(1) = "5"
startext$(2) = "6"
startext$(3) = "B"
startext$(4) = "L"
startext$(5) = "O"
startext$(6) = "C"
startext$(7) = "K"
LOCATE 12, 16
SLEEP 1
FOR i = 72 TO 79
    COLOR i
    PRINT startext$(i - 72);
    SOUND i * 5, .6
NEXT i
LOCATE 13, 19
PRINT "2.3"
SLEEP 3


Start:
CLS
PalComponentsX = 24
PalComponentsY = 11 'the remaining unused slots are skipped.
PalLeft = 20
PalTop = 20
xPixels = 320
yPixels = 200
PalWidth = xPixels - 40
PalHeight = yPixels - 40
PalComponentSpacingW = PalWidth / PalComponentsX - .5
PalComponentSpacingH = PalHeight / PalComponentsY - .5
PalComponentW = PalComponentSpacingW - 1
PalComponentH = PalComponentSpacingH - 1
PalWidth = PalComponentW * PalComponentsX
PalHeight = PalComponentH * PalComponentsX
PalX = 0
PalY = 0
PalXPrev = -1
PalYPrev = -1

PalShow
'FOR ro = 0 TO 15
'       FOR col = 0 TO 15
'               LINE (col * 16, ro * 12)-(col * 16 + 14, ro * 12 + 10), (ro * 16 + col), BF
'       NEXT col
'NEXT ro
Selection:
PalShowCursor
PalShowNum
DO
  SELECT CASE INKEY$
	CASE CHR$(0) + "H": PalHideCursor: CALL PalMoveBy(0, -1): PalShowCursor: PalShowNum
	CASE CHR$(0) + "P": PalHideCursor: CALL PalMoveBy(0, 1): PalShowCursor: PalShowNum
	CASE CHR$(0) + "K": PalHideCursor: CALL PalMoveBy(-1, 0): PalShowCursor: PalShowNum
	CASE CHR$(0) + "M": PalHideCursor: CALL PalMoveBy(1, 0): PalShowCursor: PalShowNum
	CASE "": SLEEP 0
	CASE CHR$(27): EXIT DO
	CASE ELSE: GOTO Selection
  END SELECT
LOOP

ending:
endmes$(0) = "B"
endmes$(1) = "Y"
endmes$(2) = "E"
endmes$(3) = "!"
CLS
FOR i = 76 TO 79
	SOUND i * 2, .7
	COLOR i
	LOCATE 12, i - 58
	PRINT endmes$(i - 76)
	SOUND i * 5, .7
NEXT i
SLEEP 1
SYSTEM


'-----------------------------functions------------------------------------------

SUB PalCoordsToRect (GetLeft%, GetTop%, GetRight%, GetBottom%, xAt%, yAt%)
	GetLeft% = xAt% * PalComponentSpacingW + PalLeft
	GetTop% = yAt% * PalComponentSpacingH + PalTop
	GetRight% = xAt% * PalComponentSpacingW + PalLeft + PalComponentW
	GetBottom% = yAt% * PalComponentSpacingH + PalTop + PalComponentH
END SUB

SUB PalGetCursorRect (GetLeft%, GetTop%, GetRight%, GetBottom%)
	CALL PalCoordsToRect(GetLeft%, GetTop%, GetRight%, GetBottom%, PalX, PalY)
	GetLeft% = GetLeft% - 1
	GetTop% = GetTop% - 1
	GetRight% = GetRight% + 1
	GetBottom% = GetBottom% + 1
END SUB

SUB PalHideCursor
	CALL PalShowCursorCustom(0)
END SUB

SUB PalMoveBy (xBy%, yBy%)
	CALL PalMoveTo(PalX + xBy%, PalY + yBy%)
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
	PalShow
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
	LOCATE 25, 18
	COLOR 15
	PRINT PalColor; '" ("; PalX; ","; PalY; ")     ";
END SUB


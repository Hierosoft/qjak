'revision 2.2
DECLARE SUB getloc ()
DECLARE SUB mleft ()
DECLARE SUB mright ()
DECLARE SUB mup ()
DECLARE SUB mdown ()
DECLARE SUB DrawCur ()

DIM SHARED xColr
DIM SHARED yColr

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
PRINT "2.2"
SLEEP 3


Start:
CLS
FOR ro = 0 TO 15
     FOR col = 0 TO 15
          LINE (col * 16, ro * 12)-(col * 16 + 14, ro * 12 + 10), (ro * 16 + col), BF
     NEXT col
NEXT ro

Selection:
DrawCur
getloc
DO
  SELECT CASE INKEY$
     CASE CHR$(0) + "H": mup: DrawCur: getloc
     CASE CHR$(0) + "P": mdown: DrawCur: getloc
     CASE CHR$(0) + "K": mleft: DrawCur: getloc
     CASE CHR$(0) + "M": mright: DrawCur: getloc
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

SUB DrawCur
     LINE (xColr * 16 - 1, yColr * 12 - 1)-(xColr * 16 + 15, yColr * 12 + 11), 15, B
END SUB

SUB getloc
     colnum = yColr * 16 + xColr
     COLOR 15
     LOCATE 23, 28
     PRINT colnum
END SUB

SUB mdown
LINE (xColr * 16 - 1, yColr * 12 - 1)-(xColr * 16 + 15, yColr * 12 + 11), 0, B
yColr = yColr + 1
IF (yColr > 15) THEN
     yColr = 15
END IF
END SUB

SUB mleft
LINE (xColr * 16 - 1, yColr * 12 - 1)-(xColr * 16 + 15, yColr * 12 + 11), 0, B
xColr = xColr - 1
IF (xColr < 0) THEN
     xColr = 0
END IF
END SUB

SUB mright
LINE (xColr * 16 - 1, yColr * 12 - 1)-(xColr * 16 + 15, yColr * 12 + 11), 0, B
xColr = xColr + 1
IF (xColr > 15) THEN
     xColr = 15
END IF
END SUB

SUB mup
LINE (xColr * 16 - 1, yColr * 12 - 1)-(xColr * 16 + 15, yColr * 12 + 11), 0, B
yColr = yColr - 1
IF (yColr < 0) THEN
     yColr = 0
END IF
END SUB


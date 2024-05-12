DECLARE SUB win95setup ()
DECLARE SUB win31setup ()
DECLARE SUB DOSSetup ()
SCREEN 12
COLOR 3
LINE (0, 0)-(639, 32), 0, BF
LINE (0, 0)-(639, 32), 10, B
LOCATE 2, 33: COLOR 3: PRINT "S E T U P"

LOCATE 4, 1: PRINT "Press number key for your system: (press escape to cancel)"
LOCATE 5, 1: PRINT " 1. Win95, 98, or ME (2000/XP not supported)"
LOCATE 6, 1: PRINT " 2. Win3.1 or other 3.x"
LOCATE 7, 1: PRINT " 3. DOS"
DO
  OSnum$ = INKEY$
  IF OSnum$ = "1" THEN EXIT DO
  IF OSnum$ = "2" THEN EXIT DO
  IF OSnum$ = "3" THEN EXIT DO
  IF OSnum$ = CHR$(27) THEN EXIT DO
LOOP

IF OSnum$ = "1" THEN win95setup
IF OSnum$ = "2" THEN win31setup
IF OSnum$ = "3" THEN DOSSetup
IF OSnum$ = CHR$(27) THEN GOTO ending


LOCATE 20, 1: PRINT "-                                                                              -";
LOCATE 21, 1: PRINT "-                       Finished...                                            -";
LOCATE 22, 1: PRINT "-                                                                              -";
SLEEP 1
ending:
LOCATE 20, 1: PRINT "-                                                                              -";
LOCATE 21, 1: PRINT "-                                  BYE                                         -";
LOCATE 22, 1: PRINT "-                                                                              -";
SLEEP 2
SYSTEM
END

SUB DOSSetup
SHELL ("c:")
SHELL ("cd\")
SHELL ("md qjak")
SHELL ("copy Z:\TEMP\256block.bas c:\qjak")
SHELL ("copy Z:\TEMP\check.did c:\qjak")
SHELL ("copy Z:\TEMP\jakdraw.bas c:\qjak")
SHELL ("copy Z:\TEMP\jaksound.bas c:\qjak")
SHELL ("copy Z:\TEMP\qbasic.exe c:\qjak")
SHELL ("copy Z:\TEMP\qjakmenu.bas c:\qjak")
SHELL ("copy Z:\TEMP\quiet.txt c:\qjak")
SHELL ("copy Z:\TEMP\readme~1.txt c:\qjak")
SHELL ("copy Z:\TEMP\smbreak.bas c:\qjak")
SHELL ("copy Z:\TEMP\spheroid.bas c:\qjak")
SHELL ("copy Z:\TEMP\sphmenu.bas c:\qjak")
END SUB

SUB win31setup
SHELL ("c:")
SHELL ("cd\")
SHELL ("md qjak")
SHELL ("copy Z:\TEMP\256block.bas c:\qjak")
SHELL ("copy Z:\TEMP\check.did c:\qjak")
SHELL ("copy Z:\TEMP\jakdraw.bas c:\qjak")
SHELL ("copy Z:\TEMP\jaksound.bas c:\qjak")
SHELL ("copy Z:\TEMP\qbasic.exe c:\qjak")
SHELL ("copy Z:\TEMP\qjakme~1.pif c:\qjak")
SHELL ("copy Z:\TEMP\qjak.ico c:\qjak")
SHELL ("copy Z:\TEMP\qjakmenu.bas c:\qjak")
SHELL ("copy Z:\TEMP\quiet.txt c:\qjak")
SHELL ("copy Z:\TEMP\readme~1.txt c:\qjak")
SHELL ("copy Z:\TEMP\smbreak.bas c:\qjak")
SHELL ("copy Z:\TEMP\smbreak.ico c:\qjak")
SHELL ("copy Z:\TEMP\spheroid.bas c:\qjak")
SHELL ("copy Z:\TEMP\sphmenu.bas c:\qjak")
SHELL ("copy Z:\TEMP\superm~1.pif c:\qjak")
SHELL ("copy Z:\TEMP\qjak.grp c:\windows")
END SUB

SUB win95setup
SHELL ("c:")
SHELL ("cd\")
SHELL ("md qjak")
SHELL ("cd\windows\desktop")
SHELL ("md QJak")
SHELL ("cd\")
SHELL ("copy Z:\TEMP\256block.bas c:\qjak")
SHELL ("copy Z:\TEMP\check.did c:\qjak")
SHELL ("copy Z:\TEMP\jakdraw.bas c:\qjak")
SHELL ("copy Z:\TEMP\jaksound.bas c:\qjak")
SHELL ("copy Z:\TEMP\qbasic.exe c:\qjak")
SHELL ("copy Z:\TEMP\qjakme~1.pif c:\windows\desktop\qjak")
SHELL ("copy Z:\TEMP\qjak.ico c:\qjak")
SHELL ("copy Z:\TEMP\qjakmenu.bas c:\qjak")
SHELL ("copy Z:\TEMP\quiet.txt c:\qjak")
SHELL ("copy Z:\TEMP\readme~1.txt c:\qjak")
SHELL ("copy Z:\TEMP\smbreak.bas c:\qjak")
SHELL ("copy Z:\TEMP\smbreak.ico c:\qjak")
SHELL ("copy Z:\TEMP\spheroid.bas c:\qjak")
SHELL ("copy Z:\TEMP\sphmenu.bas c:\qjak")
SHELL ("copy Z:\TEMP\superm~1.pif c:\windows\desktop\qjak")
END SUB


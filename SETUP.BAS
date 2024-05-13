DECLARE SUB winxpsetup ()
DECLARE SUB win9598setup ()
DECLARE SUB win31setup ()
DECLARE SUB DOSSetup ()
SCREEN 12
COLOR 3
LINE (0, 0)-(639, 32), 0, BF
LINE (0, 0)-(639, 32), 10, B
LOCATE 2, 33: COLOR 3: PRINT "S E T U P"

LOCATE 4, 1: PRINT "Press number key for your system: (press escape to cancel)"
LOCATE 5, 1: PRINT " 1. Windows 2000/XP"
LOCATE 6, 1: PRINT " 2. Win95, 98, or ME"
LOCATE 7, 1: PRINT " 3. Win3.1 or other 3.x"
LOCATE 8, 1: PRINT " 4. DOS"
DO
  OSnum$ = INKEY$
  IF OSnum$ = "1" THEN EXIT DO
  IF OSnum$ = "2" THEN EXIT DO
  IF OSnum$ = "3" THEN EXIT DO
  IF OSnum$ = "4" THEN EXIT DO
  IF OSnum$ = CHR$(27) THEN EXIT DO
LOOP

IF OSnum$ = "1" THEN winxpsetup
IF OSnum$ = "2" THEN win9598setup
IF OSnum$ = "3" THEN win31setup
IF OSnum$ = "4" THEN DOSSetup
IF OSnum$ = CHR$(27) THEN GOTO ending


LOCATE 20, 1: PRINT "-                                                                              -";
LOCATE 21, 1: PRINT "-                       Finished...                                            -";
LOCATE 22, 1: PRINT "-                                                                              -";
SLEEP 1
ending:
LOCATE 20, 1: PRINT "-                                                                              -";
LOCATE 21, 1: PRINT "-                                 enjoy                                        -";
LOCATE 22, 1: PRINT "-                                                                              -";
SLEEP 2
SYSTEM
END

SUB DOSSetup
SHELL ("c:")
SHELL ("cd\")
SHELL ("md qjak")
SHELL ("copy a:\256block.bas c:\qjak")
SHELL ("copy a:\check.did c:\qjak")
SHELL ("copy a:\jakdraw.bas c:\qjak")
SHELL ("copy a:\jaksound.bas c:\qjak")
SHELL ("copy a:\qbasic.exe c:\qjak")
SHELL ("copy a:\qjakmenu.bas c:\qjak")
SHELL ("copy a:\quiet.jak c:\qjak")
SHELL ("copy a:\readme~1.txt c:\qjak")
SHELL ("copy a:\smbreak.bas c:\qjak")
SHELL ("copy a:\spheroid.bas c:\qjak")
SHELL ("copy a:\sphmenu.bas c:\qjak")
END SUB

SUB win31setup
SHELL ("c:")
SHELL ("cd\")
SHELL ("md qjak")
SHELL ("copy a:\256block.bas c:\qjak")
SHELL ("copy a:\check.did c:\qjak")
SHELL ("copy a:\jakdraw.bas c:\qjak")
SHELL ("copy a:\jaksound.bas c:\qjak")
SHELL ("copy a:\qbasic.exe c:\qjak")
SHELL ("copy a:\qjakme~1.pif c:\qjak")
SHELL ("copy a:\qjak.ico c:\qjak")
SHELL ("copy a:\qjakmenu.bas c:\qjak")
SHELL ("copy a:\quiet.jak c:\qjak")
SHELL ("copy a:\readme~1.txt c:\qjak")
SHELL ("copy a:\smbreak.bas c:\qjak")
SHELL ("copy a:\smbrea~1.ico c:\qjak")
SHELL ("copy a:\spheroid.bas c:\qjak")
SHELL ("copy a:\sphmenu.bas c:\qjak")
SHELL ("copy a:\superm~1.pif c:\qjak")
SHELL ("copy a:\qjak.grp c:\windows")
END SUB

SUB win9598setup
SHELL ("c:")
SHELL ("cd\")
SHELL ("md qjak")
SHELL ("cd\windows\desktop")
SHELL ("md QJak")
SHELL ("cd\")
SHELL ("copy a:\256block.bas c:\qjak")
SHELL ("copy a:\check.did c:\qjak")
SHELL ("copy a:\jakdraw.bas c:\qjak")
SHELL ("copy a:\jaksound.bas c:\qjak")
SHELL ("copy a:\qbasic.exe c:\qjak")
SHELL ("copy a:\qjakme~1.pif c:\windows\desktop\qjak")
SHELL ("copy a:\qjak.ico c:\qjak")
SHELL ("copy a:\qjakmenu.bas c:\qjak")
SHELL ("copy a:\quiet.jak c:\qjak")
SHELL ("copy a:\readme~1.txt c:\qjak")
SHELL ("copy a:\smbreak.bas c:\qjak")
SHELL ("copy a:\smbrea~1.ico c:\qjak")
SHELL ("copy a:\spheroid.bas c:\qjak")
SHELL ("copy a:\sphmenu.bas c:\qjak")
SHELL ("copy a:\superm~1.pif c:\windows\desktop\qjak")
END SUB

SUB winxpsetup
SHELL ("c:")
SHELL ("cd\")
SHELL ("md qjak")
SHELL ("cd %HomePath%")
SHELL ("desktop")
SHELL ("md QJak")
SHELL ("cd\")
SHELL ("copy a:\256block.bas c:\qjak")
SHELL ("copy a:\check.did c:\qjak")
SHELL ("copy a:\jakdraw.bas c:\qjak")
SHELL ("copy a:\jaksound.bas c:\qjak")
SHELL ("copy a:\qbasic.exe c:\qjak")
SHELL ("copy a:\qjakme~1.pif c:\windows\%HomePath%\qjak")
SHELL ("copy a:\qjak.ico c:\qjak")
SHELL ("copy a:\qjakmenu.bas c:\qjak")
SHELL ("copy a:\quiet.jak c:\qjak")
SHELL ("copy a:\readme~1.txt c:\qjak")
SHELL ("copy a:\smbreak.bas c:\qjak")
SHELL ("copy a:\smbrea~1.ico c:\qjak")
SHELL ("copy a:\spheroid.bas c:\qjak")
SHELL ("copy a:\sphmenu.bas c:\qjak")
SHELL ("copy a:\superm~1.pif c:\%HomePath%\desktop\qjak")
END SUB


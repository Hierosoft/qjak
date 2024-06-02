DECLARE SUB winxpsetup ()
DECLARE SUB win9598setup ()
DECLARE SUB win31setup ()
DECLARE SUB DOSSetup ()
Screen 12
Color 3
Line (0, 0)-(639, 32), 0, BF
Line (0, 0)-(639, 32), 10, B
Locate 2, 33: Color 3: Print "S E T U P"

Locate 4, 1: Print "Press number key for your system: (press escape to cancel)"
Locate 5, 1: Print " 1. Windows 2000/XP"
Locate 6, 1: Print " 2. Win95, 98, or ME"
Locate 7, 1: Print " 3. Win3.1 or other 3.x"
Locate 8, 1: Print " 4. DOS"
Do
    OSnum$ = InKey$
    If OSnum$ = "1" Then Exit Do
    If OSnum$ = "2" Then Exit Do
    If OSnum$ = "3" Then Exit Do
    If OSnum$ = "4" Then Exit Do
    If OSnum$ = Chr$(27) Then Exit Do
Loop

If OSnum$ = "1" Then winxpsetup
If OSnum$ = "2" Then win9598setup
If OSnum$ = "3" Then win31setup
If OSnum$ = "4" Then DOSSetup
If OSnum$ = Chr$(27) Then GoTo ending


Locate 20, 1: Print "-                                                                              -";
Locate 21, 1: Print "-                       Finished...                                            -";
Locate 22, 1: Print "-                                                                              -";
Sleep 1
ending:
Locate 20, 1: Print "-                                                                              -";
Locate 21, 1: Print "-                                 enjoy                                        -";
Locate 22, 1: Print "-                                                                              -";
Sleep 2
System
End

Sub DOSSetup
    Shell ("c:")
    Shell ("cd\")
    Shell ("md qjak")
    Shell ("copy a:\256block.bas c:\qjak")
    Shell ("copy a:\check.did c:\qjak")
    Shell ("copy a:\jakdraw.bas c:\qjak")
    Shell ("copy a:\jaksound.bas c:\qjak")
    Shell ("copy a:\qbasic.exe c:\qjak")
    Shell ("copy a:\qjakmenu.bas c:\qjak")
    Shell ("copy a:\quiet.jak c:\qjak")
    Shell ("copy a:\readme~1.txt c:\qjak")
    Shell ("copy a:\smbreak.bas c:\qjak")
    Shell ("copy a:\spheroid.bas c:\qjak")
    Shell ("copy a:\sphmenu.bas c:\qjak")
End Sub

Sub win31setup
    Shell ("c:")
    Shell ("cd\")
    Shell ("md qjak")
    Shell ("copy a:\256block.bas c:\qjak")
    Shell ("copy a:\check.did c:\qjak")
    Shell ("copy a:\jakdraw.bas c:\qjak")
    Shell ("copy a:\jaksound.bas c:\qjak")
    Shell ("copy a:\qbasic.exe c:\qjak")
    Shell ("copy a:\qjakme~1.pif c:\qjak")
    Shell ("copy a:\qjak.ico c:\qjak")
    Shell ("copy a:\qjakmenu.bas c:\qjak")
    Shell ("copy a:\quiet.jak c:\qjak")
    Shell ("copy a:\readme~1.txt c:\qjak")
    Shell ("copy a:\smbreak.bas c:\qjak")
    Shell ("copy a:\smbrea~1.ico c:\qjak")
    Shell ("copy a:\spheroid.bas c:\qjak")
    Shell ("copy a:\sphmenu.bas c:\qjak")
    Shell ("copy a:\superm~1.pif c:\qjak")
    Shell ("copy a:\qjak.grp c:\windows")
End Sub

Sub win9598setup
    Shell ("c:")
    Shell ("cd\")
    Shell ("md qjak")
    Shell ("cd\windows\desktop")
    Shell ("md QJak")
    Shell ("cd\")
    Shell ("copy a:\256block.bas c:\qjak")
    Shell ("copy a:\check.did c:\qjak")
    Shell ("copy a:\jakdraw.bas c:\qjak")
    Shell ("copy a:\jaksound.bas c:\qjak")
    Shell ("copy a:\qbasic.exe c:\qjak")
    Shell ("copy a:\qjakme~1.pif c:\windows\desktop\qjak")
    Shell ("copy a:\qjak.ico c:\qjak")
    Shell ("copy a:\qjakmenu.bas c:\qjak")
    Shell ("copy a:\quiet.jak c:\qjak")
    Shell ("copy a:\readme~1.txt c:\qjak")
    Shell ("copy a:\smbreak.bas c:\qjak")
    Shell ("copy a:\smbrea~1.ico c:\qjak")
    Shell ("copy a:\spheroid.bas c:\qjak")
    Shell ("copy a:\sphmenu.bas c:\qjak")
    Shell ("copy a:\superm~1.pif c:\windows\desktop\qjak")
End Sub

Sub winxpsetup
    Shell ("c:")
    Shell ("cd\")
    Shell ("md qjak")
    Shell ("cd %HomePath%")
    Shell ("desktop")
    Shell ("md QJak")
    Shell ("cd\")
    Shell ("copy a:\256block.bas c:\qjak")
    Shell ("copy a:\check.did c:\qjak")
    Shell ("copy a:\jakdraw.bas c:\qjak")
    Shell ("copy a:\jaksound.bas c:\qjak")
    Shell ("copy a:\qbasic.exe c:\qjak")
    Shell ("copy a:\qjakme~1.pif c:\windows\%HomePath%\qjak")
    Shell ("copy a:\qjak.ico c:\qjak")
    Shell ("copy a:\qjakmenu.bas c:\qjak")
    Shell ("copy a:\quiet.jak c:\qjak")
    Shell ("copy a:\readme~1.txt c:\qjak")
    Shell ("copy a:\smbreak.bas c:\qjak")
    Shell ("copy a:\smbrea~1.ico c:\qjak")
    Shell ("copy a:\spheroid.bas c:\qjak")
    Shell ("copy a:\sphmenu.bas c:\qjak")
    Shell ("copy a:\superm~1.pif c:\%HomePath%\desktop\qjak")
End Sub


#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Morse(timeout = 400) { ;
   tout := timeout/1000
   key := RegExReplace(A_ThisHotKey,"[\*\~\$\#\+\!\^]")
   Loop {
      t := A_TickCount
      KeyWait %key%
      Pattern .= A_TickCount-t > timeout
      KeyWait %key%,DT%tout%
      If (ErrorLevel)
         Return Pattern
   }
}

d::MsgBox % "Morse press pattern " Morse()


x::
   g := Morse()
   If (g = "0")
      Send 1
   Else If (g = "00")
      Send 2
   Else If (g = "01")
      Send 3
	Else If (g = "1")
      Send 4
   Else
      MsgBox Press pattern %g%
Return
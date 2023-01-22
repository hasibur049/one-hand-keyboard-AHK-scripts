#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,Force ; ; SendRaw, => or Send {=}{>}.

~space & e::
Send {backspace}
Send {Enter}
return

~space & h::
Send {backspace}
Send {backspace}
return

space & y::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send p
return




~e & h::
Send {backspace}
SetKeyDelay, -1
Send {Enter}
return

~d & e::
Send {+}
return

^d::
Send {+}
return



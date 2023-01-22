#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,Force ; ; SendRaw, => or Send {=}{>}.

/*
e:: ;double press hotkey
if (A_PriorHotkey = "e" && A_TimeSincePriorHotkey < 300)
{
	SetTimer, SinglePress, Off
	SendInput, A
	return
}
SetTimer, SinglePress, -300
return

SinglePress:
SendInput, a
return

*/

$z::
	KeyWait, z, T0.2
	if (ErrorLevel)
		Send Z

	else {
		KeyWait, z, D T0.1

		if (ErrorLevel)
			Send z

		else
			Send :
	}

	KeyWait, z
return

$d::
	KeyWait, d, T0.2
	if (ErrorLevel)
		Send D

	else {
		KeyWait, d, D T0.1

		if (ErrorLevel)
			Send d

		else
			Send =
	}

	KeyWait, d
return

$t::
	KeyWait, t, T0.2
	if (ErrorLevel)
		Send T

	else {
		KeyWait, t, D T0.1

		if (ErrorLevel)
			Send t

		else
			Send &
	}
	KeyWait, t
return

$h::
	KeyWait, h, T0.2
	if (ErrorLevel)
		Send H

	else {
		KeyWait, h, D T0.1

		if (ErrorLevel)
			Send h

		else
			Send *
	}
	KeyWait, h
return

$e::
	KeyWait, e, T0.2
	if (ErrorLevel)
		Send E

	else {
		KeyWait, e, D T0.1

		if (ErrorLevel)
			Send e

		else
			Send `%
	}
	KeyWait, e
return
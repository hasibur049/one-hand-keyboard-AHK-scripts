#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force

/*
; Set tooltip's text:
;toolTipText := "This tooltip should be at bottom right corner of the screen, but above the taskbar.`nThanks, swagfag!"
; Get the taskbar's height:
WinGetPos,,,, taskBarHeight, ahk_class Shell_TrayWnd
; Show the damn tooltip:
;ToolTip, % toolTipText, A_ScreenWidth, A_ScreenHeight
; Get tooltip's handler:
toolTipHandler := "ahk_id" . WinExist("ahk_class tooltips_class32")
; Get tooltip's dimensions:
WinGetPos,,, toolTipWidth, toolTipHeight, % toolTipHandler
; And, finally, move the tooltip to the desired position:
WinMove, % toolTipHandler, , % (A_ScreenWidth - toolTipWidth), % (A_ScreenHeight - toolTipHeight - taskBarHeight)
*/
CoordMode, Tooltip, Screen ;relative to the active window by default

~space & e::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send e
return

~space & d::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send d
return

$d::
last := lay, lay := 3
SoundBeep, 700 + 300 * lay

KeyWait, d
lay := A_Priorkey != "d" ? last : last = 2 ? 1 : 2
SoundBeep, 700 + 300 * lay

if (lay = 2) {
	ToolTip Standard tooltip
	ToolTipFont("s12","Serif Bold")
	ToolTipColor("Yellow","Black")

	ToolTip, Numbers, 683, 2
} else {
	ToolTip, ,
	;Sleep 1
}
Return

#If (lay = 2)
 u::send, {blind}{7}
 r::send, {blind}{8}
 s::send, {blind}{9}
 t::send, {blind}{4}
 h::send, {blind}{5}
 e::send, {blind}{6}
 w::send, {blind}{1}
 n::send, {blind}{2}
 i::send, {blind}{3}
 a::send, {blind}{0}
 #If (lay = 3)
r::Up
h::Down
t::send, {blind}{left}
e::send, {blind}{right}
#If

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

$e::
last := layer, layer := 3
KeyWait, e
layer := A_Priorkey != "e" ? last : last = 2 ? 1 : 2
SoundBeep, 700 + 300 * layer
;ToolTip, % "`n`n     layer     `n`n "
;tooltip, hello there, 100, 100
;ToolTip, Layer = %layer%, 683, 2


if (layer = 2) {
	ToolTip Standard tooltip
	ToolTipFont("s12","Serif Bold")
	ToolTipColor("Red","White")
	ToolTip, Symbols, 683, 2
} else {
	ToolTip, ,
}
;ToolTip, Layer = %layer%, A_ScreenWidth, A_ScreenHeight
Return


/*
Tooltip, this tooltip will be turned off in 3 seconds
SetTimer, myLabel, 3000 ;instead of sleep 3000
return

myLabel:
tooltip,
SetTimer, myLabel, off
return
*/

;d::Send 1
#If (layer = 2)
$t::Send {BS}
$h::Send {Enter}
$u::
	KeyWait, u, T0.3

	if (ErrorLevel)
		send, {blind}{\} ;long

	else {
		KeyWait, u, D T0.1

		if (ErrorLevel)
			send, {blind}{/} ;single

		else
			send, {blind}{`%} ;double
	}

	KeyWait, u
return

$r::
	KeyWait, r, T0.3

	if (ErrorLevel)
		Send {:} ;long

	else {
		KeyWait, r, D T0.1

		if (ErrorLevel)
			Send {;} ;single

		else
			Send {^} ;double
	}

	KeyWait, r
return

$s::
	KeyWait, s, T0.3

	if (ErrorLevel)
		Send {`"} ;long

	else {
		KeyWait, s, D T0.1

		if (ErrorLevel)
			Send {'} ;single

		else
			Send {&} ;double
	}

	KeyWait, s
return

$o::
	KeyWait, o, T0.3

	if (ErrorLevel)
		Send {_} ;long

	else {
		KeyWait, o, D T0.1

		if (ErrorLevel)
			Send {?} ;single

		;else
			;Send {} ;double
	}

	KeyWait, o
return

$a::
	KeyWait, a, T0.3

	if (ErrorLevel)
		Send {,} ;long

	else {
		KeyWait, a, D T0.1

		if (ErrorLevel)
			Send {.} ;single

		else
			Send {=} ;double
	}

	KeyWait, a
return

$i::
	KeyWait, i, T0.3

	if (ErrorLevel)
		Send {}} ;long

	else {
		KeyWait, i, D T0.1

		if (ErrorLevel)
			Send {{} ;single

		else
			Send {!} ;double
	}

	KeyWait, i
return

$n::
	KeyWait, n, T0.3

	if (ErrorLevel)
		Send {]} ;long

	else {
		KeyWait, n, D T0.1

		if (ErrorLevel)
			Send {[} ;single

		else
			Send {@} ;double 7
	}

	KeyWait, n
return

$w::
	KeyWait, w, T0.3

	if (ErrorLevel)
		Send {)} ;long

	else {
		KeyWait, w, D T0.1

		if (ErrorLevel)
			Send {(} ;single

		else
			Send {#} ;double 8
	}

	KeyWait, w
return



$g::
	KeyWait, g, T0.3

	if (ErrorLevel)
		Send {~} ;long

	else {
		KeyWait, g, D T0.1

		if (ErrorLevel)
			Send {``} ;single

		else
			Send {|} ;double
	}

	KeyWait, g
return

$c::
	KeyWait, c, T0.3

	if (ErrorLevel)
		Send {>} ;long

	else {
		KeyWait, c, D T0.1

		if (ErrorLevel)
			Send {<} ;single

		else
			Send {$} ;double
	}

	KeyWait, c
return

$d::
	KeyWait, d, T0.3

	if (ErrorLevel)
		Send {+} ;long

	else {
		KeyWait, d, D T0.1

		if (ErrorLevel)
			Send {-} ;single

		else
			Send {*} ;double
	}

	KeyWait, d
return
#If (layer = 3)
;d::Send 3
#If

/*
 /::Send |

 p::Send {!}

 f::Send @

 m::Send {#}

 l::Send $

 j::Send `%
;----------------------

 q::Send ``

 b::Send {^}

 y::Send &

 u::Send *

 r::Send {-}

; s::Send {+}

 o::Send `=
;----------------------

 k::Send ?

 c::Send [

 d::Send {{}

 t::Send {(}

 h::Send {,}

; e::Send .

 a::Send e

 z::Send :
;-------------------

 x::Send ~

 g::Send /

 v::Send <

 w::Send `_

 n::Send "

 i::Send '

 ,::Send \
#If (layer = 3)
d::Send 3
#If
*/

/*
layer = 1 ; Auto-execute section

e::
KeyWait, e, T.1
If ErrorLevel { ; Held
 last := layer, layer := 3
 SoundBeep, 1900
 ToolTip, Layer = %layer%
 KeyWait, e
 layer := last
} Else layer := 3 - layer
ToolTip, Layer = %layer%
SoundBeep, 700 + 300 * layer
Return

#If (layer = 1)
a::Send 1
#If (layer = 2)
a::Send 2
#If (layer = 3)
a::Send 3
#If
*/

; ToolTipOpt v1.004
; Changes:
;  v1.001 - Pass "Default" to restore a setting to default
;  v1.002 - ANSI compatibility
;  v1.003 - Added workarounds for ToolTip's parameter being overwritten
;           by code within the message hook.
;  v1.004 - Fixed text colour.

ToolTipFont(Options := "", Name := "", hwnd := "") {
    static hfont := 0
    if (hwnd = "")
        hfont := Options="Default" ? 0 : _TTG("Font", Options, Name), _TTHook()
    else
        DllCall("SendMessage", "ptr", hwnd, "uint", 0x30, "ptr", hfont, "ptr", 0)
}

ToolTipColor(Background := "", Text := "", hwnd := "") {
    static bc := "", tc := ""
    if (hwnd = "") {
        if (Background != "")
            bc := Background="Default" ? "" : _TTG("Color", Background)
        if (Text != "")
            tc := Text="Default" ? "" : _TTG("Color", Text)
        _TTHook()
    }
    else {
        VarSetCapacity(empty, 2, 0)
        DllCall("UxTheme.dll\SetWindowTheme", "ptr", hwnd, "ptr", 0
            , "ptr", (bc != "" && tc != "") ? &empty : 0)
        if (bc != "")
            DllCall("SendMessage", "ptr", hwnd, "uint", 1043, "ptr", bc, "ptr", 0)
        if (tc != "")
            DllCall("SendMessage", "ptr", hwnd, "uint", 1044, "ptr", tc, "ptr", 0)
    }
}

_TTHook() {
    static hook := 0
    if !hook
        hook := DllCall("SetWindowsHookExW", "int", 4
            , "ptr", RegisterCallback("_TTWndProc"), "ptr", 0
            , "uint", DllCall("GetCurrentThreadId"), "ptr")
}

_TTWndProc(nCode, _wp, _lp) {
    Critical 999
   ;lParam  := NumGet(_lp+0*A_PtrSize)
   ;wParam  := NumGet(_lp+1*A_PtrSize)
    uMsg    := NumGet(_lp+2*A_PtrSize, "uint")
    hwnd    := NumGet(_lp+3*A_PtrSize)
    if (nCode >= 0 && (uMsg = 1081 || uMsg = 1036)) {
        _hack_ = ahk_id %hwnd%
        WinGetClass wclass, %_hack_%
        if (wclass = "tooltips_class32") {
            ToolTipColor(,, hwnd)
            ToolTipFont(,, hwnd)
        }
    }
    return DllCall("CallNextHookEx", "ptr", 0, "int", nCode, "ptr", _wp, "ptr", _lp, "ptr")
}

_TTG(Cmd, Arg1, Arg2 := "") {
    static htext := 0, hgui := 0
    if !htext {
        Gui _TTG: Add, Text, +hwndhtext
        Gui _TTG: +hwndhgui +0x40000000
    }
    Gui _TTG: %Cmd%, %Arg1%, %Arg2%
    if (Cmd = "Font") {
        GuiControl _TTG: Font, %htext%
        SendMessage 0x31, 0, 0,, ahk_id %htext%
        return ErrorLevel
    }
    if (Cmd = "Color") {
        hdc := DllCall("GetDC", "ptr", htext, "ptr")
        SendMessage 0x138, hdc, htext,, ahk_id %hgui%
        clr := DllCall("GetBkColor", "ptr", hdc, "uint")
        DllCall("ReleaseDC", "ptr", htext, "ptr", hdc)
        return clr
    }
}
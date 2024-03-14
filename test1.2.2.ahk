#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;Suspend, on
#InstallKeybdHook
#SingleInstance, force
#MaxHotkeysPerInterval 200
#Persistent
;SendMode Input
;#UseHook
;SetCapsLockState, alwaysoff
;KeyHistory
SetCapsLockState, AlwaysOff
CoordMode, ToolTip


;CoordMode, Tooltip, Screen ;relative to the active window by default;
; ^Ctrl +Shift #Win !Alt

;*#c::Run Calc.exe --- Win+C, Shift+Win+C, Ctrl+Win+C, etc. will all trigger this hotkey.
;*ScrollLock::Run Notepad --- Pressing ScrollLock will trigger this hotkey even when modifier key(s) are down.


;SetTimer, WatchCaret, 100 ;https://www.autohotkey.com/docs/v2/lib/CaretGetPos.htm
;return

;WatchCaret:
	;ToolTip(SearchString, A_CaretX-50, A_CaretY-50, 1, 2000)
	;ToolTip(word, A_CaretX-50, A_CaretY-50, 1, 2000)
    ;ToolTip, X%A_CaretX% Y%A_CaretY%, A_CaretX, A_CaretY - 20
;return

global InsertMode := true
global VisualMode := false
/*
   ----------------------------------------------
   ----------------------------------------------
   -------------Basic letter typing--------------
   ----------------------------------------------
   ----------------------------------------------
*/

#If (InsertMode) ;start of index mode
;top row
*e::tapMode("e","u","y")
*r::tapMode("r","r","b")
*t::tapMode("t","s","g")
*y::tapMode("","o","")
;home row
*a::tapMode("","c","")
*s::tapMode("","d","")
*d::tapMode("d","t","f")
*f::tapMode("f","h","m")
*g::tapMode("g","e","l")
*h::tapMode("h","a","o")
*j::tapMode("","z","")
;bottom row
*z::tapMode("",",","")
*x::tapMode("","v","")
*c::tapMode("","w","")
*v::tapMode("v","n","k")
*b::tapMode("b","i","p")
*n::Send {.}

/*
   ----------------------------------------------
   ----------------------------------------------
   ----------------Numpad Keys-------------------
   ----------------------------------------------
   ----------------------------------------------
*/


; SC037 NumpadMult

SC11C::LShift ;numpadenter
SC053::LCtrl ;NumpadDot:Scancode has higher presidence

*SC051::Send, {blind}{Control Down}{Shift Down} ;Numpad3
*SC051 Up::Send, {blind}{Control Up}{Shift Up}

SC04D::Alt ;Numpad6
/*
NumpadDot::
Send {LShift down}
KeyWait, NumpadDot ; wait for LShift to be released
Send {LShift up}
return
*/

/*
   ----------------------------------------------
   ----------------------------------------------
   --------Other main layer Shortcuts------------
   ----------------------------------------------
   ----------------------------------------------
*/

$Tab::
	SetKeyDelay -1
	Send {Backspace}
	Gosub, BackspaceLabel
return

;enter
$Enter::
    Send,{space down}
Return
Enter up::
    Send,{space up}
Return


$q::
send, {Tab}
return

;$w::Send {F5}
$w::#^c ;shortcut key to toggle invert color filter
;$Tab::Backspace

$CapsLock::
send, {Enter}
SearchString := ""
ToolTip,, A_CaretX-50, A_CaretY-50, 1, 2000
return

;backspace::capslock

^f1::
Loop
{
    Sleep, 100
    MouseGetPos, , , WhichWindow, WhichControl
    ControlGetPos, x, y, w, h, %WhichControl%, ahk_id %WhichWindow%
    ToolTip, %SearchString%`nX%X%`tY%Y%`nW%W%`t%H%
}
return

$p::Send #{PrintScreen}
#If ;end of index mode

Space::
if LongPress(160) {
	Gosub, VisualLabel
} else {
	gosub, SpacebarLabel
}
return


/*
   ----------------------------------------------
   ----------------------------------------------
   --------Spacebar long press Nev layer---------
   ----------------------------------------------
   ----------------------------------------------
*/

/*
#If (gameon = True)
Tab::MsgBox "gameone is true"
#if

\::gameon := !gameon
*/

VisualLabel:
if (!VisualMode) {
	VisualMode := true
	InsertMode := false

	ToolTip, layer on,850, 2
	}
	Return

#If (VisualMode)
	$t::Send {Up}
	$f::Send {Left}
	$g::Send {Down}
	$h::Send {Right}
	;$d::Send, c

	RShift & t::Send +{Up}
	RShift & f::Send +{Left}
	RShift & g::Send +{Down}
	RShift & h::Send +{Right}

	Down & t::Send +^{Up}
	Down & f::Send +^{Left}
	Down & g::Send +^{Down}
	Down & h::Send +^{Right}

	Right & t::Send ^{Up}
	Right & f::Send ^{Left}
	Right & g::Send ^{Down}
	Right & h::Send ^{Right}

	$v::Send {WheelUp}
	$b::Send {WheelDown}

	;scrollspeed:=5

	RShift & v::Send {WheelUp 5}
	RShift & b::Send {WheelDown 5}

	$Space::
	VisualMode := false
	InsertMode := true
	ToolTip, ,
	return
#If
return

/*
   ----------------------------------------------
   ----------------------------------------------
   --------------chrome autmation----------------
   ----------------------------------------------
   ----------------------------------------------
*/


#IfWinActive, ahk_class Chrome_WidgetWin_1

RShift & r::Send +{Up}
RShift & d::Send +{Left}
RShift & f::Send +{Down}
RShift & g::Send +{Right}

$e::Send ^{PgUp}
$r::Send ^{PgDn}

$v::Send {WheelDown}
$b::Send {WheelUp}

RShift & v::Send {WheelDown 5}
RShift & b::Send {WheelDown 5}

$t::Send !d
$RShift::Send, f
; ^Ctrl +Shift #Win !Alt
#If


/*
   ----------------------------------------------
   ----------------------------------------------
   --------------Space with any key--------------
   ----------------------------------------------
   ----------------------------------------------
*/

; Not exactly mirror but as close as we can get, Capslock enter, Tab backspace. autohotkey x zm zm

;Space & NumpadEnter::send {WheelUp}

;Space & SC00E::send {WheelDown} ;Scancode for backspace

;Space & NumpadAdd::Send {Click Left}

~Space & s::tapMode("","z","")
~Space & d::tapMode("","j","")
~Space & f::tapMode("","q","")
~Space & g::tapMode("","x","")

~Space & h::Send,% LongPress(160)?7:8 ; two key hotkey, second key long/short

~Space & t::AltTabMenu ;Middle mouse button activates Alt+Tab / Program switcher
~Space & t::AltTab ;Send Alt+Tab to shift to right
~Space & r::ShiftAltTab ;Send Shift+Alt+Tab to shift to left
;~LButton::AltTabMenuDismiss ;Fire when the Left button is pressed (Don't wait for it to be released)

/*
   ----------------------------------------------
   ----------------------------------------------
   -------------Two Key one binding--------------
   ----------------------------------------------
   ----------------------------------------------
*/

/*
*q::Send,% LongPress(160)?4:"{Blind}q" ; one key Blind hotkey, key long/short
~q & f::Send, 5 ; two key hotkey
~q & g::Send, 6 ; two key hotkey
~q & Space::Send,% LongPress(160)?0:9 ; two key hotkey, second key long/short
*/



/*
   ----------------------------------------------
   -----------Symbols layer section--------------
   -----------Layer one/ Backspace------------
   ----------------------------------------------
   ----------------------------------------------
*/

;this section is mainly for symbol layer in numpad keyboard. You have to press and hold backspace to active this layer

;SC00E is a Scancode for numpad backspace

;"
;#%#

Down::
	Send, {Down}  ; one key hotkey, key short
	Downlayer := true
return

/*
if (Downlayer) {
	ToolTip, Symble, 850, 2
} else {
	ToolTip, Sle, 850, 2
}
Return
*/
;top row in the keyboard
Down & e::tapMode("e","/","\")
Down & r::tapMode("r",";",":")
Down & t::tapMode("t","'","""")
Down & y::tapMode("y","?","!")
;home row in the keyboard
Down & a::tapMode("a","``","|")
Down & s::tapMode("s","%","#")
Down & d::tapMode("d","&","@")
Down & f::tapMode("f","*","$")
Down & g::tapMode("g","=","+")
Down & h::tapMode("h","_","-")
;bottom row in the keyboard
Down & z::tapMode("z","^","~")
Down & x::tapMode("x","<",">")
Down & c::tapMode("c","(",")")
Down & v::tapMode("v","[","]")
Down & b::tapMode("b","{","}")

---------------------------------------------------------------------------------------------------
/*
*Backspace::
last := layer, layer := 3
	ToolTip, layer 3, 850, 2
KeyWait Backspace

layer := A_Priorkey != "Backspace" ? last : last = 2 ? 1 : 2

if (layer = 2) {
	ToolTip, layer 2, 850, 2
} else {
	ToolTip,,
}
Return


#If (layer = 2)
$g::
Send {WheelDown}
Return
$f::
Send {WheelUp}
Return
#If (layer = 3)
;top row in the keyboard
e::tapMode("e","/","\")
r::tapMode("r",";",":")
t::tapMode("t","'","""")
y::tapMode("y","?","!")
;home row in the keyboard
$a::tapMode("a","``","|")
$s::tapMode("s","%","#")
$d::tapMode("d","&","@")
$f::tapMode("f","*","$")
$g::tapMode("g","=","+")
$h::tapMode("h","_","-")
;bottom row in the keyboard
$z::tapMode("z","^","~")
$x::tapMode("x","<",">")
$c::tapMode("c","(",")")
$v::tapMode("v","[","]")
$b::tapMode("b","{","}")
#If
*/
/*
   ----------------------------------------------
   -----------Number layer section---------------
   -----------Layer two/ NumpadAdd---------------
   ----------------------------------------------
   ----------------------------------------------
*/

;this section is mainly for number layer.you have to press and hold NumpadAdd to active this layer
Right::
	Send, {Right}  ; one key hotkey, key short
	Rightlayer := true
return

/*
if (Rightlayer) {
	ToolTip, Symble, 850, 2
} else {
	ToolTip, Sle, 850, 2
}
Return
*/

 Right & e::Send 7
 Right & r::send 8
 Right & t::send 9
 Right & d::send 4
 Right & f::send 5
 Right & g::send 6
 Right & c::send 1
 Right & v::send 2
 Right & b::send 3
 Right & h::send 0

   ----------------------------------------------
   --------Productivity layer section------------
   ----------Layer three/ NumpadSub--------------
   ----------------------------------------------
   ----------------------------------------------
*/

/*
 NumpadSub & q::Send ^t
 NumpadSub & b::Send ^w
 NumpadSub & y::Send ^s
 NumpadSub & u::Send ^x
 NumpadSub & r::Send ^a

 NumpadSub & -::Send ^c
 #Persistent
 ToolTip, copied.
 SetTimer, RemoveToolTip, -1000
 return

 RemoveToolTip:
 ToolTip
 return

 NumpadSub & a::Send ^v
 NumpadSub & s::Send {WheelDown}
 NumpadSub & d::Send {WheelUp}
 NumpadSub & f::Send {Click Left}

 ; If delete didn't modify anything, send a real delete key
 ; upon release.
NumpadSub::
SetKeyDelay -1
Send {Enter}
return

/*
   ----------------------------------------------
   ----------------------------------------------
   -----------------Arrow Keys-------------------
   ----------------------------------------------
   ----------------------------------------------
*/


; Up
CapsLock & w::
if GetKeyState("Shift", "D")
    if GetKeyState("Alt", "D")
        Send +!{Up}
    else if GetKeyState("Ctrl", "D")
        Send +^{Up}
    else
        Send +{Up}
else if GetKeyState("Ctrl", "D")
    if (GetKeyState("Alt", "D"))
        Send ^!{Up}
    else
        Send ^{Up}
else if GetKeyState("Alt", "D")
    Send !{Up}
else
    Send {Up}
return

; Left
; Mac-style alt+left maps to home
CapsLock & a::
if GetKeyState("Shift", "D")
    if GetKeyState("Alt", "D")
        Send +{Home}
    else if GetKeyState("Ctrl", "D")
        Send +^{Left}
    else
        Send +{Left}
else if GetKeyState("Ctrl", "D")
    if (GetKeyState("Alt", "D"))
        Send ^{Home}
    else
        Send ^{Left}
else if GetKeyState("Alt", "D")
    Send {Home}
else
    Send {Left}
return

; Down
CapsLock & s::
if GetKeyState("Shift", "D")
    if GetKeyState("Alt", "D")
        SendInput +!{Down}
    else if GetKeyState("Ctrl", "D")
        Send +^{Down}
    else
        Send +{Down}
else if GetKeyState("Ctrl", "D")
    if (GetKeyState("Alt", "D"))
        SendInput ^!{Down}
    else
        Send ^{Down}
else if GetKeyState("Alt", "D")
    SendInput !{Down}
else
    Send {Down}
return

; Right
; Mac-style alt+left maps to end
CapsLock & d::
if GetKeyState("Shift", "D")
    if GetKeyState("Alt", "D")
        Send +{End}
    else if GetKeyState("Ctrl", "D")
        Send +^{Right}
    else
        Send +{Right}
else if GetKeyState("Ctrl", "D")
    if (GetKeyState("Alt", "D"))
        Send ^{End}
    else
        Send ^{Right}
else if GetKeyState("Alt", "D")
    Send {End}
else
    Send {Right}
return

/*
   ----------------------------------------------
   ----------------------------------------------
   --------------Direct numeric key--------------
   ----------------------------------------------
   ----------------------------------------------
 */

;0123 546 987
;$,::Send {.}
/*
*6::Send 3
*3::
	KeyWait, 3, T0.23

	if (ErrorLevel) {
		SetKeyDelay -1
		send 5 ;long
	}
	else {
			SetKeyDelay -1
			send 0 ;single
	}

	KeyWait, 3
return

*4::
	KeyWait, 4, T0.23

	if (ErrorLevel) {
		SetKeyDelay -1
		send 4 ;long
	}
	else {
			SetKeyDelay -1
			send 1 ;single
	}


	KeyWait, 4
return

*5::
	KeyWait, 5, T0.23

	if (ErrorLevel) {
		SetKeyDelay -1
		send 6 ;long
	}
	else {
			SetKeyDelay -1
			send 2 ;single
	}

	KeyWait, 5
return
 */

 /*
   ----------------------------------------------
   ----------------------------------------------
   --------------change volume--------------
   ----------------------------------------------
   ----------------------------------------------
 */


#If MouseIsOver("ahk_class Shell_TrayWnd")
   WheelUp::Send {Volume_Up}
   WheelDown::Send {Volume_Down}
#If

MouseIsOver(WinTitle)
{
   MouseGetPos,,, Win
   Return WinExist(WinTitle . " ahk_id " . Win)
}

 /*
   ----------------------------------------------
   ----------------------------------------------
   --------------shorthand-----------------------
   ----------------------------------------------
   ----------------------------------------------
 */

;::btw::by the way



/*
   ----------------------------------------------
   ----------------------------------------------
   -------------Other additional code------------
   ----------------------------------------------
   ----------------------------------------------
 */

tapMode(ByRef physicalKey,ByRef shortTap, ByRef longTap)
{
	global SearchString

	if (physicalKey == "" && longTap == ""){
		Send, {blind}{%shortTap%}
		SearchString := SearchString shortTap  ; implicit concat
		;return
		searchChord(SearchString)
	}
	else {
		KeyWait, %physicalKey%, T0.16

			if (ErrorLevel) {
				SetKeyDelay -1
				Send, {blind}{%longTap%}
				SearchString := SearchString . longTap  ; Explicit concat
				searchChord(SearchString)
			}
			else {
				SetKeyDelay -1
				Send, {blind}{%shortTap%}
				SearchString := SearchString . shortTap  ; Explicit concat
				searchChord(SearchString)
			}

		KeyWait, %physicalKey%
		return
	}
}


searchChord(ByRef SearchString)
{
	global word
	global match
	;global parts

	word := False
	parts := False

	;https://www.autohotkey.com/boards/viewtopic.php?t=29213
	;https://www.autohotkey.com/boards/viewtopic.php?t=17811
	Loop, Read, E:\mison.txt
		{

			parts:=strsplit(A_LoopReadLine, A_Space,,2) ;https://www.autohotkey.com/boards/viewtopic.php?t=90924

			If RegExMatch(parts.1,  "^" SearchString "$") ;https://www.autohotkey.com/boards/viewtopic.php?t=2399
				{
					match := parts.1
					word := parts.2
					;break
					;Continue ;second concerned line
				}
		}

	if(word)
		ToolTip, %match%:%word%, A_CaretX-50, A_CaretY-50, 1, 2000
	else{
		l := StrLen(SearchString)
		StringLeft, OutputVar, SearchString, 10  ; Stores the string "This" in OutputVar.
		if (l > 10){
		ToolTip, %OutputVar% %l%:?, A_CaretX-50, A_CaretY-50, 1, 2000
		}else{
		ToolTip, %SearchString%:?, A_CaretX-50, A_CaretY-50, 1, 2000
		}
	}
}


SpacebarLabel:
	SetKeyDelay -1
	Send {space}
	SetKeyDelay -1
	if(word)
	{
		KeyWait, Space, U
		l := StrLen(match)+1
		SetKeyDelay, -1
		Send, {Backspace %l%}%word%{space}
		SetKeyDelay, -1
		word := ""
	}
	SearchString := ""
	ToolTip,, A_CaretX-50, A_CaretY-50, 1, 2000
return


LongPress(Timeout) {
    RegExMatch(Hotkey:=A_ThisHotkey, "\W$|\w*$", Key)
	KeyWait %Key%
	IF (Key Hotkey) <> (A_PriorKey A_ThisHotkey)
	   Exit
    Return A_TimeSinceThisHotkey > Timeout
}

BackspaceLabel:
	SetKeyDelay -1
	len := StrLen(SearchString)

	if(len > 10)
	{
		l := (len - 1)
		SearchString := SubStr( SearchString, 1, (len - 1))
		StringLeft, OutputVar, SearchString, 10

		ToolTip,%OutputVar% %l%:?, A_CaretX-50, A_CaretY-50, 1, 2000
		word := ""
	}
	else
	{
		SearchString := SubStr( SearchString, 1, (len - 1))

		if(!SearchString)
			ToolTip,, A_CaretX-50, A_CaretY-50, 1, 2000
		else
			ToolTip,%SearchString%:?, A_CaretX-50, A_CaretY-50, 1, 2000

		word := ""
	}
return
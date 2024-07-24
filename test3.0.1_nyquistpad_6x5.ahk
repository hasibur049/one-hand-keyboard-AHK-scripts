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

/*
#If (gameon = True)
Tab::MsgBox "gameone is true"
#if

\::gameon := !gameon
*/

global InsertMode := true
global index_layer := false ; Variable to track the state of the index layer
global toggle := false
global VisualMode := false
global SymbolMode := false
global NumberMode := false
global NumpadSymbolMode := false ; Variable to track the state of the numpad symbol layer
global NumpadNumberMode := false

; tooltip 1 index layer
; tooltip 2 visual layer
; tooltip 3 display chord dict
; tooltip 4 number layer
; tooltip 5 symbol layer
; tooltip 6 numpad symbol layer
; tooltip 7 numpad number layer

/*
   ----------------------------------------------
   ----------------------------------------------
   -------------Basic letter typing--------------
   ----------------------------------------------
   ----------------------------------------------
*/

; Start of index mode
#If (InsertMode)

; Detect if d is pressed and released without combination
*$d::
    KeyWait, d, T0.1  ; Wait to see if the d key is held down for 300ms/100ms
    if ErrorLevel
        return  ; If d is held down, do nothing
    KeyWait, d  ; Wait for the d key to be released
    return

$d Up::
    ; Check if d is pressed alone
    if (A_PriorKey != "d")
        return  ; If the prior key wasn't d alone, do nothing

    ; Toggle the index_layer state
    index_layer := !index_layer
    if (index_layer) {
        toggle := true
        ToolTip, Index, 850, 2, 1
    } else {
        toggle := false
        ToolTip,,,, 1
    }
return

; Hotkeys for d & t and d & f combinations
~d & s::Send {Left}
~d & g::Send {Up}
~d & f::Send {Right}
~d & v::Send {Down}
~d & t::AltTab ;Send Alt+Tab to shift to right

	#If (index_layer) ;;start layer 2 of index_layer
	;fn row
	;*Esc::
	*1::SendInput, % (GetKeyState("Shift", "P") ? "Q" : indexMode("q"))
	*2::SendInput, % (GetKeyState("Shift", "P") ? "Z" : indexMode("z"))
	*3::SendInput, % (GetKeyState("Shift", "P") ? "X" : indexMode("x"))
	*4::SendInput, % (GetKeyState("Shift", "P") ? "J" : indexMode("j"))
	*5::

	;top row
	*q::SendInput, % (GetKeyState("Shift", "P") ? "Z" : indexMode("z"))
	*w::SendInput, % (GetKeyState("Shift", "P") ? "B" : indexMode("b"))
	*e::
        send, {Enter}
        SearchString := ""
        ToolTip,, A_CaretX-50, A_CaretY-50, 3, 2000
    return
	*r::SendInput, % (GetKeyState("Shift", "P") ? "G" : indexMode("g"))
	*t::SendInput, % (GetKeyState("Shift", "P") ? "J" : indexMode("j"))


	; Home row hotkeys inside index_layer
    *a::SendInput, % (GetKeyState("Shift", "P") ? "U" : indexMode("u"))
    *s::SendInput, % (GetKeyState("Shift", "P") ? "O" : indexMode("o"))
    *f::SendInput, % (GetKeyState("Shift", "P") ? "R" : indexMode("r"))
    *g::SendInput, % (GetKeyState("Shift", "P") ? "C" : indexMode("c"))

	;bottom row
	;*LShift::Tab
	*z::SendInput, % (GetKeyState("Shift", "P") ? "M" : indexMode("m"))
	*x::SendInput, % (GetKeyState("Shift", "P") ? "Y" : indexMode("y"))
	*c::SendInput, % (GetKeyState("Shift", "P") ? "V" : indexMode("v"))
	*v::SendInput, % (GetKeyState("Shift", "P") ? "F" : indexMode("f"))
	*b::SendInput, % (GetKeyState("Shift", "P") ? "P" : indexMode("p"))
	#If ;end layer 2 of index_layer
	return

;fn row
;01e23 546 987
;30e12

*1::Send, 3
*2::
    KeyWait, 2, T0.16
    send % (ErrorLevel ? 5 : 0)
    KeyWait, 2
return

*3::
    KeyWait, 3, T0.20
	if (ErrorLevel) {
		Send, 4
    } else {
		send, {Enter}
        SearchString := ""
        ToolTip,, A_CaretX-50, A_CaretY-50, 3, 2000
	}
    KeyWait, 3
return

*4::
    KeyWait, 4, T0.16
    send % (ErrorLevel ? 6 : 1)
    KeyWait, 4
return
*5::Send 2

;top row
*q::indexMode("q")
*w::indexMode("h")
*e::indexMode("t")
*r::indexMode("i")
*t::indexMode("p")

;home row
*a::indexMode("s")
*s::indexMode("e")
;d
*f::indexMode("a")
*g::indexMode("w")

;bottom row
*z::indexMode("n")
*x::
	SetKeyDelay -1
	Send {Backspace}
	Gosub, BackspaceLabel
return
*c::indexMode("l")
*v::indexMode("d")
*b::indexMode("k")

/*
;enter
$Enter::
    Send,{space down}
Return
Enter up::
    Send,{space up}
Return
*/

;$q::send {Tab}
;$w::Send {F5}
;$w::#^c ;shortcut key to toggle invert color filter
;$Tab::Backspace

;backspace::capslock

/*
^f1::
Loop
{
    Sleep, 100
    MouseGetPos, , , WhichWindow, WhichControl
    ControlGetPos, x, y, w, h, %WhichControl%, ahk_id %WhichWindow%
    ToolTip, %SearchString%`nX%X%`tY%Y%`nW%W%`t%H%
}
return
*/


$p::Send #{PrintScreen}
#If
;end of index mode  ;end of index mode  ;end of index mode  ;end of index mode
return

/*
   ----------------------------------------------
   ----------------------------------------------
   ------------Other modifier key----------------
   ----------------------------------------------
   ----------------------------------------------
*/
Tab::
	gosub, NumberLebel
return

CapsLock::
	gosub, SymbolLebel
return

;LShift::

Space::
if LongPress(200) {
	Gosub, VisualLabel
} else {
	gosub, SpacebarLabel
}
return

/*
   ----------------------------------------------
   ----------------------------------------------
   --------------Space with any key--------------
   ----------------------------------------------
   ----------------------------------------------
*/

;Two Key one binding
/*
*q::Send,% LongPress(160)?4:"{Blind}q" ; one key Blind hotkey, key long/short
~q & w::Send, 5 ; two key hotkey
~q & e::Send, 6 ; two key hotkey
~q & Space::Send,% LongPress(160)?0:9 ; two key hotkey, second key long/short
*/

;Space & NumpadEnter::send {WheelUp}
;Space & SC00E::send {WheelDown} ;Scancode for backspace
;Space & NumpadAdd::Send {Click Left}

;~Space & d::AltTabMenu ;Middle mouse button activates Alt+Tab / Program switcher
;~Space & d::AltTab ;Send Alt+Tab to shift to right
;~Space & f::ShiftAltTab ;Send Shift+Alt+Tab to shift to left
;~LButton::AltTabMenuDismiss ;Fire when the Left button is pressed (Don't wait for it to be released)

;fn row
~Space & 2::Send 9
~Space & 3::Send 8
~Space & 4::Send 7
;top row
~Space & w::tapMode("w","/","\") ; two key hotkey short/long
~Space & e::tapMode("e","-","_") ; two key hotkey short/long
~Space & r::tapMode("r","=","+") ; two key hotkey short/long
~Space & t::tapMode("t","&","$") ; two key hotkey short/long
;home row
~Space & a::tapMode("a","!","%") ; two key hotkey short/long
~Space & s::tapMode("s","`'","""") ; two key hotkey short/long

~Space & d::
	InsertMode := false
	index_layer := false

	tapMode("d",";",":") ; two key hotkey short/long

	if (toggle) {
		index_layer := true

		ToolTip, Index, 850, 2, 1
		InsertMode := true

	}
	else
	{
		InsertMode := true
	}
	return

return

~Space & f::tapMode("f",".",",") ; two key hotkey short/long
~Space & g::tapMode("g","*","?") ; two key hotkey short/long
;bottom row
~Space & z::tapMode("z","<",">") ; two key hotkey short/long
~Space & x::tapMode("x","[","]") ; two key hotkey short/long
~Space & c::tapMode("c","(",")") ; two key hotkey
~Space & v::tapMode("v","{","}") ; two key hotkey
~Space & b::tapMode("b","`#","@") ; two key hotkey short/long
/*
   --------------------------------------------------
   --------------------------------------------------
   ------long press Space to active visual layer-----
   --------------------------------------------------
   --------------------------------------------------
*/

VisualLabel:
if (!VisualMode) {
	VisualMode := true
	SymbolMode := false
	NumberMode := false
	InsertMode := false
    index_layer := false

	ToolTip,,,,4
	ToolTip,,,,5
	ToolTip,,,,6
	ToolTip, Visual, 720, 2, 2
	}
	Return

#If (VisualMode)

;h - move cursor left
;j - move cursor down
;k - move cursor up
;l - move cursor right

	$s::Send {Left}
	$d::Send {Down}
	$f::Send {Up}
	$g::Send {Right}

	RShift & s::Send +{Left}
	RShift & d::Send +{Down}
	RShift & f::Send +{Up}
	RShift & g::Send +{Right}

	Down & s::Send +^{Left}
	Down & d::Send +^{Down}
	Down & f::Send +^{Up}
	Down & g::Send +^{Right}

	Right & s::Send ^{Left}
	Right & d::Send ^{Down}
	Right & f::Send ^{Up}
	Right & g::Send ^{Right}

	$c::Send {WheelUp}
	$v::Send {WheelDown}

	RShift & c::Send {WheelUp 5} ;scrollspeed:=5
	RShift & v::Send {WheelDown 5} ;scrollspeed:=5

	$Space::
	VisualMode := false
	SymbolMode := false
	NumberMode := false
	InsertMode := true

	if (toggle) {
		index_layer := true

		ToolTip,,,,2
		ToolTip,,,,4
		ToolTip,,,,5
		ToolTip, Index, 850, 2, 1
	}
	else
	{
		ToolTip,,,,2
		ToolTip,,,,4
		ToolTip,,,,5
	}
	return
#If
return

/*
   ----------------------------------------------
   ----------------------------------------------
   ---------------Tab Number layer---------------
   ----------------------------------------------
   ----------------------------------------------
*/

NumberLebel:
if (!NumberMode) {
	NumberMode := true
	SymbolMode := false
	VisualMode := false
	InsertMode := false
	index_layer := false

	ToolTip,,,,2
	ToolTip,,,,5
	ToolTip, Numpad, 980, 2, 4
	}
Return

#If (NumberMode)
	$w::Send 7
	$e::send 8
	$r::send 9
	$s::send 4
	$d::send 5
	$f::send 6
 	$x::send 1
 	$c::send 2
	$v::send 3
	$g::send 0

	$Tab::
	SymbolMode := false
	NumberMode := false
	VisualMode := false
	InsertMode := true

	if (toggle) {
		index_layer := true

		ToolTip,,,,4
		ToolTip,,,,5
		ToolTip, Index, 850, 2, 1
	}
	else
	{
		ToolTip,,,,4
		ToolTip,,,,5
	}
	return
#If
return

/*
   ----------------------------------------------
   ----------------------------------------------
   -----------Capslock symbol layer--------------
   ----------------------------------------------
   ----------------------------------------------
*/

SymbolLebel:
if (!SymbolMode) {
	SymbolMode := true
	NumberMode := false
	VisualMode := false
	InsertMode := false
	index_layer := false

	ToolTip,,,,2
	ToolTip,,,,4
	ToolTip, Symbol, 980, 2, 5
	}
Return

#If (SymbolMode)
	;fn row in the keyboard
	$2::tapMode("","~","")
	$3::tapMode("","|","")
	$4::tapMode("","^","")

	;top row in the keyboard
	$q::tapMode("","``","")
	$w::tapMode("w","/","\")
	$e::tapMode("e","-","_")
	$r::tapMode("r","=","+")
	$t::tapMode("t","&","$")

	;home row in the keyboard
	$a::tapMode("a","!","%")
	$s::tapMode("s","'","""")
	$d::tapMode("d",";",":")
	$f::tapMode("f",".",",")
	$g::tapMode("g","*","?")

	;bottom row in the keyboard
	$z::tapMode("z","<",">")
	$x::tapMode("x","[","]")
	$c::tapMode("c","(",")")
	$v::tapMode("v","{","}")
	$b::tapMode("b","#","@")

	$CapsLock::
	SymbolMode := false
	NumberMode := false
	VisualMode := false
	InsertMode := true

	if (toggle) {
		index_layer := true

		ToolTip,,,,2
		ToolTip,,,,4
		ToolTip,,,,5
		ToolTip, Index, 850, 2, 1
	}
	else
	{
		ToolTip,,,,2
		ToolTip,,,,4
		ToolTip,,,,5
	}
	return
#If
return


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

;SC04D::Alt ;Numpad6
/*
NumpadDot::
Send {LShift down}
KeyWait, NumpadDot ; wait for LShift to be released
Send {LShift up}
return
*/

/*
   ----------------------------------------------
   -----------Symbols layer section--------------
   -----------Layer one/ Backspace------------
   ----------------------------------------------
   ----------------------------------------------
*/

; Hotkey to activate the numpad symbol layer
Down::
	; Activate the numpad symbol layer
	NumpadSymbolMode := true
	VisualMode := false
	SymbolMode := false
	NumberMode := false
	InsertMode := false
	index_layer := false

	; Show the symbol layer tooltip
	ToolTip,Numpad Symbol, 980, 2, 6

	; Hide any other tooltips
	ToolTip,,,,2
	ToolTip,,,,4
	ToolTip,,,,5
return

Down Up::
	if (A_PriorKey = "Down") {
		Send, {Down}
	}
    ; Deactivate the numpad symbol layer
    NumpadSymbolMode := false

    ; Reset other modes and show the appropriate tooltip
    SymbolMode := false
    NumberMode := false
    VisualMode := false
    InsertMode := true

    if (toggle) {
        index_layer := true

        ; Hide any other tooltips
        ToolTip,,,,2
        ToolTip,,,,4
        ToolTip,,,,5
        ToolTip,,,,6

        ; Show the index layer tooltip
        ToolTip, Index, 850, 2, 1
    } else {
        ; Hide any other tooltips
        ToolTip,,,,2
        ToolTip,,,,4
        ToolTip,,,,5
        ToolTip,,,,6
    }
return

; Define behavior within the symbol layer
#If (NumpadSymbolMode)
	;fn row in the keyboard
	$2::tapMode("","~","")
	$3::tapMode("","|","")
	$4::tapMode("","^","")

	;top row in the keyboard
	$q::tapMode("","``","")
	$w::tapMode("w","/","\")
	$e::tapMode("e","-","_")
	$r::tapMode("r","=","+")
	$t::tapMode("t","&","$")

	;home row in the keyboard
	$a::tapMode("a","!","%")
	$s::tapMode("s","'","""")
	$d::tapMode("d",";",":")
	$f::tapMode("f",".",",")
	$g::tapMode("g","*","?")

	;bottom row in the keyboard
	$z::tapMode("z","<",">")
	$x::tapMode("x","[","]")
	$c::tapMode("c","(",")")
	$v::tapMode("v","{","}")
	$b::tapMode("b","#","@")
#If
return

; ---------------------------------------------------------------------------------------------------
/*
; ------- works ----------
*Down::
last := layer, layer := 3
	InsertMode := false
	ToolTip,Layer3 Active , 1400, 2, 6
KeyWait Down

;layer := A_Priorkey != "Down" ? last : last = 2 ? 1 : 2


if (A_PriorKey != "Down") {
    layer := last
} else {
    if (last = 2) {
        layer := 1
    } else {
        layer := 2
    }
}


if (layer = 2) {
	ToolTip,Layer2 Active , 1400, 2, 6
} else {
	InsertMode := true
	ToolTip,%layer%, 1400, 2, 6
	;ToolTip,,,,6
}
return

#If (layer = 2)
$s::send 0
$d::send 0
$g::Send {WheelDown}
$f::Send {WheelUp}

#If (layer = 3)
$s::send 1
$d::Send, {blind}{1}
$f::send 1
#If
return
*/

/*
   ----------------------------------------------
   -----------Number layer section---------------
   -----------Layer two/ NumpadAdd---------------
   ----------------------------------------------
   ----------------------------------------------
*/

; Hotkey to activate the numpad number layer
Right::
	; Activate the numpad number layer
	NumpadNumberMode := true
	VisualMode := false
	SymbolMode := false
	NumberMode := false
	InsertMode := false
	index_layer := false

	; Show the number layer tooltip
	ToolTip,Numpad Number, 980, 2, 7

	; Hide any other tooltips
	ToolTip,,,,2
	ToolTip,,,,4
	ToolTip,,,,5
return

Right Up::
	if (A_PriorKey = "Right") {
		Send, {Right}
	}
    ; Deactivate the numpad number layer
    NumpadNumberMode := false

    ; Reset other modes and show the appropriate tooltip
    SymbolMode := false
    NumberMode := false
    VisualMode := false
    InsertMode := true

    if (toggle) {
        index_layer := true

        ; Hide any other tooltips
        ToolTip,,,,2
        ToolTip,,,,4
        ToolTip,,,,5
        ToolTip,,,,7

        ; Show the index layer tooltip
        ToolTip, Index, 850, 2, 1
    } else {
        ; Hide any other tooltips
        ToolTip,,,,2
        ToolTip,,,,4
        ToolTip,,,,5
        ToolTip,,,,7
    }
return

; Define behavior within the number layer
#If (NumpadNumberMode)
$w::Send 7
$e::send 8
$r::send 9
$s::send 4
$d::Send, {blind}{5}
$f::send 6
$x::send 1
$c::send 2
$v::send 3
$g::send 0
#If
return

/*
   ----------------------------------------------
   --------Productivity layer section------------
   ----------Layer three/ NumpadSub--------------
   ----------------------------------------------
   ----------------------------------------------;
*/


/*
   ----------------------------------------------
   ----------------------------------------------
   --------------chrome autmation----------------
   ----------------------------------------------
   ----------------------------------------------
*/

#IfWinActive, ahk_class Chrome_WidgetWin_1
/*
RShift & e::Send +{Up}
RShift & s::Send +{Left}
RShift & d::Send +{Down}
RShift & f::Send +{Right}

$w::Send ^{PgUp}
$e::Send ^{PgDn}

$c::Send {WheelDown}
$v::Send {WheelUp}

RShift & c::Send {WheelDown 5}
RShift & v::Send {WheelDown 5}

$t::Send !d ;whats that brother?
$RShift::Send, f ;whats that brother?
; ^Ctrl +Shift #Win !Alt
*/
#If

 /*
   ----------------------------------------------
   ----------------------------------------------
   ----------------change volume-----------------
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

global SearchString

tapMode(ByRef physicalKey,ByRef shortTap, ByRef longTap)
{
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


indexMode(ByRef letters)
{
	Send, {blind}{%letters%}
	SearchString := SearchString letters  ; implicit ataeae
	searchChord(SearchString)

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
    ;C:\Users\shant\Desktop\onehand-keyboard-AHK-scripts\chording_dictionary\mison.txt

	Loop, Read, C:\Users\Dell\Downloads\mison.txt
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
		ToolTip, %match%:%word%, A_CaretX-50, A_CaretY-50, 3, 2000
	else{
		l := StrLen(SearchString)
		StringLeft, OutputVar, SearchString, 10  ; Stores the string "This" in OutputVar.
		if (l > 10){
		;ToolTip, %OutputVar% %l%:?, A_CaretX-50, A_CaretY-50, 1, 2000
		}else{
		;ToolTip, %SearchString%:?, A_CaretX-50, A_CaretY-50, 1, 2000
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

		ToolTip, , A_CaretX-50, A_CaretY-50, 3, 2000 ;tooltip will reset only when the chord match, after the send operation
	}
	SearchString := ""
    ToolTip,, A_CaretX-50, A_CaretY-50, 3, 2000 ;tooltip string will be reset
return

BackspaceLabel:
	SetKeyDelay -1
	len := StrLen(SearchString)

	if(len > 10)
	{
		l := (len - 1)
		SearchString := SubStr( SearchString, 1, (len - 1))
		StringLeft, OutputVar, SearchString, 10

		ToolTip,%OutputVar% %l%:?, A_CaretX-50, A_CaretY-50, 3, 2000
		word := ""
	}
	else
	{
		SearchString := SubStr( SearchString, 1, (len - 1))

		if(!SearchString)
			ToolTip,, A_CaretX-50, A_CaretY-50, 3, 2000
		else
			ToolTip,%SearchString%:?, A_CaretX-50, A_CaretY-50, 3, 2000

		word := ""
	}
return

LongPress(Timeout) {
    RegExMatch(Hotkey:=A_ThisHotkey, "\W$|\w*$", Key)
	KeyWait %Key%
	IF (Key Hotkey) <> (A_PriorKey A_ThisHotkey)
	   Exit
    Return A_TimeSinceThisHotkey > Timeout
}

; end of the script
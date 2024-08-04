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
; Get the mouse cursor's current position
;MouseGetPos, x, y

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

global INSERT_MODE := true
global INSERT_MODE_II := false ; Variable to track the state of the index layer
global TOGGLE := false
global VISUAL_SPACE_MODE := false
global VISUAL_ALT_MODE := false
global SYMBOL_MODE := false
global NUMBER_MODE := false
global NUMPAD_SYMBOL_MODE := false ; Variable to track the state of the numpad symbol layer
global NUMPAD_NUMBER_MODE := false
global IS_RBUTTON_DOWN := false ; Initialize flags to track the state of RButton down

index_TooltipX := 960 ; tooltip 1 index layer
visual_TooltipX := index_TooltipX - 117 ; tooltip 2 visual layer
; A_CaretX-50, A_CaretY-50 ; tooltip 3 for display chord dict
number_TooltipX := index_TooltipX + 100 ; tooltip 4 number layer
symbol_TooltipX := index_TooltipX + 100 ; tooltip 5 symbol layer
numpad_symbol_TooltipX := index_TooltipX + 100 ; tooltip 6 numpad symbol layer
numpad_number_TooltipX := index_TooltipX + 100 ; tooltip 7 numpad number layer
; MouseGetPos, x, y tooltip 8 for copied message
/*
   ----------------------------------------------
   ----------------------------------------------
   -------------Basic letter typing--------------
   ----------------------------------------------
   ----------------------------------------------
*/

#If INSERT_MODE ; Start of INSERT_MODE

; Detect if d is pressed and released without combination
*d::
    KeyWait, d, T0.1  ; Wait to see if the d key is held down for 300ms/100ms
    if ErrorLevel
        return  ; If d is held down, do nothing
    KeyWait, d  ; Wait for the d key to be released
    return

$d Up::
    ; Check if d is pressed alone
    if (A_PriorKey != "d")
        return  ; If the prior key wasn't d alone, do nothing

    ; TOGGLE the INSERT_MODE_II state
    INSERT_MODE_II := !INSERT_MODE_II
    if INSERT_MODE_II {
        TOGGLE := true
        ToolTip, Index, % index_TooltipX, 0, 1
    } else {
        TOGGLE := false
        ToolTip,,,, 1
    }
return

; Hotkeys for d & other N key combinations
~d & s::Send {Left}
~d & g::Send {Up}
~d & f::Send {Right}
~d & v::Send {Down}
~d & t::AltTab ;Send Alt+Tab to shift to right

	#If INSERT_MODE_II ;;start of INSERT_MODE_II
	;fn row
	;*Esc::
	*1::capslock
	*2::send {Tab}
	*3::SendInput, % (GetKeyState("Shift", "P") ? "X" : indexMode("x"))
	*4::SendInput, % (GetKeyState("Shift", "P") ? "J" : indexMode("j"))
	*5::send {Tab}

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

	;home row
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

	~Space & s::Send, {Left}
	~Space & d::Send, {Up}
	~Space & d Up::
		INSERT_MODE_II := true
		TOGGLE := true

        ToolTip, Index, % index_TooltipX, 0, 1
	return
	~Space & f::Send, {Down}
	~Space & g::Send, {Right}

	#If ;end of INSERT_MODE_II
	return

;fn row
;3 0e1 2, 546, 987

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
*f::indexMode("a")
*g::indexMode("w")

;bottom row
*z::indexMode("n")
*x::indexMode("l")
*c::
	SetKeyDelay -1
	Send {Backspace}
	Gosub, BackspaceLabel
return
*v::indexMode("d")
*b::indexMode("k")

#If ;end of INSERT_MODE
return

/*
   ----------------------------------------------
   ----------------------------------------------
   ------------Other modifier key----------------
   ----------------------------------------------
   ----------------------------------------------
*/
LShift & d::
LCtrl & d::
    ; TOGGLE the INSERT_MODE_II state
    INSERT_MODE_II := !INSERT_MODE_II
    if INSERT_MODE_II {
        TOGGLE := true
        ToolTip, Index, % index_TooltipX, 0, 1
    } else {
        TOGGLE := false
        ToolTip,,,, 1
	}
return

LWin::Alt
LCtrl & Alt::Reload	; Hotkey to reload the script
LCtrl & Space::Suspend ; Hotkey to suspend the script

Alt::
	gosub, VisualLabelAlt
return

Tab::
	gosub, NumberLebel
return

CapsLock::
	gosub, SymbolLebel
return

Space::
if LongPress(200) {
	Gosub, VisualLabelSpace
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

;fn row
~Space & 1::return
~Space & 2::Send 9
~Space & 3::Send 8
~Space & 4::Send 7
~Space & 5::return
;top row
~Space & w::tapMode("w","/","\") ; two key hotkey short/long
~Space & e::tapMode("e","-","_") ; two key hotkey short/long
~Space & r::tapMode("r","=","+") ; two key hotkey short/long
~Space & t::tapMode("t","&","$") ; two key hotkey short/long
;home row
~Space & a::tapMode("a","!","%") ; two key hotkey short/long
~Space & s::tapMode("s","`'","""") ; two key hotkey short/long


~Space & d::
	INSERT_MODE := false
	INSERT_MODE_II := false

	tapMode("d",";",":") ; two key hotkey short/long

	if TOGGLE {
		INSERT_MODE_II := true

		ToolTip, Index, % index_TooltipX, 0, 1
		INSERT_MODE := true

	} else {
		INSERT_MODE := true
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
   ----long press Space to active visual layer 1-----
   --------------------------------------------------
   --------------------------------------------------
*/

VisualLabelSpace:
if !VISUAL_SPACE_MODE {
	VISUAL_SPACE_MODE := true
	SYMBOL_MODE := false
	NUMBER_MODE := false
	INSERT_MODE := false
    INSERT_MODE_II := false

	ToolTip,,,,4
	ToolTip,,,,5
	ToolTip,,,,6
	ToolTip,Visual 1, % visual_TooltipX, 0, 2
	}
Return

#If VISUAL_SPACE_MODE
	;$1::#^c ;shortcut key to TOGGLE invert color filter
	$1::Send #{PrintScreen}
	$2::Send, {LWin}
	$3::Send, {F5}
	$4::Reload ; Hotkey to reload the script
	$5::Suspend ; Hotkey to suspend the script

	$s::Send {Left} ;h - move cursor left
	$d::Send {Down} ;j - move cursor down
	$f::Send {Up} ;k - move cursor up
	$g::Send {Right} ;l - move cursor right

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
	VISUAL_SPACE_MODE := false
	SYMBOL_MODE := false
	NUMBER_MODE := false
	INSERT_MODE := true

	if TOGGLE {
		INSERT_MODE_II := true

		ToolTip,,,,2
		ToolTip,,,,4
		ToolTip,,,,5
		ToolTip, Index, % index_TooltipX, 0, 1
	} else {
		ToolTip,,,,2
		ToolTip,,,,4
		ToolTip,,,,5
	}
	return
#If

/*
   ----------------------------------------------
   ----------------------------------------------
   ---------------Tab Number layer---------------
   ----------------------------------------------
   ----------------------------------------------
*/

NumberLebel:
if !NUMBER_MODE {
	NUMBER_MODE := true
	SYMBOL_MODE := false
	VISUAL_SPACE_MODE := false
	INSERT_MODE := false
	INSERT_MODE_II := false

	ToolTip,,,,2
	ToolTip,,,,5
	ToolTip, Numpad, % number_TooltipX, 0, 4
}
Return

#If NUMBER_MODE
	;fn/num row
	$1::return
	$2::return
	$3::return
	$4::return
	$5::return

	;top row
	$q::return
	$w::Send 7
	$e::send 8
	$r::send 9
	$t::return

	;home row
	$a::return
	$s::send 4
	$d::send 5
	$f::send 6
	$g::send 0

	;bottom row
	$z::return
 	$x::send 1
 	$c::send 2
	$v::send 3
	$b::return

	$Tab::
	SYMBOL_MODE := false
	NUMBER_MODE := false
	VISUAL_SPACE_MODE := false
	INSERT_MODE := true

	if TOGGLE {
		INSERT_MODE_II := true

		ToolTip,,,,4
		ToolTip,,,,5
		ToolTip, Index, % index_TooltipX, 0, 1
	} else {
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
if !SYMBOL_MODE {
	SYMBOL_MODE := true
	NUMBER_MODE := false
	VISUAL_SPACE_MODE := false
	INSERT_MODE := false
	INSERT_MODE_II := false

	ToolTip,,,,2
	ToolTip,,,,4
	ToolTip, Symbol, % symbol_TooltipX, 0, 5
	}
Return

#If SYMBOL_MODE
	;fn/num row in the keyboard
	$1::return
	$2::tapMode("","~","")
	$3::tapMode("","|","")
	$4::tapMode("","^","")
	$5::return

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
	SYMBOL_MODE := false
	NUMBER_MODE := false
	VISUAL_SPACE_MODE := false
	INSERT_MODE := true

	if (TOGGLE) {
		INSERT_MODE_II := true

		ToolTip,,,,2
		ToolTip,,,,4
		ToolTip,,,,5
		ToolTip, Index, % index_TooltipX, 0, 1
	} else {
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
	NUMPAD_SYMBOL_MODE := true
	VISUAL_SPACE_MODE := false
	SYMBOL_MODE := false
	NUMBER_MODE := false
	INSERT_MODE := false
	INSERT_MODE_II := false

	; Show the symbol layer tooltip
	ToolTip,Numpad Symbol, % numpad_symbol_TooltipX, 0, 6

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
    NUMPAD_SYMBOL_MODE := false

    ; Reset other modes and show the appropriate tooltip
    SYMBOL_MODE := false
    NUMBER_MODE := false
    VISUAL_SPACE_MODE := false
    INSERT_MODE := true

    if TOGGLE {
        INSERT_MODE_II := true

        ; Hide any other tooltips
        ToolTip,,,,2
        ToolTip,,,,4
        ToolTip,,,,5
        ToolTip,,,,6

        ; Show the index layer tooltip
        ToolTip, Index, % index_TooltipX, 0, 1
    } else {
        ; Hide any other tooltips
        ToolTip,,,,2
        ToolTip,,,,4
        ToolTip,,,,5
        ToolTip,,,,6
    }
return

; Define behavior within the symbol layer
#If NUMPAD_SYMBOL_MODE
	;fn row in the keyboard
	$1::return
	$2::tapMode("","~","")
	$3::tapMode("","|","")
	$4::tapMode("","^","")
	$5::return

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
	INSERT_MODE := false
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
	INSERT_MODE := true
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
	NUMPAD_NUMBER_MODE := true
	VISUAL_SPACE_MODE := false
	SYMBOL_MODE := false
	NUMBER_MODE := false
	INSERT_MODE := false
	INSERT_MODE_II := false

	; Show the number layer tooltip
	ToolTip,Numpad Number, % numpad_number_TooltipX, 0, 7

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
    NUMPAD_NUMBER_MODE := false

    ; Reset other modes and show the appropriate tooltip
    SYMBOL_MODE := false
    NUMBER_MODE := false
    VISUAL_SPACE_MODE := false
    INSERT_MODE := true

    if TOGGLE {
        INSERT_MODE_II := true

        ; Hide any other tooltips
        ToolTip,,,,2
        ToolTip,,,,4
        ToolTip,,,,5
        ToolTip,,,,7

        ; Show the index layer tooltip
        ToolTip, Index, % index_TooltipX, 0, 1
    } else {
        ; Hide any other tooltips
        ToolTip,,,,2
        ToolTip,,,,4
        ToolTip,,,,5
        ToolTip,,,,7
    }
return

; Define behavior within the number layer
#If NUMPAD_NUMBER_MODE
	;fn/num row
	$1::return
	$2::return
	$3::return
	$4::return
	$5::return

	;top row
	$q::return
	$w::Send 7
	$e::send 8
	$r::send 9
	$t::return

	;home row
	$a::return
	$s::send 4
	$d::send 5
	$f::send 6
	$g::send 0

	;bottom row
	$z::return
 	$x::send 1
 	$c::send 2
	$v::send 3
	$b::return
#If
return
/*
   --------------------------------------------------
   --------------------------------------------------
   -------press alt to active visual layer 2---------
   --------------------------------------------------
   --------------------------------------------------
*/

VisualLabelAlt:

return
/*
   -----------------------------------------------
   ---------------Productivity mouse--------------
   -----------------------------------------------
   -----------------------------------------------
*/

RButton::
	g := Morse()
	If (g = "1") {
		Send, +{LButton}
		Send, ^c ; single long click to copy text

		ToolTip, Copied!, 900, 500, 8

		; Hide the tooltip after 1 second
		SetTimer, HideTooltip, -1000
	} Else If (g = "01")
		Send ^z ; short long to click undo action
	Else If (g = "10")
		Send ^y  ; long short to click redo action
    Else If (g = "00")
		Send ^v  ; double short click to paste from clipboard
    Else If (g = "000")
		Send ^a ; triple short click to select all
	Else
		Send {RButton} ; usually single short click to send rbutton

Return

; Function to hide the tooltip
HideTooltip:
    ToolTip,,,,8
return


/*
   ----------------------------------------------
   ----------------------------------------------
   --------------chrome autmation----------------
   ----------------------------------------------
   ----------------------------------------------
*/

#IfWinActive, ahk_class Chrome_WidgetWin_1
/*
ClickCount := 0
StartX := 0
StartY := 0
EndX := 0
EndY := 0

; Single left click to start/end text selection and double-click to paste clipboard contents
RButton::
    ClickCount++
    If (ClickCount = 1) {
        ; First click - start selection
        MouseGetPos, StartX, StartY
    } Else If (ClickCount = 2) {
        ; Second click - end selection
        MouseGetPos, EndX, EndY
        ; Determine selection direction
        if (EndX < StartX) {
            Temp := EndX
            EndX := StartX
            StartX := Temp
            Temp := EndY
            EndY := StartY
            StartY := Temp
        }
        ; Select text between Start and End positions
        MouseMove, StartX, StartY
        Sleep 50 ; Adjust sleep time if necessary
        MouseClickDrag, Left, , , EndX, EndY

        ; Copy selected text to clipboard
        Send, ^c
        ClickCount := 0 ; Reset click counter after selection
    } Else If (ClickCount = 3) {
        ; Third click (double-click) - paste clipboard contents
        Send, ^v
        ClickCount := 0 ; Reset click counter after paste
    }
Return
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

Morse(timeout = 300) {
   tout := timeout/1000
   key := RegExReplace(A_ThisHotKey,"[\*\~\$\#\+\!\^]")
   Loop {
      t := A_TickCount
      KeyWait %key%
      Pattern .= A_TickCount-t > timeout
      KeyWait %key%,DT%tout%
    if (ErrorLevel)
      Return Pattern
   }
}

; end of the script
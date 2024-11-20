#Requires AutoHotkey v2
;#include <UIA> ; Uncomment if you have moved UIA.ahk to your main Lib folder
#include C:\Users\Dell\Downloads\UIA-v2-main\Lib\UIA.ahk
#include C:\Users\Dell\Downloads\AHK-v2-libraries-main\Lib\WinEvent.ahk
#include C:\Users\Dell\Downloads\AHK-v2-libraries-main\Lib\XHotstring.ahk

SendMode "Input"  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.
;#InstallKeybdHook
#SingleInstance Force
A_MaxHotkeysPerInterval := 200
Persistent
SetCapsLockState "AlwaysOff"
CoordMode "ToolTip"
; Get current mouse cursor position
MouseGetPos(&mouseX, &mouseY)

INSERT_MODE := true
INSERT_MODE_II := false ; Variable to track the state of the index layer
TOGGLE := false

VIM_NORMAL_SPACE_MODE := false
;NORMAL_GUI_MODE := false
NORMAL_ALT_MODE := false
NUMBER_MODE := false
SYMBOL_MODE := false
inside_symbol_layer_state := 1
NUMPAD_SYMBOL_MODE := false ; Variable to track the state of the numpad symbol layer
NUMPAD_NUMBER_MODE := false

VISUAL_MODE := false
DELETE_MODE := false
YANK_MODE := false
CHANGE_MODE := false

char_visual := false
line_visual := false
block_visual := false

; Global variables to track which GUI is currently displayed
oGui1 := "", oGui2 := "", oGui3 := "", oGui4 := "", oGui5 := "", oGui6 := ""
CurrentGui := 1
TotalGuis := 5
guiOpen := false
NumberInput := "" ; initial value for gui live display

index_TooltipX := A_ScreenWidth / 2 ; tooltip 1 index layer
vim_normal_TooltipX_Space := index_TooltipX - 117 ; tooltip 2 noraml layer 1
normal_TooltipX_Alt := index_TooltipX - 117 ; tooltip 9 normal layer 2
chord_TooltipX := index_TooltipX ; tooltip 3 for display chord dict
chord_TooltipY := A_ScreenHeight - 34  ; Y coordinate at the very bottom edge of the screen
; A_CaretX-50, A_CaretY-50 ; tooltip 3 for display chord dict
number_TooltipX := index_TooltipX + 100 ; tooltip 4 number layer
symbol_TooltipX := index_TooltipX + 100 ; tooltip 5 symbol layer
numpad_symbol_TooltipX := index_TooltipX + 100 ; tooltip 6 numpad symbol layer
numpad_number_TooltipX := index_TooltipX + 100 ; tooltip 7 numpad number layer
; MouseGetPos, x, y tooltip 8 for rbutton copy message
del_yank_change_visual_inside_NormalMode_TooltipX := index_TooltipX - 225 ; tooltip for 10 delete, yank, change, visual mode operation

;-------------------------------------------------------------------
;VsCodeWinActive := WinActive("ahk_class Chrome_WidgetWin_1 ahk_exe Code.exe")

WinEvent.Active(ActiveWindowChanged)
Persistent()

ActiveWindowChanged(hWnd, *) {
    global TOGGLE, INSERT_MODE, INSERT_MODE_II
    global VIM_NORMAL_SPACE_MODE
    global VISUAL_MODE

    VIM_NORMAL_SPACE_MODE := false
    VISUAL_MODE := false
    INSERT_MODE := true

    if WinActive("ahk_class Chrome_WidgetWin_1 ahk_exe Code.exe") {
        ; Get the active window's title
        currentTitle := WinWaitActive(hWnd)  ; Retrieve title directly with function syntax

        VimModeLibrary(currentTitle)
    } else {

        ToolTip(, , , 2)
        ToolTip(, , , 4)
        ToolTip(, , , 5)
        ToolTip(, , , 10)

        if TOGGLE {
            INSERT_MODE_II := true

            ToolTip("Index", index_TooltipX, 0, 1)
        }
    }
}

VimModeLibrary(activeTitle) {
    global TOGGLE, INSERT_MODE, INSERT_MODE_II
    global VIM_NORMAL_SPACE_MODE
    global VISUAL_MODE

    ; Get the Vim mode element
    VimStatusEl := UIA.ElementFromHandle(activeTitle)

    try {
        match := VimStatusEl.FindElement({ AutomationId: "vscodevim.vim.primary" }) ; Try finding the element
    } catch {
        ; Handle the error if element is not found
        ; MsgBox("Error: An element matching the condition was not found.")
        return
    }

    mode := match.Name  ; Get the current mode from the UI

    ;if (mode == "-- INSERT --")
    if (mode == "-- NORMAL --")
        Vim_NormalLabelSpace()
    else if (mode == "-- VISUAL --")
        Vim_VisualLabel()
    else
    {
        ToolTip(, , , 2)
        ToolTip(, , , 10)

        VIM_NORMAL_SPACE_MODE := false
        VISUAL_MODE := false
        INSERT_MODE := true

        if TOGGLE {
            INSERT_MODE_II := true

            ToolTip("Index", index_TooltipX, 0, 1)
        }
    }
}

/*
   ----------------------------------------------
   ----------------------------------------------
   -------------Basic letter typing--------------
   ----------------------------------------------
   ----------------------------------------------
*/

#HotIf INSERT_MODE ; Start of INSERT_MODE
; Detect if d is pressed and released without combination
$d::
{
    if KeyWait("d", "T0.1") ; Wait to see if the 'd' key is held down for 100ms
        return  ; If 'd' is held down, do nothing
    KeyWait("d")  ; Wait for the 'd' key to be released
    return
}

$d Up::
{
    global TOGGLE, INSERT_MODE_II ; https://www.autohotkey.com/boards/viewtopic.php?p=501239#p501239

    ; Check if d is pressed alone
    if (A_PriorKey != "d")
        return  ; If the prior key wasn't d alone, do nothing

    ; TOGGLE the INSERT_MODE_II state
    INSERT_MODE_II := !INSERT_MODE_II
    if INSERT_MODE_II {
        TOGGLE := true
        ToolTip("Index", index_TooltipX, 0, 1)
    } else {
        TOGGLE := false
        ToolTip("", , , 1)  ; Hides the tooltip
    }
    return
}

; Hotkeys for d & other N key combinations
~d & s:: Send "{Up}"
~d & f:: Send "{Down}"
~d & g::AltTab
~d & x:: Send "{Left}"
~d & v:: Send "{Right}"
~d & t:: Send "{Delete}"
~d & w:: Send "{Home} {Up} {End} {Enter}"
~d & r:: Send "{End} {Enter}"

~d & Space::
{
    g := Morse(200)
    If (g = "0")
        Gui1Setup()  ; Call the function directly
    Else If (g = "1")
        return
    Else If (g = "00")
        return
}

#HotIf INSERT_MODE_II ; start of INSERT_MODE_II
;fn row
;*Esc::
*1::
{
    if GetKeyState("CapsLock", "T")  ; Check if CapsLock is on
        SetCapsLockState("Off")      ; Turn CapsLock off
    else
        SetCapsLockState("On")       ; Turn CapsLock on
}
*2:: Send "{Tab}"
*3:: return
*4:: indexMode("x")
*5:: return

;top row
*q:: indexMode("z")
*w:: indexMode("b")
*e:: Send "{Enter}"
*r:: indexMode("g")
*t:: indexMode("j")

;home row
*a:: indexMode("u")
*s:: indexMode("o")
*f:: indexMode("r")
*g:: indexMode("c")

;bottom row
;*LShift::Tab
*z:: indexMode("m")
*x:: indexMode("y")
*c:: indexMode("v")
*v:: indexMode("f")
*b:: indexMode("p")

;fn row
~Space & 1:: return
~Space & 2:: return
~Space & 3:: return
~Space & 4:: return
~Space & 5:: return
;top row
~Space & w:: Send 2
~Space & e:: Send 3
~Space & r:: Send 4
~Space & t:: Send "{-}"

/*
	[2] [3] [4] [-]
[+] [1] [0] [5] [9]
[*] [6] [7] [8] [.]

*/

;home row
~Space & a:: Send "{+}"
~Space & s:: Send 1
~Space & d:: Send 0
~Space & d Up::
{
    global INSERT_MODE_II
    INSERT_MODE_II := true

    ToolTip("Index", index_TooltipX, 0, 1)
}
~Space & f:: Send 5
~Space & g:: Send 9
;bottom row
~Space & z:: Send "{*}"
~Space & x:: Send 6
~Space & c:: Send 7
~Space & v:: Send 8
~Space & b:: Send "{.}"

#HotIf ;end of INSERT_MODE_II

;fn row
*1::
{
    if GetKeyState("CapsLock", "T")  ; Check if CapsLock is on
        SetCapsLockState("Off")      ; Turn CapsLock off
    else
        SetCapsLockState("On")       ; Turn CapsLock on
}
*2:: Send "{Tab}"

*3:: Send "{Enter}"
*4:: indexMode("x")
*5:: return

;top row
*q:: indexMode("q")
*w:: indexMode("h")
*e:: indexMode("t")
*r:: indexMode("i")
*t:: indexMode("p")

;home row
*a:: indexMode("s")
*s:: indexMode("e")
*f:: indexMode("a")
*g:: indexMode("w")

;bottom row
*z:: indexMode("n")
*x:: indexMode("l")
*c:: Send("{Backspace}")
*v:: indexMode("d")
*b:: indexMode("k")

;fn row
~Space & 1:: return
~Space & 2:: return
~Space & 3:: return
~Space & 4:: return
~Space & 5:: return

;top row
~Space & w:: tapMode("w", "/", "\") ; two key hotkey short/long
~Space & e:: tapMode("e", "-", "_") ; two key hotkey short/long
~Space & r:: tapMode("r", "=", "+") ; two key hotkey short/long
~Space & t:: tapMode("t", "&", "$") ; two key hotkey short/long

;home row
~Space & a:: tapMode("a", "!", "%") ; two key hotkey short/long
~Space & s:: tapMode("s", "`'", "`"") ; two key hotkey short/long
~Space & d:: tapMode("d", ";", ":") ; two key hotkey short/long
~Space & d Up::
{
    global INSERT_MODE_II

    INSERT_MODE_II := false
    ToolTip("", , , 1)  ; Hides the tooltip
}
~Space & f:: tapMode("f", ".", ",") ; two key hotkey short/long
~Space & g:: tapMode("g", "*", "?") ; two key hotkey short/long

;bottom row
~Space & z:: tapMode("z", "<", ">") ; two key hotkey short/long
~Space & x:: tapMode("x", "[", "]") ; two key hotkey short/long
~Space & c:: tapMode("c", "(", ")") ; two key hotkey
~Space & v:: tapMode("v", "{", "}") ; two key hotkey
~Space & b:: tapMode("b", "`#", "@") ; two key hotkey short/long

#HotIf ;end of INSERT_MODE

/*
   ----------------------------------------------
   ----------------------------------------------
   ------------Other modifier key----------------
   ----------------------------------------------
   ----------------------------------------------
*/

LShift & d::
LCtrl & d::
{
    global TOGGLE, INSERT_MODE_II

    ; TOGGLE the INSERT_MODE_II state
    INSERT_MODE_II := !INSERT_MODE_II
    if INSERT_MODE_II {
        ssTOGGLE := true
        ToolTip("Index", index_TooltipX, 0, 1)
    } else {
        TOGGLE := false
        ToolTip("", , , 1)
}
}

LCtrl & a::
{
    if WinActive("ahk_class Chrome_WidgetWin_1 ahk_exe Code.exe")
        Send("^s")
    else
        Send("^x")
}

LCtrl & s:: Send("^z")  ; Send Ctrl+Z when either Ctrl+S is pressed
LCtrl & z:: Send("^c")  ; Send Ctrl+C when either Ctrl+Z is pressed
LCtrl & x:: Send("^v")  ; Send Ctrl+V when either Ctrl+X is pressed

LWin::Alt
LCtrl & Space:: Suspend ; Hotkey to suspend the script
LCtrl & Alt:: Reload	; Hotkey to reload the script

Alt::
{
    if VIM_NORMAL_SPACE_MODE
        Send("a")

    NormalLabelAlt()
}

CapsLock::
{
    if VIM_NORMAL_SPACE_MODE
        Send("a")

    SymbolLebelCapsLock()
}

Tab::
{
    if VIM_NORMAL_SPACE_MODE
    	Send("a")

    NumberLebelTab()
}

Space::
{
    if LongPress(200) {  ; Check if Space key is held down for more than 200ms

        if WinActive("ahk_class Chrome_WidgetWin_1 ahk_exe Code.exe") {
            Send "{Esc}"
            Vim_NormalLabelSpace()  ; Trigger Vim_NormalLabelSpace if VS Code is active
        }
    } else {
        Send "{Space}" ; Action for short press
    }
}

/*
   ----------------------------------------------------
   ----------------------------------------------------
   ---long press Space to active vim normal layer 1----
   ----------------------------------------------------
   ----------------------------------------------------
*/

Vim_NormalLabelSpace() {
    global VIM_NORMAL_SPACE_MODE, NORMAL_ALT_MODE, SYMBOL_MODE, NUMBER_MODE, INSERT_MODE, INSERT_MODE_II

    if !VIM_NORMAL_SPACE_MODE {
        VIM_NORMAL_SPACE_MODE := true
        ;guiOpen := false
        NORMAL_ALT_MODE := false
        SYMBOL_MODE := false
        NUMBER_MODE := false
        INSERT_MODE := false
        INSERT_MODE_II := false

        ToolTip(, , , 4)
        ToolTip(, , , 5)
        ToolTip(, , , 9)
        ToolTip("Normal", vim_normal_TooltipX_Space, 0, 2)
    }
}

#HotIf VIM_NORMAL_SPACE_MODE
; Detect mouse click and drag (selection)
~LButton::
{
    ;VimModeLibrary()
}

;fn row
;$1::return
$2::
{
    if LongPress(200)
        Send("gg") ;go to the first line of the document
    else
        Send("^") ;jump to the first non-blank character of the line ??????????????????????????????????????????????????????????????????
}
$3::
{
    Send("s")

    global VIM_NORMAL_SPACE_MODE, SYMBOL_MODE, NUMBER_MODE, TOGGLE, INSERT_MODE, INSERT_MODE_II

    ToolTip(, , , 2)
    ToolTip(, , , 4)
    ToolTip(, , , 5)

    VIM_NORMAL_SPACE_MODE := false
    SYMBOL_MODE := false
    NUMBER_MODE := false
    if TOGGLE {
        INSERT_MODE_II := true

        ToolTip("Index", index_TooltipX, 0, 1)
    }
}

$4::
{
    if LongPress(200)
        Send("G") ;go to the last line of the document
    Else
        Send("$") ;jump to the end of the line
}

;$5::return

; Top row remapping
$q::
{
    if LongPress(200)
        Send(">>")  ;indent (move right) line one shiftwidth
    Else
        Send("<<")  ;indent (move left) line one shiftwidth
}

$w:: DeleteLabel()
$e:: YankLabel()
$r:: ChangeLabel()
$t:: Send("p") ;put (paste) the clipboard after cursor

; home row
a:: Send("h") ;h - move cursor left
s:: Send("k") ;k - move cursor up
f:: Send("l") ;l - move cursor right
d:: Send("j") ;j - move cursor down

$g::
{
    global block_visual, line_visual, char_visual

    g := Morse(200)
    	If (g = "00") {
        block_visual := true
        Vim_VisualLabel()
    }
    Else If (g = "0") {
        char_visual := true

        Send("v")
        Vim_VisualLabel()
    }
    Else If (g = "1") {
        line_visual := true

        Send("V")
        Vim_VisualLabel()
    }
}

; Bottom row remapping
$z:: Send("b") ;jump backwards to the start of a word
$x:: Send("{WheelUp}")
$c:: Send("{WheelDown}")
$v:: Send("w") ;jump forwards to the start of a worddd

$b::
{
    keyPress := Morse(200)

    If (keyPress = "00")
        Send("^r") ; short keyPress to redo
    else If (keyPress = "0")
        Send("u") ; short keyPress to undo
}

$Space::
{
    global VIM_NORMAL_SPACE_MODE, SYMBOL_MODE, NUMBER_MODE, INSERT_MODE, INSERT_MODE_II, TOGGLE

    ToolTip(, , , 2)
    ToolTip(, , , 4)
    ToolTip(, , , 5)

	keyPress := Morse(200)
	If (keyPress = "00")
		Send("o")  ; double short keyPress to go next line and enter insert mode
	else If (keyPress = "1")
		Send("i") ; short keyPress to go to the prev char where the curser point and enter insert mode
	else If (keyPress = "0")
		Send("a") ; long keyPress to go to the next char where the curser point and enter insert mode

	VIM_NORMAL_SPACE_MODE := false
	SYMBOL_MODE := false
	NUMBER_MODE := false
	INSERT_MODE := true

    if TOGGLE {
        INSERT_MODE_II := true

        ToolTip("Index", index_TooltipX, 0, 1)
    }
}

$Alt::
{
    global VIM_NORMAL_SPACE_MODE, NORMAL_ALT_MODE

    Send "a"
    ToolTip(, , , 2)
    ToolTip("Normal 2", normal_TooltipX_Alt, 0, 9)

    NORMAL_ALT_MODE := true
    VIM_NORMAL_SPACE_MODE := false

}
~Alt Up:: InStr(A_PriorKey, 'Alt') && Send('{Esc}')
#HotIf

/*
   --------------------------------------------------
   -----------visual layer inside normal-------------
   --------------------------------------------------
*/

Vim_VisualLabel() {

    global VIM_NORMAL_SPACE_MODE, VISUAL_MODE, SYMBOL_MODE, NUMBER_MODE
    global INSERT_MODE, INSERT_MODE_II
    global char_visual, line_visual, block_visual

    if !VISUAL_MODE {
        ;guiOpen := false
        VISUAL_MODE := true
        VIM_NORMAL_SPACE_MODE := false
        SYMBOL_MODE := false
        NUMBER_MODE := false
        INSERT_MODE := false
        INSERT_MODE_II := false

        ToolTip(, , , 2)
        ToolTip(, , , 4)
        ToolTip(, , , 5)

if char_visual
		ToolTip("VISUAL", del_yank_change_visual_inside_NormalMode_TooltipX, 0, 10)
	Else if line_visual
		ToolTip("VISUAL LINE", del_yank_change_visual_inside_NormalMode_TooltipX, 0, 10)
	Else if block_visual
		ToolTip("VISUAL BLOCK", del_yank_change_visual_inside_NormalMode_TooltipX, 0, 10)
    }
}

#HotIf VISUAL_MODE

/*
~LButton::
~RButton::
*/

$Alt:: return
$Tab:: return
$CapsLock:: return
$Down:: return
$Shift:: return
$Ctrl:: return
$Right:: return

;fn row
;$1::return
$2::
{
    if LongPress(200)
        Send("gg") ;go to the first line of the document
    else
        Send("^") ;jump to the first non-blank character of the line
}
$3:: return
$4::
{
    if LongPress(200)
        Send "G" ;go to the last line of the document
    Else
        Send "{$}" ;jump to the end of the line
}
;$5::return

; Top row remapping
	$q::return
	$w::
    {
    global VISUAL_MODE
    global char_visual, line_visual, block_visual

    Send "d"

    ToolTip(, , , 10)
    VISUAL_MODE := false
    char_visual := false
    line_visual := false
    block_visual := false

    Vim_NormalLabelSpace()  ; Trigger Vim_NormalLabelSpace if VS Code is active
}


$e::
{
    global VISUAL_MODE
    global char_visual, line_visual, block_visual

    Send "y"

    ToolTip(, , , 10)
    VISUAL_MODE := false
    char_visual := false
    line_visual := false
    block_visual := false

    Vim_NormalLabelSpace()  ; Trigger Vim_NormalLabelSpace if VS Code is active
}

$r::
{
    global VIM_NORMAL_SPACE_MODE, VISUAL_MODE, SYMBOL_MODE, NUMBER_MODE
    global char_visual, line_visual, block_visual
    global TOGGLE, INSERT_MODE, INSERT_MODE_II

    Send "c"

    ToolTip(, , , 2)
    ToolTip(, , , 4)
    ToolTip(, , , 5)
    ToolTip(, , , 10)

    char_visual := false
    line_visual := false
    block_visual := false

    VISUAL_MODE := false
    VIM_NORMAL_SPACE_MODE := false
    SYMBOL_MODE := false
    NUMBER_MODE := false
    INSERT_MODE := true

    if TOGGLE {
        INSERT_MODE_II := true

        ToolTip("Index", index_TooltipX, 0, 1)
    }
}

$t::
{
    global VISUAL_MODE
    global char_visual, line_visual, block_visual

    Send "p" ;put (paste) the clipboard after cursor

    ToolTip(, , , 10)

    VISUAL_MODE := false
    char_visual := false
    line_visual := false
    block_visual := false

    Vim_NormalLabelSpace()  ; Trigger Vim_NormalLabelSpace if VS Code is active
}


; home row
$a:: Send "{Left}" ;h - move cursor left
$s:: Send "{Up}" ;k - move cursor up
$f:: Send "{Right}" ;l - move cursor right
$d:: Send "{Down}" ;j - move cursor down

$g::
{
    global VISUAL_MODE
    global char_visual, line_visual, block_visual

    Send "{Esc}"
    ToolTip(, , , 10)

    VISUAL_MODE := false
    char_visual := false
    line_visual := false
    block_visual := false

    Vim_NormalLabelSpace()  ; Trigger Vim_NormalLabelSpace if VS Code is active
}

; Bottom row remapping
$z:: Send "b" ;jump backwards to the start of a word
;$^z::Send, ^r ;redo
$x:: Send "{WheelUp}"
$c:: Send "{WheelDown}"
$v:: Send "w" ;jump forwards to the start of a word
$b:: return

; Define the hotkey to show or destroy the GUI
$Space::
{
    global VIM_NORMAL_SPACE_MODE, VISUAL_MODE, SYMBOL_MODE, NUMBER_MODE
    global char_visual, line_visual, block_visual
    global TOGGLE, INSERT_MODE, INSERT_MODE_II

    Send "{Esc}"

    g := Morse(200)
    If (g = "00")
        Send "o"  ; double short click to go next line and enter insert mode
    else If (g = "1")
        Send "a" ; long click to go to the next char where the curser point and enter insert mode
    else If (g = "0")
        Send "i" ; short click to go to the prev char where the curser point and enter insert mode

    ToolTip(, , , 2)
    ToolTip(, , , 4)
    ToolTip(, , , 5)
    ToolTip(, , , 10)

    ;guiOpen := false
    VISUAL_MODE := false
    char_visual := false
    line_visual := false
    block_visual := false

    VIM_NORMAL_SPACE_MODE := false
    SYMBOL_MODE := false
    NUMBER_MODE := false
    INSERT_MODE := true

    if TOGGLE {
        INSERT_MODE_II := true

        ToolTip("Index", index_TooltipX, 0, 1)
    }
}

#HotIf

/*
   --------------------------------------------------
   --------------------------------------------------
   ----------------delete/cut------------------------
   --------------------------------------------------
   --------------------------------------------------
*/

DeleteLabel() {
    global DELETE_MODE
    global VIM_NORMAL_SPACE_MODE

    if !DELETE_MODE {
        DELETE_MODE := true
        VIM_NORMAL_SPACE_MODE := false

        ToolTip("DELETE", del_yank_change_visual_inside_NormalMode_TooltipX, 0, 10)
    }
}

#HotIf DELETE_MODE

$Alt:: return
$Tab:: return
$CapsLock:: return
$Down:: return
$Shift:: return
$Ctrl:: return
$Right:: return

; fn row
$1:: return
$2:: return
$3:: return
$4:: return
$5:: return

; top row
$q:: return
$w::
{
    global DELETE_MODE
    global VIM_NORMAL_SPACE_MODE

    Send "dd" ;delete (cut) a line
    DELETE_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)
}

$e::
{
    global DELETE_MODE
    global VIM_NORMAL_SPACE_MODE

    Send "x" ;delete (cut) a char
    DELETE_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)
}

$r:: return
$t:: return

; home row
$a::
{
    global DELETE_MODE
    global VIM_NORMAL_SPACE_MODE

    Send "dw" ;delete (cut) the characters of the word from the cursor position to the start of the next word
    DELETE_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)
}

$s::
{
    global DELETE_MODE
    global VIM_NORMAL_SPACE_MODE

    Send "d0" ;delete/cut from the cursor to the beginning of the line/ d0
    DELETE_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)
}

$d::
{
    global DELETE_MODE
    global VIM_NORMAL_SPACE_MODE

    Send("d$") ;delete (cut) to the end of the line
    DELETE_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)
}

$f::
{
    global DELETE_MODE
    global VIM_NORMAL_SPACE_MODE

    Send "diw" ;delete (cut) word under the cursor
    DELETE_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)
}

$g::
{
    global DELETE_MODE
    global VIM_NORMAL_SPACE_MODE

    Send "daw" ;delete (cut) word under the cursor and the space after or before it
    DELETE_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)
}

; Bottom row remapping
$z:: return
$x:: return
$c::
{
    global DELETE_MODE
    global VIM_NORMAL_SPACE_MODE

    Send "dgg" ;delete/cut from the cursor to the beginning of the file
    DELETE_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)
}

$v::
{
    global DELETE_MODE
    global VIM_NORMAL_SPACE_MODE

    Send "dG" ; delete/cut from the cursor to the end of the file/
    DELETE_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)
}

$b:: return
$Space::
{
    global DELETE_MODE
    global VIM_NORMAL_SPACE_MODE

    DELETE_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)
}
#HotIf

/*
   --------------------------------------------------
   --------------------------------------------------
   -----------------yank/copy------------------------
   --------------------------------------------------
   --------------------------------------------------
*/

YankLabel() {
    global YANK_MODE
    global VIM_NORMAL_SPACE_MODE

    if !YANK_MODE {
        YANK_MODE := true
        VIM_NORMAL_SPACE_MODE := false

        ToolTip("YANK", del_yank_change_visual_inside_NormalMode_TooltipX, 0, 10)
    }
}

#HotIf YANK_MODE

$Alt:: return
$Tab:: return
$CapsLock:: return
$Down:: return
$Shift:: return
$Ctrl:: return
$Right:: return

; fn row
$1:: return
$2:: return
$3:: return
$4:: return
$5:: return

; top row
$q:: return
$w:: return
$e::
{
    global YANK_MODE
    global VIM_NORMAL_SPACE_MODE

    Send "yy" ;Select and yank/copy a single line
    YANK_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)
}

$r::
{
    global YANK_MODE
    global VIM_NORMAL_SPACE_MODE

    Send "yl" ;Select and yank/copy a single char
    YANK_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)
}

$t:: return

; home row
$a::
{
    global YANK_MODE
    global VIM_NORMAL_SPACE_MODE

    Send "yw" ;yank/copy from the cursor to the beginning of the next word
    YANK_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)
}

$s::
{
    global YANK_MODE
    global VIM_NORMAL_SPACE_MODE

    Send "y0" ;yank/copy from the cursor to the beginning of the line
    YANK_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)
}

$d::
{
    global YANK_MODE
    global VIM_NORMAL_SPACE_MODE

    Send "y$" ;yank/copy from the cursor to the end of the line
    YANK_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)
}

$f::
{
    global YANK_MODE
    global VIM_NORMAL_SPACE_MODE

    Send "yiw" ;yank/copy the entire word under the cursor. 'iw' focuses on the word itself, ignoring spaces or punctuation around it.
    YANK_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)
}

$g::
{
    global YANK_MODE
    global VIM_NORMAL_SPACE_MODE

    Send "yaw" ; yank/copy the entire word under the cursor. "aw" includes spaces or punctuation around the word, making it more inclusive in its selection.
    YANK_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)
}

; Bottom row remapping
$z:: return
$x:: return
$c::
{
    global YANK_MODE
    global VIM_NORMAL_SPACE_MODE

    Send "ygg" ;yank/copy from the cursor to the beginning of the file
    YANK_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)
}

$v::
{
    global YANK_MODE
    global VIM_NORMAL_SPACE_MODE

    Send "yG" ;yank/copy from the cursor to the end of the file
    YANK_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)
}

$b:: return
$Space::
{
    global YANK_MODE
    global VIM_NORMAL_SPACE_MODE

    YANK_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)
}
#HotIf

/*
   --------------------------------------------------
   --------------------------------------------------
   ----------------change/del------------------------
   --------------------------------------------------
   --------------------------------------------------
*/

changeToindex() {
    global VIM_NORMAL_SPACE_MODE, SYMBOL_MODE, NUMBER_MODE
    global TOGGLE, INSERT_MODE, INSERT_MODE_II

    ToolTip(, , , 2)
    ToolTip(, , , 4)
    ToolTip(, , , 5)

    ;guiOpen := false
    VIM_NORMAL_SPACE_MODE := false
    SYMBOL_MODE := false
    NUMBER_MODE := false
    INSERT_MODE := true

    if TOGGLE {
        INSERT_MODE_II := true

        ToolTip("Index", index_TooltipX, 0, 1)
    }
}

ChangeLabel() {
    global CHANGE_MODE
    global VIM_NORMAL_SPACE_MODE

    if !CHANGE_MODE {
        CHANGE_MODE := true
        VIM_NORMAL_SPACE_MODE := false

        ToolTip("CHANGE", del_yank_change_visual_inside_NormalMode_TooltipX, 0, 10)
    }
}

#HotIf CHANGE_MODE

$Alt:: return
$Tab:: return
$CapsLock:: return
$Down:: return
$Shift:: return
$Ctrl:: return
$Right:: return

; fn row
$1:: return
$2:: return
$3:: return
$4:: return
$5:: return

; top row
$q:: return
$w:: return
$e::
{
    global CHANGE_MODE
    global VIM_NORMAL_SPACE_MODE

    Send "s" ;Select and change/del a single char
    CHANGE_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)

    changeToindex()
}

$r::
{
    global CHANGE_MODE
    global VIM_NORMAL_SPACE_MODE

    Send "cc" ;Select and change/del a single line
    CHANGE_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)

    changeToindex()
}

$t:: return

; home row
$a::
{
    global CHANGE_MODE
    global VIM_NORMAL_SPACE_MODE

    Send "cw" ;change/del from the cursor to the beginning of the next word
    CHANGE_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)

    changeToindex()
}

$s::
{
    global CHANGE_MODE
    global VIM_NORMAL_SPACE_MODE

    Send "c0" ;change/del from the cursor to the beginning of the line
    CHANGE_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)

    changeToindex()
}

$d::
{
    global CHANGE_MODE
    global VIM_NORMAL_SPACE_MODE

    Send "c$" ;change/del from the cursor to the end of the line
    CHANGE_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)

    changeToindex()
}

$f::
{
    global CHANGE_MODE
    global VIM_NORMAL_SPACE_MODE

    Send "ciw" ;change/del the entire word under the cursor. 'iw' focuses on the word itself, ignoring spaces or punctuation around it.
    CHANGE_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)

    changeToindex()
}

$g::
{
    global CHANGE_MODE
    global VIM_NORMAL_SPACE_MODE

    Send "caw" ;change/del the entire word under the cursor. "aw" includes spaces or punctuation around the word, making it more inclusive in its selection.
    CHANGE_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)

    changeToindex()
}


; Bottom row remapping
$z:: return
$x:: return
$c::
{
    global CHANGE_MODE
    global VIM_NORMAL_SPACE_MODE

    Send "cgg" ;change/del from the cursor to the beginning of the file
    CHANGE_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)

    changeToindex()
}

$v::
{
    global CHANGE_MODE
    global VIM_NORMAL_SPACE_MODE

    Send "cG" ;change/del from the cursor to the end of the file
    CHANGE_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)

    changeToindex()
}

$b:: return

$Space::
{
    global CHANGE_MODE
    global VIM_NORMAL_SPACE_MODE

    CHANGE_MODE := false
    VIM_NORMAL_SPACE_MODE := true
    ToolTip(, , , 10)

}

#HotIf

/*
   ----------------------------------------------
   ----------------------------------------------
   ---------------Tab Number layer---------------
   ----------------------------------------------
   ----------------------------------------------
*/

NumberLebelTab() {
    global VIM_NORMAL_SPACE_MODE, NORMAL_ALT_MODE, SYMBOL_MODE, NUMBER_MODE
    global INSERT_MODE

    if !NUMBER_MODE {
        NUMBER_MODE := true
        SYMBOL_MODE := false
        VIM_NORMAL_SPACE_MODE := false
        NORMAL_ALT_MODE := false
        INSERT_MODE := false
        ;INSERT_MODE_II := false

        ToolTip(, , , 2)
        ToolTip(, , , 5)
        ToolTip(, , , 9)
        ToolTip("Numpad", number_TooltipX, 0, 4)
    }
    ;return
}

#HotIf NUMBER_MODE
;fn/num row
$1:: return
$2:: return
$3:: return
$4:: return
$5:: return

;top row
$q:: return
$w:: Send 7
$e:: send 8
$r:: send 9
$t:: return

;home row
$a:: return
$s:: send 4
$d:: send 5
$f:: send 6
$g:: send 0

;bottom row
$z:: return
$x:: send 1
$c:: send 2
$v:: send 3
$b:: return

$Tab::
{
    global VIM_NORMAL_SPACE_MODE, NORMAL_ALT_MODE, SYMBOL_MODE, NUMBER_MODE
    global TOGGLE, INSERT_MODE, INSERT_MODE_II

    NUMBER_MODE := false
    SYMBOL_MODE := false
    VIM_NORMAL_SPACE_MODE := false
    NORMAL_ALT_MODE := false
    INSERT_MODE := true

    if TOGGLE {
        INSERT_MODE_II := true

        ToolTip(, , , 4)
        ToolTip(, , , 5)
        ToolTip(, , , 9)
        ToolTip("Index", index_TooltipX, 0, 1)
    } else {
        ToolTip(, , , 4)
        ToolTip(, , , 5)
        ToolTip(, , , 9)
    }
    return
}

$CapsLock::
{
    global VIM_NORMAL_SPACE_MODE, NORMAL_ALT_MODE, SYMBOL_MODE, NUMBER_MODE
    global INSERT_MODE, INSERT_MODE_II
    global inside_symbol_layer_state

    inside_symbol_layer_state := 2
    SYMBOL_MODE := true
    NUMBER_MODE := false
    VIM_NORMAL_SPACE_MODE := false
    NORMAL_ALT_MODE := false
    INSERT_MODE := false
    ;INSERT_MODE_II := false

    ToolTip(, , , 2)
    ToolTip(, , , 4)
    ToolTip(, , , 9)
    ToolTip("Symbol", symbol_TooltipX, 0, 5)
}
#HotIf

/*
   ----------------------------------------------
   ----------------------------------------------
   -----------Capslock symbol layer--------------
   ----------------------------------------------
   ----------------------------------------------
*/

SymbolLebelCapsLock() {
    global VIM_NORMAL_SPACE_MODE, NORMAL_ALT_MODE, SYMBOL_MODE, NUMBER_MODE
    global INSERT_MODE, INSERT_MODE_II
    global inside_symbol_layer_state

    last := inside_symbol_layer_state, inside_symbol_layer_state := 3 ; Set the current layer to 3 when CapsLock is pressed

    INSERT_MODE := false
    INSERT_MODE_II := false
    NUMBER_MODE := false
    VIM_NORMAL_SPACE_MODE := false
    NORMAL_ALT_MODE := false

    ToolTip(, , , 2)
    ToolTip(, , , 4)
    ToolTip(, , , 9)

    KeyWait("CapsLock") ; Wait for CapsLock to be released

    ;layer := A_Priorkey != "CapsLock" ? last : last = 2 ? 1 : 2

    if (A_PriorKey != "CapsLock")
        inside_symbol_layer_state := last
    else if (last = 2)
        inside_symbol_layer_state := 1
    else
        inside_symbol_layer_state := 2


    if (inside_symbol_layer_state = 2) {

        SYMBOL_MODE := true
        INSERT_MODE := false
        ;INSERT_MODE_II := false

        ToolTip("Symbol", symbol_TooltipX, 0, 5)
    } else {

        SYMBOL_MODE := false
        INSERT_MODE := true

        ToolTip(, , , 5)

        if TOGGLE {
            INSERT_MODE_II := true

            ToolTip("Index", index_TooltipX, 0, 1)
        }
        return
    }
}

#HotIf (inside_symbol_layer_state = 2)
;fn/num row in the keyboard
$1:: return
$2:: tapMode("", "~", "")
$3:: tapMode("", "|", "")
$4:: tapMode("", "^", "")
$5:: return

;top row in the keyboard
$q:: tapMode("", "``", "")
$w:: tapMode("w", "/", "\")
$e:: tapMode("e", "-", "_")
$r:: tapMode("r", "=", "+")
$t:: tapMode("t", "&", "$")

;home row in the keyboard
$a:: tapMode("a", "!", "%")
$s:: tapMode("s", "'", "`"")
$d:: tapMode("d", ";", ":")
$f:: tapMode("f", ".", ",")
$g:: tapMode("g", "*", "?")

;bottom row in the keyboard
$z:: tapMode("z", "<", ">")
$x:: tapMode("x", "[", "]")
$c:: tapMode("c", "(", ")")
$v:: tapMode("v", "{", "}")
$b:: tapMode("b", "`#", "@")

$Alt::
{
    global VIM_NORMAL_SPACE_MODE, NORMAL_ALT_MODE, SYMBOL_MODE, NUMBER_MODE
    global INSERT_MODE, INSERT_MODE_II
    global inside_symbol_layer_state

    inside_symbol_layer_state := 1
    NORMAL_ALT_MODE := true
    VIM_NORMAL_SPACE_MODE := false
    ;CHECK_IS_ON_VIM_NORMAL_SPACE_MODE := false
    NUMBER_MODE := false
    SYMBOL_MODE := false
    INSERT_MODE := false
    INSERT_MODE_II := false

    ToolTip(, , , 2)
    ToolTip(, , , 4)
    ToolTip(, , , 5)
    ToolTip("Normal 2", normal_TooltipX_Alt, 0, 9)
    return
}
#HotIf

/*
#HotIf (inside_symbol_layer_state = 3)
$w:: Send("{Up}")
$a:: Send("{Left}")
$s::
{
    g := Morse(200)

    If (g = "0")
        Gui1Setup()  ; Call the function directly
    Else If (g = "1")
        return
    Else If (g = "00")
        return
}
$d:: Send("{Right}")
#HotIf
*/

; Case 1: inside_symbol_layer_state = 3 and TOGGLE is ON
#HotIf (inside_symbol_layer_state = 3 && TOGGLE)

$w:: Send("{WheelUp 5}")    ; Scroll up quickly when TOGGLE is on
$s::
{
    g := Morse(200)

    If (g = "0")
        Gui1Setup()  ; Call the function directly
    Else If (g = "1")
        return
    Else If (g = "00")
        return
}
$d:: Send("{WheelDown 5}")

#HotIf ; End of this conditional block

; Case 2: inside_symbol_layer_state = 3 and TOGGLE is OFF
#HotIf (inside_symbol_layer_state = 3 && !TOGGLE)

$w:: Send("{Up}")           ; Move up when TOGGLE is off
$a:: Send("{Left}")         ; Move left
$s:: Send("{Down}")         ; Move down when TOGGLE is off
$d:: Send("{Right}")

#HotIf                      ; End of this conditional block


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

*SC051:: Send("{blind}{Control Down}{Shift Down}") ;Numpad3
*SC051 Up:: Send("{blind} {Control Up} {Shift Up}")

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
{
    global NUMPAD_SYMBOL_MODE, NUMBER_MODE, SYMBOL_MODE
    global VIM_NORMAL_SPACE_MODE, NORMAL_ALT_MODE
    global INSERT_MODE, INSERT_MODE_II
    global inside_symbol_layer_state

    ; Activate the numpad symbol layer
    NUMPAD_SYMBOL_MODE := true
    VIM_NORMAL_SPACE_MODE := false
    NORMAL_ALT_MODE := false
    SYMBOL_MODE := false
    inside_symbol_layer_state := 1
    NUMBER_MODE := false
    INSERT_MODE := false
    INSERT_MODE_II := false

    ; Show the symbol layer tooltip
    ToolTip("Numpad Symbol", numpad_symbol_TooltipX, 0, 6)

    ; Hide any other tooltips
    ToolTip(, , , 2)
    ToolTip(, , , 4)
    ToolTip(, , , 5)
    ToolTip(, , , 9)
}

Down Up::
{
    global NUMPAD_SYMBOL_MODE
    global NUMBER_MODE
    global SYMBOL_MODE
    global inside_symbol_layer_state
    global VIM_NORMAL_SPACE_MODE
    global NORMAL_ALT_MODE
    global INSERT_MODE
    global INSERT_MODE_II
    global TOGGLE

    if (A_PriorKey = "Down") {
        Send "{Down}"
    }
    ; Deactivate the numpad symbol layer
    NUMPAD_SYMBOL_MODE := false

    ; Reset other modes and show the appropriate tooltip
    SYMBOL_MODE := false
    inside_symbol_layer_state := 1
    NUMBER_MODE := false
    VIM_NORMAL_SPACE_MODE := false
    NORMAL_ALT_MODE := false
    INSERT_MODE := true

    if TOGGLE {
        INSERT_MODE_II := true

        ; Hide any other tooltips
        ToolTip(, , , 2)
        ToolTip(, , , 4)
        ToolTip(, , , 5)
        ToolTip(, , , 6)
        ToolTip(, , , 9)

        ; Show the index layer tooltip
        ToolTip("Index", index_TooltipX, 0, 1)
    } else {
        ; Hide any other tooltips
        ToolTip(, , , 2)
        ToolTip(, , , 4)
        ToolTip(, , , 5)
        ToolTip(, , , 6)
        ToolTip(, , , 9)
    }
}

; Define behavior within the symbol layer
#HotIf NUMPAD_SYMBOL_MODE
;fn row in the keyboard
$1:: return
$2:: tapMode("", "~", "")
$3:: tapMode("", "|", "")
$4:: tapMode("", "^", "")
$5:: return

;top row in the keyboard
$q:: tapMode("", "``", "")
$w:: tapMode("w", "/", "\")
$e:: tapMode("e", "-", "_")
$r:: tapMode("r", "=", "+")
$t:: tapMode("t", "&", "$")

;home row in the keyboard
$a:: tapMode("a", "!", "%")
$s:: tapMode("s", "'", "`"")
$d:: tapMode("d", ";", ":")
$f:: tapMode("f", ".", ",")
$g:: tapMode("g", "*", "?")

;bottom row in the keyboard
$z:: tapMode("z", "<", ">")
$x:: tapMode("x", "[", "]")
$c:: tapMode("c", "(", ")")
$v:: tapMode("v", "{", "}")
$b:: tapMode("b", "`#", "@")
#HotIf

/*
   ----------------------------------------------
   -----------Number layer section---------------
   -----------Layer two/ NumpadAdd---------------
   ----------------------------------------------
   ----------------------------------------------
*/

; Hotkey to activate the numpad number layer
Right::
{
    global NUMPAD_NUMBER_MODE
    global NUMBER_MODE
    global SYMBOL_MODE
    global inside_symbol_layer_state
    global VIM_NORMAL_SPACE_MODE
    global NORMAL_ALT_MODE
    global INSERT_MODE
    global INSERT_MODE_II

    ; Activate the numpad number layer
    NUMPAD_NUMBER_MODE := true
    VIM_NORMAL_SPACE_MODE := false
    NORMAL_ALT_MODE := false
    SYMBOL_MODE := false
    inside_symbol_layer_state := 1
    NUMBER_MODE := false
    INSERT_MODE := false
    INSERT_MODE_II := false

    ; Show the number layer tooltip
    ToolTip("Numpad Number", numpad_number_TooltipX, 0, 7)

    ; Hide any other tooltips
    ToolTip(, , , 2)
    ToolTip(, , , 9)
    ToolTip(, , , 4)
    ToolTip(, , , 5)
}

Right Up::
{
    global NUMPAD_NUMBER_MODE
    global NUMBER_MODE
    global SYMBOL_MODE
    global inside_symbol_layer_state
    global VIM_NORMAL_SPACE_MODE
    global NORMAL_ALT_MODE
    global INSERT_MODE
    global INSERT_MODE_II
    global TOGGLE

    if (A_PriorKey = "Right") {
        Send "{Right}"
    }
    ; Deactivate the numpad number layer
    NUMPAD_NUMBER_MODE := false

    ; Reset other modes and show the appropriate tooltip
    SYMBOL_MODE := false
    inside_symbol_layer_state := 1
    NUMBER_MODE := false
    VIM_NORMAL_SPACE_MODE := false
    NORMAL_ALT_MODE := false
    INSERT_MODE := true

    if TOGGLE {
        INSERT_MODE_II := true

        ; Hide any other tooltips
        ToolTip(, , , 2)
        ToolTip(, , , 4)
        ToolTip(, , , 5)
        ToolTip(, , , 7)
        ToolTip(, , , 9)

        ; Show the index layer tooltip
        ToolTip("Index", index_TooltipX, 0, 1)
    } else {
        ; Hide any other tooltips
        ToolTip(, , , 2)
        ToolTip(, , , 4)
        ToolTip(, , , 5)
        ToolTip(, , , 7)
        ToolTip(, , , 9)
    }
}

; Define behavior within the number layer
#HotIf NUMPAD_NUMBER_MODE
;fn/num row
$1:: return
$2:: return
$3::
{
    SetKeyDelay -1
    Send "{Backspace}"
}
$4:: return
$5:: return

;top row
$q:: return
$w:: Send 2
$e:: send 3
$r:: send 4
$t:: return

;home row
$a:: return
$s:: send 1
$d:: send 0
$f:: send 5
$g:: send 9

;bottom row
$z:: return
$x:: send 6
$c:: send 7
$v:: send 8
$b:: return
#HotIf

/*
   --------------------------------------------------
   --------------------------------------------------
   -------press alt to active normal layer 2---------
   --------------------------------------------------
   --------------------------------------------------
*/

NormalLabelAlt() {
    global VIM_NORMAL_SPACE_MODE
    global NORMAL_ALT_MODE
    global NUMBER_MODE
    global SYMBOL_MODE
    global INSERT_MODE
    global INSERT_MODE_II

    if !NORMAL_ALT_MODE {
        NORMAL_ALT_MODE := true
        VIM_NORMAL_SPACE_MODE := false
        NUMBER_MODE := false
        SYMBOL_MODE := false
        INSERT_MODE := false
        INSERT_MODE_II := false

        ToolTip(, , , 2)
        ToolTip(, , , 4)
        ToolTip(, , , 5)
        ToolTip("Normal 2", normal_TooltipX_Alt, 0, 9)
    }
}

#HotIf NORMAL_ALT_MODE
;$1::#^c ;shortcut key to TOGGLE invert color filter
$1:: Send "{PrintScreen}"
$2:: Send "{LWin}"
$3:: Send "{F5}"
$4:: Reload() ; Hotkey to reload the script
$5:: Suspend() ; Hotkey to suspend the script

$d:: Send "{WheelUp 5}" ;scrollspeed:=5
$f:: Send "{WheelDown 5}" ;scrollspeed:=5

;$Alt::
$Space::
{
    global NORMAL_ALT_MODE
    global VIM_NORMAL_SPACE_MODE
    global NUMBER_MODE
    global SYMBOL_MODE
    global INSERT_MODE
    global INSERT_MODE_II
    global TOGGLE

    ToolTip(, , , 2)
    ToolTip(, , , 4)
    ToolTip(, , , 5)
    ToolTip(, , , 9)

    NORMAL_ALT_MODE := false
    VIM_NORMAL_SPACE_MODE := false
    NUMBER_MODE := false
    SYMBOL_MODE := false
    INSERT_MODE := true

    if TOGGLE {
        INSERT_MODE_II := true

        ToolTip("Index", index_TooltipX, 0, 1)
    }

    if LongPress(200) {
        if WinActive("ahk_class Chrome_WidgetWin_1 ahk_exe Code.exe") {
            Send "{Esc}"
            Vim_NormalLabelSpace()  ; Trigger Vim_NormalLabelSpace if VS Code is active
        }
    }
}

;~Alt Up:: InStr(A_PriorKey, 'Alt') && Send('{Esc}')
; https://www.autohotkey.com/boards/viewtopic.php?style=7&t=127153
#HotIf

/*
   --------------------------------------------------
   --------------------------------------------------
   -----------------------gui------------------------
   --------------------------------------------------
   --------------------------------------------------
*/

checkGui() {
    global guiOpen
    global VIM_NORMAL_SPACE_MODE
    global NORMAL_ALT_MODE
    global SYMBOL_MODE
    global NUMBER_MODE
    global INSERT_MODE
    global INSERT_MODE_II

	; Code to execute after the jump
if !guiOpen {
    guiOpen := true
    VIM_NORMAL_SPACE_MODE := false
    NORMAL_ALT_MODE := false
    SYMBOL_MODE := false
    NUMBER_MODE := false
    INSERT_MODE := false
    INSERT_MODE_II := false
    }
}

; Define the remapped hotkeys for switching between GUIs
#HotIf guiOpen
	;fn row
    $1:: Gui1Setup()
    $2:: Gui2Setup()
    $3:: Gui3Setup()
    $4:: Gui4Setup()
    $5:: Gui5Setup()

    ; Top row remapping
    $q::return
    $w::HandleNumber(7)
    $e::HandleNumber(8)
    $r::HandleNumber(9)
    $t::return

    ; Home row remapping
	$a::HandleNumber(1)
    $s::HandleNumber(4)
    $d::HandleNumber(5)
    $f::HandleNumber(6)
    $g::HandleNumber(0)

    ; Bottom row remapping
    $z::return
    $x::HandleNumber(1)
    $c::HandleNumber(2)
    $v::HandleNumber(3)
    $b::return

    $Alt::return
    $Tab::return
    $CapsLock::return
    $Down::return
    $Shift::return
    $Ctrl::return
    $Right::return

$space::
{
    global oGui1, oGui2, oGui3, oGui4, oGui5, oGui6

    global guiOpen, VIM_NORMAL_SPACE_MODE, SYMBOL_MODE, NUMBER_MODE
    global TOGGLE, INSERT_MODE, INSERT_MODE_II

    ; Destroy existing GUIs if they exist
    if IsObject(oGui1) {
        oGui1.Destroy()
        oGui1 := "" ; Optional: Reset variable to indicate no GUI is assigned
    }
    if IsObject(oGui2) {
        oGui2.Destroy()
        oGui2 := ""
    }
    if IsObject(oGui3) {
        oGui3.Destroy()
        oGui3 := ""
    }
    if IsObject(oGui4) {
        oGui4.Destroy()
        oGui4 := ""
    }
    if IsObject(oGui5) {
        oGui5.Destroy()
        oGui5 := ""
    }
    if IsObject(oGui6) {
        oGui6.Destroy()
        oGui6 := ""
    }

    guiOpen := false
    VIM_NORMAL_SPACE_MODE := false
    SYMBOL_MODE := false
    NUMBER_MODE := false
    INSERT_MODE := true

    if TOGGLE {
        INSERT_MODE_II := true
        ToolTip("Index", index_TooltipX, 0, 1)
    }
}
#HotIf

liveDisplayGui() {
    ; Calculate the position for the input display GUI
    ScreenWidth := A_ScreenWidth ; 1920
    ScreenHeight := A_ScreenHeight ; 1080

	DisplayHeight := 40  ; Height of the input display box
	DisplayWidth := 85 ; Width of the input display box

	; Calculate Y position for the bottom of the screen
	DisplayY := ScreenHeight - DisplayHeight - 54  ; 20 pixels above the bottom for padding

	; Calculate X position to center the display horizontally
	DisplayX := (ScreenWidth - DisplayWidth) / 2.05  ; Use '/' for floating-point division

    ; Create the GUI window
    global oGui6 := Gui("+AlwaysOnTop -Caption +ToolWindow")  ; Create the GUI window with flags
    oGui6.BackColor := 'EEAA99'                        ; Set the background color (which will also be the transparent color)
    oGui6.SetFont("Bold s15", "Verdana")  ; Set the font size and style

    ;Set 0x000000 (black) to be transparent (A: 255)
    WinSetTransColor((oGui6.BackColor := 000000) ' 255', oGui6)

    ; Add a text control to display the input
    oGui6.Add("Text", Format("w{} h{} BackgroundWhite center cBlack vLiveDisplay", DisplayWidth, DisplayHeight), NumberInput)

    ; Show the GUI with the specified parameters
    oGui6.Show(Format("x{} y{} w{} h{} NoActivate", DisplayX, DisplayY, DisplayWidth, DisplayHeight))
}

; Define the GUI setups
Gui1Setup() {
    global guiOpen, CurrentGui
	checkGui()
	CurrentGui := 1

    ; Create the GUI window
    global oGui1 := Gui("+AlwaysOnTop -Caption +ToolWindow")  ; Create the GUI window with flags
    oGui1.BackColor := 'EEAA99'                        ; Set the background color (which will also be the transparent color)

    ;Set 0x000000 (black) to be transparent (A: 255)
    WinSetTransColor((oGui1.BackColor := 000000) ' 255', oGui1)

	; Add transparent buttons w 150 h 120
	global ogcGui1Button11Action := oGui1.Add("Button", "x101 y1 w140 h110 BackgroundTrans", "Volume Min")
	ogcGui1Button11Action.OnEvent("Click", Gui1Button11Action)
	global ogcGui1Button12Action := oGui1.Add("Button", "x101 y119 w140 h110 BackgroundTrans ", "Volume Max")
	ogcGui1Button12Action.OnEvent("Click", Gui1Button12Action)
	global ogcGui1Button13Action := oGui1.Add("Button", "x101 y239 w140 h110 BackgroundTrans ", "Volume Mute")
	ogcGui1Button13Action.OnEvent("Click", Gui1Button13Action)
	global ogcGui1Button14Action := oGui1.Add("Button", "x101 y359 w140 h110 BackgroundTrans ", "Show Tooltip")
	ogcGui1Button14Action.OnEvent("Click", Gui1Button14Action)
	global ogcGui1Button15Action := oGui1.Add("Button", "x101 y479 w140 h110 BackgroundTrans ", "INSERT_MODE: " . INSERT_MODE)
	ogcGui1Button15Action.OnEvent("Click", Gui1Button15Action)
;-------------------------------------------------------
	global ogcGui1Button16Action := oGui1.Add("Button", "x251 y1 w140 h110 BackgroundTrans ", "Button 16")
	ogcGui1Button16Action.OnEvent("Click", Gui1Button16Action)
	global ogcGui1Button17Action := oGui1.Add("Button", "x251 y119 w140 h110 BackgroundTrans ", "Button 17")
	ogcGui1Button17Action.OnEvent("Click", Gui1Button17Action)
	global ogcGui1Button18Action := oGui1.Add("Button", "x251 y239 w140 h110 BackgroundTrans ", "Button 18")
	ogcGui1Button18Action.OnEvent("Click", Gui1Button18Action)
	global ogcGui1Button19Action:= oGui1.Add("Button", "x251 y359 w140 h110 BackgroundTrans ", "Button 19")
	ogcGui1Button19Action.OnEvent("Click", Gui1Button19Action)
	global ogcGui1Button20Action := oGui1.Add("Button", "x251 y479 w140 h110 BackgroundTrans ", "Button 20")
	ogcGui1Button20Action.OnEvent("Click", Gui1Button20Action)
;----------------------------------------------------
	global ogcGui1Button21Action := oGui1.Add("Button", "x401 y1 w140 h110 BackgroundTrans ", "Button 21")
	ogcGui1Button21Action.OnEvent("Click", Gui1Button21Action)
	global ogcGui1Button22Action := oGui1.Add("Button", "x401 y119 w140 h110 BackgroundTrans ", "Button 22")
	ogcGui1Button22Action.OnEvent("Click", Gui1Button22Action)
	global ogcGui1Button23Action := oGui1.Add("Button", "x401 y239 w140 h110 BackgroundTrans ", "Button 23")
	ogcGui1Button23Action.OnEvent("Click", Gui1Button23Action)
	global ogcGui1Button24Action := oGui1.Add("Button", "x401 y359 w140 h110 BackgroundTrans ", "Button 24")
	ogcGui1Button24Action.OnEvent("Click", Gui1Button24Action)
	global ogcGui1Button25Action := oGui1.Add("Button", "x401 y479 w140 h110 BackgroundTrans ", "Button 25")
	ogcGui1Button25Action.OnEvent("Click", Gui1Button25Action)
;-------------------------------------
	global ogcGui1Button26Action := oGui1.Add("Button", "x551 y1 w140 h110 BackgroundTrans ", "Button 26")
	ogcGui1Button26Action.OnEvent("Click", Gui1Button26Action)
	global ogcGui1Button27Action := oGui1.Add("Button", "x551 y119 w140 h110 BackgroundTrans ", "Button 27")
	ogcGui1Button27Action.OnEvent("Click", Gui1Button27Action)
	global ogcGui1Button28Action := oGui1.Add("Button", "x551 y239 w140 h110 BackgroundTrans ", CurrentGui)
	ogcGui1Button28Action.OnEvent("Click", Gui1Button28Action)
	global ogcGui1Button29Action := oGui1.Add("Button", "x551 y359 w140 h110 BackgroundTrans ", "Button 29")
	ogcGui1Button29Action.OnEvent("Click", Gui1Button29Action)
	global ogcGui1Button30Action := oGui1.Add("Button", "x551 y479 w140 h110 BackgroundTrans ", "Button 30")
	ogcGui1Button30Action.OnEvent("Click", Gui1Button30Action)
;---------------------------------
	global ogcGui1Button31Action := oGui1.Add("Button", "x701 y1 w140 h110 BackgroundTrans ", "Button 31")
	ogcGui1Button31Action.OnEvent("Click", Gui1Button31Action)
	global ogcGui1Button32Action := oGui1.Add("Button", "x701 y119 w140 h110 BackgroundTrans ", "Button 32")
	ogcGui1Button32Action.OnEvent("Click", Gui1Button32Action)
	global ogcGui1Button33Action := oGui1.Add("Button", "x701 y239 w140 h110 BackgroundTrans ", "Button 33")
	ogcGui1Button33Action.OnEvent("Click", Gui1Button33Action)
	global ogcGui1Button34Action := oGui1.Add("Button", "x701 y359 w140 h110 BackgroundTrans ", "Button 34")
	ogcGui1Button34Action.OnEvent("Click", Gui1Button34Action)
	global ogcGui1Button35Action := oGui1.Add("Button", "x701 y479 w140 h110 BackgroundTrans ", "Button 35")
	ogcGui1Button35Action.OnEvent("Click", Gui1Button35Action)
;-------------------------------------
	global ogcGui1Button36Action := oGui1.Add("Button", "x851 y1 w140 h110 BackgroundTrans ", "Button 36")
	ogcGui1Button36Action.OnEvent("Click", Gui1Button36Action)
	global ogcGui1Button37Action := oGui1.Add("Button", "x851 y119 w140 h110 BackgroundTrans ", "Button 37")
	ogcGui1Button37Action.OnEvent("Click", Gui1Button37Action)
	global ogcGui1Button38Action := oGui1.Add("Button", "x851 y239 w140 h110 BackgroundTrans ", "Button 38")
	ogcGui1Button38Action.OnEvent("Click", Gui1Button38Action)
	global ogcGui1Button39Action := oGui1.Add("Button", "x851 y359 w140 h110 BackgroundTrans ", "Button 39")
	ogcGui1Button39Action.OnEvent("Click", Gui1Button39Action)
	global ogcGui1Button40Action := oGui1.Add("Button", "x851 y479 w140 h110 BackgroundTrans ", "Button 40")
	ogcGui1Button40Action.OnEvent("Click", Gui1Button40Action)
;--------------------------
	global ogcGui1Button41Action := oGui1.Add("Button", "x1001 y1 w140 h110 BackgroundTrans ", "Button 41")
	ogcGui1Button41Action.OnEvent("Click", Gui1Button41Action)
	global ogcGui1Button42Action := oGui1.Add("Button", "x1001 y119 w140 h110 BackgroundTrans ", "Button 42")
	ogcGui1Button42Action.OnEvent("Click", Gui1Button42Action)
	global ogcGui1Button43Action := oGui1.Add("Button", "x1001 y239 w140 h110 BackgroundTrans ", "Button 43")
	ogcGui1Button43Action.OnEvent("Click", Gui1Button43Action)
	global ogcGui1Button44Action:= oGui1.Add("Button", "x1001 y359 w140 h110 BackgroundTrans ", "Button 44")
	ogcGui1Button44Action.OnEvent("Click", Gui1Button44Action)
	global ogcGui1Button45Action := oGui1.Add("Button", "x1001 y479 w140 h110 BackgroundTrans ", "Button 45")
	ogcGui1Button45Action.OnEvent("Click", Gui1Button45Action)

	global ogcGui1Button0Action := oGui1.Add("Button", "x1151 y239 w50 h110 BackgroundTrans ", "Next")
	ogcGui1Button0Action.OnEvent("Click", Gui1Button0Action)

    oGui1.OnEvent('Close', (*) => ExitApp())
	oGui1.Title := "Control Panel"
	oGui1.Show("w1246 h621")  ; Display the GUI with the buttons

	liveDisplayGui()
}

; Define the GUI setups
Gui2Setup() {
    global guiOpen, CurrentGui

	checkGui()
	CurrentGui := 2

    ; Create the GUI window
    global oGui2 := Gui("+AlwaysOnTop -Caption +ToolWindow")  ; Create the GUI window with flags
    oGui2.BackColor := 'EEAA99'                        ; Set the background color (which will also be the transparent color)

    ;Set 0x000000 (black) to be transparent (A: 255)
    WinSetTransColor((oGui2.BackColor := 000000) ' 255', oGui2)

    global ogcGui2Button1Action := oGui2.Add("Button", "x41 y239 w50 h110 BackgroundTrans ", "Prev")
	ogcGui2Button1Action.OnEvent("Click", Gui2Button1Action)

	; Add transparent buttons w 150 h 120
	global ogcGui2Button11Action := oGui2.Add("Button", "x101 y1 w140 h110 BackgroundTrans", "Volume Min")
	;ogcGui2Button11Action.OnEvent("Click", Gui2Button11Action)
	global ogcGui2Button12Action := oGui2.Add("Button", "x101 y119 w140 h110 BackgroundTrans ", "Volume Max")
	;ogcGui2Button12Action.OnEvent("Click", Gui2Button12Action)
	global ogcGui2Button13Action := oGui2.Add("Button", "x101 y239 w140 h110 BackgroundTrans ", "Volume Mute")
	;ogcGui2Button13Action.OnEvent("Click", Gui2Button13Action)
	global ogcGui2Button14Action := oGui2.Add("Button", "x101 y359 w140 h110 BackgroundTrans ", "Show Tooltip")
	;ogcGui2Button14Action.OnEvent("Click", Gui2Button14Action)
	global ogcGui2Button15Action := oGui2.Add("Button", "x101 y479 w140 h110 BackgroundTrans ", "guiOpen: " . guiOpen)
	ogcGui2Button15Action.OnEvent("Click", Gui2Button15Action)
;-------------------------------------------------------
	global ogcGui2Button16Action := oGui2.Add("Button", "x251 y1 w140 h110 BackgroundTrans ", "Button 16")
	;ogcGui2Button16Action.OnEvent("Click", Gui2Button16Action)
	global ogcGui2Button17Action := oGui2.Add("Button", "x251 y119 w140 h110 BackgroundTrans ", "Button 17")
	;ogcGui2Button17Action.OnEvent("Click", Gui2Button17Action)
	global ogcGui2Button18Action := oGui2.Add("Button", "x251 y239 w140 h110 BackgroundTrans ", "Button 18")
	;ogcGui2Button18Action.OnEvent("Click", Gui2Button18Action)
	global ogcGui2Button19Action:= oGui2.Add("Button", "x251 y359 w140 h110 BackgroundTrans ", "Button 19")
	;ogcGui2Button19Action.OnEvent("Click", Gui2Button19Action)
	global ogcGui2Button20Action := oGui2.Add("Button", "x251 y479 w140 h110 BackgroundTrans ", "Button 20")
	;ogcGui2Button20Action.OnEvent("Click", Gui2Button20Action)
;----------------------------------------------------
	global ogcGui2Button21Action := oGui2.Add("Button", "x401 y1 w140 h110 BackgroundTrans ", "Button 21")
	;ogcGui2Button21Action.OnEvent("Click", Gui2Button21Action)
	global ogcGui2Button22Action := oGui2.Add("Button", "x401 y119 w140 h110 BackgroundTrans ", "Button 22")
	;ogcGui2Button22Action.OnEvent("Click", Gui2Button22Action)
	global ogcGui2Button23Action := oGui2.Add("Button", "x401 y239 w140 h110 BackgroundTrans ", "Button 23")
	;ogcGui2Button23Action.OnEvent("Click", Gui2Button23Action)
	global ogcGui2Button24Action := oGui2.Add("Button", "x401 y359 w140 h110 BackgroundTrans ", "Button 24")
	;ogcGui2Button24Action.OnEvent("Click", Gui2Button24Action)
	global ogcGui2Button25Action := oGui2.Add("Button", "x401 y479 w140 h110 BackgroundTrans ", "Button 25")
	;ogcGui2Button25Action.OnEvent("Click", Gui2Button25Action)
;-------------------------------------
	global ogcGui2Button26Action := oGui2.Add("Button", "x551 y1 w140 h110 BackgroundTrans ", "Button 26")
	;ogcGui2Button26Action.OnEvent("Click", Gui2Button26Action)
	global ogcGui2Button27Action := oGui2.Add("Button", "x551 y119 w140 h110 BackgroundTrans ", "Button 27")
	;ogcGui2Button27Action.OnEvent("Click", Gui2Button27Action)
	global ogcGui2Button28Action := oGui2.Add("Button", "x551 y239 w140 h110 BackgroundTrans ", CurrentGui)
	ogcGui2Button28Action.OnEvent("Click", Gui2Button28Action)
	global ogcGui2Button29Action := oGui2.Add("Button", "x551 y359 w140 h110 BackgroundTrans ", "Button 29")
	;ogcGui2Button29Action.OnEvent("Click", Gui2Button29Action)
	global ogcGui2Button30Action := oGui2.Add("Button", "x551 y479 w140 h110 BackgroundTrans ", "Button 30")
	;ogcGui2Button30Action.OnEvent("Click", Gui2Button30Action)
;---------------------------------
	global ogcGui2Button31Action := oGui2.Add("Button", "x701 y1 w140 h110 BackgroundTrans ", "Button 31")
	;ogcGui2Button31Action.OnEvent("Click", Gui2Button31Action)
	global ogcGui2Button32Action := oGui2.Add("Button", "x701 y119 w140 h110 BackgroundTrans ", "Button 32")
	;ogcGui2Button32Action.OnEvent("Click", Gui2Button32Action)
	global ogcGui2Button33Action := oGui2.Add("Button", "x701 y239 w140 h110 BackgroundTrans ", "Button 33")
	;ogcGui2Button33Action.OnEvent("Click", Gui2Button33Action)
	global ogcGui2Button34Action := oGui2.Add("Button", "x701 y359 w140 h110 BackgroundTrans ", "Button 34")
	;ogcGui2Button34Action.OnEvent("Click", Gui2Button34Action)
	global ogcGui2Button35Action := oGui2.Add("Button", "x701 y479 w140 h110 BackgroundTrans ", "Button 35")
	;ogcGui2Button35Action.OnEvent("Click", Gui2Button35Action)
;-------------------------------------
	global ogcGui2Button36Action := oGui2.Add("Button", "x851 y1 w140 h110 BackgroundTrans ", "Button 36")
	;ogcGui2Button36Action.OnEvent("Click", Gui2Button36Action)
	global ogcGui2Button37Action := oGui2.Add("Button", "x851 y119 w140 h110 BackgroundTrans ", "Button 37")
	;ogcGui2Button37Action.OnEvent("Click", Gui2Button37Action)
	global ogcGui2Button38Action := oGui2.Add("Button", "x851 y239 w140 h110 BackgroundTrans ", "Button 38")
	;ogcGui2Button38Action.OnEvent("Click", Gui2Button38Action)
	global ogcGui2Button39Action := oGui2.Add("Button", "x851 y359 w140 h110 BackgroundTrans ", "Button 39")
	;ogcGui2Button39Action.OnEvent("Click", Gui2Button39Action)
	global ogcGui2Button40Action := oGui2.Add("Button", "x851 y479 w140 h110 BackgroundTrans ", "Button 40")
	;ogcGui2Button40Action.OnEvent("Click", Gui2Button40Action)
;--------------------------
	global ogcGui2Button41Action := oGui2.Add("Button", "x1001 y1 w140 h110 BackgroundTrans ", "Button 41")
	;ogcGui2Button41Action.OnEvent("Click", Gui2Button41Action)
	global ogcGui2Button42Action := oGui2.Add("Button", "x1001 y119 w140 h110 BackgroundTrans ", "Button 42")
	;ogcGui2Button42Action.OnEvent("Click", Gui2Button42Action)
	global ogcGui2Button43Action := oGui2.Add("Button", "x1001 y239 w140 h110 BackgroundTrans ", "Button 43")
	;ogcGui2Button43Action.OnEvent("Click", Gui2Button43Action)
	global ogcGui2Button44Action:= oGui2.Add("Button", "x1001 y359 w140 h110 BackgroundTrans ", "Button 44")
	;ogcGui2Button44Action.OnEvent("Click", Gui2Button44Action)
	global ogcGui2Button45Action := oGui2.Add("Button", "x1001 y479 w140 h110 BackgroundTrans ", "Button 45")
	;ogcGui2Button45Action.OnEvent("Click", Gui2Button45Action)

	global ogcGui2Button0Action := oGui2.Add("Button", "x1151 y239 w50 h110 BackgroundTrans ", "Next")
	ogcGui2Button0Action.OnEvent("Click", Gui2Button0Action)

    oGui2.OnEvent('Close', (*) => ExitApp())
	oGui2.Title := "Control Panel"
	oGui2.Show("w1246 h621")  ; Display the GUI with the buttons
}

Gui3Setup() {
    global guiOpen, CurrentGui

	checkGui()
	CurrentGui := 3

    global oGui3 := Gui("+LastFound +AlwaysOnTop -Caption +ToolWindow")
    oGui3.BackColor := "EEAA99"
    oGui3.Add("Text", "x10 y10 w200 h30", CurrentGui)

    global ogcGui3Button1Action := oGui3.Add("Button", "x100 y100 w200 h50 ", "Prev")
	ogcGui3Button1Action.OnEvent("Click", Gui3Button1Action)
	global ogcGui3Button0Action := oGui3.Add("Button", "x100 y200 w200 h50 ", "Next")
	ogcGui3Button0Action.OnEvent("Click", Gui3Button0Action)

    oGui3.Title := "Control Panel"
    oGui3.Show("w400 h300")
}

Gui4Setup() {
    global guiOpen, CurrentGui

	checkGui()
	CurrentGui := 4

    global oGui4 := Gui("+LastFound +AlwaysOnTop -Caption +ToolWindow")
    oGui4.BackColor := "EEAA99"
    oGui4.Add("Text", "x10 y10 w200 h30", CurrentGui)

    global ogcGui4Button1Action := oGui4.Add("Button", "x100 y100 w200 h50 ", "Prev")
	ogcGui4Button1Action.OnEvent("Click", Gui4Button1Action)
	global ogcGui4Button0Action := oGui4.Add("Button", "x100 y200 w200 h50 ", "Next")
	ogcGui4Button0Action.OnEvent("Click", Gui4Button0Action)

    oGui4.Title := "Control Panel"
    oGui4.Show("w400 h300")
}

Gui5Setup() {
    global guiOpen, CurrentGui

	checkGui()
	CurrentGui := 5

    global oGui5 := Gui("+LastFound +AlwaysOnTop -Caption +ToolWindow")
    oGui5.BackColor := "EEAA99"
    oGui5.Add("Text", "x10 y10 w200 h30", CurrentGui)

    global ogcGui5Button1Action := oGui5.Add("Button", "x100 y100 w200 h50 ", "Prev")
	ogcGui5Button1Action.OnEvent("Click", Gui5Button1Action)

    oGui5.Title := "Control Panel"
    oGui5.Show("w400 h300")
}

; Handle number input and update live display
HandleNumber(Num) {
    global oGui6, guiOpen, NumberInput, LastInputTime
    if (guiOpen) {  ; Only process input when GUI is open
        ; Only allow input if the length is less than 2 digits
        if (StrLen(NumberInput) < 2) {
            NumberInput .= Num  ; Append the new number to the input
            LastInputTime := A_TickCount
		}
            oGui6["LiveDisplay"].Value := NumberInput ; Update the live input display

            SetTimer(ProcessInput, -500)  ; Start a timer to wait for 500ms
    }
}

ProcessInput()
{
    global guiOpen, NumberInput, LastInputTime, oGui6

    if (guiOpen && (A_TickCount - LastInputTime >= 500)) {
        ; Check if the input is a valid button number

        if (CurrentGui = 1) && (Gui1ButtonNumber(NumberInput))
            Gui1Button%NumberInput%Action()  ; Trigger corresponding button action
        else if (CurrentGui = 2) && (Gui2ButtonNumber(NumberInput))
            Gui2Button%NumberInput%Action()  ; Trigger corresponding button action
        else if (CurrentGui = 3) && (Gui3ButtonNumber(NumberInput))
            Gui3Button%NumberInput%Action()  ; Trigger corresponding button action
        else if (CurrentGui = 4) && (Gui4ButtonNumber(NumberInput))
            Gui4Button%NumberInput%Action()  ; Trigger corresponding button action
        else if (CurrentGui = 5) && (Gui5ButtonNumber(NumberInput))
            Gui5Button%NumberInput%Action()  ; Trigger corresponding button action
        else
            NumberInput := "" ; If not a valid button number, reset the input

    ; Reset the display and input fields
    oGui6["LiveDisplay"].Value := "..."  ; Clear the live input display
    NumberInput := ""  ; Reset the input after handling
    }
}

Gui1ButtonNumber(Num) {
    return (Num >= 11 && Num <= 45) || (Num = 0) || (Num = 1) ; Return true only for numbers between 11 and 45
}

Gui2ButtonNumber(Num) {
    return (Num = 0) || (Num = 1) || (Num = 15) || (Num = 28)
}

Gui3ButtonNumber(Num) {
    return (Num = 0) || (Num = 1)
}

Gui4ButtonNumber(Num) {
    return (Num = 0) || (Num = 1)
}

Gui5ButtonNumber(Num) {
    return (Num = 0) || (Num = 1)
}
; -----------------------------DestroyGui--------------------------------------

DestroyGui() {
    global oGui1, oGui2, oGui3, oGui4, oGui5, oGui6

    ; Destroy existing GUIs if they exist
    if IsObject(oGui1) {
        oGui1.Destroy()
        oGui1 := "" ; Optional: Reset variable to indicate no GUI is assigned
    }
    if IsObject(oGui2) {
        oGui2.Destroy()
        oGui2 := ""
    }
    if IsObject(oGui3) {
        oGui3.Destroy()
        oGui3 := ""
    }
    if IsObject(oGui4) {
        oGui4.Destroy()
        oGui4 := ""
    }
    if IsObject(oGui5) {
        oGui5.Destroy()
        oGui5 := ""
    }
}

Gui1Button1Action(*) ; 1 for prev
{
}

Gui1Button0Action(*) ; 0 for next
{
    DestroyGui()
    Gui2Setup()
}

Gui2Button1Action(*) ; 1 for prev
{
    DestroyGui()
    Gui1Setup()
}

Gui2Button0Action(*) ; 0 for next
{
    DestroyGui()
    Gui3Setup()
}

Gui3Button1Action(*) ; 1 for prev
{
    DestroyGui()
    Gui2Setup()
}

Gui3Button0Action(*) ; 0 for next
{
    DestroyGui()
    Gui4Setup()
}

Gui4Button1Action(*) ; 1 for prev
{
    DestroyGui()
    Gui3Setup()
}

Gui4Button0Action(*) ; 0 for next
{
    DestroyGui()
    Gui5Setup()
}

Gui5Button1Action(*) ; 1 for prev
{
    DestroyGui()
    Gui4Setup()
}

Gui5Button0Action(*) ; 0 for next
{
}

; ---------------------------------Gui1-----------------------------------------

Gui1Button11Action(*)
{
    ;global ogcGui1Button11Action

    ; Set volume to 0 (mute)
	SoundSetVolume(0)  ; Mute the system volume
	ToolTip(ogcGui1Button11Action.Text)
	Sleep(1000)
    ToolTip()
}

Gui1Button12Action(*)
{
	ToolTip(ogcGui1Button12Action.Text)
	Sleep(1000)
    ToolTip()
}

Gui1Button13Action(*)
{
	ToolTip(ogcGui1Button13Action.Text)
	Sleep(1000)
    ToolTip()
}

Gui1Button14Action(*)
{
	ToolTip(ogcGui1Button14Action.Text)
	Sleep(1000)
    ToolTip()
}

Gui1Button15Action(*)
{
	ToolTip(ogcGui1Button15Action.Text)
	Sleep(1000)
    ToolTip()
}

Gui1Button16Action(*)
{
	ToolTip(ogcGui1Button16Action.Text)
	Sleep(1000)
    ToolTip()
}

Gui1Button17Action(*)
{
	ToolTip(ogcGui1Button17Action.Text)
	Sleep(1000)
    ToolTip()
}

Gui1Button18Action(*)
{
	ToolTip(ogcGui1Button18Action.Text)
	Sleep(1000)
    ToolTip()
}

Gui1Button19Action(*)
{
	ToolTip(ogcGui1Button19Action.Text)
	Sleep(1000)
    ToolTip()
}

Gui1Button20Action(*)
{
	ToolTip(ogcGui1Button20Action.Text)
	Sleep(1000)
    ToolTip()
}

Gui1Button21Action(*)
{
    ToolTip(ogcGui1Button21Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button22Action(*)
{
    ToolTip(ogcGui1Button22Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button23Action(*)
{
    ToolTip(ogcGui1Button23Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button24Action(*)
{
    ToolTip(ogcGui1Button24Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button25Action(*)
{
    ToolTip(ogcGui1Button25Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button26Action(*)
{
    ToolTip(ogcGui1Button26Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button27Action(*)
{
    ToolTip(ogcGui1Button27Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button28Action(*)
{
    ToolTip(ogcGui1Button28Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button29Action(*)
{
    ToolTip(ogcGui1Button29Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button30Action(*)
{
    ToolTip(ogcGui1Button30Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button31Action(*)
{
    ToolTip(ogcGui1Button31Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button32Action(*)
{
    ToolTip(ogcGui1Button32Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button33Action(*)
{
    ToolTip(ogcGui1Button33Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button34Action(*)
{
    ToolTip(ogcGui1Button34Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button35Action(*)
{
    ToolTip(ogcGui1Button35Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button36Action(*)
{
    ToolTip(ogcGui1Button36Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button37Action(*)
{
    ToolTip(ogcGui1Button37Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button38Action(*)
{
    ToolTip(ogcGui1Button38Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button39Action(*)
{
    ToolTip(ogcGui1Button39Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button40Action(*)
{
    ToolTip(ogcGui1Button40Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button41Action(*)
{
    ToolTip(ogcGui1Button41Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button42Action(*)
{
    ToolTip(ogcGui1Button42Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button43Action(*)
{
    ToolTip(ogcGui1Button43Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button44Action(*)
{
    ToolTip(ogcGui1Button44Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui1Button45Action(*)
{
    ToolTip(ogcGui1Button45Action.Text)
    Sleep(1000)
    ToolTip()
}

; ---------------------------------Gui2-----------------------------------------

Gui2Button15Action(*) {
    ToolTip(ogcGui2Button15Action.Text)
    Sleep(1000)
    ToolTip()
}

Gui2Button28Action(*)
{
    ToolTip(ogcGui2Button28Action.Text)
    Sleep(1000)
    ToolTip()
}

/*
   -----------------------------------------------
   ---------------Productivity mouse--------------
   -----------------------------------------------
   -----------------------------------------------
*/

/*
RButton::
{

    g := Morse(300)
    If (g = "00") {
        ;MsgBox("00 Pressed")


        if WinActive("ahk_class Chrome_WidgetWin_1 ahk_exe Code.exe") {
            if !VIM_NORMAL_SPACE_MODE {

                A_Clipboard := ""  ; Clear the clipboard
                Send("^ c")        ; Simulate Ctrl+C to copy selected text
                Errorlevel := !ClipWait(1)     ; Wait for up to 1 second for the clipboard to contain data
                if (ErrorLevel)
                    MsgBox("Clipboard did not contain any data within 1 second.")
                else
                    MsgBox("Copied text: " A_Clipboard) ; Show the copied content
            }
            Send("a")
        }
*/

/*
else
    Clipboard := ""  ; Clear the clipboard
Send, ^ c        ; Simulate Ctrl+C to copy selected text
ClipWait, 1     ; Wait for up to 1 second for the clipboard to contain data
if (ErrorLevel)
    MsgBox, Clipboard did not contain any data within 1 second.
else
    MsgBox, Copied text: %Clipboard% ; Show the copied content
*/
/*
    }
    Else If (g = "0")
 MsgBox("0 Pressed")
    ;Send "{ RButton }" ; single short click to send rbutton
    Return
}
*/
;---------------------------------------------------------------------------

; --------------------------------------------------------------------------
/*
mbutton::
{ ; V1toV2: Added bracket
    global ; V1toV2: Made function global
    CoordMode("Mouse", "Screen")
    MouseGetPos(&XposA, &YposA)
    XposA -= 80
    YposA -= 80
    oGui50 := Gui()
    oGui50.destroy()
    oGui50.BackColor := "EEAA99"

    ; Buttons (1st column)
    ogcButtonButton1 := oGui50.Add("Button", "x2 y0 w50 h50 BackgroundTrans gdothis10", "Button 1")
    ogcButtonButton1.OnEvent("Click", 50ButtonButton1.Bind("Normal"))
    ogcButtonUndo := oGui50.Add("Button", "x2 y60 w50 h50 BackgroundTrans gdothis20", "Undo")
    ogcButtonUndo.OnEvent("Click", 50ButtonUndo.Bind("Normal"))
    ogcButtonRedo := oGui50.Add("Button", "x2 y120 w50 h50 BackgroundTrans gdothis30", "Redo")
    ogcButtonRedo.OnEvent("Click", 50ButtonRedo.Bind("Normal"))
    ogcButton := oGui50.Add("Button", "x2 y180 w50 h50 BackgroundTrans gdothis40")
    ogcButton.OnEvent("Click", 50Button.Bind("Normal"))
    ogcButton := oGui50.Add("Button", "x2 y240 w50 h50 BackgroundTrans gdothis50")
    ogcButton.OnEvent("Click", 50Button.Bind("Normal"))

    ; Buttons (2nd column)
    ogcButton := oGui50.Add("Button", "x62 y0 w50 h50")
    ogcButton.OnEvent("Click", 50Button.Bind("Normal"))
    ogcButtonCut := oGui50.Add("Button", "x62 y60 w50 h50 BackgroundTrans gdothis3", "Cut")
    ogcButtonCut.OnEvent("Click", 50ButtonCut.Bind("Normal"))
    ogcButtonClose := oGui50.Add("Button", "x62 y120 w50 h50 BackgroundTrans gclosewanrmenu", "Close")
    ogcButtonClose.OnEvent("Click", 50ButtonClose.Bind("Normal"))
    ogcButtonNewButton9 := oGui50.Add("Button", "x62 y180 w50 h50 BackgroundTrans gdothis14", "New Button 9")
    ogcButtonNewButton9.OnEvent("Click", 50ButtonNewButton9.Bind("Normal"))
    ogcButtonNewButton10 := oGui50.Add("Button", "x62 y240 w50 h50 BackgroundTrans gdothis15", "New Button 10")
    ogcButtonNewButton10.OnEvent("Click", 50ButtonNewButton10.Bind("Normal"))

    ; Buttons (3rd column)
    ogcButtonMinimize := oGui50.Add("Button", "x122 y0 w50 h50 BackgroundTrans gdothis5", "Minimize")
    ogcButtonMinimize.OnEvent("Click", 50ButtonMinimize.Bind("Normal"))
    ogcButtonCopy := oGui50.Add("Button", "x122 y60 w50 h50 BackgroundTrans gdothis4", "Copy")
    ogcButtonCopy.OnEvent("Click", 50ButtonCopy.Bind("Normal"))
    ogcButtonNewButton11 := oGui50.Add("Button", "x122 y180 w50 h50 BackgroundTrans gdothis11", "New Button 11")
    ogcButtonNewButton11.OnEvent("Click", 50ButtonNewButton11.Bind("Normal"))
    ogcButtonNewButton12 := oGui50.Add("Button", "x122 y240 w50 h50 BackgroundTrans gdothis32", "New Button 12")
    ogcButtonNewButton12.OnEvent("Click", 50ButtonNewButton12.Bind("Normal"))

    ; Buttons (4th column)
    ogcButtonMaximize := oGui50.Add("Button", "x182 y0 w50 h50 BackgroundTrans gdothis1", "Maximize")
    ogcButtonMaximize.OnEvent("Click", 50ButtonMaximize.Bind("Normal"))
    ogcButtonPaste := oGui50.Add("Button", "x182 y60 w50 h50 BackgroundTrans gdothis2", "Paste")
    ogcButtonPaste.OnEvent("Click", 50ButtonPaste.Bind("Normal"))
    ogcButtonNewButton13 := oGui50.Add("Button", "x182 y120 w50 h50 BackgroundTrans gdothis13", "New Button 13")
    ogcButtonNewButton13.OnEvent("Click", 50ButtonNewButton13.Bind("Normal"))
    ogcButtonNewButton14 := oGui50.Add("Button", "x182 y180 w50 h50 BackgroundTrans gdothis14", "New Button 14")
    ogcButtonNewButton14.OnEvent("Click", 50ButtonNewButton14.Bind("Normal"))
    ogcButtonNewButton59 := oGui50.Add("Button", "x182 y240 w50 h50 BackgroundTrans gdothis59", "New Button 59")
    ogcButtonNewButton59.OnEvent("Click", 50ButtonNewButton59.Bind("Normal"))
    ; New Buttons (5th column)
    ogcButtonClose := oGui50.Add("Button", "x242 y0 w50 h50 BackgroundTrans gdothis9", "Close")
    ogcButtonClose.OnEvent("Click", 50ButtonClose.Bind("Normal"))
    ogcButtonSelectAll := oGui50.Add("Button", "x242 y60 w50 h50 BackgroundTrans gdothis100", "Select All")
    ogcButtonSelectAll.OnEvent("Click", 50ButtonSelectAll.Bind("Normal"))
    ogcButtonNewButton6 := oGui50.Add("Button", "x242 y120 w50 h50 BackgroundTrans gdothis111", "New Button 6")
    ogcButtonNewButton6.OnEvent("Click", 50ButtonNewButton6.Bind("Normal"))
    ogcButtonNewButton99 := oGui50.Add("Button", "x242 y180 w50 h50 BackgroundTrans gdothis99", "New Button 99")
    ogcButtonNewButton99.OnEvent("Click", 50ButtonNewButton99.Bind("Normal"))
    ogcButtonNewButton78 := oGui50.Add("Button", "x242 y240 w50 h50 BackgroundTrans gdothis78", "New Button 78")
    ogcButtonNewButton78.OnEvent("Click", 50ButtonNewButton78.Bind("Normal"))

    oGui50.Opt("+LastFound +AlwaysOnTop +ToolWindow")
    WinSetTransColor("EEAA99")
    oGui50.Opt("-Caption")
    oGui50.Title := "menus"
    oGui50.Show("x" . XposA . " y" . YposA . " h300 w299") ; Adjust width to accommodate the new columns
    Return

    SetTitleMatchMode(2)

closewanrmenu:
    oGui50.Destroy()
    return

    ; Button actions
dothis1:
    oGui50.Destroy()
    WinMaximize("A")
    Return

dothis2:
    Send("^p")
    Return

dothis3:
    Send("^x")
    Return

dothis4:
    Send("^c")
    Return

dothis5:
    oGui50.Destroy()
    WinMinimize("A")
    Return

dothis6:
    oGui50.Destroy()
    MsgBox("New Button 1")
    Return

dothis7:
    oGui50.Destroy()
    MsgBox("New Button 2")
    Return

dothis8:
    oGui50.Destroy()
    MsgBox("New Button 3")
    Return

dothis9:
    oGui50.Destroy()
    WinClose("A")
    Return

dothis10:
    oGui50.Destroy()
    MsgBox("New Button 5")
    Return

dothis11:
    oGui50.Destroy()
    MsgBox("New Button 6")
    Return

dothis12:
    oGui50.Destroy()
    MsgBox("New Button 7")
    Return

dothis13:
    oGui50.Destroy()
    MsgBox("New Button 8")
    Return

dothis14:
    oGui50.Destroy()
    MsgBox("New Button 9")
    Return

dothis15:
    oGui50.Destroy()
    MsgBox("New Button 10")
    Return

dothis20:
    Send("^z") ;undo
    Return

dothis30:
    Send("^y") ;redo
    Return

dothis32:
    oGui50.Destroy()
    MsgBox("New Button 17")
    Return

dothis40:
    oGui50.Destroy()
    MsgBox("New Button 13")
    Return

dothis50:
    oGui50.Destroy()
    MsgBox("New Button 14")
    Return

dothis100:
    Send("^a")
    Return

dothis111:
    oGui50.Destroy()
    MsgBox("New Button 15")
    Return

dothis59:
    oGui50.Destroy()
    MsgBox("New Button 59")
    Return

dothis99:
    oGui50.Destroy()
    MsgBox("New Button 99")
    Return

dothis78:
    oGui50.Destroy()
    MsgBox("New Button 78")
    Return
}
*/

/*
f1::
{
    global ; V1toV2: Made function global
    MyMenu := Menu()
    MyMenu.Add("A Item 1", item1handler)
    MyMenu.Add("B Item 2", item2handler)
    MyMenu.Show()
    Return
} ; V1toV2: Added bracket before function
item1handler(A_ThisMenuItem := "", A_ThisMenuItemPos := "", MyMenu := "", *)
{ ; V1toV2: Added bracket
    global ; V1toV2: Made function global
    MsgBox("You pressed item 1")
    Return
} ; V1toV2: Added Bracket before label
item2handler(A_ThisMenuItem := "", A_ThisMenuItemPos := "", MyMenu := "", *)
{ ; V1toV2: Added bracket
    global ; V1toV2: Made function global
    MsgBox("You pressed item 2")
    Return
}
*/

/*
   ----------------------------------------------
   ----------------------------------------------
   --------------chrome autmation----------------
   ----------------------------------------------
   ----------------------------------------------
*/

#HotIf WinActive("ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe",)
$space:: Send "{Space Down}"
$space Up:: Send "{Space Up}"
#HotIf

/*
   ----------------------------------------------
   ----------------------------------------------
   -----------------Hotstring--------------------
   ----------------------------------------------
   ----------------------------------------------
*/


; Can be used as normal hotstrings
XHotstring("::omg", "oh my god")
XHotstring(":*:ahk", "autohotkey")

XHotstring("::fyi", "for your information")
XHotstring("::afaik", "as far as I know")
XHotstring("::thats", "that's")
XHotstring(":B0:btw", " by the way")
XHotstring(":*:s@", "shanto.ewu99@gmail.com")

;XHotstring.EndChars := "-,.?!`n"  ; Only hyphen, comma, period, question mark, and Enter trigger the hotstring.

; Type Unicode characters with '{U+1234}' (any four hexadecimal numbers)
XHotstring(":O:{U\+([0-9A-F]{4})}", "{U+$1}")

; Type 'input: ', then some word/letters/numbers, and press an end character to display the written string
XHotstring("::input: (\S+)", (Match, *) => (ToolTip("You wrote: '" Match[1] "'"), SetTimer(ToolTip, -3000)))


/*
  ----------------------------------------------
  ----------------------------------------------
  ----------------change volume-----------------
  ----------------------------------------------
  ----------------------------------------------
*/

#HotIf MouseIsOver("ahk_class Shell_TrayWnd")
WheelUp:: Send "{Volume_Up}"
WheelDown:: Send "{Volume_Down}"
#HotIf

MouseIsOver(WinTitle)
{
    MouseGetPos(, , &Win)
    Return WinExist(WinTitle . " ahk_id " . Win)
}

/*
   ----------------------------------------------
   ----------------------------------------------
   -------------Other additional code------------
   ----------------------------------------------
   ----------------------------------------------
*/

tapMode(physicalKey, shortTap, longTap)
{
    if (physicalKey == "" && longTap == "") {
        Send("{blind}{" shortTap "}")
    }
    else {
        ErrorLevel := !KeyWait(physicalKey, "T0.16")

        if (ErrorLevel) {
            SetKeyDelay(-1)
            Send("{blind}{" longTap "}")
        }
        else {
            SetKeyDelay(-1)
            Send("{blind}{" shortTap "}")
        }

        ErrorLevel := !KeyWait(physicalKey)
        return
    }
}

indexMode(key) {
    ; Check if Ctrl is pressed
    if GetKeyState("Ctrl", "P") {
        SendInput("{Ctrl down}" key "{Ctrl up}")  ; Send Ctrl+u

        ; Check if Alt is pressed
    } else if GetKeyState("Alt", "P") {
        SendInput("{Alt down}" key "{Alt up}")  ; Send Alt+u

        ; Check if Shift is pressed
    } else if GetKeyState("Shift", "P") {
        SendInput("{Shift down}" key "{Shift up}")  ; Send Shift+u (uppercase U)

        ; If no modifier is pressed
    } else
        SendInput(key)   ; Send lowercase u
}

LongPress(Timeout) {
    RegExMatch(Hotkey := A_ThisHotkey, "\W$|\w*$", &Key)
    KeyWait((Key && Key[0]))
    IF ((Key && Key[0]) Hotkey) != (A_PriorKey A_ThisHotkey)
        Exit()
    Return A_TimeSinceThisHotkey > Timeout
}

Morse(Timeout) {
    tout := Timeout / 1000
    key := RegExReplace(A_ThisHotKey, "[\*\~\$\#\+\!\^]")
    Loop {
        t := A_TickCount
        ErrorLevel := !KeyWait(key)
        Pattern .= A_TickCount - t > Timeout
        ErrorLevel := !KeyWait(key, "DT" tout)
        if (ErrorLevel)
            Return Pattern
    }
}
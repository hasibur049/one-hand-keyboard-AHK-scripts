#Requires AutoHotkey v2
;#include <UIA> ; Uncomment if you have moved UIA.ahk to your main Lib folder
#include C:\Users\Dell\Downloads\UIA-v2-main\Lib\UIA.ahk

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

;IS_RBUTTON_DOWN := false ; Initialize flags to track the state of RButton down
;global CapsLockArrow := false

; CHECK_IS_ON_VIM_VISUAL_SPACE_MODE := false
; CHECK_IS_ON_VIM_NORMAL_SPACE_MODE := false
; VSCodeTabSwitchWhileInsetMode := false
VISUAL_MODE := false
DELETE_MODE := false
YANK_MODE := false
CHANGE_MODE := false

char_visual := false
line_visual := false
block_visual := false

; Global variables to track which GUI is currently displayed
; CurrentGui := 1
; TotalGuis := 5
; guiOpen := false

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

;----------------------------------------------------------------------------------------

; Initialize the variable to track if VS Code is active
global IsVSCodeActive := False

; Set up a timer that only checks every second while VS Code is active
SetTimer(CheckActiveWindow, 100)  ; Poll every 500 ms (half second) only when VS Code is active

CheckActiveWindow() {
    global IsVSCodeActive
    global VIM_NORMAL_SPACE_MODE
    global VISUAL_MODE
    global SYMBOL_MODE
    global NUMBER_MODE
    global TOGGLE
    global INSERT_MODE
    global INSERT_MODE_II

    ; V1toV2: Removed SetBatchLines, -1
    DetectHiddenWindows(true)

    if !WinExist("A")  ; Check if there is an active window
        return

    ; Get the title of the currently active window
    activeTitle := WinGetTitle("A")

    ; Check if the active window is Visual Studio Code
    if InStr(activeTitle, "Visual Studio Code") {
        if !IsVSCodeActive {
            IsVSCodeActive := True

            VimModeLibrary(activeTitle)
        }
    }
    else
    {
        if IsVSCodeActive {
            IsVSCodeActive := False

            ToolTip(, , , 2)
            ToolTip(, , , 4)
            ToolTip(, , , 5)
            ToolTip(, , , 10)
            ;ToolTip,,,,9

            VIM_NORMAL_SPACE_MODE := false
            VISUAL_MODE := false
            SYMBOL_MODE := false
            NUMBER_MODE := false


            ;guiOpen := false
            ;CHECK_IS_ON_VIM_NORMAL_SPACE_MODE := true
            INSERT_MODE := true

            if TOGGLE {
                INSERT_MODE_II := true

                ToolTip("Index", index_TooltipX, 0, 1)
            }
        }
    }
}

;-----------------------------------------------------------------------------------
/*
SetTimer(CheckTabChange, 100)  ; Check every 100ms

global prevTitle := ""

CheckTabChange() {
    global prevTitle

    ; Check if the active window belongs to VS Code
    if !WinActive("ahk_class Chrome_WidgetWin_1 ahk_exe Code.exe")
        return
    else
    ; Get the active window's title
        currentTitle := WinGetTitle("ahk_class Chrome_WidgetWin_1 ahk_exe Code.exe")  ; Directly get the active window's title

    VimStatusEl := UIA.ElementFromHandle(currentTitle)

    if !VimStatusEl
        return

    match := VimStatusEl.FindElement({ AutomationId: "vscodevim.vim.primary" }) ;works

    if !match
        return

    mode := match.Name ; live element

    ; Ensure the title is valid and has changed from the previous title
    if (currentTitle != "" && currentTitle != prevTitle) {
        ;prevTitle := currentTitle
        ; Perform action on tab change
        ;MsgBox("Tab changed to: " currentTitle)
        ; Get the Vim mode element

        if (mode == "-- NORMAL --") {
            ;ToolTip("Normal", vim_normal_TooltipX_Space, 0, 2)
            Vim_NormalLabelSpace()
        } else if (mode == "-- VISUAL --")
            Vim_VisualLabel()
        else {
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
    prevTitle := currentTitle
}
*/
;-------------------------------------------------------------------------------

VimModeLibrary(activeTitle) {
    global TOGGLE
    global INSERT_MODE
    global INSERT_MODE_II
    global VIM_NORMAL_SPACE_MODE := false
    global VISUAL_MODE := false

    ; Get the Vim mode element
    VimStatusEl := UIA.ElementFromHandle(activeTitle)

    if !VimStatusEl
        return

    ;match := VimStatusEl.FindElement({ AutomationId: "vscodevim.vim.primary" }) ;works

    try {
        match := VimStatusEl.FindElement({ AutomationId: "vscodevim.vim.primary" }) ; Try finding the element
    } catch {
        ; Handle the error if element is not found
        ; MsgBox("Error: An element matching the condition was not found.")
        return
    }

    if !match
        return

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
    global INSERT_MODE_II
    global TOGGLE ; https://www.autohotkey.com/boards/viewtopic.php?p=501239#p501239

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
    If (g = "0") {
        return
        ; Gui1Setup()  ; Call the function directly
    }
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
    global INSERT_MODE_II
    global TOGGLE

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
   ;if VIM_NORMAL_SPACE_MODE
    ;	Send, a

    NormalLabelAlt()
}

CapsLock::
{
    ;if VIM_NORMAL_SPACE_MODE
    ;    Send("a")

    SymbolLebelCapsLock()
}

Tab::
{
    ;if VIM_NORMAL_SPACE_MODE
    ;	Send("a")

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
   ---------------------------------------------------
   ---------------------------------------------------
   ---long press Space to active vim normal layer 1---
   ----------------------i-----------------------------
   ---------------------------------------------------
*/

Vim_NormalLabelSpace() {
    global VIM_NORMAL_SPACE_MODE
    global NORMAL_ALT_MODE
    global SYMBOL_MODE
    global NUMBER_MODE
    global INSERT_MODE
    global INSERT_MODE_II

    if !VIM_NORMAL_SPACE_MODE {
        VIM_NORMAL_SPACE_MODE := true
        ;CHECK_IS_ON_VIM_NORMAL_SPACE_MODE := true
        ;VSCodeTabSwitchWhileInsetMode := false
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

/*
if VSCodeTabSwitchWhileInsetMode {

	VSCodeTabSwitchWhileInsetMode := false
	CHECK_IS_ON_VIM_NORMAL_SPACE_MODE := false
	VIM_NORMAL_SPACE_MODE := false
	Send, {Esc}
	Send, a ; long keyPress to go to the next char where the curser point and enter insert mode

	SYMBOL_MODE := false
	NUMBER_MODE := false
	INSERT_MODE := true

	if TOGGLE {
		INSERT_MODE_II := true

		ToolTip, Index, % index_TooltipX, 0, 1
	}
}
return
*/

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
        Send("^") ;jump to the first non-blank character of the line ?????????????????????????????????????????????????????????????????????????????????????????
}
$3::
{
    Send("s")

    global VIM_NORMAL_SPACE_MODE
    global SYMBOL_MODE
    global NUMBER_MODE
    global INSERT_MODE
    global INSERT_MODE_II
    global TOGGLE

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
    global block_visual
    global line_visual
    global char_visual

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

;d & g::Send, !{Tab}
d & g Up::
{

    global VIM_NORMAL_SPACE_MODE
    global SYMBOL_MODE
    global NUMBER_MODE
    global INSERT_MODE
    global INSERT_MODE_II
    global TOGGLE

    ToolTip(, , , 2)
    ToolTip(, , , 4)
    ToolTip(, , , 5)

    ;guiOpen := false
    ;CHECK_IS_ON_VIM_NORMAL_SPACE_MODE := true
    VIM_NORMAL_SPACE_MODE := false
    SYMBOL_MODE := false
    NUMBER_MODE := false
    if TOGGLE {
        INSERT_MODE_II := true

        ToolTip("Index", index_TooltipX, 0, 1)
    }
}
; Define the hotkey to show or destroy the GUI

$Space::
{
    global VIM_NORMAL_SPACE_MODE
    global SYMBOL_MODE
    global NUMBER_MODE
    global INSERT_MODE
    global INSERT_MODE_II
    global TOGGLE

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
    global VIM_NORMAL_SPACE_MODE
    global NORMAL_ALT_MODE

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
    global VISUAL_MODE
    global VIM_NORMAL_SPACE_MODE
    global SYMBOL_MODE
    global NUMBER_MODE
    global INSERT_MODE
    global INSERT_MODE_II
    global char_visual
    global line_visual
    global block_visual

    if !VISUAL_MODE {
        ;guiOpen := false
        VISUAL_MODE := true
        ;CHECK_IS_ON_VIM_VISUAL_SPACE_MODE := true
        VIM_NORMAL_SPACE_MODE := false
        ;CHECK_IS_ON_VIM_NORMAL_SPACE_MODE := false
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
{

}
Vim_NormalLabelSpace  ; Trigger Vim_NormalLabelSpace if VS Code is active
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
    global char_visual
    global line_visual
    global block_visual

    Send "d"

    ToolTip(, , , 10)
    VISUAL_MODE := false
    char_visual := false
    line_visual := false
    block_visual := false

    ;CHECK_IS_ON_VIM_VISUAL_SPACE_MODE := false
    ;CHECK_IS_ON_VIM_NORMAL_SPACE_MODE := true

    Vim_NormalLabelSpace()  ; Trigger Vim_NormalLabelSpace if VS Code is active
}


$e::
{
    global VISUAL_MODE
    global char_visual
    global line_visual
    global block_visual
    Send "y"

    ToolTip(, , , 10)
    VISUAL_MODE := false
    char_visual := false
    line_visual := false
    block_visual := false

    ;CHECK_IS_ON_VIM_VISUAL_SPACE_MODE := false
    ;CHECK_IS_ON_VIM_NORMAL_SPACE_MODE := true

    Vim_NormalLabelSpace()  ; Trigger Vim_NormalLabelSpace if VS Code is active
}

$r::
{
    global char_visual
    global line_visual
    global block_visual
    global VISUAL_MODE
    global VIM_NORMAL_SPACE_MODE
    global SYMBOL_MODE
    global NUMBER_MODE
    global INSERT_MODE
    global TOGGLE
    global INSERT_MODE_II

    Send "c"

    ToolTip(, , , 2)
    ToolTip(, , , 4)
    ToolTip(, , , 5)
    ToolTip(, , , 10)

    char_visual := false
    line_visual := false
    block_visual := false

    VISUAL_MODE := false
    ;CHECK_IS_ON_VIM_NORMAL_SPACE_MODE := false
    ;CHECK_IS_ON_VIM_VISUAL_SPACE_MODE := false
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
    global char_visual
    global line_visual
    global block_visual

    Send "p" ;put (paste) the clipboard after cursor

    ToolTip(, , , 10)

    VISUAL_MODE := false
    char_visual := false
    line_visual := false
    block_visual := false

    ;CHECK_IS_ON_VIM_VISUAL_SPACE_MODE := false
    ;CHECK_IS_ON_VIM_NORMAL_SPACE_MODE := true

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
    global char_visual
    global line_visual
    global block_visual

    Send "{Esc}"
    ToolTip(, , , 10)

    VISUAL_MODE := false

    ;CHECK_IS_ON_VIM_VISUAL_SPACE_MODE := false
    ;CHECK_IS_ON_VIM_NORMAL_SPACE_MODE := true

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
    global VISUAL_MODE
    global char_visual
    global line_visual
    global block_visual
    global VIM_NORMAL_SPACE_MODE
    global SYMBOL_MODE
    global NUMBER_MODE
    global INSERT_MODE
    global INSERT_MODE_II
    global TOGGLE

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

    ;CHECK_IS_ON_VIM_NORMAL_SPACE_MODE := false
    ;CHECK_IS_ON_VIM_VISUAL_SPACE_MODE := false
    VIM_NORMAL_SPACE_MODE := false
    SYMBOL_MODE := false
    NUMBER_MODE := false
    INSERT_MODE := true

    if TOGGLE {
        INSERT_MODE_II := true

        ToolTip("Index", index_TooltipX, 0, 1)
    }
}

;d & g::Send, !{Tab}
d & g Up::
{
    global VISUAL_MODE
    global VIM_NORMAL_SPACE_MODE
    global SYMBOL_MODE
    global NUMBER_MODE
    global INSERT_MODE
    global INSERT_MODE_II
    global TOGGLE

    ToolTip(, , , 2)
    ToolTip(, , , 4)
    ToolTip(, , , 5)
    ToolTip(, , , 10)

    VISUAL_MODE := false
    /*
    char_visual := false
    line_visual := false
    	    block_visual := false
    */
    ;CHECK_IS_ON_VIM_VISUAL_SPACE_MODE := true
    ;CHECK_IS_ON_VIM_NORMAL_SPACE_MODE := false
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
    global VIM_NORMAL_SPACE_MODE
    global SYMBOL_MODE
    global NUMBER_MODE
    global INSERT_MODE
    global TOGGLE
    global INSERT_MODE_II

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
    global NUMBER_MODE
    global SYMBOL_MODE
    global VIM_NORMAL_SPACE_MODE
    global NORMAL_ALT_MODE
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
    global TOGGLE
    global NUMBER_MODE
    global SYMBOL_MODE
    global VIM_NORMAL_SPACE_MODE
    global NORMAL_ALT_MODE
    global INSERT_MODE
    global INSERT_MODE_II

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
    global NUMBER_MODE
    global SYMBOL_MODE
    global VIM_NORMAL_SPACE_MODE
    global NORMAL_ALT_MODE
    global INSERT_MODE
    global INSERT_MODE_II
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
    global NUMBER_MODE
    global SYMBOL_MODE
    global VIM_NORMAL_SPACE_MODE
    global NORMAL_ALT_MODE
    global INSERT_MODE
    global INSERT_MODE_II
    global inside_symbol_layer_state

    last := inside_symbol_layer_state, inside_symbol_layer_state := 3 ; Set the current layer to 3 when CapsLock is pressed
    ;inside_symbol_layer_state := 3     ; Set the current layer to 3
    ;last := inside_symbol_layer_state  ; Store the current layer value in 'last'

    ;CapsLockArrow := true

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
    global NUMBER_MODE
    global SYMBOL_MODE
    global VIM_NORMAL_SPACE_MODE
    global NORMAL_ALT_MODE
    global INSERT_MODE
    global INSERT_MODE_II
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


#HotIf (inside_symbol_layer_state = 3)
$w:: Send("{Up}")
$a::
{
    ; Switch to the next tab with Ctrl + Tab
    if WinActive("ahk_class Chrome_WidgetWin_1 ahk_exe Code.exe")
       SendEvent("^{tab}")
}

$s::
{
    ; Switch to the previous tab with Ctrl + Shift + Tab
    if WinActive("ahk_class Chrome_WidgetWin_1 ahk_exe Code.exe")
        SendEvent("^+{tab}")
}

$a UP::
$s UP::
{
    Sleep(200)  ; Delay for (500 ms)

    if WinActive("ahk_class Chrome_WidgetWin_1 ahk_exe Code.exe") {
        ; Get the active window's title
        currentTitle := WinGetTitle("ahk_class Chrome_WidgetWin_1 ahk_exe Code.exe")  ; Retrieve title directly with function syntax
        VimModeLibrary(currentTitle)
    }
}

$d:: Send("{Right}")
#HotIf

/*
; Case 1: inside_symbol_layer_state = 3 and TOGGLE is ON
#HotIf (inside_symbol_layer_state = 3 && TOGGLE)

$w:: Send("{WheelUp 5}")    ; Scroll up quickly when TOGGLE is on
$a::
$s::

#HotIf ; End of this conditional block

; Case 2: inside_symbol_layer_state = 3 and TOGGLE is OFF
#HotIf (inside_symbol_layer_state = 3 && !TOGGLE)

$w:: Send("{Up}")           ; Move up when TOGGLE is off
$a:: Send("{Left}")         ; Move left
$s:: Send("{Down}")         ; Move down when TOGGLE is off

#HotIf                      ; End of this conditional block
*/

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
    global NUMPAD_SYMBOL_MODE
    global NUMBER_MODE
    global SYMBOL_MODE
    global inside_symbol_layer_state
    global VIM_NORMAL_SPACE_MODE
    global NORMAL_ALT_MODE
    global INSERT_MODE
    global INSERT_MODE_II

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
        ;CHECK_IS_ON_VIM_NORMAL_SPACE_MODE := false
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
        MsgBox("long press 200")
        /*
        if WinActive("ahk_class Chrome_WidgetWin_1 ahk_exe Code.exe") {
            Send, { Esc }
            Gosub, Vim_NormalLabelSpace  ; Trigger Vim_NormalLabelSpace if VS Code is active
        }
        */
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
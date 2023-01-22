#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,Force ; ; SendRaw, => or Send {=}{>}.

SetCapsLockState, AlwaysOff ;so it doesn't toggle every time
$w::

If GetKeyState("CapsLock","p")

Send {Up}

else

Send w

Return

!w::MsgBox Hotkey Works

;;;;
LShift & k::Send {Up}
LShift & x::Send {Down}
LShift & "::Send {Left}
LShift & g::Send {Right}
NumpadEnter & space::Send {Down}

Tab::Send {Backspace}
CapsLock::Send {Enter}

;-::Send {LButton}
;'::Send {RButton}
NumpadAdd::Send {Enter}
~CapsLock & q::Send {WheelUp}

;;NumpadDot::Shift
;;NumpadSub::Ctrl

,::Send {Backspace}
Left::Send {Enter}

;;;;;;;;;;;;;;;;;;;;;;

~space & c::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {1}
return

~space & d::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {2}
return

~space & t::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {3}
return

~space & h::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {4}
return

~space & e::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {5}
return

~space & a::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {6}
return

~space & v::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {7}
return

~space & w::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {8}
return

~space & n::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {9}
return

~space & i::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {0}
return

;;;;;;;;;;;;;;;;;;;;;

NumpadEnter & /::Send |

NumpadEnter & p::Send {!}

NumpadEnter & f::Send @

NumpadEnter & m::Send {#}

NumpadEnter & l::Send $

NumpadEnter & j::Send `%
;----------------------

NumpadEnter & q::Send ``

NumpadEnter & b::Send {^}

NumpadEnter & y::Send &

NumpadEnter & u::Send *

NumpadEnter & r::Send {-}

NumpadEnter & s::Send {+}

NumpadEnter & o::Send `=
;----------------------

NumpadEnter & k::Send ?

NumpadEnter & c::Send [

NumpadEnter & d::Send {{}

NumpadEnter & t::Send {(}

NumpadEnter & h::Send {,}

NumpadEnter & e::Send .

NumpadEnter & a::Send `;

NumpadEnter & z::Send :
;-------------------

NumpadEnter & x::Send ~

NumpadEnter & g::Send /

NumpadEnter & v::Send <

NumpadEnter & w::Send `_

NumpadEnter & n::Send "

NumpadEnter & i::Send '

NumpadEnter & ,::Send \
;--------------------
~space & y::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send >
return

~space & u::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send ]
return

~space & r::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {}}
return

~space & s::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {)}
return
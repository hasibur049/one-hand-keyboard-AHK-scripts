#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,Force ; ; SendRaw, => or Send {=}{>}.


LShift & k::Send {Up}
LShift & x::Send {Down}
LShift & "::Send {Left}
LShift & g::Send {Right}


Tab::Send {Backspace}
CapsLock::Send {Enter}
-::Send {LButton}
'::Send {RButton}
NumpadAdd::Send {Enter}
~CapsLock & q::Send {WheelUp}
;;NumpadDot::Shift
;;NumpadSub::Ctrl

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
NumpadEnter & w::Send 1

NumpadEnter & n::Send 2

NumpadEnter & i::Send 3

NumpadEnter & t::Send 4

NumpadEnter & h::Send 5

NumpadEnter & e::Send 6 ;----------

NumpadEnter & u::Send 7

NumpadEnter & r::Send 8

NumpadEnter & s::Send 9

NumpadEnter & a::Send 0

NumpadEnter & p::Send ``

NumpadEnter & f::Send [

NumpadEnter & m::Send ]

NumpadEnter & l::Send `;

NumpadEnter & o::Send .

NumpadEnter & d::Send / ;----------

NumpadEnter & g::Send \

NumpadEnter & v::Send '

NumpadEnter & b::Send {(}

NumpadEnter & y::Send {)}

;qbqqqqq

NumpadAdd & p::Send ~

NumpadAdd & f::Send {{}

NumpadAdd & m::Send {}}

NumpadAdd & l::Send :

NumpadAdd & u::Send &

NumpadAdd & r::Send *

NumpadAdd & s::Send {+}

NumpadAdd & o::Send -

NumpadAdd & d::Send ?

NumpadAdd & t::Send $

NumpadAdd & h::Send `%

NumpadAdd & e::Send `=

NumpadAdd & a::Send `_

NumpadAdd & g::Send |

NumpadAdd & v::Send "

NumpadAdd & w::Send {!}

NumpadAdd & n::Send @

NumpadAdd & i::Send {#}

NumpadAdd & b::Send <

NumpadAdd & y::Send >

NumpadAdd & ,::Send {^}
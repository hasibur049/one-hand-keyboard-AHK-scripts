#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,Force ; ; SendRaw, => or Send {=}{>}.

Tab::Backspace
CapsLock::Enter
NumpadDot::Shift
NumpadSub::Ctrl

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
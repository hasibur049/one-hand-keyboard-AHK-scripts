#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,Force ; ; SendRaw, => or Send {=}{>}.

Appskey:: Send {enter}
RAlt:: Send {backspace}

;;---------------
;;k c d t h e a z--with--space
;;---------------


~space & w::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {1}
return

~space & n::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {2}
return

~space & i::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {3}
return

~space & t::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {4}
return

~space & h::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {5}
return

~space & e::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {6}
return

~space & u::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {7}
return

~space & r::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {8}
return

~space & s::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {9}
return

~space & a::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {0}
return

~space & p::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {``}
return

~space & f::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {[}
return

~space & m::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {]}
return

~space & l::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {;}
return

~space & o::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {.}
return

~space & d::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {/}
return

~space & g::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {\}
return

~space & v::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {'}
return

~space & b::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {(}
return

~space & y::
SetKeyDelay, -1
Send {backspace}
SetKeyDelay, -1
Send {)}
return

;;---------------
;;k c d t h e a z--with--LAlt 8 9 4
;;---------------
LAlt & p:: Send {~}

LAlt & f:: Send {{}

LAlt & m:: Send {}}

LAlt & l:: Send {:}

LAlt & u:: Send {&}

LAlt & r:: Send {*}

LAlt & s:: Send {+}

LAlt & o:: Send {-}

LAlt & d:: Send {?}

LAlt & t:: Send {$}

LAlt & h:: Send {`%}

LAlt & e:: Send {=}

LAlt & a:: Send {_}

LAlt & g:: Send {|}

LAlt & v:: Send {"}

LAlt & w:: Send {!}

LAlt & n:: Send {@}

LAlt & i:: Send {#}

LAlt & b:: Send {<}

LAlt & y:: Send {>}

LAlt & ,:: Send {^}

;F4 & d:: Send {?}

;F8 & d:: Send {/}



Numpad0 & d::
Send {backspace}
Send {?}
return

Numpad0  & t::
Send {backspace}
Send {$}
return

Numpad0  & h::
Send {backspace}
Send {`%}
return

Numpad0  & e::
Send {backspace}
Send {=}
return


;F7::LCtrl

;F9 & d:: Send {?}
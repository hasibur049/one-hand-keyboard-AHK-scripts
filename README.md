# one-hand-keyboard-AHK-scripts

This is my personal keyboard layout. It is designed for use with only the left hand. People who have use of only their left hand can benefit from using this software.

---------------
### Index Layer
1. Start/End Index Layer:
- Press `D` key to start/end.
2. Switch Layers:
- While the `Index` is I/II, press the `symbol`/`numpad`/`visual 1?2`<br> to switch layers.
```
Index Layer I

|       |CapsLock|   TAB  |   ENT  |    X   |        |
|       |    Q   |    H   |    T   |    I   |    P   |
|       |    S   |    E   |  Index [[   A  ]]    W   |
|       |    N   |    L   |   BS   |    D   |    K   |
|       |        |        |                          |

Index Layer II

|       |CapsLock|   TAB  |        |    x   |        |
|       |    Z   |    B   |   ENT  |    G   |    J   |
|       |    U   |    O   |        [[   R  ]]    C   |
|       |    M   |    Y   |    V   |    F   |    P   |
|       |        |        |                          |
```
 Hotkeys for d & other N key combinations
```
d & s:: Send "{Up}"
d & f:: Send "{Down}"
d & g:: AltTab
d & x:: Send "{Left}"
d & v:: Send "{Right}"
d & t:: Send "{Delete}"
d & w:: Send "{Home} {Up} {End} {Enter}"
d & r:: Send "{End} {Enter}"
d & Space:
       -> ToolTip("Long Press !")
       -> Gui1Setup()  ; Call the function directly
```
Other Modifier keys 
```
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
```
--------------------
### Space with N key
- Press any key While `Space` key down and `index` layer I.
```

|       |        |        |        |        |        |
|       |        |   /\   |   -_   |   =+   |   &$   |
|       |   !%   |   '"   |   ;:   [[  .,  ]]   *?   |
|       |   <>   |   []   |   ()   |   {}   |   #@   |
|       |        |        |           Space          |
```
- Press any key While `Space` key down and `index` layer II.
```

|       |        |        |        |        |        |
|       |        |    2   |   3    |   4    |    -   |
|       |   +    |    1   |   0    [[  5   ]]    9   |
|       |   *    |    6   |   7    |   8    |    .   |
|       |        |        |           Space          |
```
-------------------------
### Number & Symbol Layer
1. Start/End Number Layer:
- Press `Tab` key to start/end.
2. Switch Layers:
- While the `Numpad` is on, press the `symbol`/`visual 1?2` to switch layers.
```
Number/Numpad Layer 

|       |        |        |        |        |        |
|Numpad |        |   7    |    8   |    9   |        |
|       |        |   4    |    5   [[   6  ]]    0   |
|       |        |   1    |    2   |    3   |        |
|       |        |        |                          |
```
1. Start/End Symbol Layer:
- Press `Capslock` key to start/end.
```
Symbol Layer

|       |        |    ~   |    |   |    ^   |        |
|       |    `   |   /\   |   -_   |   =+   |   &$   |
|Symbol |   !%   |   '"   |   ;:   [[  .,  ]]   *?   |
|       |   <>   |   []   |   ()   |   {}   |   #@   |
|       |        |        |                          |

short tap to send ;
long tap (160ms) to send :
```

--------------------------
### vim VS Code 
VIM_NORMAL_SPACE_MODE
```
;fn row
1: return
2:
-> go to the first line of the document(gg)
-> jump to the first non-blank character of the line(^) 
3: delete the character under the cursor and place you in insert mode(s)
4:
-> ("G") go to the last line of the document
-> ("$") jump to the end of the line
5: return 

; Top row 
q:
-> (">>") indent (move right) line one shiftwidth
-> ("<<") indent (move left) line one shiftwidth
w: DeleteLabel()
e: YankLabel()
r: ChangeLabel()
t: ("p") put (paste) the clipboard after cursor

; home row
a: ("h") move cursor left
s: ("k") move cursor up
f: ("l") move cursor right
d: ("j") move cursor down
g:
(g = "00") go to block_visual in Vim_VisualLabel()
(g = "0") go to char_visual in Vim_VisualLabel()
(g = "1") go to line_visual in Vim_VisualLabel()

; Bottom row 
z: ("b") jump backwards to the start of a word
x: WheelUp
c: WheelDown
v: ("w") jump forwards to the start of a word
b:
(keyPress = "00") ("^r") short keyPress to redo
(keyPress = "0") ("u") short keyPress to undo

Space:
(keyPress = "00") ("o") double short keyPress to go next line and enter insert mode
(keyPress = "1") ("i") short keyPress to go to the prev char where the curser point and enter insert mode
(keyPress = "0") ("a") long keyPress to go to the next char where the curser point and enter insert mode
----------- 
Extra reference

q: indent (move right) line one shiftwidth.(>>)
h: Move left.
t: Move right.
i: Enter Insert mode before the cursor.
p: Paste after the cursor.

s: Enter Visual mode to select characters.
e: jump backwards to the start of a word. {b}
a: Enter Insert mode after the cursor.
w: jump forwards to the start of a word.

n: jump to the first non-blank character of the line. {^}
l: Move down.
BS: Move up.
d{motion}: "Delete" command. Deletes the text defined by the motion.
    Examples:
    dw: Delete from the cursor position to the end of the word.
    diw: Delete the entire word under the cursor.
    dd: Delete the entire current line.
k: jump to the end of the line. {$}

b - redo. { Ctrl + r}
u – undo.
yy – yank (copy) a line
gg - go to the first line of the document
r – replace a single character.
cc – change (replace) entire line and enter insert mode.
. – repeat last command.
p – put (paste) the clipboard after cursor
x – delete (cut) character
z – de-indent (move left) line one shiftwidth. {<<}

1. Yank (y)
Purpose: Copy text.
Examples: yy, yw, yiw, y$
2. Delete (d)
Purpose: Delete (cut) text.
Examples: dd, dw, diw, d$
3. Change (c)
Purpose: Delete text and enter Insert mode.
Examples: cc, cw, ciw, c$
```

Visual mode

```
Visual Mode (character-wise selection)

Alt: return
Tab: return
CapsLock: return
Down: return
Shift: return
Ctrl: return
Right: return

;fn row
1: return
2:
("gg") go to the first line of the document
("^") jump to the first non-blank character of the line
3: return
4:
("G") go to the last line of the document
("$") jump to the end of the line
5: return

; Top row
q: return
w:
Send "d" // Vim_NormalLabelSpace()  ; Trigger Vim_NormalLabelSpace if VS Code is active
e:
Send "y" //Vim_NormalLabelSpace()  ; Trigger Vim_NormalLabelSpace if VS Code is active
r:
Send "c"
t: "p" put (paste) the clipboard after cursor

; home row
a: "Left" move cursor left
s: "Up" move cursor up
f: "Right" move cursor right
d: "Down" move cursor down
g: send "ESC"

; Bottom row 
z: "b" jump backwards to the start of a word
^z: "^r" redo
x: "WheelUp"
c: "WheelDown"
v: "w" jump forwards to the start of a word
b: return

Space:
(g = "00") "o" double short click to go next line and enter insert mode
(g = "1") "a" long click to go to the next char where the curser point and enter insert mode
(g = "0") "i" short click to go to the prev char where the curser point and enter insert mode

-------------
Extra reference

q: 
h: Move left.
t: Move right.
i: Change the selected text (delete and enter Insert mode). {c}
p: Paste text after the selected area.

s: Exir Visual mode and Enter insert mode.
e: Move backward to the beginning of the current word. {b}
a: Yank (copy) the selected text. {y}
w: Move forward to the start of the next word.

n: Move to the beginning of the line. {0}
l: Move down.
BS: Move up.
d: Delete the selected text (works like cut).
k: Move to the end of the line. {$}
u: Undo the last action
```
```
Visual Line Mode (V)

V: Starts Visual Line mode, selecting entire lines.
d: Delete the selected lines.
y: Yank (copy) the selected lines.
c: Change the selected lines (delete and enter Insert mode).
>: Indent the selected lines.
<: Unindent the selected lines.
=: Auto-indent the selected lines.

Visual Block Mode (Ctrl+v)

Ctrl+v: Start Visual Block mode.
I: Insert text before the block (type text and press Esc to apply to all lines in the block).
A: Append text after the block (type text and press Esc to apply to all lines in the block).
d: Delete the selected block.
y: Yank the selected block.
p: Paste the block after the selection.
r: Replace selected characters with a single character.
```
----------------
### Visual Layer
1. Start/End Visual 1:
- Long press `Space` (200ms) key to start.
- Short press `Space` key to end.
2. Switch Layers:
- While the `Visual 1` is on, press the `symbol`/`numpad`/`visual 2`<br> to switch layers.
```
Visual 1

|       |        |        |        |        |        |
|       |        |        |        |        |        |
|       |        |        |WheelUp [WheelDn ]        |
|       |        |        |        |        |        |
|       |        |        |                          |
```
1. Start/End Visual 2:
- Press `Alt` to start.
- Press `Alt`/`Space` to end.
2. Switch Layers:
- While the ` Visual 2` is on, press the `symbol`/`numpad`/`visual 1`<br> to switch layers.
```
Visual 2

|       |        |        |        |        |        |
|       |        |        |        |        |        |
|       |        |        |        [[      ]]        |
|       |        |        |        |        |        |
|       |        |        |                          |
```
--------------------------
### Quarty Keyboard Layout
- Left part of the Quarty Keyboard Layout. where 'F' is typing home/<br> guide key.
```

| Esc   |    !1  |    @2  |    #3  |    $4  |    %5  |
| Tab   |    Q   |    W   |    E   |    R   |    T   |
| Caps  |    A   |    S   |    D   [[   F  ]]    G   |
| Shift |    Z   |    X   |    C   |    V   |    B   |
| Ctrl  |   Win  |   Alt  |         Spacebar         |

Effort layer

|  10   |    8   |   2.5  |   2.5  |   2.5  |    7   |
|   6   |   3.5  |    1   |    1   |    1   |    4   |
|   5   |    1   |   0.5  |   0.5  [[  0.5 ]]    3   |
|   7   |   2.5  |   1.5  |   1.5  |   1.5  |    8   |
|   15  |   13   |    6   |    3   |    1   |   0.5  |
```

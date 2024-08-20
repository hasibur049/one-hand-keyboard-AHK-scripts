# one-hand-keyboard-AHK-scripts

This is my personal keyboard layout. It is designed for use with only the left hand. People who have use of only their left hand can benefit from using this software.

---------------
### Index Layer
1. Start/End Index Layer:
- Press `F` key to start/end.
2. Switch Layers:
- While the `Index` is on/off, press the `symbol`/`numpad`/`visual 1?2`<br> to switch layers.
```
Index Layer off

|       |        |   TAB  |   ENT  |    X   |        |
|       |    Q   |    H   |    T   |    I   |    P   |
|       |    S   |    E   |  Index [[   A  ]]    W   |
|       |    N   |    L   |   BS   |    D   |    K   |
|       |        |        |                          |

Index Layer on

|       |        |        |   BS   |        |        |
|       |    Z   |    B   |   ENT  |    G   |    J   |
|       |    U   |    O   |        [[   R  ]]    C   |
|       |    M   |    Y   |    V   |    F   |    P   |
|       |        |        |                          |
```
-------------------------
### Number & Symbol Layer
1. Start/End Number Layer:
- Press `Tab` key to start/end.
2. Switch Layers:
- While the `Numpad` is on, press the `symbol`/`visual 1?2` to switch layers.
```
Number/Numpad Layer 

|       |        |        |    BS  |        |        |
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
--------------------
### Space with N key
- Press any key While `Space` key down and `index` layer off.
```

|       |        |    9   |    8   |    7   |        |
|       |        |   /\   |   -_   |   =+   |   &$   |
|       |   !%   |   '"   |   ;:   [[  .,  ]]   *?   |
|       |   <>   |   []   |   ()   |   {}   |   #@   |
|       |        |        |           Space          |
```
- Press any key While `Space` key down and `index` layer on.
```

|       |        |    9   |   8    |   7    |        |
|       |        |    5   |   1    |   0    |    9   |
|       |   6    |  Left  |  Down  [[  Up  ]]  Right |
|       |   7    |    4   |   3    |   2    |    8   |
|       |        |        |           Space          |
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
### vim VS Code 
Normal Mode
```
Normal Mode (Index Layer off)

|       |        |   TAB  |   ENT  |    X   |        |
|       |    Q   |    H   |    T   |    I   |    P   |
|       |    S   |    E   |  Index [[   A  ]]    W   |
|       |    N   |    L   |   BS   |    D   |    K   |
|       |        |        |                          |

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
```
```
Normal Mode (Index Layer on)

|       |        |        |   BS   |        |        |
|       |    Z   |    B   |   ENT  |    G   |    J   |
|       |    U   |    O   |        [[   R  ]]    C   |
|       |    M   |    Y   |    V   |    F   |    P   |
|       |        |        |                          |

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
Visual Mode (character-wise selection) (Index Layer off)

|       |        |   TAB  |   ENT  |    X   |        |
|       |    Q   |    H   |    T   |    I   |    P   |
|       |    S   |    E   |  Index [[   A  ]]    W   |
|       |    N   |    L   |   BS   |    D   |    K   |
|       |        |        |                          |

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

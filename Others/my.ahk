#Requires AutoHotkey v2.0

layerActive := true
modeBrowse := "browse"
modeInsert := "insert"
modeMouse := "mouse"
mode := modeBrowse
isVisualMode := false

CaptalizeFirstLetter(Str) {
    if (Str = "")
        return Str
    return StrUpper(SubStr(Str, 1, 1)) . SubStr(Str, 2)
}

ShowBottomRightTooltip(Text) {
    ToolTip(Text, A_ScreenWidth, A_ScreenHeight)
}

ToolTipMode() {
    symbol := mode
    if (symbol = modeInsert && isVisualMode) {
        symbol := Format("{1} (visual)", modeInsert)
    }
    ShowBottomRightTooltip(CaptalizeFirstLetter(symbol))
}

ToggleLayer() {
    global layerActive := !layerActive
    if layerActive {
        ToolTipMode()
    } else {
        ToolTip()
    }
}

StartUp(md) {
    global isvisualMode := false
    if !layerActive {
        global mode := md
        ToggleLayer()
    } else {
        if mode = md {
            ToggleLayer()
        } else {
            global mode := md
            ToolTipMode()
        }
    }
}

^;:: StartUp(modeBrowse)
^'::StartUp(modeInsert)
^+;::StartUp(modeMouse)
^{:: {
    global layerActive := false
    ToolTip()
}

#HotIf layerActive && mode = modeBrowse
h::Send "{Left}"
j::Send "{Down}"
k::Send "{Up}"
l::Send "{Right}"
+h::Send "!{Left}" ; {Browser_Back} does not work in some applications  
+l::Send "!{Right}" ; {Browser_Forward} does not work in some applications
+j::Send "{End}"
+k::Send "{Home}"
^f::Send "{PgDn}"
^b::Send "{PgUp}"
^e::SendEvent "{WheelDown}"
^y::SendEvent "{WheelUp}"
^d::SendEvent "{WheelDown 5}"
^u::SendEvent "{WheelUp 5}"
)::Send "{F6}"
(::Send "+{F6}"
^m::Send "{Enter}"
^[::Send "{Escape}"
#HotIf

#HotIf layerActive && mode = modeInsert && isVisualMode
^b::Send "+{Left}"
^n::Send "+{Down}"
^p::Send "+{Up}"
^f::Send "+{Right}"
!b::Send "^+{Left}"
!f::Send "^+{Right}"
^a::Send "+{Home}"
^e::Send "+{End}"
#HotIf

#HotIf layerActive && mode = modeInsert
^Space:: {
    ; Ideally, when text is selected, this key should cancel the selection while keeping the cursor position.
    ; However, windows does not have a function to cancel selection only.
    ; Left and Right arrow keys do cancel selection, but Left moves the cursor to the left edge of the selection, and Right moves it to the right edge.
    ; So here it is simply toggling visual mode.
    global isVisualMode := !isVisualMode
    ToolTipMode()
}
^b::Send "{Left}"
^n::Send "{Down}"
^p::Send "{Up}"
^f::Send "{Right}"
!b::Send "^{Left}"
!f::Send "^{Right}"
!^a::Send "^a"
^a::Send "{Home}"
^e::Send "{End}"
^d::Send "{Delete}"
!d::Send "^{Delete}"
^h::Send "{Backspace}"
!^h::Send "^{Backspace}"
^k::Send "+{End}{Delete}"
^u::Send "+{Home}{Delete}"
^m::Send "{Enter}"
!^m::Send "^{Enter}"
^[::Send "{Escape}"
^/::Send "^z"
!/::Send "^y"
#HotIf

#HotIf layerActive && mode = modeMouse
h::MouseMove -50, 0, 0, "R"
k::MouseMove 0, -50, 0, "R"
j::MouseMove 0, 50, 0, "R"
l::MouseMove 50, 0, 0, "R"
Space::Send "{LButton}"
+Space::Send "{RButton}"
#HotIf

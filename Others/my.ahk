#Requires AutoHotkey v2.0

layerActive := false
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
    global isVisualMode := false
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

DisableLayer() {
    global layerActive := false
    ToolTip()
}

DisableVisualMode() {
    global isVisualMode := false
    ToolTipMode()
}

SendInsertModeKeyBase(key, disableVisual) {
    global isVisualMode
    if isVisualMode {
        Send "+" . key
        if disableVisual {
            DisableVisualMode()
        }
    } else {
        Send key
    }
}

SendInsertModeEditKey(key) {
    SendInsertModeKeyBase(key, true)
}

SendInsertModeMoveKey(key) {
    SendInsertModeKeyBase(key, false)
}

^;::StartUp(modeInsert)
^'::StartUp(modeBrowse)
^+;::StartUp(modeMouse)
^{::DisableLayer()
^[::Send "{Escape}"

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
!^m::Send "^{Enter}"
^[::Send "{Escape}"
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
^b::SendInsertModeMoveKey("{Left}")
^n::SendInsertModeMoveKey("{Down}")
^p::SendInsertModeMoveKey("{Up}")
^f::SendInsertModeMoveKey("{Right}")
!b::SendInsertModeMoveKey("^{Left}")
!f::SendInsertModeMoveKey("^{Right}")
!^o::Send "!{Left}" ; {Browser_Back} does not work in some applications  
!^i::Send "!{Right}" ; {Browser_Forward} does not work in some applications
!^a::Send "^a"
^a::SendInsertModeMoveKey("{Home}")
^e::SendInsertModeMoveKey("{End}")
!<::SendInsertModeMoveKey("^{Home}")
!>::SendInsertModeMoveKey("^{End}")
; ^v::SendInsertModeMoveKey("{PgDn}")
; !v::SendInsertModeMoveKey("{PgUp}")
^d::SendInsertModeEditKey("{Delete}")
!d::SendInsertModeEditKey("^{Delete}")
^h::SendInsertModeEditKey("{Backspace}")
^w::SendInsertModeEditKey("^{Backspace}")
!^h::SendInsertModeEditKey("^{Backspace}")
^k:: {
    Send "+{End}"
    Send "{Delete}"
    global isVisualMode
    if isVisualMode {
        DisableVisualMode()
    }
}
^u:: {
    Send "+{Home}"
    Send "{Delete}"
    global isVisualMode
    if isVisualMode {
        DisableVisualMode()
    }
}
^c::SendInsertModeEditKey("^c")
^x::SendInsertModeEditKey("^x")
; ^w::Send "^x"
; !w::Send "^c"
; ^y::Send "^v"
^m::SendInsertModeEditKey("{Enter}")
!^m::Send "+{Enter}"
^o::Send "^{Enter}"
^[::Send "{Escape}"
^/::Send "^z"
!/::Send "^y"
!^w::Send "^w"
#HotIf

#HotIf layerActive && mode = modeMouse
h::MouseMove -50, 0, 0, "R"
k::MouseMove 0, -50, 0, "R"
j::MouseMove 0, 50, 0, "R"
l::MouseMove 50, 0, 0, "R"
Space::Send "{LButton}"
+Space::Send "{RButton}"
#HotIf

#Requires AutoHotkey v2.0

layerActive := true
modeBrowse := "browse"
modeInsert := "insert"
modeMouse := "mouse"
mode := modeBrowse

CaptalizeFirstLetter(Str) {
    if (Str = "")
        return Str
    return StrUpper(SubStr(Str, 1, 1)) . SubStr(Str, 2)
}

ShowBottomRightTooltip(Text) {
    ToolTip(Text, A_ScreenWidth, A_ScreenHeight)
}

ToolTipMode() {
    ShowBottomRightTooltip(CaptalizeFirstLetter(mode))
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

#HotIf layerActive && mode = modeBrowse
i:: {
    global mode := modeInsert
    ToolTipMode()
}
h::Send "{Left}"
j::Send "{Down}"
k::Send "{Up}"
l::Send "{Right}"
+h::Send "!{Left}" ; {Browser_Back} does not work in some applications  
+l::Send "!{Right}" ; {Browser_Forward} does not work in some applications
^f::Send "{PgDn}"
^b::Send "{PgUp}"
^m::Send "{Enter}"
^[::Send "{Escape}"
#HotIf

#HotIf layerActive && mode = modeInsert
^[:: {
    global mode := modeBrowse
    ToolTipMode()
}
^b::Send "{Left}"
^n::Send "{Down}"
^p::Send "{Up}"
^f::Send "{Right}"
^+b::Send "+{Left}"
^+n::Send "+{Down}"
^+p::Send "+{Up}"
^+f::Send "+{Right}"
!b::Send "^{Left}"
!f::Send "^{Right}"
!+b::Send "^+{Left}"
!+f::Send "^+{Right}"
!^a::Send "^a"
^a::Send "{Home}"
^e::Send "{End}"
^+a::Send "+{Home}"
^+e::Send "+{End}"
^d::Send "{Delete}"
!d::Send "^{Delete}"
^h::Send "{Backspace}"
!h::Send "^{Backspace}"
^k::Send "+{End}{Delete}"
^u::Send "+{Home}{Delete}"
^m::Send "{Enter}"
!^m::Send "^{Enter}"
^/::Send "^z"
!/::Send "^y"
#HotIf

#HotIf layerActive && mode = modeMouse
h::MouseMove -50, 0, 0, "R"
k::MouseMove 0, -50, 0, "R"
j::MouseMove 0, 50, 0, "R"
l::MouseMove 50, 0, 0, "R"
Space::Send "{LButton}"
#HotIf

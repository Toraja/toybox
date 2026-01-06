#Requires AutoHotkey v2.0

ShowBottomRightTooltip(Text) {
    ToolTip(Text, A_ScreenWidth, A_ScreenHeight)
}

layerActive := true
modeNormal := "normal"
modeInsert := "insert"
mode := modeNormal

^;:: {
    global layerActive := !layerActive
    global mode := "normal"
    if layerActive {
        ShowBottomRightTooltip("Normal")
    } else {
        ToolTip()
    }
}

#HotIf layerActive && mode = modeNormal
h::Send "{Left}"
j::Send "{Down}"
k::Send "{Up}"
l::Send "{Right}"
+h::Send "{Home}"
+l::Send "{End}"
^f::Send "{PgDn}"
^b::Send "{PgUp}"
^m::Send "{Enter}"
i:: {
    global mode := modeInsert
    ShowBottomRightTooltip("Insert")
}
#HotIf

#HotIf layerActive && mode = modeInsert
^[:: {
    global mode := modeNormal
    ShowBottomRightTooltip("Normal")
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
#HotIf

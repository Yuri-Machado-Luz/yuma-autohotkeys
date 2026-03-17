#Requires AutoHotkey v2.0.18+
#SingleInstance Force
SetBatchLines := 10
SetTitleMatchMode(2)

;  === REMAP SIMPLES ===
CapsLock::Esc



; === CONFIGURAÇÃO ===
global Config := {
    shortcuts: [
        {trigger: "A", display: "A - F13", send: "^{F13}"},
        {trigger: "1", display: "1 - F14", send: "^{F14}"},
        {trigger: "2", display: "2 - F15", send: "^{F15}"},
        {trigger: "3", display: "3 - F16", send: "^{F16}"},
        {trigger: "4", display: "4 - F17", send: "^{F17}"},
        {trigger: "5", display: "5 - F18", send: "^{F18}"},
        {trigger: "6", display: "6 - F19", send: "^{F19}"},
        {trigger: "7", display: "7 - F20", send: "^{F20}"},
        {trigger: "8", display: "8 - F21", send: "^{F21}"},
        {trigger: "9", display: "9 - F22", send: "^{F22}"},
        {trigger: "C", display: "C - F23", send: "^{F23}"},
        {trigger: "B", display: "B - F23", send: "^!{F13}"},
    ]
}

global MenuActive := false

; === EXECUTA O ATALHO ===
ExecuteShortcut(trigger) {
    global Config
    for shortcut in Config.shortcuts {
        if shortcut.trigger == trigger {
            Send(shortcut.send)
            return
        }
    }
}

; === HOTKEYS COM #HotIf (só ativas quando MenuActive = true) ===
#HotIf MenuActive
A::ExecuteShortcut("A")
1::ExecuteShortcut("1")
2::ExecuteShortcut("2")
3::ExecuteShortcut("3")
4::ExecuteShortcut("4")
5::ExecuteShortcut("5")
6::ExecuteShortcut("6")
7::ExecuteShortcut("7")
8::ExecuteShortcut("8")
9::ExecuteShortcut("9")
C::ExecuteShortcut("C")
B::ExecuteShortcut("B")
#HotIf

; === DETECTA CTRL 3X ===
~LCtrl::
~RCtrl::
{
    static pressCount := 0
    static lastPressTime := 0

    currentTime := A_TickCount
    timeSinceLastPress := currentTime - lastPressTime

    ; Se passou mais de 300ms desde a última pressão, reseta
    if timeSinceLastPress > 300 {
        pressCount := 1
    } else {
        pressCount++
    }

    lastPressTime := currentTime

    ; Se chegou a 3 pressões, ativa MenuActive
    if pressCount == 3 {
        global MenuActive
        MenuActive := true
        pressCount := 0
        lastPressTime := 0

        ; Auto-desativa após 2 segundos
        SetTimer(() => (MenuActive := false), 2000)
        return
    }

    ; Auto-reset se não houver próxima pressão em 500ms
    SetTimer(() => (pressCount := 0), 500)
}

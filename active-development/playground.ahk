/*
====================================WARNING!===================================
|                                                                             |
|                       ARQUIVO PLAYGROUND PARA TESTES                        |
|                                                                             |
|                       COMPILADO DE SNIPPETS DIVERSOS                        |
|                                                                             |
|                     RECOMENDO NÃO UTILIZAR DIRETAMENTE                      |
|                                                                             |
|        INCLUSO NO REPOSITÓRIO PARA EXPOSIÇÃO DE IDEIAS, TESTES E AFINS      |
|                                                                             |
====================================WARNING!===================================
*/

; === UMA VERSÃO ESTÁVEL JÁ EXISTE EM plug-n-play/better-remap*.ahk
; === VERSÃO INICIAL DO SCRIPT DE REMAPPING - Versão estável funciona em modelo de "combos"

;@Ahk2Exe-IgnoreBegin
#SingleInstance Force
SetBatchLines := 10
SetTitleMatchMode(2)
;  === REMAP SIMPLES ===
CapsLock::Esc

;@format array_style: expand

global Config := {
    shortcuts: [
        { trigger: "A", send: "^{F13}" },
        { trigger: "1", send: "^{F14}" },
        { trigger: "2", send: "^{F15}" },
        { trigger: "3", send: "^{F16}" },
        { trigger: "4", send: "^{F17}" },
        { trigger: "5", send: "^{F18}" },
        { trigger: "6", send: "^{F19}" },
        { trigger: "7", send: "^{F20}" },
        { trigger: "8", send: "^{F21}" },
        { trigger: "9", send: "^{F22}" },
        { trigger: "C", send: "^{F23}" },
        { trigger: "B", send: "^!{F13}" },
    ]
}

global MenuActive := false

; === EXECUTA O ATALHO ===
ExecuteShortcut(trigger) {
    global Config
    for shortcut in Config.shortcuts {
        if shortcut.trigger == trigger {
            Send(shortcut.send)
            SoundBeep(300, 60)
            return
        }
    }
}

; === HOTKEYS COM #HotIf (só ativas quando MenuActive = true) ===
#HotIf MenuActive

A:: ExecuteShortcut("A")
1:: ExecuteShortcut("1")
2:: ExecuteShortcut("2")
3:: ExecuteShortcut("3")
4:: ExecuteShortcut("4")
5:: ExecuteShortcut("5")
6:: ExecuteShortcut("6")
7:: ExecuteShortcut("7")
8:: ExecuteShortcut("8")
9:: ExecuteShortcut("9")
B:: ExecuteShortcut("B")
C:: ExecuteShortcut("C")
#HotIf

; === DETECTA CTRL 3X ===
~LCtrl::
~RCtrl::
{
    static pressCount := 0
    static lastPressTime := 0

    currentTime := A_TickCount
    timeSinceLastPress := currentTime - lastPressTime

    ; Se passou mais de X ms desde a última pressão, reseta
    if timeSinceLastPress > 200 {
        pressCount := 1
    } else {
        pressCount++
    }

    lastPressTime := currentTime

    ; Se chegou a 2 pressões, ativa MenuActive
    if pressCount == 2 {
        global MenuActive
        MenuActive := true
        pressCount := 0
        lastPressTime := 0

        SoundBeep(400, 60) ; Beep
        SetTimer(() => (MenuActive := false), 1000)
        return
    }
    SetTimer(() => (pressCount := 0), 500)
}
;@Ahk2Exe-IgnoreEnd

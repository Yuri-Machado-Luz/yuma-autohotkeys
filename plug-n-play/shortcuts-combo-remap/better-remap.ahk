#Requires AutoHotkey v2.0.18+
#SingleInstance Force

; ============================================================================
; GLOBAL HOTKEYS
; ============================================================================
CapsLock::Esc

; ============================================================================
; STATE VARIABLES
; ============================================================================
global modCtrl := 0
global modAlt := 0
global modShift := 0
global comboInProgress := false
global comboTimeout := 0

; ============================================================================
; CONFIGURATION
; ============================================================================
global COMBO_TIMEOUT := 1000
global DOUBLE_CLICK_DELAY := 250

ModKeys := ["D", "F", "O", "I", "N", "R", "W", "P", "T", "0", "BackSpace"]

; ============================================================================
; COMBO HOTKEYS - Active only when comboInProgress = true
; ============================================================================
#HotIf comboInProgress
D:: ExecuteRemap(1) ;F13
F:: ExecuteRemap(2) ;F14
O:: ExecuteRemap(3) ;F15
I:: ExecuteRemap(4) ;F16
N:: ExecuteRemap(5) ;F17
R:: ExecuteRemap(6) ;F18
W:: ExecuteRemap(7) ;F19
P:: ExecuteRemap(8) ;F20
T:: ExecuteRemap(9) ;F21
0:: ExecuteRemap(10) ;F22
BackSpace:: ExecuteRemap(11) ;F23
#HotIf

^!+F18:: Reload() ; Shift -> Shift -> Ctrl -> Alt -> Space -> R = ^!+F18 (Reload script)

; ============================================================================
; FUNCTION: ExecuteRemap(keyIndex)
; ============================================================================
; Sends F13-F23 with accumulated modifiers when combo is active
; Falls back to original ModKeys[keyIndex] if combo is not active
;
ExecuteRemap(keyIndex) {
    global modCtrl, modAlt, modShift, comboInProgress

    if comboInProgress {
        theKey := "F" . (12 + keyIndex)
        mods := ""

        loop modCtrl
            mods .= "^"
        loop modAlt
            mods .= "!"
        loop modShift
            mods .= "+"

        SendInput(mods . "{" . theKey . "}")

        modCtrl := 0
        modAlt := 0
        modShift := 0
        comboInProgress := false
    } else {
        SendInput(ModKeys[keyIndex])

    }
}

; ============================================================================
; HOTKEY: Shift Double/Triple Click - Activate/Close Combo
; ============================================================================
; Double Shift = Activate combo
; Triple Shift = Close combo
; ~ prefix allows Shift to pass through to applications
;
~LShift::
~RShift::
{
    global comboInProgress, modCtrl, modAlt, modShift, comboTimeout
    static pressCount := 0
    static lastPressTime := 0

    currentTime := A_TickCount
    timeSinceLastPress := currentTime - lastPressTime

    if timeSinceLastPress > DOUBLE_CLICK_DELAY {
        pressCount := 1
    } else {
        pressCount++
    }

    lastPressTime := currentTime

    ; Double-click activates combo
    if pressCount == 2 && !comboInProgress {
        comboInProgress := true
        modCtrl := 0
        modAlt := 0
        modShift := 0
        comboTimeout := A_TickCount + COMBO_TIMEOUT

        SetTimer(CheckComboTimeout, 100)
        return
    }

    ; Triple-click closes combo
    if pressCount == 3 && comboInProgress {
        comboInProgress := false
        modCtrl := 0
        modAlt := 0
        modShift := 0

        SetTimer(CheckComboTimeout, 0)
        pressCount := 0
        return
    }

    SetTimer(() => (pressCount := 0), 500)
}

; ============================================================================
; TIMER CALLBACK: CheckComboTimeout()
; ============================================================================
; Runs every 100ms while combo is active
; Auto-closes combo if COMBO_TIMEOUT is exceeded
;
CheckComboTimeout() {
    global comboInProgress, modCtrl, modAlt, modShift, comboTimeout
    if comboInProgress && A_TickCount > comboTimeout {
        comboInProgress := false
        modCtrl := 0
        modAlt := 0
        modShift := 0
        SetTimer(CheckComboTimeout, 0)
    }
}

; ============================================================================
; MODIFIERS HOTKEYS - Active only when comboInProgress = true
; ============================================================================
; Without ~ prefix = blocks the original key from reaching applications
;
#HotIf comboInProgress

Space::
{
    global comboInProgress, modShift, modCtrl, modAlt, comboTimeout
    if comboInProgress {
        if modShift == 0 {
            modShift++
            comboTimeout := A_TickCount + COMBO_TIMEOUT
        } else {
            comboInProgress := false
            modCtrl := 0
            modAlt := 0
            modShift := 0

            SetTimer(CheckComboTimeout, 0)
        }
    }
}

LCtrl::
RCtrl::
{
    global comboInProgress, modCtrl, modShift, modAlt, comboTimeout
    if comboInProgress {
        if modCtrl == 0 {
            modCtrl++
            comboTimeout := A_TickCount + COMBO_TIMEOUT
        } else {
            comboInProgress := false
            modCtrl := 0
            modAlt := 0
            modShift := 0

            SetTimer(CheckComboTimeout, 0)
        }
    }
}

LAlt::
RAlt::
{
    global comboInProgress, modAlt, modShift, modCtrl, comboTimeout
    if comboInProgress {
        if modAlt == 0 {
            modAlt++
            comboTimeout := A_TickCount + COMBO_TIMEOUT
        } else {
            comboInProgress := false
            modCtrl := 0
            modAlt := 0
            modShift := 0

            SetTimer(CheckComboTimeout, 0)
        }
    }
}

#HotIf

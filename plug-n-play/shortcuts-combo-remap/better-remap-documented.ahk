; ============================================================================
; MACRO REMAPPER v2
; ============================================================================
; Sistema de combo-based hotkey remapping com modificadores acumulados
; Desenvolvido com AutoHotkey 2.0.18+
;
; FLUXO DE FUNCIONAMENTO:
;   1. Duplo clique em Shift → ativa modo COMBO
;   2. Pressiona Space/Ctrl/Alt → adiciona modificador (Shift/Ctrl/Alt)
;   3. Pressiona letra/número → envia F13-F23 com modificadores acumulados
;   4. Combo fecha automaticamente:
;      → Triplo clique em Shift (manual)
;      → Pressionar modificador 2x (ex: Space 2x fecha)
;      → Timeout 1000ms sem atividade (automático)
;
; MAPEAMENTO DE TECLAS:
;   Shift duplo     → Ativa combo -> triplo fecha combo
;   Space (combo)   → Adiciona Shift (modificador = +)
;   Ctrl (combo)    → Adiciona Ctrl (modificador = ^)
;   Alt (combo)     → Adiciona Alt (modificador = !)
;   A-Z, 0-9, -     → Executa remap (F13-F23 + mods)
;
; EXEMPLOS DE USO:
;   Shift Shift A        → Envia F13
;   Shift Shift Space A  → Envia +F13 (Shift+F13) r
;   Shift Shift Space Ctrl A → Envia ^+F13 (Ctrl+Shift+F13)
;   Shift Shift Space Ctrl Alt A → Envia ^!+F13 (Ctrl+Alt+Shift+F13)
;
; ============================================================================

#Requires AutoHotkey v2.0.18+
#SingleInstance Force

; ============================================================================
; VARIÁVEIS DE ESTADO GLOBAL
; ============================================================================
; Rastreiam quantitativo de cada modificador acumulado durante combo
global modCtrl := 0      ; Número de vezes que Ctrl foi pressionado
global modAlt := 0       ; Número de vezes que Alt foi pressionado
global modShift := 0     ; Número de vezes que Shift foi pressionado

; Flag que indica se estamos dentro do modo "combo" ativo
; Usado por #HotIf para ativar/desativar hotkeys condicionais
global comboInProgress := false

; Timestamp (A_TickCount) que marca quando o combo vai expirar
; Verificado pelo timer CheckComboTimeout() a cada 100ms
global comboTimeout := 0


; ============================================================================
; CONFIGURAÇÃO DO SISTEMA - Valores adaptáveis para preferências do usuário
; ============================================================================
; Tempo máximo (em ms) que o combo permanece ativo sem atividade
; Após este tempo, o combo fecha automaticamente
global COMBO_TIMEOUT := 1000

; Janela de tempo (em ms) para detectar duplo clique em Shift
; Se dois Shift forem pressionados dentro desta janela, combo ativa
global DOUBLE_CLICK_DELAY := 200


; ============================================================================
; HOTKEYS CUSTOMIZÁVEIS - Definição de teclas remapeáveis
; ============================================================================
; Array que mapeia letras/números para indices usados em ExecuteRemap()
; Índice 1→F13, 2→F14, ..., 11→F23
ModKeys := ["D", "F", "O", "I", "N", "R", "W", "P", "T", "0", "BackSpace"]

; Hotkeys que só funcionam QUANDO combo está ativo (comboInProgress = true)
; #HotIf comboInProgress garante que esses hotkeys são ignorados fora do combo
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

; === QUICK RELOAD PARA DEBUG ===
^!+F18::Reload() ; Shift -> Shift -> Ctrl -> Alt -> Space -> R = ^!+F18 (Reload script)

; ============================================================================
; FUNCTION: ExecuteRemap(keyIndex)
; ============================================================================
; Envia F13-F23 com modificadores acumulados, ou envia a tecla original
;
; PARÂMETROS:
;   keyIndex (1-11) → Índice do array ModKeys
;                     1 = A (F13)
;                     2 = C (F14)
;                     11 = - (F23)
;
; COMPORTAMENTO:
;   → Se combo ativo: Envia F(12+keyIndex) com modificadores acumulados
;     Exemplo: modCtrl=1, modShift=1 → SendInput("^+{F13}")
;   → Se combo inativo: Envia ModKeys[keyIndex] original (fallback)
;
; MODIFICADORES ENVIADOS:
;   modCtrl > 0  → Adiciona "^" (Ctrl)
;   modAlt > 0   → Adiciona "!" (Alt)
;   modShift > 0 → Adiciona "+" (Shift)
;
; FEEDBACK:
;   SoundBeep 600Hz por 60ms ao enviar comando (combo ativo)
;   SoundBeep 200Hz por 30ms ao enviar fallback (combo inativo)
;
ExecuteRemap(keyIndex) {
    global modCtrl, modAlt, modShift, comboInProgress

    if comboInProgress {
        ; Monta o nome da F-key
        ; F13 = 12+1, F14 = 12+2, F23 = 12+11
        theKey := "F" . (12 + keyIndex)
        mods := ""

        ; Acumula modificadores em STRING (ordem: Ctrl → Alt → Shift)
        ; SendInput sintaxe: "^" = Ctrl, "!" = Alt, "+" = Shift
        loop modCtrl
            mods .= "^"
        loop modAlt
            mods .= "!"
        loop modShift
            mods .= "+"

        ; Envia a combinação final
        ; Exemplo: mods="^+" + theKey="F13" → "^+{F13}"
        SendInput(mods . "{" . theKey . "}")
        SoundBeep(600, 60)

        ; RESET: Limpa combo após execução (single-use)
        modCtrl := 0
        modAlt := 0
        modShift := 0
        comboInProgress := false
    } else {
        ; Fallback: Envia a tecla original se combo não ativo
        SendInput(ModKeys[keyIndex])
        SoundBeep(200, 30)
    }
}


; ============================================================================
; HOTKEY: Shift duplo/triplo - Ativa/fecha combo
; ============================================================================
; ~LShift / ~RShift permite que Shift passe adiante (~ = passthrough)
;
; DUPLO CLIQUE (pressCount == 2):
;   → Ativa combo: comboInProgress = true
;   → Reseta modificadores: modCtrl, modAlt, modShift = 0
;   → Inicia timeout: SetTimer(CheckComboTimeout, 100)
;   → Feedback: SoundBeep 300Hz (combo ativado)
;
; TRIPLO CLIQUE (pressCount == 3):
;   → Fecha combo: comboInProgress = false
;   → Reseta modificadores
;   → Para timer: SetTimer(CheckComboTimeout, 0)
;   → Feedback: SoundBeep 200Hz (combo fechado)
;
; DETECÇÃO DE DUPLO CLIQUE:
;   → Usa DOUBLE_CLICK_DELAY (200ms) como janela máxima
;   → timeSinceLastPress > DOUBLE_CLICK_DELAY → reseta contador
;   → Contador reseta automaticamente após 500ms de pausa
;
~LShift::
~RShift::
{
    global comboInProgress, modCtrl, modAlt, modShift, comboTimeout
    static pressCount := 0          ; Quantas vezes Shift foi pressionado
    static lastPressTime := 0       ; Timestamp do último Shift

    currentTime := A_TickCount
    timeSinceLastPress := currentTime - lastPressTime

    ; Se passou da janela de detecção, reseta contador
    if timeSinceLastPress > DOUBLE_CLICK_DELAY {
        pressCount := 1
    } else {
        pressCount++
    }

    lastPressTime := currentTime

    ; DUPLO CLIQUE: inicia combo
    if pressCount == 2 && !comboInProgress {
        comboInProgress := true
        modCtrl := 0
        modAlt := 0
        modShift := 0
        comboTimeout := A_TickCount + COMBO_TIMEOUT
        SoundBeep(300, 60)
        SetTimer(CheckComboTimeout, 100)  ; Verifica timeout a cada 100ms
        return
    }

    ; TRIPLO CLIQUE: fecha combo
    if pressCount == 3 && comboInProgress {
        comboInProgress := false
        modCtrl := 0
        modAlt := 0
        modShift := 0
        SoundBeep(200, 60)
        SetTimer(CheckComboTimeout, 0)    ; Para o timer
        pressCount := 0
        return
    }

    ; Auto-reseta contador após 500ms de inatividade
    SetTimer(() => (pressCount := 0), 500)
}



; ============================================================================
; TIMER CALLBACK: CheckComboTimeout()
; ============================================================================
; Chamado a cada 100ms enquanto combo está ativo
; Verifica se A_TickCount ultrapassou comboTimeout
;
; SE TIMEOUT ATINGIDO:
;   → Fecha combo: comboInProgress = false
;   → Reseta modificadores
;   → Para timer: SetTimer(CheckComboTimeout, 0)
;
; TIMEOUT VALUE:
;   → Definido em COMBO_TIMEOUT (padrão: 1000ms)
;   → Atualizado cada vez que modificador é pressionado
;
CheckComboTimeout() {
    global comboInProgress, modCtrl, modAlt, modShift, comboTimeout

    if comboInProgress && A_TickCount > comboTimeout {
        ; Timeout atingido → fecha combo
        comboInProgress := false
        modCtrl := 0
        modAlt := 0
        modShift := 0
        SetTimer(CheckComboTimeout, 0)
    }
}


; ============================================================================
; HOTKEYS: Modificadores durante combo
; ============================================================================
; COMPORTAMENTO:
;   → Sem prefixo ~ = BLOQUEIAM a tecla original (não passa para app)
;   → Só funcionam quando #HotIf comboInProgress = true
;
; LÓGICA DE CADA MODIFICADOR:
;   1º pressão → modX++ (adiciona modificador)
;   2º pressão → fecha combo (anti-sticking / double-close)
;
; TIMEOUT UPDATE:
;   → Cada pressão de modificador renova o timeout
;   → comboTimeout := A_TickCount + COMBO_TIMEOUT
;   → Previne fechamento automático enquanto usuário está interagindo
;

#HotIf comboInProgress

; === SPACE: Adiciona modificador Shift (+ em SendInput) ===
Space::
{
    global comboInProgress, modShift, modCtrl, modAlt, comboTimeout

    if comboInProgress {
        if modShift == 0 {
            ; Primeira vez: incrementa modShift
            modShift++
            ; Renova timeout (impede auto-close)
            comboTimeout := A_TickCount + COMBO_TIMEOUT
            ; Sem feedback sonoro (apenas ao fechar)
        } else {
            ; Segunda vez: fecha combo (anti-sticking)
            comboInProgress := false
            modCtrl := 0
            modAlt := 0
            modShift := 0
            SoundBeep(200, 60)
            SetTimer(CheckComboTimeout, 0)
        }
    }
}


; === CTRL: Adiciona modificador Ctrl (^ em SendInput) ===
LCtrl::
RCtrl::
{
    global comboInProgress, modCtrl, modShift, modAlt, comboTimeout

    if comboInProgress {
        if modCtrl == 0 {
            ; Primeira vez: incrementa modCtrl
            modCtrl++
            ; Renova timeout
            comboTimeout := A_TickCount + COMBO_TIMEOUT
        } else {
            ; Segunda vez: fecha combo
            comboInProgress := false
            modCtrl := 0
            modAlt := 0
            modShift := 0
            SoundBeep(200, 60)
            SetTimer(CheckComboTimeout, 0)
        }
    }
}


; === ALT: Adiciona modificador Alt (! em SendInput) ===
LAlt::
RAlt::
{
    global comboInProgress, modAlt, modShift, modCtrl, comboTimeout

    if comboInProgress {
        if modAlt == 0 {
            ; Primeira vez: incrementa modAlt
            modAlt++
            ; Renova timeout
            comboTimeout := A_TickCount + COMBO_TIMEOUT
        } else {
            ; Segunda vez: fecha combo
            comboInProgress := false
            modCtrl := 0
            modAlt := 0
            modShift := 0
            SoundBeep(200, 60)
            SetTimer(CheckComboTimeout, 0)
        }
    }
}

#HotIf  ; Fim de hotkeys condicionais ao combo

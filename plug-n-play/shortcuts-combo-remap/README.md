# Hotkey Combo Maker

Sistema de combo-based hotkey remapping com modificadores acumulados para AutoHotkey 2.0.18+

## Começar rapidinho

1. Execute `better-remap.ahk` (versão otimizada)
2. Duplo clique em **Shift** para ativar combo mode
3. Pressione modificadores e depois uma tecla de comando
4. Pronto! Recebeu um F13-F23 com seus modificadores

## Como funciona

### Ativar combo

Pressione **Shift duas vezes rapidamente** (dentro de 200ms por padrão)

### Adicionar modificadores

Enquanto combo está ativo, pressione:

- **Space** → Adiciona Shift
- **Ctrl** → Adiciona Ctrl
- **Alt** → Adiciona Alt

Você pode acumular múltiplos modificadores clicando várias vezes.

### Enviar comando

Pressione qualquer uma destas teclas para disparar o atalho com modificadores acumulados:

| Tecla | Output | Tecla | Output |
| ----- | ------ | ----- | ------ |
| **D** | F13    | **N** | F17    |
| **F** | F14    | **R** | F18    |
| **O** | F15    | **W** | F19    |
| **I** | F16    | **P** | F20    |

Mais: **T** (F21) | **0** (F22) | **BackSpace** (F23)

### Fechar combo

Combo fecha automaticamente:

- Pressione **Shift três vezes**, ou
- Pressione o mesmo modificador duas vezes (ex: Space 2x), ou
- Aguarde timeout (padrão 1000ms)

## Exemplos de uso

| Entrada                      | Output               | Uso                     |
| ---------------------------- | -------------------- | ----------------------- |
| Shift Shift `D`              | `F13`                | Comando simples         |
| Shift Shift Space `D`        | `Shift+F13`          | Comando com Shift       |
| Shift Shift Space Ctrl `D`   | `Shift+Ctrl+F13`     | Múltiplos modificadores |
| Shift Shift Space Ctrl Alt P | `Shift+Ctrl+Alt+F20` | Stack completo          |

## Requisitos

- **AutoHotkey 2.0.18+** [(download)](https://www.autohotkey.com/download/)
- **Windows** 10+

## Atalhos padrão do sistema

Global (fora do combo):

- `CapsLock` → `Escape`

Debug:

- `Ctrl+Alt+Shift+F18` → Recarrega o script

## Como customizar

Edite o topo do script com suas preferências:

```ahk
; Tempo máximo que o combo permanece ativo sem atividade
global COMBO_TIMEOUT := 1000         ; em milissegundos

; Janela para detectar duplo clique em Shift
global DOUBLE_CLICK_DELAY := 200     ; em milissegundos

; Teclas remapeáveis (mande para seus atalhos)
ModKeys := ["D", "F", "O", "I", "N", "R", "W", "P", "T", "0", "BackSpace"]
```

## Arquivos

- **`better-remap.ahk`** ← Use este. Versão compilada e otimizada para produção.
- **`better-remap-documented.ahk`** ← Use se quiser estudar o código. Contém comentários linha-a-linha explicando cada função e lógica.

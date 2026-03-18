# Plug & Play Scripts

Scripts AHK prontos para uso. Copie o arquivo desejado para sua máquina e execute.

## Scripts disponíveis

### Hotkey Combo Maker

📁 **Local:** `shortcuts-combo-remap/`

Sistema de combo-based hotkey remapping com modificadores acumulados para AutoHotkey 2.0.18+

**Começar rapidinho:**

1. Copie `shortcuts-combo-remap/better-remap.ahk` para onde quiser
2. Execute o arquivo (`.ahk`)
3. Duplo clique em **Shift** para ativar o combo mode
4. Pressione **Space**, **Ctrl** ou **Alt** para adicionar modificadores
5. Pressione uma letra/número para enviar F13-F23

**Atalhos padrão:**

- `CapsLock` → `Escape` (global)
- `Ctrl+Alt+Shift+F18` → Recarrega o script

```ahk
^!+F18::Reload
; COMBO = Shift->Shift->Ctrl->Alt->Space->R == Ctrl+Alt+Shift+F18
```

[📖 Documentação completa](./shortcuts-combo-remap/README.md)

## Como escolher qual usar?

- **`better-remap.ahk`** — Use esta. Versão compilada e otimizada.
- **`better-remap-documented.ahk`** — Use se quiser estudar o código. Comentários linhas a linha.

## Requisitos

- Windows 10+
- [AutoHotkey 2.0.18+](https://www.autohotkey.com/download/)

## Personalização

Edite as variáveis no topo de cada script:

```ahk
global COMBO_TIMEOUT := 1000         ; tempo até combo expirar
global DOUBLE_CLICK_DELAY := 200     ; janela para detectar duplo clique
ModKeys := [...] ; teclas remapeáveis
```

## Contribuições

Se encontrar bugs ou tiver sugestões, abra um issue ou PR no repositório.

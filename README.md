<!-- markdownlint-disable MD033 -->

# Macros via Auto Hot Keys

Esse repositório contém macros AHK variados para utilização geral.

---

> Aviso
>
> ## Scripts otimizados para uso pessoal
>
> _Embora desenvolvidos sob o principio de modularidade — permitindo personalização em massa — recomendo discrição ao utilizá-los._

---

> Nota
> Remendo a leitura da [documentação oficial](https://www.autohotkey.com/docs/v2/) para melhor entendimento do funcionamento dos scripts.

## Estrutura

```tree
active-development/  → Playground com scripts experimentais e em desenvolvimento
plug-n-play/         → Scripts estáveis e prontos para usar
tests/               → Testes de modularidade e conceitos
```

## Scripts

### 🎯 [plug-n-play/](./plug-n-play/)

Scripts prontos para produção. Copie o arquivo `.ahk` desejado e execute.

### Requisitos

- Windows 10+
- [AutoHotkey 2.0.18+](https://www.autohotkey.com/download/)

#### [**Hotkey Combo Maker**](./plug-n-play/shortcuts-combo-remap/README.md)

Sistema de combo-based hotkey remapping com modificadores acumulados.

**Recursos:**

- Duplo clique em Shift para ativar combo mode
- Acumular modificadores (Space → Shift, Ctrl → Ctrl, Alt → Alt)
- Enviar F13-F23 com modificadores via letras/números
- Auto-close por timeout ou triplo Shift

**Arquivos:**

- `better-remap.ahk` — Versão otimizada (recomendada)
- `better-remap-documented.ahk` — Versão com comentários detalhados

[Documentação](./plug-n-play/shortcuts-combo-remap/README.md)

### [active-development/](./active-development/)

Arquivos experimentais e em desenvolvimento. **Não recomendado para uso.**

- `playground.ahk` — Compilado de snippets variados para prototipar ideias

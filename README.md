# Dotfiles

Dotfiles gerenciados com [chezmoi](https://www.chezmoi.io/) e encriptados com [age](https://github.com/FiloSottile/age).

## O que é gerenciado

### Shell e Terminal

- `~/.zshrc` — Zsh config (oh-my-zsh + powerlevel10k)
- `~/.p10k.zsh` — Powerlevel10k theme config
- `~/.secrets.env` — Variáveis de ambiente sensíveis (encrypted)

### Git

- `~/.gitconfig` — Git config (template — signing key path varia por máquina)
- `~/.gitignore` — Global gitignore
- `~/.ssh/config` — SSH hosts
- `~/.ssh/id_ed25519` — Chave SSH para git (encrypted)
- `~/.ssh/id_ed25519.pub` — Chave pública SSH
- `~/.ssh/github_signing_ed25519` — Chave de assinatura de commits (encrypted)
- `~/.ssh/github_signing_ed25519.pub` — Chave pública de assinatura

### Ferramentas de Desenvolvimento

- `~/.config/.jira/.config.yml` — Jira CLI config
- `~/.config/gh/config.yml` — GitHub CLI config
- `~/.config/cmux/cmux.json` — cmux config

### Claude Code

- `~/.claude/CLAUDE.md` — Instruções globais
- `~/.claude/settings.json` — Configurações (modelo, plugins)
- `~/.claude/commands/` — Comandos customizados
- `~/.claude/skills/` — Skills customizadas

## Pré-requisitos

```bash
# macOS
brew install chezmoi age

# Linux (Fedora)
sudo dnf install chezmoi
# age: baixar binário de https://github.com/FiloSottile/age/releases
```

## Setup numa máquina nova

### 1. Copiar a chave age

Copiar `key.txt` de uma máquina existente via canal seguro (scp, AirDrop, etc):

```bash
mkdir -p ~/.config/chezmoi
# copiar key.txt para ~/.config/chezmoi/key.txt
chmod 600 ~/.config/chezmoi/key.txt
```

O `chezmoi.toml` é gerado automaticamente pelo repo (via `.chezmoi.toml.tmpl`).

### 2. Aplicar

```bash
chezmoi init --apply git@github.com:rafabene/dotfiles.git
```

## Uso diário

### Editar um dotfile

```bash
chezmoi edit ~/.zshrc
chezmoi apply
```

### Adicionar um novo dotfile

```bash
chezmoi add ~/.novo-arquivo
```

### Adicionar um arquivo com secrets

```bash
chezmoi add --encrypt ~/.arquivo-secreto
```

### Atualizar a partir do repo (pull + apply)

```bash
chezmoi update
```

### Ver diferenças entre estado atual e source

```bash
chezmoi diff
```

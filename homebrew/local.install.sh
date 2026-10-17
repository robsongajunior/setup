#!/usr/bin/env bash
#
# install-brew-noadmin.sh
# Instala o Homebrew SEM acesso de administrador (sem sudo), dentro de uma pasta
# do seu usuário, e configura o ~/.zshrc para usar esse brew.
#
# Uso:
#   ./install-brew-noadmin.sh <caminho-destino>
#
# Exemplos:
#   ./install-brew-noadmin.sh ~/homebrew_owned
#   ./install-brew-noadmin.sh ~/.local/homebrew
#   ./install-brew-noadmin.sh /Users/guilherme.santana/homebrew_owned
#

set -euo pipefail

# ---------------------------------------------------------------------------
# Cores para as mensagens (degrada bem se o terminal não suportar)
# ---------------------------------------------------------------------------
if [ -t 1 ]; then
  BOLD="$(printf '\033[1m')"; RED="$(printf '\033[31m')"; GREEN="$(printf '\033[32m')"
  YELLOW="$(printf '\033[33m')"; BLUE="$(printf '\033[34m')"; RESET="$(printf '\033[0m')"
else
  BOLD=""; RED=""; GREEN=""; YELLOW=""; BLUE=""; RESET=""
fi

info()  { printf "%s==>%s %s\n" "${BLUE}${BOLD}" "${RESET}" "$*"; }
ok()    { printf "%s✔%s  %s\n" "${GREEN}" "${RESET}" "$*"; }
warn()  { printf "%s!%s  %s\n" "${YELLOW}${BOLD}" "${RESET}" "$*"; }
die()   { printf "%s✘  %s%s\n" "${RED}${BOLD}" "$*" "${RESET}" >&2; exit 1; }

# ---------------------------------------------------------------------------
# 1. Validar o argumento
# ---------------------------------------------------------------------------
if [ "$#" -ne 1 ]; then
  die "Faltou o caminho de destino.
    Uso: $0 <caminho-destino>
    Ex.: $0 ~/homebrew_owned"
fi

# Expande ~ para $HOME e resolve o caminho absoluto (sem exigir que já exista)
RAW_PATH="$1"
case "$RAW_PATH" in
  "~")      RAW_PATH="$HOME" ;;
  "~/"*)    RAW_PATH="$HOME/${RAW_PATH#\~/}" ;;
esac
# Normaliza para caminho absoluto
PARENT_DIR="$(cd "$(dirname "$RAW_PATH")" 2>/dev/null && pwd || true)"
[ -n "$PARENT_DIR" ] || die "O diretório pai de '$RAW_PATH' não existe. Crie-o antes ou escolha outro caminho."
BREW_PREFIX="$PARENT_DIR/$(basename "$RAW_PATH")"

info "Prefixo escolhido: ${BOLD}$BREW_PREFIX${RESET}"

# ---------------------------------------------------------------------------
# 2. Checagens de segurança
# ---------------------------------------------------------------------------
# Nunca deixar rodar como root — o Homebrew não deve ser root.
if [ "$(id -u)" = "0" ]; then
  die "Não rode este script como root/sudo. O Homebrew deve pertencer ao seu usuário."
fi

# Se a pasta já existe e tem conteúdo, avisar antes de mexer.
if [ -e "$BREW_PREFIX" ]; then
  if [ -d "$BREW_PREFIX/.git" ] || [ -x "$BREW_PREFIX/bin/brew" ]; then
    warn "Já parece existir um Homebrew em '$BREW_PREFIX'. Vou pular o clone e só reconfigurar o PATH."
    SKIP_CLONE=1
  elif [ -n "$(ls -A "$BREW_PREFIX" 2>/dev/null || true)" ]; then
    die "'$BREW_PREFIX' já existe e não está vazio (e não parece um Homebrew). Escolha outro caminho ou limpe a pasta."
  else
    SKIP_CLONE=0
  fi
else
  SKIP_CLONE=0
fi

# ---------------------------------------------------------------------------
# 3. Clonar o Homebrew (git preferido, curl como fallback)
# ---------------------------------------------------------------------------
if [ "${SKIP_CLONE:-0}" -eq 0 ]; then
  if command -v git >/dev/null 2>&1; then
    info "Clonando o Homebrew com git..."
    git clone https://github.com/Homebrew/brew "$BREW_PREFIX"
  elif command -v curl >/dev/null 2>&1; then
    info "git não encontrado — baixando o tarball com curl..."
    mkdir -p "$BREW_PREFIX"
    curl -fL https://github.com/Homebrew/brew/tarball/master \
      | tar xz --strip-components 1 -C "$BREW_PREFIX"
  else
    die "Nem 'git' nem 'curl' encontrados. Instale um dos dois e rode de novo."
  fi
  ok "Homebrew baixado em $BREW_PREFIX"
fi

# Confirma que o binário existe
[ -x "$BREW_PREFIX/bin/brew" ] || die "Não encontrei um brew executável em '$BREW_PREFIX/bin/brew'. Algo deu errado no clone."

# ---------------------------------------------------------------------------
# 4. Configurar o ~/.zshrc (idempotente)
# ---------------------------------------------------------------------------
ZSHRC="$HOME/.zshrc"
SHELLENV_LINE="eval \"\$($BREW_PREFIX/bin/brew shellenv)\""

touch "$ZSHRC"

if grep -Fq "$SHELLENV_LINE" "$ZSHRC"; then
  ok "A linha do shellenv para este prefixo já existe no ~/.zshrc — nada a fazer."
else
  # Comenta linhas de shellenv de OUTROS prefixos do Homebrew, para evitar conflito de PATH.
  if grep -q 'brew shellenv' "$ZSHRC"; then
    warn "Encontrei outra(s) linha(s) de 'brew shellenv' no ~/.zshrc apontando para outro prefixo."
    warn "Vou comentá-las (não apagar) para evitar conflito. Backup em ~/.zshrc.bak-brew"
    cp "$ZSHRC" "$HOME/.zshrc.bak-brew"
    # Comenta apenas as linhas com 'brew shellenv' que NÃO são a nova
    sed -i.tmp "/brew shellenv/ s|^\([^#]\)|# [comentado pelo install-brew-noadmin] \1|" "$ZSHRC"
    rm -f "$ZSHRC.tmp"
  fi
  {
    printf '\n# Homebrew (instalado sem admin em %s)\n' "$BREW_PREFIX"
    printf '%s\n' "$SHELLENV_LINE"
  } >> "$ZSHRC"
  ok "Adicionada ao ~/.zshrc a linha:  $SHELLENV_LINE"
fi

# ---------------------------------------------------------------------------
# 5. Verificação rápida na sessão atual (sem depender do reload)
# ---------------------------------------------------------------------------
info "Verificando a instalação..."
eval "$("$BREW_PREFIX/bin/brew" shellenv)"
hash -r 2>/dev/null || true

BREW_VER="$("$BREW_PREFIX/bin/brew" --version | head -n1 || true)"
ok "$BREW_VER"
ok "brew --prefix -> $("$BREW_PREFIX/bin/brew" --prefix)"

# ---------------------------------------------------------------------------
# 6. Instruções finais
# ---------------------------------------------------------------------------
printf '\n%s========================================================%s\n' "$GREEN$BOLD" "$RESET"
ok "Homebrew instalado sem admin em: $BREW_PREFIX"
printf '\n%sPara usar agora nesta janela do terminal:%s\n' "$BOLD" "$RESET"
printf '  source ~/.zshrc && hash -r\n'
printf '\n%sDepois teste com:%s\n' "$BOLD" "$RESET"
printf '  brew --version\n'
printf '  brew doctor    # avisos sobre prefixo não-padrão são esperados\n'
printf '\n%sInstalar algo (ex.: gh e claude-code):%s\n' "$BOLD" "$RESET"
printf '  brew install gh\n'
printf '  brew install --cask claude-code\n'
printf '%s========================================================%s\n' "$GREEN$BOLD" "$RESET"

warn "Lembrete: NUNCA rode 'brew' com sudo — é o que causa os erros de permissão."

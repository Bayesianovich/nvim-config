#!/usr/bin/env bash

set -Eeuo pipefail

REPO_URL="${NVIM_CONFIG_REPO:-https://github.com/Bayesianovich/nvim-config.git}"
CONFIG_DIR="${NVIM_CONFIG_DIR:-${XDG_CONFIG_HOME:-${HOME}/.config}/nvim}"
LOCAL_BIN="${HOME}/.local/bin"
LOCAL_OPT="${HOME}/.local/opt"

DRY_RUN=0
SKIP_DEPENDENCIES=0
SKIP_SYNC=0
WITH_AI=0

log() {
  printf '[nvim-install] %s\n' "$*"
}

warn() {
  printf '[nvim-install] WARNING: %s\n' "$*" >&2
}

die() {
  printf '[nvim-install] ERROR: %s\n' "$*" >&2
  exit 1
}

usage() {
  cat <<'EOF'
Usage: install.sh [options]

Options:
  --dry-run      Print the planned actions without changing the system.
  --skip-deps    Do not install operating-system dependencies.
  --skip-sync    Do not run the initial Lazy.nvim plugin sync.
  --with-ai      Install Claude Code and Codex CLI with npm.
  -h, --help     Show this help message.
EOF
}

run() {
  if ((DRY_RUN)); then
    printf '[dry-run]'
    printf ' %q' "$@"
    printf '\n'
    return 0
  fi
  "$@"
}

run_as_root() {
  if ((EUID == 0)); then
    run "$@"
  elif command -v sudo >/dev/null 2>&1; then
    run sudo "$@"
  else
    die "Installing system packages requires root access or sudo."
  fi
}

append_path_line() {
  local file="$1"
  # Keep HOME and PATH dynamic for future shell sessions.
  # shellcheck disable=SC2016
  local line='export PATH="$HOME/.local/bin:$PATH"'

  if ((DRY_RUN)); then
    log "Would ensure ${LOCAL_BIN} is configured in ${file}."
    return
  fi

  touch "$file"
  if ! grep -Fqx "$line" "$file"; then
    printf '\n%s\n' "$line" >>"$file"
  fi
}

ensure_local_bin() {
  run mkdir -p "$LOCAL_BIN" "$LOCAL_OPT"
  export PATH="${LOCAL_BIN}:${PATH}"

  append_path_line "${HOME}/.profile"
  case "${SHELL:-}" in
    */bash) append_path_line "${HOME}/.bashrc" ;;
    */zsh) append_path_line "${HOME}/.zshrc" ;;
  esac
}

install_dependencies() {
  if ((SKIP_DEPENDENCIES)); then
    log "Skipping operating-system dependencies."
    return
  fi

  if command -v apt-get >/dev/null 2>&1; then
    log "Installing dependencies with apt."
    run_as_root apt-get update
    run_as_root env DEBIAN_FRONTEND=noninteractive apt-get install -y \
      build-essential ca-certificates clang-format curl fd-find git gzip nodejs npm \
      python3 python3-venv ripgrep tar unzip wl-clipboard xclip xdg-utils
  elif command -v dnf >/dev/null 2>&1; then
    log "Installing dependencies with dnf."
    run_as_root dnf install -y \
      ca-certificates clang-tools-extra curl fd-find gcc gcc-c++ git gzip make nodejs npm \
      python3 ripgrep tar unzip wl-clipboard xclip xdg-utils
  elif command -v pacman >/dev/null 2>&1; then
    log "Installing dependencies with pacman."
    run_as_root pacman -Syu --needed --noconfirm \
      base-devel ca-certificates clang curl fd git gzip nodejs npm python ripgrep tar unzip \
      wl-clipboard xclip xdg-utils
  else
    die "Unsupported package manager. Use --skip-deps after installing the README requirements."
  fi
}

ensure_fd_command() {
  if command -v fd >/dev/null 2>&1; then
    return
  fi
  if command -v fdfind >/dev/null 2>&1; then
    run ln -sfn "$(command -v fdfind)" "${LOCAL_BIN}/fd"
    return
  fi
  warn "Neither fd nor fdfind is available. File picking will be limited."
}

nvim_is_compatible() {
  local output version major minor

  command -v nvim >/dev/null 2>&1 || return 1
  output="$(nvim --version)"
  version="${output%%$'\n'*}"
  if [[ ! "$version" =~ v([0-9]+)\.([0-9]+) ]]; then
    return 1
  fi

  major="${BASH_REMATCH[1]}"
  minor="${BASH_REMATCH[2]}"
  ((major > 0 || minor >= 11))
}

install_neovim() {
  local arch asset_dir archive_url temp_dir install_dir backup_dir

  if nvim_is_compatible; then
    local installed_output installed_version
    installed_output="$(nvim --version)"
    installed_version="${installed_output%%$'\n'*}"
    log "Neovim ${installed_version} is already compatible."
    return
  fi

  case "$(uname -m)" in
    x86_64 | amd64)
      arch="x86_64"
      ;;
    aarch64 | arm64)
      arch="arm64"
      ;;
    *)
      die "Neovim's official Linux archive is not configured for architecture: $(uname -m)"
      ;;
  esac

  asset_dir="nvim-linux-${arch}"
  archive_url="https://github.com/neovim/neovim/releases/latest/download/${asset_dir}.tar.gz"
  install_dir="${LOCAL_OPT}/nvim"

  if ((DRY_RUN)); then
    log "Would install Neovim from ${archive_url} into ${install_dir}."
    return
  fi

  temp_dir="$(mktemp -d)"
  log "Installing the latest stable Neovim release."
  curl -fL "$archive_url" -o "${temp_dir}/nvim.tar.gz"
  tar -xzf "${temp_dir}/nvim.tar.gz" -C "$temp_dir"

  if [[ -e "$install_dir" ]]; then
    backup_dir="${install_dir}.backup.$(date +%Y%m%d%H%M%S)"
    mv "$install_dir" "$backup_dir"
    log "Backed up the previous local Neovim to ${backup_dir}."
  fi

  mkdir -p "$LOCAL_OPT"
  mv "${temp_dir}/${asset_dir}" "$install_dir"
  ln -sfn "${install_dir}/bin/nvim" "${LOCAL_BIN}/nvim"
  rm -rf "$temp_dir"
}

install_lazygit() {
  local version arch archive_url temp_dir

  if command -v lazygit >/dev/null 2>&1; then
    log "Lazygit is already installed."
    return
  fi

  case "$(uname -m)" in
    x86_64 | amd64) arch="x86_64" ;;
    aarch64 | arm64) arch="arm64" ;;
    *)
      warn "Skipping Lazygit on unsupported architecture: $(uname -m)"
      return
      ;;
  esac

  if ((DRY_RUN)); then
    log "Would install the latest Lazygit release into ${LOCAL_BIN}."
    return
  fi

  version="$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest \
    | sed -nE 's/.*"tag_name":[[:space:]]*"v?([^"]+)".*/\1/p')"
  if [[ -z "$version" ]]; then
    warn "Could not determine the latest Lazygit version; skipping it."
    return
  fi

  archive_url="https://github.com/jesseduffield/lazygit/releases/download/v${version}/lazygit_${version}_Linux_${arch}.tar.gz"
  temp_dir="$(mktemp -d)"
  log "Installing Lazygit ${version}."
  curl -fL "$archive_url" -o "${temp_dir}/lazygit.tar.gz"
  tar -xzf "${temp_dir}/lazygit.tar.gz" -C "$temp_dir" lazygit
  install -m 0755 "${temp_dir}/lazygit" "${LOCAL_BIN}/lazygit"
  rm -rf "$temp_dir"
}

install_ai_clis() {
  if ((!WITH_AI)); then
    return
  fi
  if ! command -v npm >/dev/null 2>&1; then
    die "--with-ai requires npm."
  fi

  log "Installing optional AI CLIs. Authentication is still required afterward."
  run npm config set prefix "$HOME/.local"
  run npm install -g @anthropic-ai/claude-code @openai/codex
}

check_required_commands() {
  local command_name

  if ((DRY_RUN)); then
    return
  fi
  for command_name in git nvim rg fd lazygit node npm python3 clang-format; do
    command -v "$command_name" >/dev/null 2>&1 || die "Required command is unavailable: ${command_name}"
  done
}

sync_config() {
  local parent_dir origin dirty backup_dir

  case "$CONFIG_DIR" in
    "" | / | "$HOME") die "Refusing unsafe config directory: ${CONFIG_DIR}" ;;
  esac

  parent_dir="$(dirname "$CONFIG_DIR")"
  run mkdir -p "$parent_dir"

  if [[ -d "${CONFIG_DIR}/.git" ]]; then
    origin="$(git -C "$CONFIG_DIR" remote get-url origin 2>/dev/null || true)"
    dirty="$(git -C "$CONFIG_DIR" status --porcelain 2>/dev/null || true)"
    if [[ "$origin" == "$REPO_URL" && -z "$dirty" ]]; then
      log "Updating the existing clean configuration."
      run git -C "$CONFIG_DIR" fetch --prune origin
      run git -C "$CONFIG_DIR" pull --ff-only origin main
      return
    fi
  fi

  if [[ -e "$CONFIG_DIR" ]]; then
    backup_dir="${CONFIG_DIR}.backup.$(date +%Y%m%d%H%M%S)"
    run mv "$CONFIG_DIR" "$backup_dir"
    log "Backed up the existing configuration to ${backup_dir}."
  fi

  log "Cloning Neovim configuration into ${CONFIG_DIR}."
  run git clone "$REPO_URL" "$CONFIG_DIR"
}

sync_plugins() {
  if ((SKIP_SYNC)); then
    log "Skipping Lazy.nvim plugin sync."
    return
  fi
  if ((DRY_RUN)); then
    log "Would run the initial Lazy.nvim plugin sync."
    return
  fi
  command -v nvim >/dev/null 2>&1 || die "nvim is not available after installation."

  log "Synchronizing Neovim plugins. This may take a few minutes."
  nvim --headless "+Lazy! sync" "+qa"
}

main() {
  while (($#)); do
    case "$1" in
      --dry-run) DRY_RUN=1 ;;
      --skip-deps) SKIP_DEPENDENCIES=1 ;;
      --skip-sync) SKIP_SYNC=1 ;;
      --with-ai) WITH_AI=1 ;;
      -h | --help)
        usage
        exit 0
        ;;
      *)
        usage >&2
        die "Unknown option: $1"
        ;;
    esac
    shift
  done

  if [[ "$(uname -s)" != "Linux" ]]; then
    if ((DRY_RUN)); then
      warn "Simulating the Linux installer on $(uname -s)."
    else
      die "This installer supports Linux and WSL. Use install.ps1 on Windows."
    fi
  fi

  ensure_local_bin
  install_dependencies
  ensure_fd_command
  install_neovim
  install_lazygit
  install_ai_clis
  check_required_commands
  sync_config
  sync_plugins

  log "Installation complete."
  log "Restart your shell, run nvim, then use :checkhealth and :Mason."
  if ((!WITH_AI)); then
    log "Optional AI CLIs were not installed. Re-run with --with-ai if needed."
  else
    log "Authenticate claude and codex before using their Neovim integrations."
  fi
  log "Select a Nerd Font in your terminal if icons are missing."
}

main "$@"

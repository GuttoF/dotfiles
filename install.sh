#!/bin/bash

echo "Atualizando o Homebrew..."
brew update || {
  echo "Erro ao atualizar o Homebrew. Verifique sua instalação."
  exit 1
}

PACKAGES=(
  git
  wget
  btop
  fastfetch
  lazydocker
  lazygit
  neovim
  gh
  zellij
  fzf
  eza
  zoxide
  bat
  ripgrep
  fd-find
  tldr
  ruff
  uv
  pyright
  mise
)

echo "Instalando pacotes de terminal..."
for package in "${PACKAGES[@]}"; do
  if ! brew list $package &>/dev/null; then
    echo "Instalando $package..."
    if ! brew install $package; then
      echo "Erro ao instalar $package. Pulando..."
    fi
  else
    echo "$package já está instalado."
  fi
done

CASKS=(
  font-caskaydia-mono-nerd-font
  firefox
  zen-browser
  brave-browser
  orbstack
  obsidian
  visual-studio-code
  spotify
  bruno
  vlc
  alacritty
  localsend
  raycast
  virtualbox
  beekeeper-studio
  dbeaver-community
  nordpass
  nordvpn
  starship
  pycharm
  goland
  datagrip
  ghostty
)

echo "Instalando aplicativos gráficos..."
for cask in "${CASKS[@]}"; do
  if ! brew list --cask $cask &>/dev/null; then
    echo "Instalando $cask..."
    if ! brew install --cask $cask; then
      echo "Erro ao instalar $cask. Pulando..."
    fi
  else
    echo "$cask já está instalado."
  fi
done

echo "Baixando e instalando arquivos via curl..."
CURL_DOWNLOADS=(
  "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
)

for item in "${CURL_DOWNLOADS[@]}"; do
  URL="${item%%:*}"
  DEST="${item##*:}"
  echo "Baixando $URL..."
  if curl -L -o "$DEST" "$URL"; then
    chmod +x "$DEST"
    echo "$DEST instalado com sucesso."
  else
    echo "Erro ao baixar $URL. Pulando..."
  fi
done

echo "Limpando arquivos desnecessários..."
if ! brew cleanup; then
  echo "Erro ao realizar a limpeza."
fi

echo "Instalação concluída!"

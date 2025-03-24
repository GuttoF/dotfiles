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
  bat
  ripgrep
  fd-find
  tldr
  ruff
  uv
  pyright
  mise
  gopls
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
  insomnia
  spotify
  bruno
  vlc
  localsend
  raycast
  virtualbox
  beekeeper-studio
  dbeaver-community
  nordpass
  nordvpn
  pycharm
  goland
  datagrip
  ghostty
  jandedobbeleer/oh-my-posh/oh-my-posh
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

echo "Baixando e instalando plugins para Oh My Zsh..."

echo "Instalando fast-syntax-highlighting..."
if git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting; then
  echo "fast-syntax-highlighting instalado com sucesso."
else
  echo "Erro ao instalar fast-syntax-highlighting. Pulando..."
fi

echo "Instalando zsh-syntax-highlighting..."
if git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting; then
  echo "zsh-syntax-highlighting instalado com sucesso."
else
  echo "Erro ao instalar zsh-syntax-highlighting. Pulando..."
fi

echo "Instalando zsh-autosuggestions..."
if git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions; then
  echo "zsh-autosuggestions instalado com sucesso."
else
  echo "Erro ao instalar zsh-autosuggestions. Pulando..."
fi

echo "Copiando arquivos de configuração para ~/.config..."
if [ ! -d "$HOME/.config" ]; then
  echo "Criando pasta ~/.config..."
  mkdir -p "$HOME/.config"
fi

if [ -d "config" ]; then
  echo "Copiando arquivos..."
  cp -r config/* "$HOME/.config/"
  echo "Arquivos de configuração copiados com sucesso!"
else
  echo "Erro: A pasta 'config' não foi encontrada."
fi

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

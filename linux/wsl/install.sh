#!/bin/bash

check_error() {
  if [ $? -ne 0 ]; then
    echo "Erro: $1"
    exit 1
  fi
}

echo "Atualizando o sistema..."
sudo apt update && sudo apt upgrade -y
check_error "Falha ao atualizar o sistema."

echo "Instalando dependências básicas..."
sudo apt install -y curl git unzip wget build-essential pkg-config autoconf bison clang rustc \
  libssl-dev libreadline-dev zlib1g-dev libyaml-dev libncurses5-dev libffi-dev libgdbm-dev libjemalloc2 \
  libvips imagemagick libmagickwand-dev mupdf mupdf-tools gir1.2-gtop-2.0 gir1.2-clutter-1.0 \
  redis-tools sqlite3 libsqlite3-0 libmysqlclient-dev libpq-dev postgresql-client postgresql-client-common
check_error "Falha ao instalar dependências básicas."

echo "Instalando fontes..."
mkdir -p ~/.local/share/fonts
cd /tmp
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaMono.zip
unzip CascadiaMono.zip -d CascadiaFont
cp CascadiaFont/*.ttf ~/.local/share/fonts
rm -rf CascadiaMono.zip CascadiaFont

wget -O iafonts.zip https://github.com/iaolo/iA-Fonts/archive/refs/heads/master.zip
unzip iafonts.zip -d iaFonts
cp iaFonts/iA-Fonts-master/iA\ Writer\ Mono/Static/iAWriterMonoS-*.ttf ~/.local/share/fonts
rm -rf iafonts.zip iaFonts
fc-cache
cd -
check_error "Falha ao instalar fontes."

echo "Instalando ferramentas de desenvolvimento..."
curl -LsSf https://astral.sh/uv/install.sh | sh
curl -LsSf https://astral.sh/ruff/install.sh | sh
sudo snap install gopls --classic
sudo snap install pyright --classic
check_error "Falha ao instalar ferramentas de desenvolvimento."

echo "Instalando Mise..."
sudo apt update -y && sudo apt install -y gpg wget curl
sudo install -dm 755 /etc/apt/keyrings
wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/mise-archive-keyring.gpg 1>/dev/null
echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=$(dpkg --print-architecture)] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list
sudo apt update
sudo apt install -y mise
check_error "Falha ao instalar Mise."

echo "Instalando Fastfetch..."
sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
sudo apt update -y
sudo apt install -y fastfetch
check_error "Falha ao instalar Fastfetch."

echo "Instalando GitHub CLI..."
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg &&
  sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg &&
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
  sudo apt update &&
  sudo apt install gh -y
check_error "Falha ao instalar GitHub CLI."

echo "Instalando Lazydocker e Lazygit..."
cd /tmp
LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -sLo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"
tar -xf lazydocker.tar.gz lazydocker
sudo install lazydocker /usr/local/bin
rm lazydocker.tar.gz lazydocker

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -sLo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar -xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit.tar.gz lazygit
mkdir -p ~/.config/lazygit/
touch ~/.config/lazygit/config.yml
cd -
check_error "Falha ao instalar Lazydocker e Lazygit."

echo "Instalando Neovim..."
cd /tmp
wget -O nvim.tar.gz "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz"
tar -xf nvim.tar.gz
sudo install nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
sudo cp -R nvim-linux-x86_64/lib /usr/local/
sudo cp -R nvim-linux-x86_64/share /usr/local/
rm -rf nvim-linux-x86_64 nvim.tar.gz
cd -
check_error "Falha ao instalar Neovim."

echo "Instalando Zellij..."
cd /tmp
wget -O zellij.tar.gz "https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz"
tar -xf zellij.tar.gz zellij
sudo install zellij /usr/local/bin
rm zellij.tar.gz zellij
cd -
check_error "Falha ao instalar Zellij."

echo "Instalando ferramentas de terminal..."
sudo apt install -y fzf ripgrep bat eza zoxide plocate btop apache2-utils fd-find tldr
check_error "Falha ao instalar ferramentas de terminal."

echo "Instalando Docker..."
sudo install -m 0755 -d /etc/apt/keyrings
sudo wget -qO /etc/apt/keyrings/docker.asc https://download.docker.com/linux/ubuntu/gpg
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
sudo usermod -aG docker ${USER}
echo '{"log-driver":"json-file","log-opts":{"max-size":"10m","max-file":"5"}}' | sudo tee /etc/docker/daemon.json
check_error "Falha ao instalar Docker."

echo "Instalando plugins do Oh My Zsh..."
if git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting; then
  echo "fast-syntax-highlighting instalado com sucesso."
else
  echo "Erro ao instalar fast-syntax-highlighting. Pulando..."
fi

if git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting; then
  echo "zsh-syntax-highlighting instalado com sucesso."
else
  echo "Erro ao instalar zsh-syntax-highlighting. Pulando..."
fi

if git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions; then
  echo "zsh-autosuggestions instalado com sucesso."
else
  echo "Erro ao instalar zsh-autosuggestions. Pulando..."
fi

echo "Copiando arquivos de configuração..."
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
sudo apt autoremove -y && sudo apt clean || {
  echo "Erro ao realizar a limpeza."
}

echo "Instalação concluída!"

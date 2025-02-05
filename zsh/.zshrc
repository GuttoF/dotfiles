export ZSH="$HOME/.oh-my-zsh"
export VIRTUAL_ENV_DISABLE_PROMPT=1
export HOMEBREW_NO_ENV_HINTS=1
export PATH="$PATH:/Users/gutto/.lmstudio/bin"

plugins=(git python fast-syntax-highlighting zsh-autosuggestions docker z)

source $ZSH/oh-my-zsh.sh
source ~/.config/zsh/aliases
source ~/.config/zsh/credentials

eval "$(starship init zsh)"
eval "$(zellij setup --generate-auto-start zsh)"
eval "$(/opt/homebrew/bin/mise activate zsh)"

if [[ $- == *i* ]]; then
    if command -v zellij &>/dev/null; then
        function zellij_tab_name_update_pre() {
            if [[ -n "$ZELLIJ" ]]; then
                local cmd_line=(${(z)1})
                local process_name=${cmd_line[1]}
                if [[ -n "$process_name" && "$process_name" != "z" ]]; then
                    nohup zellij action rename-tab "$process_name" >/dev/null 2>&1
                fi
            fi
        }

        function zellij_tab_name_update_post() {
            if [[ -n "$ZELLIJ" ]]; then
                local cmd_line=(${(z)1})
                local process_name=${cmd_line[1]}
                if [[ "$process_name" == "z" ]]; then
                    nohup zellij action rename-tab "$(pwd)" >/dev/null 2>&1
                fi
            fi
        }

        autoload -Uz add-zsh-hook
        add-zsh-hook preexec zellij_tab_name_update_pre
        add-zsh-hook precmd zellij_tab_name_update_post
    fi
fi

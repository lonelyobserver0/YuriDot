# ~/.config/fish/config.fish

set -g fish_greeting ""

set -gx PATH $PATH $HOME/.local/bin $HOME/Softwares/pycharm-community-2024.3.4/bin \
    $HOME/.config/hypr/scripts/themes $HOME/.config/hypr/scripts/power $HOME/Betterbird
set -gx XDG_CONFIG_DIR "$HOME/.config"
set -gx PATH $HOME/Code/Shell-scripts $PATH
set -gx PATH $HOME/Code/Shell-scripts/wofi_menu $PATH
set -gx PATH $HOME/.local/bin $PATH
set -gx PATH $HOME/.local/share/JetBrains/Toolbox/scripts $PATH
set -gx XDG_RUNTIME_DIR /run/user/$(id -u)
set -gx PATH $PATH $HOME/.lmstudio/bin

# Preferred editor (SSH conditional)
if set -q SSH_CONNECTION
    set -gx EDITOR nano
else
    set -gx EDITOR nano
end

# Aliases
alias bak="sudo rsync -av --delete --exclude=\"/run/media/\$USER/Data/\" --exclude=\"/home/\$USER/.local/share/Steam/\" --exclude='/sys' --exclude='/dev' --exclude='/mnt' --exclude='/media' --exclude='/tmp' --exclude='/proc' --exclude='/run' --exclude=\"/home/\$USER/.cache/\" / /mnt/data/backup/"
alias sdrn='shutdown -r now'
alias vscan="clamscan --recursive --infected --exclude-dir='^/sys|^/dev' /"
alias clear="clear && sttt scanline --scanline-reverse true -d 0.5"
alias gitbase="git add . && git commit -m 'gitbase' && git push"

# -----------------------------------------------

if status is-interactive
    #starship init fish | source
end

#set -x STARSHIP_CONFIG $HOME/.config/starship/starship-pywal.toml

clear

function fish_prompt
    # Salva lo status dell'ultimo comando
    set -l last_status $status
    
    # Colori
    set -l cyan (set_color cyan)
    set -l yellow (set_color yellow)
    set -l red (set_color red)
    set -l green (set_color green)
    set -l blue (set_color blue)
    set -l magenta (set_color magenta)
    set -l normal (set_color normal)
    set -l bold (set_color --bold)
    
    # Virtualenv Python
    if set -q VIRTUAL_ENV
        echo -n $bold$green'('(basename $VIRTUAL_ENV)')' $normal
    end
    
    # Username e hostname
    echo -n $bold$cyan$USER$normal
    echo -n ' at '
    echo -n $bold$magenta(prompt_hostname)$normal
    echo -n ' in '
    
    # Directory corrente (con ~ per home)
    echo -n $bold$blue(prompt_pwd)$normal
    
    # Git branch se siamo in un repository
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set -l git_branch (git branch 2>/dev/null | sed -n '/\* /s///p')
        echo -n ' on '
        echo -n $bold$yellow"$git_branch"$normal
        
        # Mostra * se ci sono modifiche non committate
        if not git diff-index --quiet HEAD -- 2>/dev/null
            echo -n $red'*'$normal
        end
    end
    
    # Nuova riga
    echo
    
    # Simbolo del prompt (rosso se l'ultimo comando è fallito)
    if test $last_status -eq 0
        echo -n $green'➜ '$normal
    else
        echo -n $red'➜ '$normal
    end
end

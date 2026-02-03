function yuritheme
    if pgrep -f refresh-theme.py > /dev/null
        pkill -f refresh-theme.py
        python3 $HOME/Code/YuriLand/yuritheme/refresh-theme.py
    else
        python3 $HOME/Code/YuriLand/yuritheme/refresh-theme.py
    end
end

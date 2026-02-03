function chdns
    set bak_flag $argv[1]
    if test "$bak_flag" = "-b"
        sudo ./Code/Shell-scripts/switch_dns.sh --backup    # Fa il backup di /etc/resolv.conf e lo cambia
    else
        sudo ./Code/Shell-scripts/switch_dns.sh             # Ripristina il backup (se esiste) senza fare un nuovo backup
    end
end

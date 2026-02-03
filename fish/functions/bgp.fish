function bgp
    if test (count $argv) -eq 0
        echo "Uso: bgp <comando> [argomenti...]"
        return 1
    end

    # Cartella log
    set logdir "$HOME/logs"
    mkdir -p $logdir

    # Nome del comando (senza percorso)
    set cmd_name (basename $argv[1])
    set logfile "$logdir/$cmd_name.log"

    # Esegui in background, staccato e con output rediretto al log
    nohup $argv > $logfile 2>&1 & disown

    echo "Avviato in background: $argv"
    echo "Log: $logfile"
end

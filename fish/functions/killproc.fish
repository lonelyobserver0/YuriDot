function killproc
    if test -z "$argv[1]"
        echo "Uso: killproc <nome-processo>"
        return 1
    end

    set self %self
    set matches (pgrep -af "$argv[1]" | grep -v "$self")

    if test -z "$matches"
        echo "Nessun processo trovato per: $argv[1]"
        return 1
    end

    set pids (echo "$matches" | awk '{print $1}' | grep -v "$self")

    echo "Terminazione dei seguenti PID:"
    echo "$pids"

    kill $pids 2>/dev/null

    if test $status -eq 0
        echo "Processi terminati con successo."
    else
        echo "Errore durante la terminazione dei processi."
    end
end


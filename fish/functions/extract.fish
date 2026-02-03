function extract
    # Verifica che sia stato fornito almeno un file
    if test (count $argv) -eq 0
        echo "Uso: extract <archivio>"
        return 1
    end

    set file $argv[1]

    # Verifica che il file esista
    if not test -f $file
        echo "Errore: il file '$file' non esiste"
        return 1
    end

    # Determina il tipo di archivio ed estrai
    switch $file
        # Archivi TAR
        case "*.tar.gz" "*.tgz"
            echo "Estrazione archivio tar.gz: $file"
            command tar -xzf $file
        
        case "*.tar.bz2" "*.tbz2" "*.tb2"
            echo "Estrazione archivio tar.bz2: $file"
            command tar -xjf $file
        
        case "*.tar.xz" "*.txz"
            echo "Estrazione archivio tar.xz: $file"
            command tar -xJf $file
        
        case "*.tar.zst" "*.tzst"
            echo "Estrazione archivio tar.zst: $file"
            command tar --zstd -xf $file
        
        case "*.tar.lz" "*.tlz"
            echo "Estrazione archivio tar.lz: $file"
            command tar --lzip -xf $file
        
        case "*.tar"
            echo "Estrazione archivio tar: $file"
            command tar -xf $file
        
        # Archivi compressi singoli
        case "*.gz"
            echo "Decompressione file gz: $file"
            gunzip $file
        
        case "*.bz2"
            echo "Decompressione file bz2: $file"
            bunzip2 $file
        
        case "*.xz"
            echo "Decompressione file xz: $file"
            unxz $file
        
        case "*.zst"
            echo "Decompressione file zst: $file"
            unzstd $file
        
        # ZIP e RAR
        case "*.zip" "*.jar" "*.war" "*.ear"
            echo "Estrazione archivio zip: $file"
            unzip $file
        
        case "*.rar"
            echo "Estrazione archivio rar: $file"
            unrar x $file
        
        # 7-Zip
        case "*.7z"
            echo "Estrazione archivio 7z: $file"
            7z x $file
        
        # Altri formati
        case "*.Z"
            echo "Decompressione file Z: $file"
            uncompress $file
        
        case "*.lz"
            echo "Decompressione file lz: $file"
            lzip -d $file
        
        case "*.lzma"
            echo "Decompressione file lzma: $file"
            unlzma $file
        
        case "*.cab"
            echo "Estrazione archivio cab: $file"
            cabextract $file
        
        case "*.deb"
            echo "Estrazione pacchetto deb: $file"
            ar x $file
        
        case "*.rpm"
            echo "Estrazione pacchetto rpm: $file"
            rpm2cpio $file | cpio -idmv
        
        case "*"
            echo "Errore: tipo di archivio non riconosciuto"
            echo "Formati supportati:"
            echo "  TAR: .tar, .tar.gz, .tgz, .tar.bz2, .tbz2, .tar.xz, .txz, .tar.zst, .tar.lz"
            echo "  Compressi: .gz, .bz2, .xz, .zst, .lz, .lzma, .Z"
            echo "  Altri: .zip, .jar, .rar, .7z, .cab, .deb, .rpm"
            return 1
    end

    if test $status -eq 0
        echo "Estrazione completata con successo!"
    else
        echo "Errore durante l'estrazione"
        return 1
    end
end

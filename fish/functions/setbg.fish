function setbg

    set WALLPAPERS "/home/$USER/Pictures/Wallpapers"
    set WAYBAR_CONFIG "/home/$USER/.config/waybar"
    set WOFI_CONFIG "/home/$USER/.config/wofi"

    # Facciamo aprtire pywal
    wal -i $WALLPAPERS/$argv[1]

    sass $WOFI_CONFIG/style.scss $WOFI_CONFIG/style.css

    nemo-pywal

    # Cambiamo lo sfondo con animazione circolare
    swww img $WALLPAPERS/$argv[1] --transition-type grow --transition-pos 0.854,0.977 --transition-step 90

    # Facciamo in modo che il cambio di colore di waybar si mischi con l'animazione dello sfondo
    sass $WAYBAR_CONFIG/style.scss $WAYBAR_CONFIG/style.css
    pkill waybar
    bgp waybar

end

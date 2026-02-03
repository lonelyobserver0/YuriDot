# YuriDot

Dotfiles per Hyprland/Wayland con supporto pywal.

## Installazione

```bash
curl -fsSL https://raw.githubusercontent.com/lonelyobserver0/YuriDot/main/setup.sh | bash
```

oppure

```bash
wget -qO- https://raw.githubusercontent.com/lonelyobserver0/YuriDot/main/setup.sh | bash
```

## Contenuto

| Cartella | Descrizione |
|----------|-------------|
| `fish/` | Configurazione Fish shell + funzioni custom |
| `waybar/` | Barra superiore per Hyprland |
| `wofi/` | Launcher applicazioni |
| `gtk/` | Tema GTK custom |
| `gtk-2.0/` | Configurazione GTK 2 |
| `gtk-3.0/` | Configurazione GTK 3 |
| `gtk-4.0/` | Configurazione GTK 4 |
| `cinnamon/` | Tema Cinnamon |

## Dipendenze

**Richieste:**
- `git`
- `sass` - per compilare i file SCSS
- `pywal` - per i temi dinamici basati su wallpaper

## Pywal

I temi di waybar e wofi usano i colori generati da pywal. Per configurarli:

```bash
wal -i /percorso/alla/tua/immagine.jpg
```

Questo genera `~/.cache/wal/colors.scss` usato dai file SCSS.

## Funzioni Fish incluse

| Funzione | Descrizione |
|----------|-------------|
| `bgp <comando>` | Esegue un comando in background con log |
| `setbg <wallpaper>` | Cambia wallpaper + aggiorna temi pywal |
| `gpumode <mode>` | Cambia modalità GPU (Hybrid/Integrated/etc) |
| `chdns` | Cambia DNS |
| `killvpn` | Termina il processo VPN |
| `extract <file>` | Estrae archivi di vari formati |

## Backup

Lo script di setup crea automaticamente un backup delle configurazioni esistenti in:
```
~/.config/backup_YYYYMMDD_HHMMSS/
```

## License

MIT

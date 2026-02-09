#!/bin/bash

# =============================================================================
# YuriDot - Setup Script
# =============================================================================
# Uso:
#   curl -fsSL https://raw.githubusercontent.com/lonelyobserver0/YuriDot/main/setup.sh | bash
#
# Oppure:
#   wget -qO- https://raw.githubusercontent.com/lonelyobserver0/YuriDot/main/setup.sh | bash
# =============================================================================

set -e

REPO_URL="https://github.com/lonelyobserver0/YuriDot.git"
REPO_NAME="YuriDot"
TMP_DIR=$(mktemp -d)
BACKUP_DIR="$HOME/.config/backup_$(date +%Y%m%d_%H%M%S)"
CONFIG_DIR="$HOME/.config"
APPLICATIONS_DIR="$HOME/.local/share/applications"

# Colori
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info()  { echo -e "${BLUE}[INFO]${NC} $1"; }
log_ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Cartelle da installare
FOLDERS=(
    "cinnamon"
    "fish"
    "gtk"
    "gtk-2.0"
    "gtk-3.0"
    "gtk-4.0"
    "waybar"
    "wofi"
    "quickshell"
)

cleanup() {
    log_info "Pulizia file temporanei..."
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

# =============================================================================
# MAIN
# =============================================================================

echo ""
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║         YuriDot - Setup Script         ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Verifica dipendenze
log_info "Verifica dipendenze..."
for cmd in git; do
    if ! command -v $cmd &> /dev/null; then
        log_error "$cmd non trovato. Installalo e riprova."
        exit 1
    fi
done
log_ok "Dipendenze OK"

# Clona repo
log_info "Clonazione repository in $TMP_DIR..."
git clone --depth 1 "$REPO_URL" "$TMP_DIR/$REPO_NAME" 2>/dev/null
log_ok "Repository clonata"

# Crea directory config se non esiste
mkdir -p "$CONFIG_DIR"

# Backup e copia cartelle
log_info "Installazione configurazioni..."
BACKUP_CREATED=false

for folder in "${FOLDERS[@]}"; do
    SRC="$TMP_DIR/$REPO_NAME/$folder"
    DEST="$CONFIG_DIR/$folder"

    if [ -d "$SRC" ]; then
        # Se esiste già, fai backup
        if [ -d "$DEST" ]; then
            if [ "$BACKUP_CREATED" = false ]; then
                mkdir -p "$BACKUP_DIR"
                BACKUP_CREATED=true
            fi
            log_warn "Backup: $folder -> $BACKUP_DIR/"
            cp -r "$DEST" "$BACKUP_DIR/"
            rm -rf "$DEST"
        fi

        # Copia nuova configurazione
        cp -r "$SRC" "$DEST"
        log_ok "Installato: $folder"
    fi
done

if [ "$BACKUP_CREATED" = true ]; then
    log_info "Backup salvato in: $BACKUP_DIR"
fi

# Installa file .desktop
log_info "Installazione file .desktop..."
mkdir -p "$APPLICATIONS_DIR"

if [ -f "$TMP_DIR/$REPO_NAME/wallpaper-picker.desktop" ]; then
    if [ -f "$APPLICATIONS_DIR/wallpaper-picker.desktop" ]; then
        if [ "$BACKUP_CREATED" = false ]; then
            mkdir -p "$BACKUP_DIR"
            BACKUP_CREATED=true
        fi
        cp "$APPLICATIONS_DIR/wallpaper-picker.desktop" "$BACKUP_DIR/"
        log_warn "Backup: wallpaper-picker.desktop -> $BACKUP_DIR/"
    fi
    cp "$TMP_DIR/$REPO_NAME/wallpaper-picker.desktop" "$APPLICATIONS_DIR/"
    log_ok "Installato: wallpaper-picker.desktop"
fi

# Sostituisci placeholder __HOME__ con il percorso reale
log_info "Configurazione percorsi utente..."
find "$CONFIG_DIR" -type f \( -name "*.scss" -o -name "*.css" \) -exec sed -i "s|__HOME__|$HOME|g" {} \; 2>/dev/null || true
log_ok "Percorsi configurati"

# Compila SCSS se sass è disponibile
if command -v sass &> /dev/null; then
    log_info "Compilazione file SCSS..."

    if [ -f "$CONFIG_DIR/wofi/style.scss" ]; then
        sass "$CONFIG_DIR/wofi/style.scss" "$CONFIG_DIR/wofi/style.css" 2>/dev/null && \
            log_ok "Compilato: wofi/style.css" || log_warn "Errore compilazione wofi (pywal colors.scss mancante?)"
    fi

    if [ -f "$CONFIG_DIR/waybar/style.scss" ]; then
        sass "$CONFIG_DIR/waybar/style.scss" "$CONFIG_DIR/waybar/style.css" 2>/dev/null && \
            log_ok "Compilato: waybar/style.css" || log_warn "Errore compilazione waybar (pywal colors.scss mancante?)"
    fi
else
    log_warn "sass non trovato - compila manualmente i file .scss"
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║       Installazione completata!        ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo "Note:"
echo "  - Per i temi pywal, assicurati che ~/.cache/wal/colors.scss esista"
echo "  - Esegui 'wal -i <immagine>' per generare i colori"
if [ "$BACKUP_CREATED" = true ]; then
    echo "  - Backup precedente: $BACKUP_DIR"
fi
echo ""

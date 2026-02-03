function nemo-pywal -d "Applica i colori di pywal a Nemo"
    set -l colors_file "$HOME/.cache/wal/colors"
    set -l gtk_css_dir "$HOME/.config/gtk-3.0"
    set -l gtk_css "$gtk_css_dir/gtk.css"

    # Verifica pywal
    if not test -f "$colors_file"
        echo "Errore: Esegui prima 'wal -i <immagine>'"
        return 1
    end

    # Leggi i colori
    set -l c (cat "$colors_file")

    # Crea directory
    mkdir -p "$gtk_css_dir"

    # Genera il CSS per Nemo
    echo "/* Nemo Pywal Theme - Generato automaticamente */

/* =============================================
   FINESTRA PRINCIPALE
   ============================================= */

.nemo-window {
    background-color: $c[1];
    color: $c[8];
}

/* =============================================
   VISTA FILE (IconView, ListView, CompactView)
   ============================================= */

.nemo-window .view,
.nemo-window .nemo-window-pane .view,
.nemo-window iconview,
.nemo-window treeview,
.nemo-window GtkTreeView,
.nemo-window .nemo-window-pane widget > .view {
    background-color: $c[1];
    color: $c[8];
}

/* Pannello inattivo (split view) */
.nemo-window .nemo-inactive-pane .view,
.nemo-window .nemo-inactive-pane .view:not(:selected),
.nemo-window .nemo-inactive-pane iconview {
    background-color: shade($c[1], 0.95);
    color: $c[8];
}

/* Selezione - solo bordo colorato, sfondo trasparente */
.nemo-window .view:selected,
.nemo-window .view:selected:focus,
.nemo-window iconview:selected,
.nemo-window treeview:selected,
.nemo-window .nemo-window-pane .view:selected,
.nemo-window .nemo-inactive-pane .view:selected,
.nemo-window .nemo-inactive-pane .view:selected:focus {
    background-color: transparent;
    color: $c[8];
    border: 1px solid $c[5];
    border-radius: 4px;
}

/* Selezione focus più evidente */
.nemo-window .view:selected:focus {
    border: 2px solid $c[5];
}

/* Hover */
.nemo-window .view:hover,
.nemo-window iconview:hover,
.nemo-window .view.cell:hover {
    background-color: alpha($c[9], 0.5);
}

/* =============================================
   SIDEBAR (Pannello laterale)
   ============================================= */

.nemo-places-sidebar,
.nemo-places-sidebar .view,
.nemo-places-sidebar list,
.nemo-places-sidebar row,
.places-treeview {
    background-color: $c[1];
    color: $c[8];
}

.nemo-places-sidebar row:selected,
.nemo-places-sidebar row:active,
.places-treeview:selected {
    background-color: $c[5];
    color: $c[1];
}

.nemo-places-sidebar row:hover,
.places-treeview:hover {
    background-color: alpha($c[9], 0.5);
}

/* Indicatori disco nella sidebar */
.places-treeview {
    -NemoPlacesTreeView-disk-full-bg-color: $c[9];
    -NemoPlacesTreeView-disk-full-fg-color: $c[5];
}

.places-treeview:selected {
    -NemoPlacesTreeView-disk-full-bg-color: $c[1];
    -NemoPlacesTreeView-disk-full-fg-color: $c[8];
}

/* =============================================
   TOOLBAR
   ============================================= */

.nemo-window toolbar,
.nemo-window .toolbar,
.nemo-window .primary-toolbar {
    background-color: $c[1];
    color: $c[8];
    border-color: $c[9];
}

/* Tutti i pulsanti nella toolbar */
.nemo-window toolbar button,
.nemo-window toolbar button.flat,
.nemo-window toolbar button.image-button,
.nemo-window toolbar button.text-button,
.nemo-window toolbar .button,
.nemo-window toolitem > button,
.nemo-window toolitem > button.flat,
.nemo-window toolbar toolitem button,
.nemo-window toolbar toolitem > button,
.nemo-window toolbar > button,
.nemo-window headerbar button,
.nemo-window actionbar button,
.nemo-window * button.flat,
.nemo-window * button.image-button {
    background-color: transparent;
    background-image: none;
    color: $c[8];
    border: none;
    box-shadow: none;
}

.nemo-window toolbar button:hover,
.nemo-window toolbar toolitem button:hover,
.nemo-window toolitem > button:hover {
    background-color: alpha($c[9], 0.3);
    background-image: none;
}

.nemo-window toolbar button:active,
.nemo-window toolbar button:checked,
.nemo-window toolbar toolitem button:active,
.nemo-window toolbar toolitem button:checked {
    background-color: alpha($c[5], 0.3);
    background-image: none;
    color: $c[8];
}

/* Pulsanti linked (gruppo di pulsanti) */
.nemo-window toolbar .linked button,
.nemo-window toolbar .linked > button,
.nemo-window .linked button {
    background-color: transparent;
    background-image: none;
    color: $c[8];
    border: none;
}

.nemo-window toolbar .linked button:hover {
    background-color: alpha($c[9], 0.3);
}

.nemo-window toolbar .linked button:checked,
.nemo-window toolbar .linked button:active {
    background-color: alpha($c[5], 0.3);
}

/* =============================================
   PATHBAR (Barra del percorso)
   ============================================= */

.nemo-window .path-bar,
.nemo-window .pathbar,
.nemo-window .path-bar-box {
    background-color: $c[1];
}

.nemo-window .path-bar button,
.nemo-window .pathbar button,
.nemo-pathbar-button {
    background-color: transparent;
    color: $c[8];
    border: none;
}

.nemo-window .path-bar button:hover,
.nemo-window .pathbar button:hover,
.nemo-pathbar-button:hover {
    background-color: alpha($c[9], 0.3);
}

/* Directory corrente (pulsante attivo/checked) */
.nemo-window .path-bar button:checked,
.nemo-window .path-bar button:active,
.nemo-window .pathbar button:checked,
.nemo-window .pathbar button:active,
.nemo-pathbar-button:active,
.nemo-pathbar-button:checked,
.nemo-window .path-bar button.current-dir,
.nemo-window .pathbar button.current-dir {
    background-color: transparent;
    color: $c[5];
    font-weight: bold;
    border-bottom: 2px solid $c[5];
}

/* Location entry (barra indirizzo testuale) */
.nemo-window .path-bar entry,
.nemo-window .location-entry {
    background-color: $c[1];
    color: $c[8];
    border-color: $c[9];
}

/* =============================================
   STATUSBAR
   ============================================= */

.nemo-window statusbar,
.nemo-window .statusbar {
    background-color: $c[1];
    color: $c[8];
    border-color: $c[9];
}

/* =============================================
   SCROLLBAR
   ============================================= */

.nemo-window scrollbar {
    background-color: $c[1];
}

.nemo-window scrollbar slider {
    background-color: alpha($c[8], 0.3);
}

.nemo-window scrollbar slider:hover {
    background-color: alpha($c[8], 0.5);
}

.nemo-window scrollbar slider:active {
    background-color: $c[5];
}

/* =============================================
   RUBBERBAND (Selezione multipla)
   ============================================= */

.nemo-window rubberband,
.nemo-window .rubberband,
rubberband {
    background-color: alpha($c[5], 0.3);
    border: 1px solid $c[5];
}

/* =============================================
   ENTRY (Caselle di testo / Rinomina)
   ============================================= */

.nemo-window entry,
.nemo-window .nemo-window-pane widget.entry {
    background-color: $c[1];
    color: $c[8];
    border-color: $c[5];
}

.nemo-window entry:focus {
    border-color: $c[5];
}

.nemo-window entry selection,
.nemo-window .nemo-window-pane widget.entry:selected {
    background-color: $c[5];
    color: $c[1];
}

/* =============================================
   MENU
   ============================================= */

.nemo-window menu,
.nemo-window menubar,
.nemo-window .popup {
    background-color: $c[1];
    color: $c[8];
}

.nemo-window menu menuitem:hover,
.nemo-window menubar menuitem:hover {
    background-color: $c[5];
    color: $c[1];
}

/* =============================================
   NOTEBOOK / TABS
   ============================================= */

.nemo-window notebook,
.nemo-window notebook header {
    background-color: $c[1];
}

.nemo-window notebook tab {
    background-color: transparent;
    color: $c[8];
}

.nemo-window notebook tab:checked {
    background-color: alpha($c[5], 0.3);
    border-bottom-color: $c[5];
}

.nemo-window notebook tab:hover {
    background-color: alpha($c[9], 0.3);
}

/* =============================================
   INFOBAR / FLOATING STATUSBAR
   ============================================= */

.nemo-window .floating-bar,
.nemo-window infobar {
    background-color: alpha($c[1], 0.9);
    color: $c[8];
    border-color: $c[9];
}

/* =============================================
   SEPARATORI E BORDI
   ============================================= */

.nemo-window separator,
.nemo-window paned > separator {
    background-color: $c[9];
}

/* =============================================
   EXTRA
   ============================================= */

/* Treeview headers */
.nemo-window treeview header button {
    background-color: $c[1];
    color: $c[8];
    border-color: $c[9];
}

.nemo-window treeview header button:hover {
    background-color: alpha($c[9], 0.5);
}

/* Tooltip */
.nemo-window tooltip {
    background-color: $c[1];
    color: $c[8];
    border-color: $c[9];
}" > "$gtk_css"

    # Chiudi Nemo per applicare i cambiamenti
    nemo -q 2>/dev/null

    echo "✓ Colori pywal applicati a Nemo"
    echo "  Background: $c[1]"
    echo "  Accent:     $c[5]"
    echo "  Foreground: $c[8]"
    echo ""
    echo "Riapri Nemo per vedere i cambiamenti."
end

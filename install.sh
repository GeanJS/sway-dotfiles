#!/bin/bash

set -e

DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d%H%M%S)"
SYSTEM_FONT_DIR="/usr/share/fonts"
SYSTEM_ICON_DIR="/usr/share/icons"

CONFIG_ITEMS=("sway" "kitty" "rofi" "waybar" "backgrounds" "gtk-3.0")
ZSH_FILE=".zshrc"
FONT_DIR="maplefont"
ICON_DIR="icons"

echo "==> Instalando dotfiles..."
mkdir -p "$BACKUP_DIR"
mkdir -p "$CONFIG_DIR"

# Symlinks para ~/.config/*
for item in "${CONFIG_ITEMS[@]}"; do
    SRC="$DOTFILES_DIR/$item"
    DEST="$CONFIG_DIR/$item"

    echo "-> Config: $item"

    if [ -e "$DEST" ] || [ -L "$DEST" ]; then
        echo "   Backup de $DEST -> $BACKUP_DIR/"
        mv "$DEST" "$BACKUP_DIR/"
    fi

    ln -s "$SRC" "$DEST"
    echo "   Linkado $SRC -> $DEST"
done

# Symlink do .zshrc
echo "-> Config: $ZSH_FILE"
if [ -e "$HOME/$ZSH_FILE" ] || [ -L "$HOME/$ZSH_FILE" ]; then
    echo "   Backup de $HOME/$ZSH_FILE -> $BACKUP_DIR/"
    mv "$HOME/$ZSH_FILE" "$BACKUP_DIR/"
fi
ln -s "$DOTFILES_DIR/zsh/$ZSH_FILE" "$HOME/$ZSH_FILE"
echo "   Linkado $DOTFILES_DIR/zsh/$ZSH_FILE -> $HOME/$ZSH_FILE"

# Instalar fontes (precisa sudo)
echo "-> Instalando fonte em $SYSTEM_FONT_DIR/$FONT_DIR"
if [ -d "$DOTFILES_DIR/$FONT_DIR" ]; then
    sudo cp -r "$DOTFILES_DIR/$FONT_DIR" "$SYSTEM_FONT_DIR/"
    sudo fc-cache -fv
    echo "   Fonte instalada!"
else
    echo "   Fonte não encontrada em $DOTFILES_DIR/$FONT_DIR"
fi

# Instalar ícones (precisa sudo)
echo "-> Instalando ícones em $SYSTEM_ICON_DIR/$ICON_DIR"
if [ -d "$DOTFILES_DIR/$ICON_DIR" ]; then
    sudo cp -r "$DOTFILES_DIR/$ICON_DIR" "$SYSTEM_ICON_DIR/"
    echo "   Ícones instalados!"
else
    echo "   Ícones não encontrados em $DOTFILES_DIR/$ICON_DIR"
fi

echo "✅ Tudo pronto! Dotfiles instalados."

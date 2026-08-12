#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
	local src="$1" dest="$2"

	mkdir -p "$(dirname "$dest")"

	if [[ -e "$dest" && ! -L "$dest" ]]; then
		mv "$dest" "$dest.bak"
		echo "backed up $dest -> $dest.bak"
	fi

	ln -sfn "$src" "$dest"
	echo "linked $dest"
}

link "$repo/herdr/config.toml" "$HOME/.config/herdr/config.toml"

case "$(uname -s)" in
	Darwin)
		link "$repo/ghostty/config" "$HOME/.config/ghostty/config"
		echo "reload Ghostty with cmd+shift+,"
		;;
	Linux)
		link "$repo/kitty/kitty.conf" "$HOME/.config/kitty/herdr-keys.conf"
		echo "add 'include herdr-keys.conf' to ~/.config/kitty/kitty.conf, then reload with ctrl+shift+f5"
		;;
	*)
		echo "unsupported platform: $(uname -s)" >&2
		exit 1
		;;
esac

if command -v herdr >/dev/null 2>&1; then
	herdr server reload-config >/dev/null 2>&1 || true
	echo "reloaded herdr"
fi

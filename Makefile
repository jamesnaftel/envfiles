deploy:
	stow -t ~ zsh
	stow --dotfiles -R --verbose=3 -t ~/.config/nvim nvim
	stow -t ~ tmux


if status is-interactive
    fish_add_path "/home/rob-isaac/.local/bin"

    set -gx EDITOR vim
    set -gx VISUAL vim

    abbr --add g git
    for al in (git --list-cmds=alias)
	abbr g$al "git $al"
    end
    abbr --add cfg "git --git-dir=$HOME/.cfg/ --work-tree=$XDG_CONFIG_HOME"
    if command -q nvim
	abbr --add v nvim
	abbr --add vi nvim
	abbr --add vim nvim
	abbr --add evim NVIM_APPNAME=evim nvim
	set -gx EDITOR nvim
	set -gx VISUAL nvim
    end

    if command -q zoxide
	zoxide init fish | source
    end
    if command -q mise
	mise activate fish | source
    end
    if command -q navi
	navi widget fish | source
    end
end

if status is-interactive
    # Remove fish greeting.
    set fish_greeting

    # Neovim abbreviations / editor setup.
    if command -q nvim
        abbr v nvim
        abbr n nvim
        abbr vim nvim
        abbr gpgvim NVIM_APPNAME=nvim-gpg nvim
        set -gx VISUAL nvim
        set -gx EDITOR nvim
    end

    # Git abbreviations.
    if command -q git
        abbr g git
        for alias in (git config --get-regexp ^alias | sed "s/alias\.//g")
            set alias_list (string split " " $alias)
            abbr g$alias_list[1] git $alias_list[2..]
            abbr --command git $alias_list[1] $alias_list[2..]
        end
        abbr conf git --git-dir=$HOME/.cfg/ --work-tree=$HOME
    end

    # Lazygit abbreviations.
    if command -q lazygit
        abbr lg lazygit
        abbr lconf lazygit --git-dir=$HOME/.cfg/ --work-tree=$HOME
    end

    # Homebrew setup.
    if command -q brew
        abbr --command brew deptree deps --tree --installed
    end

    # Fzf fish setup.
    if command -q fzf
        fzf --fish | source
    end

    # Zoxide fish setup.
    if command -q zoxide
        zoxide init fish | source
    end

    # Gpg agent setup.
    if command -q tty
        set -gx GPG_TTY (tty)
    end

    # Cargo env setup.
    if test -f "$HOME/.cargo/env.fish"
        source "$HOME/.cargo/env.fish"
    end

    # Personal scripts setup.
    if test -d "$HOME/Code/scripts/"
        fish_add_path "$HOME/Code/scripts/"

        if test -f "$HOME/Code/scripts/bookmarks.sh"
            function b
                set out ("$HOME/Code/scripts/bookmarks.sh" $argv)
                set ret $status
                if test $ret = 0 && test "$out" != "" && test (count $argv) = 0
                    cd $out
                end
                return $ret
            end
        end
    end

    # Set theme.
    source ~/.config/fish/themes/nightfox.fish
end

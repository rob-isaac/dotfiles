if status is-interactive
    # Add some abbreviations
    abbr --add vi nvim
    abbr --add vim nvim
    abbr --add lg lazygit
    abbr --add ld lazydocker
    abbr --add cat bat
    abbr --add dot git --git-dir=$HOME/.dotfiles --work-tree=$HOME
    abbr --add ldot lazygit --git-dir=$HOME/.dotfiles --work-tree=$HOME
    abbr --add ls eza
    abbr --add cmake-ninja cmake -G Ninja -DCMAKE_CXX_COMPILER_LAUNCHER=ccache -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++
    abbr --add less less -R

    # Add bin locations to path
    fish_add_path $HOME/bin
    fish_add_path $HOME/.cargo/bin
    fish_add_path $HOME/go/bin
    fish_add_path $HOME/node/bin

    # Convenience function for generating a flamegraph after perf record
    function perf-fg -d "takes perf.data and generates a flamegraph svg"
        if test (count $argv) -ne 1
            echo "usage: perf-fg <out-file>"
            return
        end
        perf script | stackcollapse-perf.pl | flamegraph.pl >$argv[1]
    end

    # Convenience function to move the most recently downloaded file
    function dmv -d "move the most-recent download to pwd"
        set __fname (ls -t ~/Downloads | head -n 1)
        set __fpath "$HOME/Downloads/"$__fname""
        mv "$__fpath" \.
    end

    # Convenience function to copy the most recently downloaded file
    function dcp -d "copy the most-recent download to pwd"
        set __fname (ls -t ~/Downloads | head -n 1)
        set __fpath "$HOME/Downloads/"$__fname""
        cp -a "$__fpath" \.
    end

    # Remove the fish greeting message
    set -g fish_greeting

    # Use colors for less pager
    set -gx PAGER less -R

    # Set editor to nvim if available
    if command -sq nvim
        set -gx EDITOR nvim
    end

    # Setup the GPG agent
    set -gx GPG_TTY (tty)
    if command -sq gpgconf
        gpgconf --launch gpg-agent
    end

    # Init zoxide
    if command -sq zoxide
        zoxide init --cmd j fish | source
    end

    # Initialize conda if available
    # TODO(Rob): would be nice if we could speed this up a bit
    if test -f $HOME/miniconda3/bin/conda
        eval $HOME/miniconda3/bin/conda "shell.fish" hook $argv | source
        # activate dev environment if available (will print error if not found)
        conda activate dev
    end

    # Activate mise environment if available (similar to asdf)
    if test -f $HOME/.local/bin/mise
        $HOME/.local/bin/mise activate fish | source
    end

    # Setup ghcup (haskell) environment
    set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin $HOME/.ghcup/bin $PATH

    # Source secrets file if available
    if test -f $HOME/.config/fish/secret.fish
        source $HOME/.config/fish/secret.fish
    end

    source $HOME/.config/fish/wezterm.fish
end


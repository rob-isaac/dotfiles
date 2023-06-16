if status is-interactive
    # Add some abbreviations
    abbr --add vim nvim
    abbr --add tw taskwarrior-tui
    abbr --add nf neofetch
    abbr --add lg lazygit
    abbr --add cat bat
    abbr --add dot git --git-dir=$HOME/.dotfiles --work-tree=$HOME
    abbr --add cmake cmake -G Ninja -DCMAKE_CXX_COMPILER_LAUNCHER=ccache -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++
    abbr --add make ninja
    abbr --add fd fdfind
    abbr --add ls exa

    # Add bin locations to path
    fish_add_path $HOME/bin
    fish_add_path $HOME/.cargo/bin
    fish_add_path $HOME/go/bin
    fish_add_path $HOME/node/bin

    # Set editor to nvim if available
    if command -sq nvim
        set -gx EDITOR nvim
    end

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

    # Set my pwd to $HOME
    cd $HOME
end

# Initialize conda if available
# TODO(Rob): would be nice if we could speed this up a bit
if test -f $HOME/miniconda3/bin/conda
    eval $HOME/miniconda3/bin/conda "shell.fish" hook $argv | source
    # activate dev environment if availible (will print error if not found)
    conda activate dev
end

# Activate asdf environment if available
if test -f $HOME/.asdf/asdf.fish
    source $HOME/.asdf/asdf.fish
end

# Source secrets file if available
if test -f $HOME/.config/fish/secret.fish
    source $HOME/.config/fish/secret.fish
end

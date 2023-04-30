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
    abbr --add fd fd-find
    abbr --add ls exa

    fish_add_path $HOME/bin
    fish_add_path $HOME/.cargo/bin
    fish_add_path $HOME/go/bin
    fish_add_path $HOME/node/bin

    if command -sq nvim
        set -gx EDITOR nvim
    end

    function perf-fg -d "takes perf.data and generates a flamegraph svg"
        if test (count $argv) -ne 1
            echo "usage: perf-fg <out-file>"
            return
        end
        perf script | stackcollapse-perf.pl | flamegraph.pl >$argv[1]
    end

    function dmv -d "move the most-recent download to pwd"
        set __fname "$(ls -t ~/Downloads | head -n 1)"
        set __fpath "$HOME/Downloads/"$__fname""
        mv "$__fpath" \.
    end

    function dcp -d "copy the most-recent download to pwd"
        set __fname "$(ls -t ~/Downloads | head -n 1)"
        set __fpath "$HOME/Downloads/"$__fname""
        cp -a "$__fpath" \.
    end
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/rob/miniconda3/bin/conda
    eval /home/rob/miniconda3/bin/conda "shell.fish" hook $argv | source
end
# <<< conda initialize <<<

# Activate dev environment if available
if command -v conda >/dev/null
    if conda env list | grep dev >/dev/null
        conda activate dev
    end
end

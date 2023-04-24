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

    if command -sq nvim
        set -gx EDITOR nvim
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

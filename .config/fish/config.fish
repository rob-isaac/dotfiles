if status is-interactive
    # Remove fish greeting.
    set fish_greeting

    # Homebrew setup.
    if command -q brew
        abbr --command brew deptree deps --tree --installed
    end

    # Mise setup.
    if command -q mise
        mise activate fish | source
    end

    # Fzf
    if command -q fzf
        fzf --fish | source
    end

    # Zoxide/jump fish setup.
    if command -q zoxide
        zoxide init --cmd j fish | source
    else if command -q jump
        jump shell fish | source
    end

    # Gpg agent setup.
    if command -q tty
        set -gx GPG_TTY (tty)
    end

    # Cargo env setup.
    if test -f "$HOME/.cargo/env.fish"
        source "$HOME/.cargo/env.fish"
    end

    # # Starship setup.
    # if command -q starship
    #     starship init fish | source
    # end

    # Duck-db setup.
    if test -d "$HOME/.duckdb/cli/latest"
        fish_add_path "$HOME/.duckdb/cli/latest"
    end

    function reload_config -d "function to reload config"
        # @fish-lsp-disable-next-line 2003
        set -U RELOAD_SIGNAL (date)
    end

    function __reload_on_change --on-variable RELOAD_SIGNAL
        source ~/.config/fish/config.fish
        echo "Config reloaded!"
    end

    # Neovim abbreviations.
    if command -q nvim
        set -gx EDITOR nvim
        set -gx VISUAL nvim
        abbr v nvim
        abbr vi nvim
        abbr vim nvim
        abbr n nvim
        abbr evim NVIM_APPNAME=evim nvim
    end

    # Git abbreviations.
    if command -q git
        abbr g git
        for alias in (git config --get-regexp ^alias | sed "s/alias\.//g")
            set alias_list (string split " " $alias)
            # skip aliases which are shell functions
            if string match -q -- "!*" $alias_list[2]
                continue
            end
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

    # Binding to copy current command to clipboard
    function copy_commandline
        commandline | pbcopy
    end
    bind \ec copy_commandline # Alt-c

    # Binding to copy previous command to clipboard
    function copy_prev_command
        history | head -n1 | pbcopy
    end
    bind \eC copy_prev_command # Alt-c

    # Set theme.
    source ~/.config/fish/themes/nightfox.fish
end

# Source secrets.
if test -f "$HOME/.config/fish/secrets.fish"
    source "$HOME/.config/fish/secrets.fish"
end

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/Downloads/google-cloud-sdk/path.fish.inc" ]
    source "$HOME/Downloads/google-cloud-sdk/path.fish.inc"
end

# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

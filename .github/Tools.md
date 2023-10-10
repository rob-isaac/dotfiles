# Tools List

 - [wezterm](https://github.com/wez/wezterm): A GPU-accelerated terminal emulator, configuable in lua. Supports kitty image protocol.
 - [fish](https://github.com/fish-shell/fish-shell): A user-friendly shell with out-of-the-box completion-suggestions and command highlighting.
 - [neovim](https://github.com/neovim/neovim): A fork of vim which supports lua configuration.
 - [lazygit](https://github.com/jesseduffield/lazygit): TUI for managing git
 - [lazydocker](https://github.com/jesseduffield/lazydocker): TUI for managing docker
 - [ninja](https://github.com/ninja-build/ninja): A build-system alternative to `make`. Generally has better performance.
 - [bear](https://github.com/rizsotto/Bear): A tool for generating `compile-commands.json` files for projects which either (1) are lacking a generator for the file or (2) have complex header dependencies which can cause the LSP to have issues in some files when using the default `compile-commands.json`.
 - [bazel-compdb](https://github.com/grailbio/bazel-compilation-database): Generate compile-commands.json for bazel
 - [fzf](https://github.com/junegunn/fzf): Terminal fuzzy-finder
 - [lemonade](https://github.com/lemonade-command/lemonade): Copy, paste, and open browser over remote connection
 - [k9s](https://github.com/derailed/k9s): Kubernetes management
 - [buck](https://github.com/facebook/buck2): Build system
 - [bazel](https://github.com/bazelbuild/bazel): Build system
 - Rust Tools
   - [ripgrep](https://github.com/BurntSushi/ripgrep): Like `grep` but better
   - [fd-find](https://github.com/sharkdp/fd): Like `find` but better
   - [bat](https://github.com/sharkdp/bat): Like `cat` but better
   - [delta](https://github.com/dandavison/delta): Better viewing of git deltas (requires setup in .gitconfig)
   - [github-cli](https://github.com/cli/cli): Allows interacting with github (managing pull-requests, etc) over commandline
   - [exa](https://github.com/ogham/exa): Like `ls` but better
   - [silicon](https://github.com/Aloxaf/silicon): A tool for generating code-snippets
   - [xplr](https://github.com/sayanarijit/xplr): A TUI file file-explorer
   - [spotify-tui](https://github.com/Rigellute/spotify-tui): A TUI client for spotify
   - [btm](https://github.com/ClementTsang/bottom): System visualization TUI like htop
   - [dua](https://github.com/Byron/dua-cli): Interactive disk-usage analyzer similar to ncdu
   - [dust](https://github.com/bootandy/dust): Quick non-interactive disk usage visualizer
   - [procs](https://github.com/dalance/procs): Modern replacement for ps
   - [tealdeer](https://github.com/dbrgn/tealdeer): TLDR pages
   - [z](https://github.com/ajeetdsouza/zoxide): Smarter cd. Depends on fzf and init with `zoxide init fish | source`
   - [so](https://github.com/samtay/so): Terminal interface for stack overflow
   - [sad](https://github.com/ms-jpq/sad): Better sed with fzf integration

## Other tools to try

 - [wuzz](https://github.com/asciimoo/wuzz): TUI for analyzing http requests/responses
 - [httpie](https://github.com/httpie/httpie): CLI tool for analyzing http requests/responses (alternative to curl)
 - [ctop](https://github.com/bcicen/ctop): Like `top` for docker containers
 - [glow](https://github.com/charmbracelet/glow): Cli markdown viewer
 - [zellij](https://github.com/zellij-org/zellij): Modern terminal workspace manager (alternative to tmux)
 - [calcure](https://github.com/anufrievroman/calcure): Terminal callendar. Can sync with google callendar
 - [euporie](https://github.com/joouha/euporie): Terminal jupyter notebook viewer/runner
 - [termscp](https://github.com/veeso/termscp): Terminal UI for file transfer
 - [gh-dash](https://github.com/dlvhdr/gh-dash): UI for `gh` (github CLI)
 - [awesome-wm](https://github.com/awesomeWM/awesome): Modern window manager
   - [awesome-wm-widgets](https://github.com/streetturtle/awesome-wm-widgets/tree/a808ead3c74d57a7ccdb7f9e55cfa10a136d488c): Widgets for awesome-wm
 - [kdash](https://github.com/kdash-rs/kdash): Kubernetes dashboard TUI
 - [gpg-tui](https://github.com/orhun/gpg-tui): GPG key management TUI
 - [asdf](https://github.com/asdf-vm/asdf): Version manager for many different languages
 - [mosh](https://mosh.org/): Alternative to ssh with better support for laggy networks
 - [ast-grep](https://github.com/ast-grep/ast-grep): Like grep but for AST
 - [fpp](https://github.com/facebook/PathPicker): Choose paths from arbitrary output
 - [act](https://github.com/nektos/act): Run github actions locally
 - [just](https://github.com/casey/just): Make altermative
 - [watchexec](https://github.com/watchexec/watchexec): Automatically run commands on file change
# Installation

Many of the tools are available via `cargo install`

```
cargo install \
  ripgrep \
  fd-find \
  bat \
  git-delta \
  exa \
  silicon \
  bottom \
  dua-cli \
  du-dust \
  gitui \
  procs \
  tealdeer \
  zoxide \
  so \
  viu \
  tidy-viewer \
  spotify-tui
cargo install --locked --force xplr
```

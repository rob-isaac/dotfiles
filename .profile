# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
  # include .bashrc if it exists
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
  PATH="$HOME/.local/bin:$PATH"
fi

# >>> start ssh-agent
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval `ssh-agent -s`
  ssh-add
fi
function reloadssh() {
  eval "$(tmux show-env -s |grep '^SSH_')"
}
# <<< end ssh-agent

# >>> start tmux session and export some variables
[ -z "$TMUX"  ] && { tmux attach || exec tmux new-session;} # can use exec tmux new-session to exit after
alias config='/usr/bin/git --git-dir=/home/rob/.cfg/ --work-tree=/home/rob'
alias lspg='KATANA_ENABLE_EXPERIMENTAL=UseLogStructuredForUpdates'
alias dev='$HOME/katana-enterprise/scripts/dev'
if command -v conda &> /dev/null; then
  if conda env list | grep katana-dev &> /dev/null; then
    conda activate katana-dev
    export SRC_DIR=~/katana-enterprise
    export BUILD_DIR=~/Builds/current
    export GRAPH_QUERY_DIR=$SRC_DIR/lonestar/querying/distributed/graph-query
    export MY_CMAKE_ARGS="-DCMAKE_BUILD_TYPE=DEBUG -DKATANA_LANG_BINDINGS=python \
      -DKATANA_COMPONENTS='rdkit' -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
      -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++"
    export ADDITIONAL_PACKAGES='numactl-devel-cos6-x86_64 pynvim'
    export AWS_EC2_METADATA_DISABLED=true
  fi
fi
cd $HOME
# <<< end tmux session and export some variables

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
env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
  (umask 077; ssh-agent >| "$env")
  . "$env" >| /dev/null ; }

  agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2=agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
  agent_start
  ssh-add
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
  ssh-add
fi

unset env
# <<< start ssh-agent

# >>> start tmux session and export some variables
[ -z "$TMUX"  ] && { tmux attach || exec tmux new-session;} # can use exec tmux new-session to exit after
alias config='/usr/bin/git --git-dir=/home/rob/.cfg/ --work-tree=/home/rob'
conda activate katana-dev
export CXXFLAGS="$CXXFLAGS -Wfatal-errors"
export SRC_DIR=~/katana-enterprise
export BUILD_DIR=~/Builds/current
export GRAPH_QUERY_DIR=$SRC_DIR/lonestar/querying/distributed/graph-query
export CMAKE_ARGS="-DCMAKE_BUILD_TYPE=DEBUG -DKATANA_LANG_BINDINGS=python \
  -DKATANA_COMPONENTS='rdkit;gnn'"
export AWS_EC2_METADATA_DISABLED=true
# start docker
# sudo service docker status || sudo service docker start
# cd to home in case we are starting wsl from another directory
cd
if [[ -n "$IS_WSL" || -n "$WSL_DISTRO_NAME" ]]; then
    echo "This is WSL"
    # setup the X11 server for GUI apps
    # requires Xlaunch with defaults + DISABLE ACCESS CONTROL
    # https://stackoverflow.com/questions/61110603/how-to-set-up-working-x11-forwarding-on-wsl2
    export DISPLAY=$(ip route list default | awk '{print $3}'):0
    export LIBGL_ALWAYS_INDIRECT=1
    # TODO(Rob): use auth instead of open access to X11
    # https://stackoverflow.com/questions/66768148/how-to-setup-vcxsrv-for-use-with-wsl2
    # export DISPLAY=host.docker.internal:0
else
    echo "This is not WSL"
fi

# <<< start tmux session and export some variables

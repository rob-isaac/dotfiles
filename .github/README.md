# Rob's Dotfiles

A dotfile repo based on [https://www.atlassian.com/git/tutorials/dotfiles].

## Cloning

```bash
# Clone the repo.
git clone --bare https://github.com/rob-isaac/dotfiles $HOME/.cfg

# Attempt checkout.
git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout

# If checkout failed, backup conflicting files before retrying.
mkdir -p $HOME/.cfg.bak
config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} $HOME/.cfg.bak/{}
```

## Restarting From Scratch

```bash
mkdir $HOME/.cfg
git init --bare $HOME/.cfg
alias dot='git --git-dir=$HOME/.cfg --work-tree=$HOME'
```

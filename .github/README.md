A Dotfile Repo based on https://www.atlassian.com/git/tutorials/dotfiles.

# Starting From Scratch:
```
mkdir $HOME/.dotfiles
git init --bare $HOME/.dotfiles
alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dot config --local status.showUntrackedFiles no
```

then commit dotfiles with `dot add <dotfile>; dot commit -m <message>`

# Installing on new System
```
echo ".dotfiles" >> .gitignore
git clone --bare <git-repo-url> $HOME/.dotfiles
alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dot config --local status.showUntrackedFiles no
dot checkout # this may throw error -> resolve conficts and retry
```

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Show active GIT branch
# Source: http://jasonseifer.com/2010/05/05/osx-post-install-guide-4
#         https://github.com/blog/297-dirty-git-state-in-your-prompt
parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ →\ \1$(parse_git_dirty)/"
}

function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo " *"
}

export GIT_PS1_SHOWDIRTYSTATE=true
export PS1='\[\e[1;37m\][\[\e[1;35m\]\u\[\e[1;37m\]@\[\e[1;32m\]\h\[\e[1;37m\]:\[\e[1;36m\]\w\[\e[1;33m\]$(parse_git_branch)\[\e[1;37m\]]\n$ \[\e[0m\]'

function do_clip() {
    xclip -sel clip < $1
}
alias clip=do_clip

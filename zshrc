autoload -U compaudit compinit
compinit -u -C -d "$HOME/.zcompdump-$HOST-$ZSH_VERSION"

zmodload -i zsh/complist
WORDCHARS=''
unsetopt menu_complete
unsetopt flowcontrol
setopt auto_menu
setopt complete_in_word
setopt always_to_end
bindkey -M menuselect '^o' accept-and-infer-next-history
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $HOME/.cache/oh-my-zsh-cache

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history

bindkey -e
# Edit the current command line in $EDITOR
bindkey "^[m" copy-prev-shell-word                    # [Esc-m] - copy and paste previous word (for use in cp/mv)
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search

autoload -Uz is-at-least
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic
setopt long_list_jobs
setopt interactivecomments

autoload -U colors && colors
zstyle ':completion:*' list-colors "Gxfxcxdxbxegedabagacad"
setopt auto_cd
setopt multios
setopt prompt_subst

_plz_complete_zsh() {
    local args=("${words[@]:1:$CURRENT}")
    local IFS=$'\n'
    local completions=($(GO_FLAGS_COMPLETION=1 ${words[1]} -p -v 0 --noupdate "${args[@]}"))
    for completion in $completions; do
	compadd $completion
    done
}

compdef _plz_complete_zsh plz

function colored() {
	env     LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") _NROFF_U=1 "$@"
}
function man() { colored man "$@" ; }

encode64() { { [ $# -ne 0 ] && echo "$@" || cat ; } | base64 ; }
decode64() { { [ $# -ne 0 ] && echo "$@" || cat ; } | base64 -d ; }

alias -s pdf=mupdf
alias -s ps=zathura

source "$HOME/.zshtheme"

alias x=extract

extract() {
	local remove_archive
	local success
	local extract_dir

	if (( $# == 0 )); then
		echo "Usage: extract [-option] [file ...]

Options:
        -r, --remove    Remove archive after unpacking." >&2
	fi

	remove_archive=1
	[[ "$1" == "-r" || "$1" == "--remove" ]] && { remove_archive=0 ; shift ; }

	while (( $# > 0 )); do
		[ ! -f "$1" ] && { echo "'$1' doesn't exist" >&2 ; shift ; continue ; }

		success=0
		extract_dir="${1:t:r}"
		case "${1:l}" in
			(*.tar.gz|*.tgz) tar zxvf "$1" ;;
			(*.tar.bz2|*.tbz|*.tbz2) tar xvjf "$1" ;;
			(*.tar.xz|*.txz) tar --xz -xvf "$1" ;;
			(*.tar.zma|*.tlz) tar --lzma -xvf "$1" ;;
			(*.tar) tar xvf "$1" ;;
			(*.gz) gunzip -k "$1" ;;
			(*.bz2) bunzip2 "$1" ;;
			(*.xz) unxz "$1" ;;
			(*.lzma) unlzma "$1" ;;
			(*.z) uncompress "$1" ;;
			(*.zip|*.war|*.jar|*.sublime-package|*.ipsw|*.xpi|*.apk|*.aar|*.whl) unzip "$1" -d $extract_dir ;;
			(*.rar) unrar x -ad "$1" ;;
			(*.rpm) mkdir "$extract_dir" && cd "$extract_dir" && rpm2cpio "../$1" | cpio --quiet -id && cd .. ;;
			(*.7z) 7za x "$1" ;;
			(*.deb)
				mkdir -p "$extract_dir/control"
				mkdir -p "$extract_dir/data"
				cd "$extract_dir"; ar vx "../${1}" > /dev/null
				cd control; tar xzvf ../control.tar.gz
				cd ../data; extract ../data.tar.*
				cd ..; rm *.tar.* debian-binary
				cd .. ;;
			(*) echo "'$1' cannot be extracted" >&2 ; success=1 ;;
		esac

		(( success = $success > 0 ? $success : $? ))
		(( $success == 0 )) && (( $remove_archive == 0 )) && rm "$1"
		shift
	done
}

export LANG=en_US.UTF-8
export EDITOR=vim
export VISUAL='emacsclient'
export VEDITOR='emacsclient -n'
export PAGER='less'
export ARCHFLAGS="-arch x86_64"
export TERM=xterm-256color

zlibd() (printf "\x1f\x8b\x08\x00\x00\x00\x00\x00"|cat - $@|gzip -dc)
alias v="$VEDITOR"
alias V="sudo $EDITOR"
alias mv="mv -i"
e()    ($VISUAL $(ls | fzf))
E()    (sudo $VISUAL $(ls | fzf))
uzip() (unzip -d "$(echo "$1" | sed s/\.zip//g -)" "$1")
sd()   (sudo shutdown $@ now)
mnt() {
        mkdir -p "$HOME/mnt"
        sudo mount "$1" "$HOME/mnt"
        sudo chown -R "$USER:$USER" "$HOME/mnt"
}
alias umnt='sudo umount ~/mnt'
alias m='make -j$(nproc)'
alias mi='sudo make -j$(nproc) install'
alias mt='make -j$(nproc) test'
alias o='open'
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias l='ls -lFah'
alias ll='ls -lh'
alias la='ls -lAFh'
alias ls='ls -G'

alias grep="grep --color=auto --exclude-dir=.bzr --exclude-dir=CVS --exclude-dir=.git --exclude-dir=.hg --exclude-dir=.svn"

alias e64=encode64
alias d64=decode64

alias zsh-theme="$VEDITOR $HOME/.zsh-theme"
alias zshrc="$VEDITOR $HOME/.zshrc"
alias vimrc="$VISUAL $HOME/.vimrc"
alias help='man'

alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g L='| less'
alias -g NE='2> /dev/null'
alias -g NUL='> /dev/null 2>&1'

alias g='git'
alias ga='git add -v'
alias gaa='git add -vA'
alias gc='git commit -v'
alias gca='git commit -va'
alias gcam='git commit -vam'
alias gcsm='git commit -vsm'
alias gcl='git clone --recurse-submodules -v'
alias gcm='git commit -vm'
alias gd='git diff'
alias gi='git init'
alias gl='git pull'
alias gp='git push -v'
alias gs='git status'

alias dstat='ifstat -i en0'

alias rr='curl -s -L http://bit.ly/10hA8iC | bash'

alias tmp='pushd ; cd $(mktemp -d)'

alias dl='curl -LO'

alias x86='arch -arch x86_64'
alias arm='arch -arch arm64'

alias gcp='~/.bin/gcp -g'
alias gmv='~/.bin/gmv -g'

ght() (git tag $@ && git push origin --tags)
glcp() (git pull && git commit $@ && git push)

archof() (file $(which $@))

export PATH="/opt/homebrew/lib/ruby/gems/3.0.0/bin:$PATH"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$PATH:/opt/local/Library/Frameworks/Python.framework/Versions/3.9/bin"
export PATH="$PATH:/opt/local/Library/Frameworks/Python.framework/Versions/3.8/bin"
export PATH="$PATH:/opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin"
export PATH="$PATH:$HOME/Library/Python/3.9/bin"
export PATH="$PATH:$HOME/Library/Python/3.8/bin"
export PATH="$PATH:$HOME/Library/Python/3.7/bin"
export PATH="$PATH:$HOME/Library/Python/2.7/bin"
export PATH="$PATH:$HOME/.bin"
export PATH="$PATH:$HOME/vcpkg"
export PATH="$PATH:$HOME/flutter/bin:$HOME/.rvm/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.wasmer/bin:$HOME/.wasmer/globals/wapm_packages/.bin"
export PATH="$PATH:/opt/homebrew/opt/llvm/bin"
export PATH="$PATH:/Applications/CraftOS-PC.app/Contents/MacOS"
export PATH="$PATH:$HOME/.emacs.d/bin/"
export PATH="$PATH:$HOME/.pub-cache/bin"
export PATH="$PATH:/opt/local/bin"
export PATH="$PATH:$HOME/fvm/versions/stable/bin"
export PATH="$PATH:$HOME/.local/bin"

export GPG_TTY=$(tty)

export CARP_DIR=~/Carp/

command -v pfetch >/dev/null && pfetch

true

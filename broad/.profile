eval `dircolors ~/dircolors.ansi-dark`
export PS1='\[\e[33m\]\W/ \[\033[0m\]'
export TERM=xterm-256color
export LC_ALL="C"
export PATH=$PATH:/xchip/tcga/Tools/gdac/bin:/xchip/scarter/dmccabe/bin:/xchip/scarter/dmccabe/software
export PKG_CONFIG_PATH=/xchip/scarter/dmccabe/lib/pkgconfig
export JAGS_HOME=/xchip/scarter/dmccabe/bin/jags
export LD_RUN_PATH=/xchip/scarter/dmccabe/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/xchip/scarter/dmccabe/lib:/broad/software/free/Linux/redhat_6_x86_64/pkgs/r_3.3.0/lib64/R/lib

use Python-3.4
export VIRTUAL_ENV_DISABLE_PROMPT=1
source ~/myxchip/bin/venv/bin/activate
export PATH=$PATH:~/myxchip/bin/venv/bin

shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

function t() {
  n=0
  r=0
  s=0
  c=""

  TEMP=`getopt -o nr:s:c: -- "$@"`
  eval set -- "$TEMP"

  while true ; do
    case "$1" in
      -r) r=$2 ; shift 2 ;;
      -s) s=$2 ; shift 2 ;;
      -c) c="-c $2" ; shift 2 ;;
      -n) n=1 ; shift ;;
      --) shift ; break ;;
      *) echo "Invalid option -$1" ; exit 1 ;;
    esac
  done

  cmd="sed -e 's/^#CHROM/CHROM/' -e '/^#/d' $1"

  if [[ $n -eq 1 ]]; then
    cmd="$cmd | head -n 1 | csvcut -n -t"
  else
    if [[ $((r+s)) -ne 0 ]]; then
      nlines=`eval "$cmd | wc -l"`
      d1=$(($r+3))
      d2=$((nlines-s))
      cmd="$cmd | sed '$d1,$d2 d' | sed '$(($r+2)) s/[^\t]*/.../g'"
    fi

    cmd="$cmd | csvcut $c -t | csvlook"
  fi

  echo "$cmd"
  eval "$cmd"
}

function tn() {
  eval "t -n $@"
}

function th() {
  eval "t -r 5 $@"
}

function tt() {
  eval "t -s 5 $@"
}

function tht() {
  eval "t -r 5 -s 5 $@"
}

function wq() {
  if [[ $# -eq 0 ]]; then
    t=5
  else
    t=$1
  fi
  watch -n $t -d 'qstat'
}

man() {
  env \
  LESS_TERMCAP_mb=$(printf "\x1b[38;2;255;200;200m") \
  LESS_TERMCAP_md=$(printf "\x1b[38;2;255;100;200m") \
  LESS_TERMCAP_me=$(printf "\x1b[0m") \
  LESS_TERMCAP_so=$(printf "\x1b[38;2;60;90;90;48;2;40;40;40m") \
  LESS_TERMCAP_se=$(printf "\x1b[0m") \
  LESS_TERMCAP_us=$(printf "\x1b[38;2;150;100;200m") \
  LESS_TERMCAP_ue=$(printf "\x1b[0m") \
  man "$@"
}

alias xchip="cd /xchip/scarter/dmccabe" 
alias Rscript="Rscript --no-save --no-restore"
alias R="R --no-save --no-restore"
alias logout="exit"
alias ls="ls --color"
alias l="ls -al --color"
alias l1="ls -1 --color"
alias vat="vimcat"

use UGER

xchip

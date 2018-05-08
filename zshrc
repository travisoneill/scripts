# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/Users/travisoneill/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi




# ####ENVIRONMENT SETUP#####

export GOPATH=`go env GOPATH`
export PATH=$PATH:$(go env GOPATH)/bin

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_144.jdk/Contents/Home


# symlink to airport command
ln -s /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport /usr/local/bin/airport

#NVM config
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export DJANGO_SETTINGS_MODULE=arcweb.settings_local_dev
# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true
# cache pip-installed packages to avoid re-downloading
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache

# tracks arcviz root for setup script
ARCVIZ_ROOT=/Users/travisoneill/desktop/arcviz3

# makes pyenv activte work
if [[ $PATH != *$(pyenv root)* ]]; then
  eval "$(pyenv init -)"
fi


# ###ALIASES AND SCRIPTS###
alias reload="source ~/.zshrc && echo Shell config reloaded"
alias newbr="git checkout develop && git pull && git checkout -b"
# alias arc="cd ${ARCVIZ_ROOT} && pyenv activate arcviz_3.6.2 && export PYTHONPATH=`pwd`:`pwd`/arcweb && export DJANGO_SETTINGS_MODULE=arcweb.settings_local_dev"
# alias arc2="cd ${ARCVIZ_ROOT} && pyenv activate arcviz_2.6.6 && export PYTHONPATH=`pwd`:`pwd`/arcweb && export DJANGO_SETTINGS_MODULE=arcweb.settings_local_dev"
alias arc3="cd ${ARCVIZ_ROOT} && pyenv activate arcviz_3.6.2 && pwd && export PYTHONPATH=`pwd`:`pwd`/arcweb && export DJANGO_SETTINGS_MODULE=arcweb.settings_local_dev"
alias arcopen="pycharm $ARCVIZ_ROOT"
alias append="git stash pop"
alias config="atom ~/.zshrc"
alias pop="git reset HEAD~1 && git stash"
alias cut="git checkout -b"

getlarry() {
  cd $ARCVIZ_ROOT
  arcdb --backup
  rm arcweb.django.sqlite3
  scp travis@10.0.0.211:/home/arc/runner/arcviz_9999_scons/arcvizdata/arcviz.db $ARCVIZ_ROOT/arcweb.django.sqlite3
}

delete() {
  git branch -d $1
  git push origin --delete $1
}

commit() {
  git add -u
  if [[ $# == 0 ]]; then
    git commit -m "no message"
    return
  fi

  eval "git commit -m '${@}'"
}

pushsecret() {
  if [[ $# < 2 ]]; then
    echo 'args: <repo> <filename>'
    return
  fi

  declare BRANCH=$(git symbolic-ref --short HEAD)
  for i in $@; do
    if [[ $i == $1 ]]; then
      continue
    fi
    git add -f $i
  done

  git commit -m 'adding secret files'
  git push -f $1 $BRANCH

  for i in $@; do
    if [[ $i == $1 ]]; then
      continue
    fi
    git rm --cached $i
  done
  git reset --hard HEAD~1
}

rel() {
  git checkout "release_${1:0:1}.${1:1:1}.${1:2:1}"
}

jira() {
  if [[ $1 == '--open' || $1 == '-o' ]]; then
    open https://arcadiadata.atlassian.net/browse/ARC-$2
  else
    git checkout "ARC-${1}"
  fi
}

iss() {
  if [[ $# > 0 ]]; then
    open https://arcadiadata.atlassian.net/browse/ARC-$1
  fi
}

ppr() {
  open https://bitbucket.org/arcadiadata/arcviz/pull-requests/$1
}

push() {
  declare BRANCH=$(git symbolic-ref --short HEAD)
  if [[ $# == 0 ]]; then
    git push origin $BRANCH
  fi

  if [[ $# != 0 ]]; then
    git push $1 origin $BRANCH
  fi
}

pull() {
  declare BRANCH=$(git symbolic-ref --short HEAD)
  if [[ $# == 0 ]]; then
    git pull origin $BRANCH
  fi

  if [[ $# != 0 ]]; then
    git pull $1 origin $BRANCH
  fi
}

br() {
  declare BASE="develop"
  declare PREFIX="ARC-"

  if [[ $(pwd) != *$ARCVIZ_ROOT* ]]; then
    declare BASE="master"
    declare PREFIX=""
  fi

  if [[ $# == 0 ]]; then
    git checkout $BASE
    return
  fi

  git checkout $1

  if [[ $? != 0 && $PREFIX != "" ]]; then
    git checkout "${PREFIX}${1}"
  fi

}

arcmerge() {
  if [[ $(pwd) != *$ARCVIZ_ROOT* ]]; then
    return
  fi

  if [[ $# == 0 ]]; then
    echo -e "arcmerge <branch> to merge and delete locally and remotely"
    return
  fi

  declare MERGE_MSG=$(git merge $1)
  echo $MERGE_MSG

  if [[ $MERGE_MSG == *CONFLICT* ]]; then
    echo Delete aborted due to merge conflicts
    return
  fi

  if [[ $1 == *develop* || $1 == *poc* || $1 == *release* ]]; then
    echo -e "DELETE ABORTED"
    echo -e "Probably not a good idea to delete ${1}"
    return
  fi

  declare BRANCH=$(git symbolic-ref --short HEAD)
  git push origin $BRANCH
  git push origin --delete $1
  git branch -d $1
}

getmac() {
  declare LINE=$(ifconfig en0 ether | grep ether)
  declare MAC=${LINE:7}
  echo $MAC
}

routerip() {
  netstat -nr | grep default | grep -E -o "([0-9]{1,3}\.){3}[0-9]{1,3}"
}

allmacs() {
  # declare MACS=$(arp -a | grep -E -o "([A-Fa-f0-9]{1,2}:){5}[A-Fa-f0-9]{1,2}")
  # echo $MACS
  arp -a | while read line ; do
    declare IP=$(echo $line | grep -E -o "([0-9]{1,3}\.){3}[0-9]{1,3}")
    declare MAC=$(echo $line | grep -E -o "([A-Fa-f0-9]{1,2}:){5}[A-Fa-f0-9]{1,2}")
    echo $IP $MAC
  done
}

asshole() {
  declare ME=$(getmac)
  declare ROUTER=$(routerip)
  declare PREFIX=$(routerip | grep -E -o "^[0-9]{1,3}\.[0-9]{1,3}")
  echo $PREFIX

  allmacs | while read LINE ; do
    # echo $LINE | awk '{print $1}'
    # echo $LINE | awk '{print $2}'
    declare IP=$(echo $LINE | awk '{print $1}')
    declare MAC=$(echo $LINE | awk '{print $2}')
    declare PRE=$(echo $IP | grep -E -o "^[0-9]{1,3}\.[0-9]{1,3}")
    # echo $PRE
    # echo $IP
    # echo $MAC
    if [[ "$MAC" == "$ME" ]]; then
      echo ME $LINE
    elif [[ "$ROUTER" == "$IP" ]]; then
      echo ROUTER $LINE
    elif [[ "$PREFIX" !=  "$PRE" ]]; then
      echo OTHER $LINE
    else
      spoofmac $MAC
      sudo airport -z
    fi

  done

  spoofmac
}

spoofmac() {

  if [[ $# > 0 ]]; then
    sudo ifconfig en0 ether $1
    echo Your MAC address has been changed to: $1
    return
  fi

  declare LINE=$(ifconfig en0 ether | grep ether)
  declare MAC=${LINE:7}
  declare OUI=${MAC:0:8}
  declare NIC=${MAC:9}
  declare R1=$RANDOM
  declare R2=$RANDOM
  declare R3=$RANDOM
  declare BYTE1=$(hex $(($R1%256)))
  declare BYTE2=$(hex $(($R2%256)))
  declare BYTE3=$(hex $(($R3%256)))
  declare NIC="${BYTE1}:${BYTE2}:${BYTE3}"
  declare NEWMAC="${OUI}:${NIC}"
  sudo ifconfig en0 ether $NEWMAC
  echo Your MAC address has been changed to: $NEWMAC
}

hex() {
  declare HEX=$(echo "obase=16; ${1}" | bc)
  if [[ ${#HEX} < 2 ]]; then
    echo 0${HEX}
  else
    echo $HEX
  fi
}

arcdb() {
  if [[ $# == 0 ]]; then
    echo -b / --backup
    echo -r / --revert
    echo -c / --clear
  fi

  if [[ $1 == "--clear" || $1 == "-c" ]]; then
    rm -rf $ARCVIZ_ROOT/backupdbs
  fi

  if [[ ! -d $ARCVIZ_ROOT/backupdbs ]]; then
    mkdir $ARCVIZ_ROOT/backupdbs
    echo directory $ARCVIZ_ROOT/backupdbs created
  fi

  # number of backups in backup directory
  declare NUM=${"$(ls $ARCVIZ_ROOT/backupdbs | wc -l)"##* }
  declare NEXT=$((NUM + 1))

  if [[ $1 == "--backup" || $1 == "-b" ]]; then
    if [[ $# < 2 ]]; then
      cp $ARCVIZ_ROOT/arcweb.django.sqlite3 $ARCVIZ_ROOT/backupdbs/arcweb.django.backup$NEXT.sqlite3
    else
      cp $ARCVIZ_ROOT/arcweb.django.sqlite3 $ARCVIZ_ROOT/backupdbs/arcweb.django.backup$2.sqlite3
    fi
  fi

  if [[ $1 == "--revert" || $1 == "-r" ]]; then
    if [[ $# < 2 ]]; then
      cp $ARCVIZ_ROOT/backupdbs/arcweb.django.backup$NUM.sqlite3 $ARCVIZ_ROOT/arcweb.django.sqlite3
    else
      cp $ARCVIZ_ROOT/backupdbs/arcweb.django.backup$2.sqlite3 $ARCVIZ_ROOT/arcweb.django.sqlite3
    fi
  fi
}

testf() {
  if [[ ! -d backupdbs ]]; then
    mkdir backupdbs
    echo directory $ARCVIZ_ROOT/backupdbs created
  fi

  if [[ $1 == "--clear" || $1 == "-c" ]]; then
    rm -rf $ARCVIZ_ROOT/backupdbs
    mkdir $ARCVIZ_ROOT/backupdbs
  fi

  declare N=$(ls backupdbs | wc -l)
  declare NUMBACKUPS=${N##* }

  echo $NUMBACKUPS

  declare N=$((NUMBACKUPS + 1))

  echo $N

  echo $ARCVIZ_ROOT/backupdbs/arcweb.django.backup$N.sqlite3

  echo $((${"$(ls backupdbs | wc -l)"##* } + 1))

}

arpa() {
  for i in {1..254}; do
    ping -c 1 10.0.1.$i
  done
}

arcset() {
  ARCVIZ_ROOT=`pwd`
}

movebuild() {
  rm $ARCVIZ_ROOT/arcweb/static/js/arc/arc_all.js
  cp $ARCVIZ_ROOT/arcweb/static/js/build/js/arc/arc_all.babel.js $ARCVIZ_ROOT/arcweb/static/js/arc/arc_all.js
}

removebuild() {
   rm $ARCVIZ_ROOT/arcweb/static/js/arc/arc_all.js
}

arcie() {
  if [[ $# == 0 || $1 == "-h" || $1 == "--help" ]]; then
    echo arcie --run to run ie server
    echo arcie --stop to exit ie mode
    echo arcie --update to rebuild and run ie server
    return
  fi

  pyenv activate arcviz_2.6.6

  declare ARC_IP=`ipconfig getifaddr en0`
  declare ARC_PORT=8001

  if [[ $1 == "-u" || $1 == "--update" || ! -f $ARCVIZ_ROOT/arcweb/static/js/arc/arc_all.js ]]; then
    cd $ARCVIZ_ROOT
    scons
    rm $ARCVIZ_ROOT/arcweb/static/js/arc/arc_all.js
    cp $ARCVIZ_ROOT/arcweb/static/js/build/js/arc/arc_all.babel.js $ARCVIZ_ROOT/arcweb/static/js/arc/arc_all.js
  fi

  if [[ $1 == "-u" || $1 == "--update" || $1 == "--run" || $1 == "-r" ]]; then
    cd $ARCVIZ_ROOT/arcweb
    ./manage.py runserver 0.0.0.0:$ARC_PORT
    echo Server running at $ARC_IP:$ARC_PORT
  fi

  if [[ $1 == "-s" || $1 == "--stop" ]]; then
    rm $ARCVIZ_ROOT/arcweb/static/js/arc/arc_all.js
  fi
}

manage() {
  cd $ARCVIZ_ROOT/arcweb
  export PYTHONPATH=`pwd`:`pwd`/arcweb
  export DJANGO_SETTINGS_MODULE=arcweb.settings_local_dev
  python manage.py $1
}

javaeval() {
  declare CP=$HOME/javaeval
  rm $CP/JavaEval.java
  touch $CP/JavaEval.java
  echo Running: $1
  echo "import java.io.*; import java.util.*; public class JavaEval {public static void main(String[] args) {System.out.println($1);}}" > $HOME/javaeval/JavaEval.java
  javac $CP/JavaEval.java -cp $CP
  java -cp $CP JavaEval
}

# validmac() {
#
#   ^([0-9A-Fa-f]{2}[:]){5}([0-9A-Fa-f]{2})$
# }

# jira() {
#   if [[ $(pwd) != *$ARCVIZ_ROOT* ]]; then
#     return
#   fi
#
#   if [[ $# == 0 ]]; then
#     echo -e "jira <number> to create or checkout branch"
#     return
#   fi
#
#   git checkout "ARC-${1}"
#
#   if [[ $? != 0 ]]; then
#     newbr "ARC-${1}"
#   fi
# }

# arct() {
#   if [[ $(pwd) != *$ARCVIZ_ROOT* ]]; then
#     echo 111
#   fi
# }

#!/bin/bash

# Simple wrapper script to install, load, and upgrade nvm
# please source this script with $NVM_DIR of your choice

# set NVM_DIR if not exist
if [[ -z ${NVM_DIR+x} ]]; then
  export NVM_DIR="$HOME/.nvm"
fi

# function to load nvm
function nvmload {
  if [[ -d $NVM_DIR ]]; then
    if [[ $NPM_CONFIG_PREFIX != "" ]]; then
      echo "NPM_CONFIG_PREFIX Environment variable is not empty"
      echo "It will be unset and copied to _NPMCONFIGPREFOLD"
      export _NPMCONFIGPREFOLD="$NPM_CONFIG_PREFIX"
    fi
    
    unset NPM_CONFIG_PREFIX
    export NPM_CONFIG_USERCONFIG="$NVM_DIR/npmrc_user"
    export NPM_CONFIG_GLOBALCONFIG="$NVM_DIR/npmrc_global"

    # loads nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" &&

    # loads nvm bash_completion
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" &&

    return 0
  else
    echo "Error, $NVM_DIR is NOT exist, install nvm first."
    return 1
  fi
  echo "Error loading nvm"
  return 1
}

function nvmunload {
  if [[ -z $(command -v nvm)  ]]; then
    echo "nvm is not loaded"
    return 1
  fi
  NVM_DIR_PREV="$NVM_DIR"
  nvm unload
  export NPM_CONFIG_PREFIX="$_NPMCONFIGPREFOLD"
  export NVM_DIR="$NVM_DIR_PREV"
}


# function to install NVM into $NVM_DIR
function nvminstall {
  # set NVM_DIR if not exist
  if [[ -z ${NVM_DIR+x} ]]; then
    export NVM_DIR="$DEF_NVM_DIR"
  fi

  if [[ ! -d $NVM_DIR ]]; then
    git clone https://github.com/creationix/nvm.git "$NVM_DIR" &&
    cd "$NVM_DIR" &&
    git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)` &&

    nvmload &&

    nvm install node &&
    npm config set cache "$NVM_DIR/npm_cache_user" &&

    return 0
  else
    echo "Error, $NVM_DIR is already exist, delete first before installation"
    return 1
  fi
  echo "Error installing nvm"
  return 1
}


# function upgrade nvm
function nvmupgrade {
  if [[ -d $NVM_DIR ]]; then
    cd "$NVM_DIR"
    git fetch --tags origin &&
    git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)` &&
    
    nvmload &&
    
    return 0
  else
    echo "Error, $NVM_DIR is NOT exist, install nvm first."
    return 1
  fi
  echo "Error upgrading nvm"
  return 1
}

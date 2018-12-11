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
      echo "It will be unset and copied to _NPM_CONFIG_PREFIX"
      NPM_CONFIG_PREFIX_OLD=$_NPM_CONFIG_PREFIX
      export _NPM_CONFIG_PREFIX
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
    echo "Error, $NVM_DIR is NOT exist, install NVM first."
    return 1
  fi
  echo "Error loading NVM"
  return 1
}

function nvmunload {
  nvm unload
  NPM_CONFIG_PREFIX=$_NPM_CONFIG_PREFIX
  export NPM_CONFIG_PREFIX
}


# function to install NVM into $NVM_DIR
function nvminstall {
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
  echo "Error installing NVM"
  return 1
}


# function upgrade nvm
function nvmupgrade {
  if [[ -d $NVM_DIR ]]; then
    cd "$NVM_DIR"
    git fetch --tags origin &&
    git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)` &&
    \. "$NVM_DIR/nvm.sh"
    return 0
  else
    echo "Error, $NVM_DIR is NOT exist, install NVM first."
    return 1
  fi
  echo "Error upgrading NVM"
  return 1
}

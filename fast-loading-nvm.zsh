#!/bin/zsh
export NVM_DIR="$HOME/.nvm"
function load_nvm() {
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

    if [ ! -z "$AUTO_LOAD_NVMRC_FILES" ] && [ "$AUTO_LOAD_NVMRC_FILES" = true ]
    then
        autoload -U add-zsh-hook
        load-nvmrc() {
          local node_version="$(nvm version)"
          local nvmrc_path="$(nvm_find_nvmrc)"

          if [ -n "$nvmrc_path" ]; then
            local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

            if [ "$nvmrc_node_version" = "N/A" ]; then
              nvm install
            elif [ "$nvmrc_node_version" != "$node_version" ]; then
              nvm use
            fi
          elif [ "$node_version" != "$(nvm version default)" ]; then
            echo "Reverting to nvm default version"
            nvm use default
          fi
        }
        add-zsh-hook chpwd load-nvmrc
    fi

    if [ ! -z "$LOAD_NVMRC_ON_INIT" ] && [ "$LOAD_NVMRC_ON_INIT" = true ]
    then
        load-nvmrc
    fi
}

# Initialize a new worker
async_start_worker nvm_worker -n
async_register_callback nvm_worker load_nvm
async_job nvm_worker sleep 0.1

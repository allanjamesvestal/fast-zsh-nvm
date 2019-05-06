#!/bin/zsh
export NVM_DIR="$HOME/.nvm"
function load_nvm() {
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

    if [ ! -z "$AUTO_LOAD_NVMRC_FILES" ] && [ "$AUTO_LOAD_NVMRC_FILES" = true ]
    then
        autoload -U add-zsh-hook
        load-nvmrc() {
            if [[ -f .nvmrc && -r .nvmrc ]]; then
                nvm use
            elif [[ $(nvm version) != $(nvm version default)  ]]; then
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
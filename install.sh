#!/usr/bin/env bash

# get abs path of current script
_base_path="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

VENV_PATH="$_base_path/ws-autoreload/venv"

is_python3_installed() {
    command -v python3 &>/dev/null && echo true || echo false
}

is_venv_present() {
    [[ -d "$VENV_PATH" ]] && echo true || echo false
}

setup_venv() {

    if [[ $(is_venv_present) == true ]]; then
        echo "venv already present, skipping creation..."
        return
    else
        python3 -m venv "$VENV_PATH"
    fi
}

install_requirements() {

    source "$VENV_PATH"/bin/activate
    pip install -r "$_base_path"/ws-autoreload/requirements.txt
    deactivate
}

main() {
    if [[ $(is_python3_installed) == true ]]; then
        setup_venv
        install_requirements
    else
    else
        echo 'No python3 in path detected, aborting.'
    fi
}

main

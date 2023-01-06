#!/usr/bin/env bash

_base_path="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

_python_path="$_base_path/../ws-autoreload/venv/bin/python"

_autoreload_path="$_base_path/../ws-autoreload/autoreload.py"

_autoreload_pid=

function start_autoreload_server() {
    $_python_path $_autoreload_path "$@" &
    _autoreload_pid=$!
}

function main() {
    start_autoreload_server "$@"
    echo "$_autoreload_pid"
}

main "$@"

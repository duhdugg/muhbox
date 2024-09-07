autoload -U add-zsh-hook
function _pyenv_chpwd_hook {
    if test -f ./venv/bin/activate; then
        source ./venv/bin/activate
    fi
}
_pyenv_chpwd_hook
add-zsh-hook chpwd _pyenv_chpwd_hook

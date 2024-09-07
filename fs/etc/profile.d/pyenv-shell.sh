export PYENV_ROOT="/opt/pyenv"
if [[ "$PATH" != *"$PYENV_ROOT/bin"* ]]; then
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

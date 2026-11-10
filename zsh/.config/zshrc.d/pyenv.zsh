# pyenv: shims on PATH at startup (no forks); shell integration lazy-inits on first `pyenv`
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/shims ]] && path=("$PYENV_ROOT/shims" $path)
[[ -d $PYENV_ROOT/bin ]] && path=("$PYENV_ROOT/bin" $path)
pyenv() {
    unfunction pyenv
    eval "$(command pyenv init - zsh)"
    pyenv "$@"
}

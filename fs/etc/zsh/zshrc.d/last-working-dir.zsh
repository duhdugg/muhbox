# copied from oh-my-zsh
# MIT License
#
# Copyright (c) 2009-2022 Robby Russell and contributors (https://github.com/ohmyzsh/ohmyzsh/contributors)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
ZSH_CACHE_DIR="/run/user/$UID"
# Flag indicating if we've previously jumped to last directory
typeset -g ZSH_LAST_WORKING_DIRECTORY

# Updates the last directory once directory is changed
autoload -U add-zsh-hook
add-zsh-hook chpwd chpwd_last_working_dir
chpwd_last_working_dir() {
  # Don't run in subshells
  [[ "$ZSH_SUBSHELL" -eq 0 ]] || return 0
  # Add ".$SSH_USER" suffix to cache file if $SSH_USER is set and non-empty
  local cache_file="$ZSH_CACHE_DIR/last-working-dir${SSH_USER:+.$SSH_USER}"
  builtin pwd >| "$cache_file"
}

# Changes directory to the last working directory
lwd() {
  # Add ".$SSH_USER" suffix to cache file if $SSH_USER is set and non-empty
  local cache_file="$ZSH_CACHE_DIR/last-working-dir${SSH_USER:+.$SSH_USER}"
  [[ -r "$cache_file" ]] && cd "$(cat "$cache_file")"
}

# Jump to last directory automatically unless:
# - this isn't the first time the plugin is loaded
# - it's not in $HOME directory
[[ -n "$ZSH_LAST_WORKING_DIRECTORY" ]] && return
[[ "$PWD" != "$HOME" ]] && return

lwd 2>/dev/null && ZSH_LAST_WORKING_DIRECTORY=1 || true

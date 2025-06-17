if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Created by `pipx` on 2025-02-12 07:37:08
set PATH $PATH /home/szoloa/.local/bin

set -gx EDITOR vim

alias spotdlc='spotdl --threads 8 --proxy http://127.0.0.1:7890'

alias del='trash-put'

zoxide init fish | source

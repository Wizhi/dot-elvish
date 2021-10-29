use epm

epm:install &silent-if-installed=$true github.com/zzamboni/elvish-completions

use github.com/zzamboni/elvish-completions/cd
use github.com/zzamboni/elvish-completions/git

fn dotfiles [@a]{ git --git-dir=$E:HOME/.dotfiles --work-tree=$E:HOME $@a }
edit:completion:arg-completer[dotfiles] = $edit:completion:arg-completer[git]

edit:abbr['||'] = '| less'

use prompts/git git-prompt
use prompts/kcr kcr-prompt

edit:prompt = {
    if $git-prompt:cwd[is-repository] {
        git-prompt:pwd
    } else {
        tilde-abbr $pwd
    }

    put ' > '
}

edit:rprompt = {
    for segment [
        (kcr-prompt:client)
        (git-prompt:head)
        (git-prompt:status)
    ] {
        if $segment {
            put ' ' $segment
        }
    }
}

use epm

epm:install &silent-if-installed=$true github.com/zzamboni/elvish-completions

use github.com/zzamboni/elvish-completions/cd
use github.com/zzamboni/elvish-completions/git

fn dotfiles [@a]{ git --git-dir=$E:HOME/.dotfiles --work-tree=$E:HOME $@a }
edit:completion:arg-completer[dotfiles] = $edit:completion:arg-completer[git]

edit:abbr['||'] = '| less'

epm:install &silent-if-installed=$true github.com/href/elvish-gitstatus

use github.com/href/elvish-gitstatus/gitstatus
use str

fn -git-prompt []{
    set prompt = ''
    set git = (gitstatus:query $pwd)

    if $git[is-repository] {
        if (eq $git[local-branch] $git[remote-branch]) {
            prompt = $prompt' '(styled $git[local-branch] 'green')
        } else {
            prompt = $prompt' '(styled $git[local-branch] 'green')':'(styled $git[remote-branch] 'yellow')
        }

        fn a [k i @s]{
            if (> $git[$k] 0) {
                prompt = $prompt(styled $i $@s)
            }
        }

        a conflicted     '%' red
        a unstaged       '!' yellow
        a staged         '+' green
        a untracked      '?' blue
        a commits-behind '🠗' yellow
        a commits-ahead  '🠕' green
    }

    put $prompt
}

edit:rprompt = (constantly (-git-prompt))

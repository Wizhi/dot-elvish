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
    set git = (gitstatus:query $pwd)

    if (not $git[is-repository]) {
        return
    }

    var branch

    if (eq $git[local-branch] $git[remote-branch]) {
        branch = (styled $git[local-branch] 'green')
    } else {
        branch = (styled $git[local-branch] 'green')':'(styled $git[remote-branch] 'yellow')
    }

    set status = ''

    fn add-status [k i @s]{
        if (> $git[$k] 0) {
            status = $status(styled $i $@s)
        }
    }

    add-status conflicted     '%' red
    add-status unstaged       '!' yellow
    add-status staged         '+' green
    add-status untracked      '?' blue
    add-status commits-behind '🠗' yellow
    add-status commits-ahead  '🠕' green

    set prompt = ''

    each [item]{
        if (not-eq $item '') {
            set prompt = $prompt' '$item
        }
    } [$branch $status]

    put $prompt
}

edit:rprompt = $-git-prompt~

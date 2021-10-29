use epm

epm:install &silent-if-installed=$true github.com/href/elvish-gitstatus

use str
use github.com/href/elvish-gitstatus/gitstatus

var cwd

set edit:after-command = [$@edit:after-command [_]{
    set cwd = (gitstatus:query $pwd)
}]

fn branch [git]{
    if (not $git[is-repository]) {
        return
    }

    if (eq $git[local-branch] "") {
        styled $git[commit][:8] yellow
    } elif (eq $git[local-branch] $git[remote-branch]) {
        styled $git[local-branch] 'green'
    } else {
        put (styled $git[local-branch] 'green')':'(styled $git[remote-branch] 'yellow')
    }
}

fn status [git]{
    if (not $git[is-repository]) {
        return
    }

    set status = ''

    fn add [k i @s]{
        if (> $git[$k] 0) {
            status = $status(styled $i $@s)
        }
    }

    add conflicted     '%' red
    add unstaged       '!' yellow
    add staged         '+' green
    add untracked      '?' blue
    add commits-behind '🠗' yellow
    add commits-ahead  '🠕' green

    if (not-eq $status '') {
        put $status
    }
}

fn prompt [&path=$pwd]{
    set git = (gitstatus:query $pwd)

    if (not $git[is-repository]) {
        return
    }

    set prompt = (branch $git)
    set status = (status $git)

    if (not-eq $status '') {
        set prompt = $prompt' '$status
    }

    put $prompt
}

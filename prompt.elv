use prompts/git
use prompts/kcr

set edit:prompt = {
    if $git:cwd[is-repository] {
        git:pwd
    } else {
        tilde-abbr $pwd
    }

    put ' > '
}

set edit:rprompt = {
    for segment [
        (kcr:client)
        (git:head)
        (git:status)
    ] {
        if $segment {
            put ' ' $segment
        }
    }
}

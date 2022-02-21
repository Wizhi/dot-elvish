use path
use str

var file-name; set file-name = '.env'

fn -parse-line {|line|
    var name value; set name value = (str:split &max=2 '=' $line)

    str:trim-space $name
    str:trim-space $value
}

fn -parse {|lines|
    var env = [&]

    for line $lines {
        set line = (str:trim-space $line)

        if (or (eq $line '') (str:has-prefix $line '#')) {
            continue
        }

        var name value = (-parse-line $line)

        set env[$name] = $value
    }

    put $env
}

fn parse-file {|path|
    if (not (path:is-regular $path)) {
        fail
    }

    -parse [(cat $path)]
}

fn load-file {|path|
    if (not (path:is-regular $path)) {
        fail
    }

    var env; set env = (parse-file $path)

    for name [(keys $env)] {
        set-env $name $env[$name]
    }
}

fn unload-file {|path|
    if (not (path:is-regular $path)) {
        fail
    }

    var env; set env = (parse-file $path)

    for name [(keys $env)] {
        unset-env $name
    }
}

fn load {|&path=$file-name|
    if (not (path:is-regular $path)) {
        return
    }

    load-file $path
}

fn hook {|&file-name=$file-name|
    var loaded; set loaded = []

    fn files {|dir|
        var names; set names = [(str:split '/' (path:abs $dir))][1..]

        for i [(range (count $names))] {
            var file; set file = '/'(str:join '/' $names[..(+ $i 1)])'/'$file-name

            if (path:is-regular $file) {
                put $file
            }
        }
    }

    fn callback {|dir|
        for file [(order &reverse $loaded)] {
            unload-file $file
        }

        var files; set files = [(files (path:abs $dir))]

        for file $files {
            load-file $file
        }

        set loaded = $files
    }

    put $callback~
}

fn exec {|&path=$file-name script|
    if (not (path:is-regular $path)) {
        return
    }

    var env; set env = (parse-file $path)
    var original; set original = (each {|name|
        if (has-env $name) {
            put [$name (get-env $name)]
        }

        set-env $name $env[$name]
    } [(keys $env)] | make-map)

    eval $script

    for name [(keys $env)] {
        if (has-key $original $name) {
            set-env $name $original[$name]
        } else {
            unset-env $name
        }
    }
}

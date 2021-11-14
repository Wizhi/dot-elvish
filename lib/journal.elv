use str

var dir = $E:HOME/journal
var editor = $E:EDITOR

fn cleanup []{
    find $dir -empty -type d,f -delete
}

fn -day []{
    put (date "+%Y/%m/%d")
}

fn -time []{
    put (date "+%H:%M:%S")
}

fn -dir [&create=$true]{
    set path = $dir/(-day)

    if $create {
        mkdir --parents $path
    }

    put $path
}

fn -editor []{
    if (has-external $editor) {
        external $editor
    } elif (has-external $E:EDITOR) {
        external $E:EDITOR
    } else {
        fail "no editor found"
    }
}

fn open []{
    (-editor) (-dir)/entry.md
}

fn event [summary]{
    printf "[%s] %s\n" (-time) $summary >> (-dir)/entry.md
}

fn -meal-path []{
    put (-dir)/meals
}

fn meal [summary &kcal=0]{
    set path = (-meal-path)
    set metadata = [&time=(-time)]

    if (< 0 $kcal) {
        set metadata[kcal] = (printf "%.2f" $kcal)
    }

    printf "%s | %s\n" $summary (keys $metadata | each [name]{
        put (printf "%s: %s" $name $metadata[$name])
    } | str:join ", " [(all)]) >> $path
}

fn meals []{
    cat (-meal-path)
}

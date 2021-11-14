use path
use str

var dir = $E:HOME/journal
var editor = $E:EDITOR

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

fn save []{
    try {
        git -C $dir add (-dir)
        git -C $dir commit --quiet --message (printf "Save %s @ %s" (-day) (-time)) > /dev/null
    } except { }
}

fn cleanup []{
    find $dir -empty -type d,f -delete
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

fn -entry-path []{
    set path = (-dir)/entry.md

    if (not (path:is-regular $path)) {
        printf "# %s\n\nHow's life?\n\n" (-day) > $path
    }

    put $path
}

fn open []{
    (-editor) (-entry-path)
}

fn event [summary]{
    printf "## %s %s\n\nWhat happened?\n\n" (-time) $summary >> (-entry-path)
}

fn events []{
    grep -E "^## [0-9]{2}:[0-9]{2}:[0-9]{2}" (-entry-path)
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

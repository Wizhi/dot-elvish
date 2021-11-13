use str

var dir = $E:HOME/journal
var editor = $E:EDITOR

fn -editor []{
    if (has-external $editor) {
        external $editor
    } elif (has-external $E:EDITOR) {
        external $E:EDITOR
    } else {
        fail 'no editor found'
    }
}

fn -today [&create=$true]{
    set path = $dir/(date '+%Y/%m/%d')

    if $create {
        mkdir --parents $path
    }

    put $path
}

fn open []{
    (-editor) (-today)/entry.md
}

fn -meal-path []{ put (-today)/meals }

fn meal [summary &kcal=0 &dir=$dir]{
    set path = (-meal-path)
    set metadata = [&time=(date '+%H:%M:%S')]

    if (< 0 $kcal) {
        set metadata[kcal] = (printf "%.2f" $kcal)
    }

    printf "%s | %s\n" $summary (keys $metadata | each [name]{
        put (printf '%s: %s' $name $metadata[$name])
    } | str:join ", " [(all)]) >> $path
}

fn meals []{
    cat (-meal-path)
}

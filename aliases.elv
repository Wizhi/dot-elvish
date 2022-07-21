use str

fn -alias {|a b &fail=$false|
    if (has-external $b) {
        edit:add-var (str:trim-suffix $a ~)~ (external $b)

        if (has-key $edit:completion:arg-completer $b) {
            set edit:completion:arg-completer[$a] = $edit:completion:arg-completer[$b]
        }
    } elif $fail {
        fail "external "$b" not found"
    }
}

-alias k kubectl

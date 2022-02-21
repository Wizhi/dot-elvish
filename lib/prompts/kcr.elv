fn client {||
    if (has-external kcr) {
        try {
            kcr prompt
        } except { }
    }
}

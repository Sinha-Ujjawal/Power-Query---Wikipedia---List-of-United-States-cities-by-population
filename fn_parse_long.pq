(long as text) as number =>
    let
        long_trimmed = Text.Trim(long)
    in
        if Text.EndsWith(long_trimmed, "°E") then
            Number.FromText(fn_remove_strings(long_trimmed, {"°E"}))
        else if Text.EndsWith(long_trimmed, "°W") then
            -Number.FromText(fn_remove_strings(long_trimmed, {"°W"}))
        else
            error "Cannot parse '" & long_trimmed & "' as a valid longitude, expected of form number°E | number°W"

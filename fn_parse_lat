(lat as text) as number =>
    let
        lat_trimmed = Text.Trim(lat)
    in
        if Text.EndsWith(lat_trimmed, "°N") then
            Number.FromText(fn_remove_strings(lat_trimmed, {"°N"}))
        else if Text.EndsWith(lat_trimmed, "°S") then
            -Number.FromText(fn_remove_strings(lat_trimmed, {"°S"}))
        else
            error "Cannot parse '" & lat_trimmed & "' as a valid latitute, expected of form number°N | number°S"

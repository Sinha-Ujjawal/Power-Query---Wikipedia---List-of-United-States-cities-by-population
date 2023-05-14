(latlong as text) as list =>
    let
        latlong_split = Text.Split(Text.Trim(latlong), " ")
        , lat = try fn_parse_lat(latlong_split{0}) otherwise null
        , long = try fn_parse_long(latlong_split{1}) otherwise null
    in
        {lat, long}

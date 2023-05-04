fn_pipe(
    #"Wiki list of US cities by population"[Data]{6},
    {
        each Table.RenameColumns(_, {"Census-designated place", "Census Designated Place"})
        , each Table.TransformColumns(
            _
            , {
                {"2020 census", try_fn(Int32.From)}
                , {"Change", fn_parse_percentage}
                , {"2020 land area", each fn_pipe(_, {each fn_remove_strings(_, {"sq", "mi"}), try_fn(Number.FromText)})}
                , {"2020 land area2", each fn_pipe(_, {each fn_remove_strings(_, {"km"}), try_fn(Number.FromText)})}
                , {"2020 population density", each fn_pipe(_, {each fn_remove_strings(_, {"/", "sq", "mi"}), try_fn(Number.FromText)})}
                , {"2020 population density2", each fn_pipe(_, {each fn_remove_strings(_, {"/", "km"}), try_fn(Number.FromText)})}
                , {"Location", each Text.Select(Text.Split(_, " / "){1}, {"A".."Z", "a".."z", "0".."9", "-", " ", ".", "°"})}
            }
        )
        , each Table.AddColumn(_, "LatLong", each fn_parse_latlong(_[Location]))
        , each Table.AddColumn(_, "Latitude", each _[LatLong]{0})
        , each Table.AddColumn(_, "Longitude", each _[LatLong]{1})
        , each Table.RemoveColumns(_, {"Location", "LatLong"})
        , each Table.RenameColumns(
            _
            , {
                {"Change", "% Change"}
                , {"2020 land area", "2020 land area (sq mi)"}
                , {"2020 land area2", "2020 land area (sq km)"}
                , {"2020 population density", "2020 population density (per sq mi)"}
                , {"2020 population density2", "2020 population density (per sq km)"}
            }
        )
        , each Table.TransformColumnTypes(
            _
            , {
                {"2020 census", Int32.Type}
                , {"% Change", Number.Type}
                , {"2020 land area (sq mi)", Number.Type}
                , {"2020 land area (sq km)", Number.Type}
                , {"2020 population density (per sq mi)", Number.Type}
                , {"2020 population density (per sq km)", Number.Type}
                , {"Latitude", Number.Type}
                , {"Longitude", Number.Type}
            }
        )
        , each Table.SelectColumns(
            _
            , {
                "Census Designated Place"
                , "State"
                , "2020 census"
                , "% Change"
                , "2020 land area (sq mi)"
                , "2020 land area (sq km)"
                , "2020 population density (per sq mi)"
                , "2020 population density (per sq km)"
                , "Latitude"
                , "Longitude"
            }
        )
    }
)

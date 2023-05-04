fn_pipe(
    #"Wiki list of US cities by population"{7}[Data],
    {
        each Table.RemoveFirstN(_, 1)
        , each Table.TransformColumns(
            _
            , {
                {"2021 estimate", try_fn(Int32.From)}
                , {"2020 census", try_fn(Int32.From)}
                , {"Peak population", try_fn(Int32.From)}
                , {"Percent decline from peak population", fn_parse_percentage}
            }
        )
        , each Table.RenameColumns(_, {"Percent decline from peak population", "% Decline from peak population"})
        , each Table.TransformColumnTypes(
            _
            , {
                {"2021 estimate", Int32.Type}
                , {"2020 census", Int32.Type}
                , {"Peak population", Int32.Type}
                , {"% Decline from peak population", Number.Type}
            }
        )
        , each Table.SelectColumns(
            _
            , {
                "City"
                , "State"
                , "2021 estimate"
                , "2020 census"
                , "Peak population"
                , "% Decline from peak population"
                , "Notes"
            }
        )
    }
)

let
    RawData                = #"Wiki list of US cities by population"{7}[Data]
    , ColNames             = Table.ColumnNames(RawData)
    , YearEstimatePopCol   = ColNames{2}
    , LastCensusYearPopCol = ColNames{3}
in
    fn_pipe(
        RawData,
        {
            each Table.RemoveFirstN(_, 1)
            , each Table.TransformColumns(
                _
                , {
                    {YearEstimatePopCol                      , try_fn(Int32.From)}
                    , {LastCensusYearPopCol                  , try_fn(Int32.From)}
                    , {"Peak population"                     , try_fn(Int32.From)}
                    , {"Percent decline from peak population", fn_parse_percentage}
                }
            )
            , each Table.RenameColumns(_, {"Percent decline from peak population", "% Decline from peak population"})
            , each Table.TransformColumnTypes(
                _
                , {
                    {YearEstimatePopCol                , Int32.Type}
                    , {LastCensusYearPopCol            , Int32.Type}
                    , {"Peak population"               , Int32.Type}
                    , {"% Decline from peak population", Number.Type}
                }
            )
            , each Table.SelectColumns(
                _
                , {
                    "City"
                    , "State"
                    , YearEstimatePopCol
                    , LastCensusYearPopCol
                    , "Peak population"
                    , "% Decline from peak population"
                    , "Notes"
                }
            )
        }
    )

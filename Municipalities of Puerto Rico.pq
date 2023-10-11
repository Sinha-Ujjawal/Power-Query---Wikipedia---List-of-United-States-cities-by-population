let
    RawData                           = #"Wiki list of US cities by population"{5}[Data]
    , ColNames                        = Table.ColumnNames(RawData)
    , RankCol                         = ColNames{0}
    , YearEstimatePopCol              = ColNames{2}
    , LastCensusYearPopCol            = ColNames{3}
    , LastCensusYearAreaCol           = ColNames{5}
    , LastCensusYearArea2Col          = ColNames{6}
    , LastCensusYearPopDensCol        = ColNames{7}
    , LastCensusYearPopDens2Col       = ColNames{8}
    , LastCensusYear                  = Text.BeforeDelimiter(LastCensusYearPopCol, " ")
    , LastCensusYearAreaColRename     = Text.Combine({LastCensusYear, " land area (sq mi)"})
    , LastCensusYearArea2ColRename    = Text.Combine({LastCensusYear, " land area (sq km)"})
    , LastCensusYearPopDensColRename  = Text.Combine({LastCensusYear, " population density (per sq mi)"})
    , LastCensusYearPopDens2ColRename = Text.Combine({LastCensusYear, " population density (per sq km)"})
in
    fn_pipe(
        RawData,
        {
            each _
            , each Table.TransformColumns(
                _
                , {
                    {YearEstimatePopCol         , try_fn(Int32.From)}
                    , {LastCensusYearPopCol     , try_fn(Int32.From)}
                    , {"Change"                 , fn_parse_percentage}
                    , {LastCensusYearAreaCol    , each fn_pipe(_, {each fn_remove_strings(_, {"sq", "mi"}), try_fn(Number.FromText)})}
                    , {LastCensusYearArea2Col   , each fn_pipe(_, {each fn_remove_strings(_, {"km"}), try_fn(Number.FromText)})}
                    , {LastCensusYearPopDensCol , each fn_pipe(_, {each fn_remove_strings(_, {"/", "sq", "mi"}), try_fn(Number.FromText)})}
                    , {LastCensusYearPopDens2Col, each fn_pipe(_, {each fn_remove_strings(_, {"/", "km"}), try_fn(Number.FromText)})}
                    , {"Location"               , each Text.Select(Text.Split(_, " / "){1}, {"A".."Z", "a".."z", "0".."9", "-", " ", ".", "°"})}
                }
            )
            , each Table.AddColumn(_, "LatLong", each fn_parse_latlong(_[Location]))
            , each Table.AddColumn(_, "Latitude", each _[LatLong]{0})
            , each Table.AddColumn(_, "Longitude", each _[LatLong]{1})
            , each Table.RemoveColumns(_, {"Location", "LatLong"})
            , each Table.RenameColumns(
                _
                , {
                    {"Change"                   , "% Change"}
                    , {LastCensusYearAreaCol    , LastCensusYearAreaColRename}
                    , {LastCensusYearArea2Col   , LastCensusYearArea2ColRename}
                    , {LastCensusYearPopDensCol , LastCensusYearPopDensColRename}
                    , {LastCensusYearPopDens2Col, LastCensusYearPopDens2ColRename}
                }
            )
            , each Table.TransformColumnTypes(
                _
                , {
                    {YearEstimatePopCol               , Int32.Type}
                    , {LastCensusYearPopCol           , Int32.Type}
                    , {"% Change"                     , Number.Type}
                    , {LastCensusYearAreaColRename    , Number.Type}
                    , {LastCensusYearArea2ColRename   , Number.Type}
                    , {LastCensusYearPopDensColRename , Number.Type}
                    , {LastCensusYearPopDens2ColRename, Number.Type}
                    , {"Latitude"                     , Number.Type}
                    , {"Longitude"                    , Number.Type}
                }
            )
            , each Table.SelectColumns(
                _
                , {
                    RankCol
                    , "Municipio"
                    , YearEstimatePopCol
                    , LastCensusYearPopCol
                    , "% Change"
                    , LastCensusYearAreaColRename
                    , LastCensusYearArea2ColRename
                    , LastCensusYearPopDensColRename
                    , LastCensusYearPopDens2ColRename
                    , "Latitude"
                    , "Longitude"
                }
            )
        }
    )

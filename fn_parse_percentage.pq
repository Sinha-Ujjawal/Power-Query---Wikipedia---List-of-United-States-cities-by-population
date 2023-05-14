(s) => fn_pipe(
    s
    , {
        each Text.Remove(_, {"+", "%"})
        , each Text.Replace(_, "−", "-")
        , try_fn(Number.FromText)
    }
)

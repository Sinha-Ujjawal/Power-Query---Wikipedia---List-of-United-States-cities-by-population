(initial_data, fns as list) =>
    List.Accumulate(fns, initial_data, (d, fn) => fn(d))

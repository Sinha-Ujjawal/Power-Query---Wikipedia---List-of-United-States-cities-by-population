(string as text, removal_strings as list) =>
    List.Accumulate(removal_strings, string, (s, rs) => Text.Replace(s, rs, ""))

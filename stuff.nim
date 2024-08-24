proc ssplit(str: string): seq[string] =
    var skip = false
    var line: seq[string]
    for index, char in pairs(str):
        if skip == true:
            skip = false
            continue
        if char == '\\':
            line.add($str[index + 1])
            skip = true
        else:
            line.add($char)
    return line
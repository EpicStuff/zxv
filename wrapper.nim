#[
    this is a "compiler" for my custom language which I am calling zxc for now
    it's basically nim but with a few styles changes to match my preference

    Changes:
        - indents are with tabs instead of spaces (the objectively superior method) not that they matter anymore, see below
        - single quotes and double quotes are swapped so ' for string and " for characters
        - replaces the indentation system a bracket system to avoid the "formatting is my syntax" issue

    Bracket system: (i think theres an official name for this)
        - basically just the normal
        ```if stuff {
            do something
        } else {
            do other stuff
        }``` 
        system but `{` is replace with `:` (like normal, but) and `}` is replace with `;`
        - proper indentation with tabs is still recommended

    To Do:
        - make it so that `.` gets replaced by `;` so you can do multiple statements on the same line
        - make sure quote processing works under all situations

    Notes (to self):
        - ' = string
        - " = char
]#

import os, strutils, std/strformat, macros

# constants
const indentation = "\t"

# get command line parameters
var params = commandLineParams()

# loop through command line parameters for first argument that doesn't start with `-`
# var file: string
# for num, param in params:
#     if param[0] != '-':
#         file = param
#         params.delete(num)
#         break

var file = "test.zxc"

# load the code
var code = readFile(file)

# # find unused placeholder
# var placeholder: string
# const placeholders = ['“', '”']
# for placeholder in placeholders:
#     if placeholder not in code:
#         break
# else:
#     raise newException(ValueError, 'No unused placeholder found')

# remove trailing whitespace
var old_code = code
while true:
    code = code.replace(" \n", "\n")
    if code == old_code:
        break
    old_code = code


var debug = 0
proc test(i: int, v: string) = 
    echo fmt"{i}, {v}"
    debug += 1


# deal with indentation
var indent = 0
var comment = 0
var in_str = false

var lines = splitLines(code)
for num, line in pairs(lines):
    # skip empty lines
    if line == "":
        continue
    ## deal with comments
    # skip comments (if line, ignoring indentation starts with #)
    if line.replace(indentation, "")[0] == '#':
        continue
    # check if is start of multiline comment (if line, ignoring indentation starts with #[)
    if line.replace(indentation, "")[0..1] == "#[":
        comment += 1
    # check if is end of multiline comment
    if line[^2..^1] == "#]" and comment > 0:
        comment -= 1
    # if is in a comment block
    if comment > 0:
        continue

    ## deal with multiline strings
    # to do

    ## if not in a comment/string block
    # get rid of indentation
    lines[num] = strip(line)
    # go character by character
    for index, char in pairs(line):
        ## swap quotes
        # dealing with characters
        # if not in a string/char and encounter `"`
        if not in_str:
            if char == '"':
                while true:
                    test(112, lines[num])
                    # if is "\""
                    try:
                        if lines[num][index..index+4] == "\"\\\"\"":
                            # replace with '\''
                            lines[num] = lines[num][0..index-1] & "'\''" & lines[num][index+5..^1]
                            break
                    except IndexDefect:
                        discard;
                    # if is """
                    try:
                        if lines[num][index..index+3] == "\"\"\"":
                            test(124, lines[num])
                            # replace """ with '''
                            lines[num] = lines[num][0..index-1] & "'\''" & lines[num][index+3..^1]
                            break
                    except IndexDefect:
                        discard;
                    # if is ""
                    try:
                        if lines[num][index..index+2] == "\"\"":
                            raise newException(ValueError,
                                    fmt"empty char detected (and is not allowed), lines[num]: {num + 1}, char: {index + 1}")
                    except IndexDefect:
                        discard;
                        # replace " with '
                        lines[num] = lines[num][0..index-1] & "'" & lines[num][index+1..^1]
                        break

        # dealing with strings
            test(142, lines[num])
            if char == '\'':
                echo char
                echo lines[num][0..index-2]
                lines[num] = lines[num][0..index-2] & "\"" & lines[num][index..^1]
                test(145, lines[num])
                in_str = true
        else:
            test(148, lines[num])
            # if " in a string, escape it
            if char == '"':
                lines[num] = lines[num][0..index-1] & '\"' & lines[num][index+1..^1]
            if char == '\'' and lines[num][index-1] != '\\':
                try:
                    lines[num] = lines[num][0..index-2] & '\"' & lines[num][index..^1]
                except RangeDefect:
                    lines[num] = lines[num][0..index-2] & '\"'
                in_str = false
        test(155, lines[num])

    ## deal with indentation
    test(158, lines[num])
    lines[num] = repeat("  ", indent) & lines[num]
    if lines[num][^1] == ':':
        indent += 1
    elif lines[num][^1] == ';':
        indent -= 1

# save the code
echo lines.join("\n")
writeFile(file.replace(".zxc", ".nim"), lines.join("\n"))

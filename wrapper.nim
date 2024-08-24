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

import os, strutils, std/strformat, strslice, std/sequtils

# get command line parameters
var params = commandLineParams()

# loop through command line parameters for first argument that doesn't start with `-`
var file: string
for num, param in params:
    if param[0] != '-':
        file = param
        params.delete(num)
        break

# var file = "test.zxc"

# load the code
var code = readFile(file)

# remove trailing whitespace
var old_code = code
while true:
    code = code.replace(" \n", "\n")
    if code == old_code:
        break
    old_code = code


# deal with indentation
var indent = 0
var comment = 0
var in_str = false

var lines = splitLines(code)
for num, lIne in pairs(lines):
    var line = map(strip(lIne), proc(c: char): string = $c)
    # skip empty lines
    if line == @[]:
        continue
    ## deal with comments
    # skip comments (if line, ignoring indentation starts with #)
    # check if is start of multiline comment (if line, ignoring indentation starts with #[)
    if line[0..1].join() == "#[":
        comment += 1
    # check if is end of multiline comment
    if line[^2..^1].join() == "#]" and comment > 0:
        comment -= 1
    if line[0] == "#":
        continue
    # if is in a comment block
    if comment > 0:
        continue

    ## deal with multiline strings
    # to do
    echo fmt"{num}, {comment}"
    ## if not in a comment/string block
    # go character by character
    for index, char in pairs(line):
        ## swap quotes
        # dealing with characters
        # if not in a string/char and encounter `"`
        if not in_str:
            if char == "\"":
                while true:
                    # if is "\""
                    try:
                        if line[index..index+4] == ["\"", "\\", "\"", "\""]:
                            # replace with '\''
                            line[index] = "'\\''"
                            line[index + 1] = ""
                            line[index + 2] = ""
                            line[index + 3] = ""
                            line[index + 4] = ""
                            break
                    except IndexDefect:
                        discard;

                    try:
                        if line[index..index+3] == ["\"", "\"", "\""]:
                            # replace with '\''
                            line[index] = "'\\''"
                            line[index + 1] = ""
                            line[index + 2] = ""
                            line[index + 3] = ""
                    except IndexDefect:
                        discard;
                    # if is ""
                    try:
                        if line[index..index+2] == ["\"", "\""]:
                            raise newException(ValueError, fmt"empty char detected (and is not allowed), lines[num]: {num + 1}, char: {index + 1}")
                    except IndexDefect:
                        discard;
                    # replace " with '
                    line[index] = "'"
                    break

        # dealing with strings
            
            if char == "'":
                line[index] = "\""
                in_str = true
        else:
            # if " in a string, escape it
            if char == "\"":
                line[index] = "\\\""
            if char == "'" and line[index-1] != "\\":
                line[index] = "\""
                in_str = false
        

    ## deal with indentation
    line[0] = repeat("    ", indent) & line[0]
    if line[^1] == ":":
        indent += 1
    for index in countdown(line.len - 1, 0):
        if line[index] == ";":
            line[^1] = ""
            indent -= 1;
        else:
            break;

    lines[num] = line.join()

# save the code
writeFile(file.replace(".zxc", ".nim"), lines.join("\n"))

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
        - handle unesseary escape characters, eg. '\'' -> "'"
        - add support for functions
        - create a readme

    Notes (to self):
        - ' = string
        - " = char

    Future plans:
        - auto replace camalcase with underscores
        - add recursion so that you can import/include .zxc files
        - create/fork (vscode) linter/formatter
]#

import os, strutils, std/strformat, strslice, std/sequtils
include stuff

# get command line parameters
var params = commandLineParams()

# # loop through command line parameters for first argument that doesn't start with `-`
# var file: string
# for num, param in params:
#     if param[0] != '-':
#         file = param
#         params.delete(num)
#         break

var file = "test.zxc"

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
    # split string into list of 1 long strings, unless escape character
    var line = ssplit(lIne)
    # skip empty lines
    if line == @[]:
        continue
    ## deal with comments
    # check if is start of multiline comment (if line, ignoring indentation starts with #[)
    if line[0..1].join() == "#[":
        comment += 1
    # check if is end of multiline comment
    if line[^2..^1].join() == "]#" and comment > 0:
        comment -= 1
    # if is in a comment block, skip
    if comment > 0:
        continue
    if line[0] == "#":
        #lines[num] = "  "
        continue

    ## deal with multiline strings
    # to do

    ## if not in a comment/string block
    # go character by character
    for index, char_group in pairs(line):
        ## swap quotes
        # dealing with characters
        # if not in a string/char and encounter `"`
        if not in_str:
            if char_group == "\"":
                block a:
                    # if is "\"" or """
                    try:
                        if char_group =="\"\\\"\"" or char_group == "\"\"\"":
                            # replace with '\''
                            line[index] = "'\\''"
                            break a
                    except IndexDefect:
                        discard
                    # elif is ""
                    try:
                        if char_group == "\"\"":
                            raise newException(ValueError, fmt"empty char detected (and is not allowed), lines[num]: {num + 1}, char: {index + 1}")
                    except IndexDefect:
                        discard
                    # replace " with '
                    line[index] = "'"

        # dealing with strings
            # if not in string and encounter ', replace with " and enter string
            if char == "'":
                line[index] = "\""
                in_str = true
        else:
            # if " in a string, escape it
            if char == "\"":
                line[index] = "\\\""
            # if ' in a string and is not escaped, swap it and exit string
            if char_group == "'":
                line[index] = "\""
                in_str = false
        

    ## deal with indentation
    line[0] = repeat("    ", indent) & line[0]
    if line[^1] == ":":
        indent += 1
    for index in countdown(line.len - 1, 0):
        if line[index] == ";":
            line[index] = ""
            indent -= 1;
        else:
            break

    lines[num] = line.join()

# save the code
writeFile(file.replace(".zxc", ".nim"), lines.join("\n"))

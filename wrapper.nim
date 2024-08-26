#[
    this is a "compiler" for my custom language which I am calling zxc for now
    it's basically nim but with a few styles changes to match my preference

    Changes:
        - indents are with tabs instead of spaces (the objectively superior method) not that they matter anymore, see below
        - single quotes and double quotes are swapped so ' for string and " for characters
        - replaces the indentation system a bracket system to avoid the "formatting is my syntax" issue

    Bracket system: (i think theres an official name for this)
        - basically just the normal
        ```
        if stuff {
            do something
        } else {
            do other stuff
        }
        ```
        system but `{` is replace with `:` (like normal, but) and `}` is replace with `;`
        - proper indentation with tabs is still recommended

    Notes (to self):
        - ' = string
        - " = char
]#

import os, strutils, std/strformat, strslice
include stuff

const indentation = "  "

# get command line parameters
var params = commandLineParams()

# loop through command line parameters for first argument that doesn't start with `-`
var file: string
for num, param in params:
    if param[0] != '-':
        file = param
        params.delete(num)
        break

# load the code
var code = readFile(file)

# remove trailing whitespace
var old_code = code
while true:
    code = code.replace(" \n", "\n")
    code = code.replace("\t\n", "\n")
    if code == old_code:
        break
    old_code = code

# deal with indentation
var indent = 0
var comment = 0
var in_char = false
var in_str = false

var lines = splitLines(code)
for num, lIne in pairs(lines):
    debugEcho "checking line: ", num
    # split string into list of 1 long strings, unless escape character
    var line = ssplit(strip(lIne))
    # skip empty lines
    if line == @[]:
        continue
    ## deal with comments
    #debugEcho 'line starts with: ', line[0], 'comment: ', comment
    # check if is start of multiline comment (if line, ignoring indentation starts with #[)
    if line[0] == "#[":
        comment += 1
    # check if is end of multiline comment
    if line[^1] == "]#" and comment > 0:
        comment -= 1
    # if is in a comment block or is a normal line comment, skip
    if comment > 0 or line[0] == "#":
        lines[num] = lines[num].replace("\t", indentation)
        continue

    ## deal with multiline strings
    # to do

    ## if not in a comment/string block
    # go character by character
    for index, char_group in pairs(line):
        debugEcho "\tchecking ", index, "th char group: ", char_group, "\t\t\t", "indent: ", indent, ",\tcomment: ", comment, ",\tin char: ", in_char, ",\tin str: ", in_str
        ## swap quotes
        # dealing with characters
        if in_char:
            if char_group == "'":
                line[index] = "\\'"
            in_char = false
            continue
        # if not in a string/char and encounter `"`
        if not in_str:
            if char_group == "\"":
                block a:
                    # if is "\"" or """
                    try:
                        if char_group == "\"\\\"\"" or char_group == "\"\"\"":
                            # replace with '\''
                            line[index] = "'\\''"
                            break a
                    except IndexDefect:
                        discard
                    # elif is ""
                    try:
                        if char_group == "\"\"":
                            raise newException(ValueError, fmt"empty char detected (and is not allowed), line: {num + 1}, char: {index + 1}")
                    except IndexDefect:
                        discard
                    # else, replace " with '
                    line[index] = "'"
                    in_char = true
        # dealing with strings
            # if not in string and encounter ', replace with " and enter string
            if char_group == "'":
                line[index] = "\""
                in_str = true
        else:
            # if " in string, escape it
            if char_group == "\"":
                line[index] = "\\\""
            # if """ in string, escape it (\"\"\")
            elif char_group == "\"\"\"":
                line[index] = "\\\"\\\"\\\""
            # if "\"" in string, escape it (\"\\\"\")
            elif char_group == "\"\\\"\"":
                line[index] = "\\\"\\\\\\\"\\\""
            # if \' in string, remove unesseary escape
            elif char_group == "\\'":
                line[index] = "'"

            # if ' in a string and is not escaped, swap and escape it, and exit string
            if char_group == "'":
                line[index] = "\""
                in_str = false

    ## deal with indentation
    line[0] = repeat(indentation, indent) & line[0]
    if line[^1] == ":" or line[^1] == "=":
        indent += 1
    for index in countdown(line.len - 1, 0):
        if line[index] == ";":
            line[index] = ""
            indent -= 1
        else:
            break
    lines[num] = line.join()

# save the code
writeFile(file.replace(".zxc", ".nim"), lines.join("\n"))

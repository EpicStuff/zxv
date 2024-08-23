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

import os, strutils, std/strformat

# constants
const indentation = "\t"

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
				# if is "\""
                if line[index..index+4] == "\"\\\"\"":
                    # replace with '\''
                    lines[num] = line[0..index-1] & "'\''" & line[index+5..^1]
                # if is """
                elif line[index..index+3] == "\"\"\"":
                    echo line
                    # replace """ with '''
                    lines[num] = line[0..index-1] & "'\''" & line[index+3..^1]
                # is not """
                elif line[index..index+2] == "\"\"":
                    raise newException(ValueError, fmt"empty char detected (and is not allowed), line: {num + 1}, char: {index + 1}")
				else:
                    # replace " with '
                    lines[num] = line[0..index-1] & "'" & line[index+1..^1]

        # dealing with strings
            if char == '\'':
                lines[num] = line[0..index-1] & "\"" & line[index+1..^1]
                in_str = true
        else:
            # if " in a string, escape it
            if char == '"':
                lines[num] = line[0..index-1] & '\"' & line[index+1..^1]
            if char == '\'' and line[index-1] != '\\':
                lines[num] = line[0..index-1] & '\"' & line[index+1..^1]
                in_str = false

    ## deal with indentation
    lines[num] = repeat("  ", indent) & line
    if line[^1] == ':':
        indent += 1
    elif line[^1] == ';':
        indent -= 1

# save the code
writeFile(file.replace(".zxc", ".nim"), code.join("\n"))

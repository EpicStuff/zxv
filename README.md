# ZXV
zxv, (prodounced tim) is [Nim](https://github.com/nim-lang/Nim) but with a few syntax changes to match my prefrences. (the name is still under "development")

## Introduction
I only recently stumbled across Nim and was like lets give this a try, only to find "Tabs are forbidden in Nim to enforce a consistent coding style and eliminate potential issues related to mixed indentation." which is almost as much bullshit as yaml's "Tabs have been outlawed since they are treated differently by different editors and tools. And since indentation is so critical to proper interpretation of YAML, this issue is just too tricky to even attempt." Afterall, Tabs are objectivly the superior indentation method. So I made this to make Nim work with tabs, and while I was at it, I went a bit overboard and made a few other changes.

## Changes:
- indents are with tabs instead of spaces (the objectively superior method) not that they matter anymore, see below
- replaces the indentation system a bracket system to avoid the "formatting is my syntax" issue that python has
- single quotes and double quotes can both be used to indicated a string, prepend a `c` for character (like with `&`) and stuff (see details)

### Bracket System: (i think theres an official name for this)
- basically just the normal
```
if stuff {
	do something
	some more code
} else {
	do other stuff
}
``` 
system but `{` is replace with `:` (like normal, but) and `}` is replace with `;` so it becomes
```
if stuff:
	do something
	some more code
;
else:
	do other stuff
;
``` 
- proper indentation with tabs is still recommended but not required
- not super sure about this idea, might just make this optional

### Quotes:
- `"this is a string"`, `'this is also a string'`, `c"a"` or `c'a'` for character 
- theres some fancy auto escaping stuff going on for nested quotes in strings that I don't quite remember

## Usage
- basic usage: `./zxc c|compile filename.zxv`
- `./zxc -h|--help` for other commands

## zxv Formmating Conventions
- still under development
- `# comment` for comments, `#code` for commented out code 

## Compiling

### The Easy Way

Download the latest binary and use that to "compile" all the `.zxv` files

### The Hard Way

1. `git checkout v1.0.2`
	- `cp wrapper.zxc wrapper.nim` and `cp stuff.zxc stuff.nim`
	- a) get rid of all `;` except for the one on wrapper line 146 (regex: `(?<!');` -> ``)
	- b) replace all tabs with 2 spaces (regex: `\t` -> `  `)
	- c) replace all `"` with `\"` (regex: `"` -> `\"`)
	- d) replace all not escaped `'` with " (regex: `(?<!\\)'` -> `"`)
	- e) replace `\"=\"` -> `'-'` (wrapper line 38) and `\"*\"` -> `'*'` (stuff line 25) (not regex)
	- f) fix indentation on line 79 (dedent twice)
	- `nim c wrapper`
2. `git checkout v1.0.3`, `./wrapper src/stuff.zxv && ./wrapper src/wrapper.zxv`, `nim c src/wrapper`
3. `git checkout v1.0.4`, `mkdir build/`, `cd src/`, `./wrapper wrapper.zxv`, `cd ..`, `nim c build/wrapper`
4. `git checkout v1.1.0`, `./build/wrapper src/utils.zxv && ./build/wrapper src/main.zxv && ./build/wrapper src/zdocopt.zxv -c`

## To Do:
- make it so that `.` (or another symbol) gets replaced by `;` so you can do multiple statements on the same line (i think thats a thing in Nim)
- add support for `##[`, `]##`, and `#?`
- make it (default, optionaly) compile straight to binary instead of to nim
- make it work for `type` (current workaround, add `#:` to end of line)
- add auto semi colon feature (adds semicolons based on indentation)
- finished Quotes section of the readme
- warn/fail on bracket miss match
- add f command to format zxv file to proper indentation (based on : and ;)

## Future Plans:
- add recursion so that you can import/include .zxv files
- create/fork (vscode) linter/formatter
	- make it suggest the snake case version instead of camelCase
- add fancy support for indents in multiline strings where the tabs dont end up getting "parsed" (if nim doesn't do this allready)
- forbid indentation with spaces
- future future plan: add support for reusing variables, unless I can find good reason why nim doesn't allow this
- maybe add support for aligning lines using spaces (eg. 
```
x = a,
	b,
```
)

## Stuff
- i'd love any contributions (as long as matches my views on what the "correct" programming formmating is)
- [Anti Commercial-AI license Thingy](https://creativecommons.org/licenses/by-nc-sa/4.0/)

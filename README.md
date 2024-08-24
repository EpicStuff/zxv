# ZXC
zxc, (prodounced zim) is [Nim](https://github.com/nim-lang/Nim) but with a few syntax changes to match my prefrences. (The name is temporary)

## Introduction
I only recently stumbled across Nim and was like lets give this a try, only to find "Tabs are forbidden in Nim to enforce a consistent coding style and eliminate potential issues related to mixed indentation." which is almost as much bullshit as yaml's "Tabs have been outlawed since they are treated differently by different editors and tools. And since indentation is so critical to proper interpretation of YAML, this issue is just too tricky to even attempt." Afterall, Tabs are objectivly the superior indentation method. So I made this to make Nim work with tabs, and while I was at it, I went a bit overboard and made a few other changes.

## Changes:
- indents are with tabs instead of spaces (the objectively superior method) not that they matter anymore, see below
- replaces the indentation system a bracket system to avoid the "formatting is my syntax" issue that python has
- single quotes and double quotes are swapped so ' for string and " for characters

## Bracket system: (i think theres an official name for this)
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
	some more code;
else:
	do other stuff;
``` 
- proper indentation with tabs is still recommended

## To Do:
- make it so that `.` (or another symbol) gets replaced by `;` so you can do multiple statements on the same line (i think thats a thing in Nim)
- add support for ##[, ]##, and #?
- make it (default, optionaly) compile straight to binary instead of to nim

## Future plans:
- add recursion so that you can import/include .zxc files
- create/fork (vscode) linter/formatter
	- make it suggest the snake case version instead of camelcase
- add fancy support for indents in multiline strings where the tabs dont end up getting "parsed" (if nim doesnt do this allready)
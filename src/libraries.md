argparse requirments:
- commands:
	- command alias
		- invalidates argparse
	- per command help
	- per command flags
- help:
	- `zxv` should print full help
	- `zxv wrong command` should print only usage
	- `zxv c -h` prints help for only c
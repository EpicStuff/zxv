import sys
from epicstuff import rich_try
from docopt import docopt

doc_main = '''
	zxv
	a basic desc of zxv.

	Usage:
		zxv <command> [<args>...]
		zxv -h, --help
		zxv --version

	Commands:
		format, f   [-v] <input> [-o <output>]
		compile, c  [-v] [-t <folder>] <input> [-o <output>] -- [<args>...]
		run, r      [-v] [-t <folder>] <input> [-o <output>] -- [<args>...]
		convert, C  [-v] [-f <format>] [-t <folder>] <input> [-o <output>] -- [<args>...]

	Options:
		-h, --help                 Show this.
		--version                  Show version.
		-v, --verbose              Enable verbose output.
		-o <output>                Specify output file.
		-t, --tmp_folder <folder>  Specify temporary folder. [default: {temp}]
		-f, --format <format>      Specify output format. [default: nim]

		Arguments after -- are passed onto nim.
'''

doc_format = '''
	format zxv input

	Usage:
		zxv {command} [-v] <input> [-o <output>]
		zxv {command} -h, --help    Show extended help.

	Options:
		-h, --help         Show this.
		-v, --verbose      Enable verbose output.
		-o <output>        Specify output file.
'''
doc_compile = '''
	compile input

	Usage:
		zxv {command} [-v] [-t <folder>] <input> [-o <output>] -- [<args>...]
		zxv {command} -h, --help    Show extended help.

	Options:
		-h, --help         Show this.
		-v, --verbose      Enable verbose output.
		-o <output>       Specify output file.
		-t, --tmp_folder <folder>  Specify temporary folder. [default: {temp}]

		Arguments after -- are passed onto nim.
'''
doc_run = '''
	compile to tmp folder then run input

	Usage:
		zxv {command} [-v] [-t <folder>] <input> [-o <output>] -- [<args>...]
		zxv {command} -h, --help    Show extended help.

	Options:
		-h, --help         Show this.
		-v, --verbose      Enable verbose output.
		-o <output>       Specify output file.
		-t, --tmp_folder <folder>  Specify temporary folder. [default: {temp}]

		Arguments after -- are passed onto nim.
'''
doc_convert = '''
	convert input to another format

	Usage:
		zxv {command} [-v] [--format=<format>] [--tmp_folder=<folder>] <input> [-o <output>] -- [<args>...]
		zxv {command} -h, --help

	Options:
		-h, --help                 Show this.
		-v, --verbose              Enable verbose output.
		-o <output>                Specify output file.
		-f, --format <format>      Specify output format. [default: nim]
		-t, --tmp_folder <folder>  Specify temporary folder. [default: {temp}]

		Arguments after -- are passed onto nim.
'''
# doc_convert = '''
# 	convert input to another format

# 	Usage:
# 		zxv C [-v] [--format=<format>] <input>
# 		zxv C -h, --help    Show extended help.

# 	Options:
# 		-h, --help                 Show this.
# 		-v, --verbose              Enable verbose output.
# 		-o <output>                Specify output file.
# 		-f, --format <format>      Specify output format. [default: nim]
# 		-t, --tmp_folder <folder>  Specify temporary folder. [default: {temp}]

# 		Arguments after -- are passed onto nim.
# '''

temp = 'tmp folder location'

args = {'<command>': None}

with rich_try():
	# try:
	args = docopt(doc_main.format(temp=temp), version='zxv 0.1.0', options_first=True)
	print(args)
	# except SystemExit:
	# 	pass

command = args['<command>']

if command in ['compile', 'c']:
	with rich_try():
		# try:
		args_compile = docopt(doc_compile.format(command=command, temp=temp))
		print(args_compile)
		# except SystemExit:
		# 	pass
elif command in ['convert', 'C']:
	with rich_try():
		# try:
		print(sys.argv)
		argv = sys.argv
		argv[0] = 'zxv'
		args_convert = docopt(doc_convert.format(command=command, temp=temp))
		print(args_convert)
		# except SystemExit:
		# 	pass

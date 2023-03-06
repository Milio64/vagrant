#!/usr/bin/env python3
#
# Execute a shell command after a delay time.
#  arg[1] is delay time in seconds
#
import sys, subprocess, time
#CHEAP_LOG_FILE = '/tmp/' + __file__ + '.log'
CHEAP_LOG_FILE = __file__ + '.log'


args = sys.argv
if not sys.stdout.isatty():
    sys.stdout = open(CHEAP_LOG_FILE, 'w')  # cheap log output
    sys.stderr = sys.stdout
cmd = args.pop(0)
try:
    delay = float(args.pop(0))
    if not args:  # only an empty list remaining?
        raise ValueError
except (ValueError, IndexError):
    print('Usage: {} seconds_to_delay command and args to run'.format(cmd))
    sys.exit(1)
print('sleeping {} seconds...'.format(delay))
time.sleep(delay)
print(time.asctime())
print('Running command: {}'.format(' '.join(args)))
print('- - - - - - - - - - - - - - -')
sys.stdout.flush()
try:
    subprocess.run(' '.join(args), shell=True, check=True, stdout=sys.stdout, stderr=subprocess.STDOUT)
except subprocess.CalledProcessError as e:
    print(e)
    
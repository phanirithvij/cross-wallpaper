import subprocess
from sys import platform
import sys

path = sys.argv[1]

if platform == 'win32':
    subprocess.Popen(fr'explorer /select,"{path}"')

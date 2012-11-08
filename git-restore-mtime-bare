#!/usr/bin/env python
# Change mtime of files based on commit date of last change
# Bare-bones version. Current dir must be top-level of work tree.
# Usage: git-restore-mtime-bare [pathspecs...]
#
# By default update all files
# Example: to only update only the README and files in ./doc:
# git-restore-mtime-bare README doc

import subprocess, shlex
import sys, os.path

# List files matching user pathspec, relative to current directory
filelist = set()
for path in (sys.argv[1:] or [os.path.curdir]):

    # file or symlink (to file, to dir or broken - git handles the same way)
    if os.path.isfile(path) or os.path.islink(path):
        filelist.add(os.path.relpath(path))

    # dir
    elif os.path.isdir(path):
        for root, subdirs, files in os.walk(path):
            if '.git' in subdirs:
                subdirs.remove('.git')

            for file in files:
                filelist.add(os.path.relpath(os.path.join(root, file)))

# Process the log until all files are 'touched'
mtime = 0
gitobj = subprocess.Popen(shlex.split('git whatchanged --pretty=%at'),
                          stdout=subprocess.PIPE)
for line in gitobj.stdout:
    line = line.strip()

    # Blank line between Date and list of files
    if not line: continue

    # File line
    if line.startswith(':'):
        file = line.split('\t')[-1]
        if file in filelist:
            filelist.remove(file)
            #print mtime, file
            os.utime(file, (mtime, mtime))

    # Date line
    else:
        mtime = long(line)

    # All files done?
    if not filelist:
        break
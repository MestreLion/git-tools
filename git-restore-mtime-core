#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# git-restore-mtime - Change mtime of files based on commit date of last change
#
#    Copyright (C) 2012 Rodrigo Silva (MestreLion) <linux@rodrigosilva.com>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program. See <http://www.gnu.org/licenses/gpl.html>
#
# Stripped-down version: no fancy options or statistics. Just the core!
#
# Only works from inside the work tree. Assumes git dir is "<toplevel>/.git"

import subprocess, shlex
import sys, os.path
import logging as logger
import argparse
import time

parser = argparse.ArgumentParser(
    description='Restore original modification time of files based on '
                'the date of the most recent commit that modified them. '
                'Useful when generating release tarballs. '
                'Current directory must be inside work tree')

parser.add_argument('--verbose', '-v',
                    action="store_true",
                    help='print warnings and debug info for each processed file. ')

parser.add_argument('--merge', '-m',
                    action="store_true",
                    help='include merge commits.')

parser.add_argument('pathspec',
                    nargs='*', default=[os.path.curdir],
                    help='only modify paths (dirs or files) matching PATHSPEC, '
                        'absolute or relative to current directory. '
                        'Default is current directory')

args = parser.parse_args()
logger.basicConfig(level=logger.DEBUG if args.verbose else logger.ERROR,
                   format='%(levelname)s:\t%(message)s')


# Find repo's top level.
try:
    workdir = os.path.abspath(subprocess.check_output(shlex.split(
                    'git rev-parse --show-toplevel')).strip())
except subprocess.CalledProcessError as e:
    sys.exit(e.returncode)


# List files matching user pathspec, relative to current directory
# git commands always print paths relative to work tree root
filelist = set()
for path in args.pathspec:

    # file or symlink (to file, to dir or broken - git handles the same way)
    if os.path.isfile(path) or os.path.islink(path):
        filelist.add(os.path.relpath(path, workdir))

    # dir
    elif os.path.isdir(path):
        for root, subdirs, files in os.walk(path):
            if '.git' in subdirs:
                subdirs.remove('.git')

            for file in files:
                filelist.add(os.path.relpath(os.path.join(root, file), workdir))


# Process the log until all files are 'touched'
def parselog(merge=False, filterlist=[]):
    gitobj = subprocess.Popen(shlex.split('git whatchanged --pretty=%at') +
                              (['-m'] if merge else []) + filterlist,
                              stdout=subprocess.PIPE)
    mtime = 0
    for line in gitobj.stdout:
        line = line.strip()

        # Blank line between Date and list of files
        if not line: continue

        # File line
        if line.startswith(':'):
            file = os.path.normpath(line.split('\t')[-1])
            if file in filelist:
                logger.debug("%s\t%s", time.ctime(mtime), file)
                filelist.remove(file)
                try:
                    os.utime(os.path.join(workdir, file), (mtime, mtime))
                except Exception as e:
                    logger.error("%s\n", e)

        # Date line
        else:
            mtime = long(line)

        # All files done?
        if not filelist:
            break

parselog(args.merge)


# Missing files
if filelist and not args.merge:
    filterlist = list(filelist)
    for i in range(0, len(filterlist), 100):
        parselog(merge=True, filterlist=filterlist[i:i+100])

# Still missing some?
for file in filelist:
    logger.warn("not found in log: %s", file)

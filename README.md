Git Tools
=========

Assorted git-related scripts and tools


Requirements
------------

- **Git** (duh!). Tested in v1.7.9.5 and prior versions since 2010
- **Python** (for `git-restore-mtime`). Tested in Python 2.7.4, also works in Python 3
- **Bash** (for all other tools). Tested in Bash 4, some may work in Bash 3 or even `sh`

Bash and Python are already installed by default in virtually all GNU/Linux distros. And you probably already have Git if you are interested in these tools. But if somehow you don't, the command to install dependencies for Debian-like distros (like Ubuntu/Mint) is:

`sudo apt-get bash python git`

Install
-------

Just clone the repository and add the install directory to your `$PATH`

	cd ~/some/dir
	git clone https://github.com/MestreLion/git-tools.git
	echo 'PATH=$PATH:~/some/dir/git-tools' >> ~/.profile  # or ~/.bashrc


Uninstall
---------

Just delete the directory! And, optionally, remove it from your `$PATH`

	rm -rf ~/some/dir/git-tools
	sed -i '/git-tools/d' ~/.profile

---

Tools
=====

This is a brief description of the tools. For more detailed instructions, see `--help` of each tool.

git-branches-rename
-------------------

*Batch renames branches with a matching prefix to another prefix*

Examples:

	$ git-rename-branches bug bugfix
	bug/128  -> bugfix/128
	bug_test -> bugfix_test

	$ git-rename-branches ma backup/ma
	master -> backup/master
	main   -> backup/main


git-clone-subset
----------------

*Clones a subset of a git repository*

Uses `git clone` and `git filter-branch` to remove from the clone all files but the ones requested, along with their associated commit history.

Clones a `repository` into a `destination` directory and runs on the clone `git filter-branch --prune-empty --tree-filter 'git rm ...' -- --all` to prune from history all files except the ones matching a `pattern`, effectively creating a clone with a subset of files (and history) of the original repository.

Useful for creating a new repository out of a set of files from another repository, migrating (only) their associated history. Very similar to what `git filter-branch --subdirectory-filter` does, but for a file pattern instead of just a single directory.


git-find-uncommited-repos
-------------------------

*Recursively list repos with uncommited changes*

Recursively finds all git repositories in the given directory(es), runs `git status` on them, and prints the location of reposities with uncommited changes. The tool I definitely use the most.


git-rebase-theirs
-----------------

*Resolve rebase conflicts and failed cherry-picks by favoring 'theirs' version*

When using `git rebase`, conflicts are usually wanted to be resolved by favoring the `working branch` version (the branch being rebased, *'theirs'* side in a rebase), instead of the `upstream` version (the base branch, *'ours'* side). But `git rebase --strategy -X theirs` is only available from git 1.7.3. For older versions, `git-rebase-theirs` is the solution. And despite the name, it's also useful for fixing failed cherry-picks


git-restore-mtime
-----------------

*Restore original modification time of files based on the date of the most recent commit that modified them*

Probably the most popular and useful tool.

Git, unlike other version control systems, does not preserve the original timestamp of commited files. Whenever repositories are cloned, or branches/files are checked out, file timestamps are reset to the current date. While this behavior has its justifications (notably when using `make` to compile software), sometimes it is desirable to restore the original modification date of a file (for example, when generating release tarballs). As git does not provide any way to do that, `git-restore-mtime` tries to workaround this limitation.

For more information and background, see http://stackoverflow.com/a/13284229/624066


git-strip-merge
---------------

*A `git-merge` wrapper that delete files on a "foreign" branch before merging*

Answer for "*How to setup a git driver to ignore a folder on merge?*", see http://stackoverflow.com/questions/3111515

Example:

	$ git checkout master
	$ git-strip-merge design photoshop/*.psd

---

Contributing
------------

Patches are welcome! Fork, hack, request pull!

If you find a bug or have any enhacement request, please to open a [new issue](https://github.com/MestreLion/git-tools/issues/new)


Written by
----------

Rodrigo Silva (MestreLion) <linux@rodrigosilva.com>

Licenses and Copyright
----------------------

Copyright (C) 2012 Rodrigo Silva (MestreLion) <linux@rodrigosilva.com>.

License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.

This is free software: you are free to change and redistribute it.

There is NO WARRANTY, to the extent permitted by law.

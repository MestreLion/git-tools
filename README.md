Git Tools
=========

Assorted git-related scripts and tools


Requirements
------------

- **Git** (duh!). Tested in v2.17.1 and prior versions since 2010
- **Python** (for `git-restore-mtime`). Requires Python 3.8 or later
- **Bash** (for all other tools). Tested in Bash 4, some may work in Bash 3 or even `sh`

Bash and Python are already installed by default in virtually all GNU/Linux distros.
And you probably already have Git if you are interested in these tools.
If needed, the command to install dependencies for Debian-like distros (like Ubuntu/Mint) is:

	sudo apt install bash python3 git

Installation
------------

For [Debian](https://tracker.debian.org/pkg/git-mestrelion-tools),
[Ubuntu](https://launchpad.net/ubuntu/+source/git-mestrelion-tools),
LinuxMint, and their derivatives, in official repositories as `git-restore-mtime`:

	sudo apt install git-restore-mtime

For [Fedora](https://src.fedoraproject.org/rpms/git-tools)
and in EPEL repository for CentOS, Red Hat Enterprise Linux (RHEL), Oracle Linux and others, as root:

	dnf install git-tools  # 'yum' if using older CentOS/RHEL releases

[Gentoo](https://packages.gentoo.org/packages/dev-vcs/git-tools) and Funtoo, also as root:

	emerge dev-vcs/git-tools

Arch Linux [AUR](https://aur.archlinux.org/packages/git-tools-git):

Follow the [AUR instructions](https://wiki.archlinux.org/title/Arch_User_Repository#Installing_and_upgrading_packages) to build and install a package from the user contributed PKGBUILD or use your favorite AUR helper. Note this is a recipie for a VCS package that installs the latest Git HEAD as of the time you build the package, not the latest stable taggged version.

[Homebrew](https://formulae.brew.sh/formula/git-tools):

	brew install git-tools

[MacPorts](https://ports.macports.org/port/git-tools/details/):

	sudo port install git-tools

Also available in Kali Linux, MidnightBDS _mports_, Mageia, and possibly other distributions.

[GitHub Actions](https://github.com/marketplace/actions/git-restore-mtime): _(`git-restore-mtime` only)_
```yaml
build:
  steps:
  - uses: actions/checkout@v3
    with:
      fetch-depth: 0
  - uses: chetan/git-restore-mtime-action@v2
```

**Manual install**: to run from the repository tree, just clone and add the installation directory to your `$PATH`:
```sh
cd ~/some/dir
git clone https://github.com/MestreLion/git-tools.git
echo 'PATH=$PATH:~/some/dir/git-tools' >> ~/.profile  # or ~/.bashrc
```

To install the `man` pages, simply copy (or symlink) the files from [`man1/`](man1) folder
to `~/.local/share/man/man1`, creating the directory if necessary:
```sh
dest=${XDG_DATA_HOME:$HOME/.local/share}/man/man1
mkdir -p -- "$dest"
cp -t "$dest" -- ~/some/dir/git-tools/man1/*.1  # or `ln -s -t ...`
```


Usage
-----

If you installed using your operating system package manager, or if you added the cloned repository to your `$PATH`,
you can simply run the tools as if they were regular `git` subcommands! For example:

	git restore-mtime --test

The magic? Git considers any executable named `git-*` in either `/usr/lib/git-core` or in `$PATH` to be a subcommand!
It also integrates with `man`, triggering the manual pages if they're installed,
such as when installing using your package manager:

	git restore-mtime --help
	git help strip-merge

In case the manual pages are not installed in the system, such as when running from the cloned repository,
you can still read the built-in help by directly invoking the tool:

	git-clone-subset --help


Uninstall
---------

For the packaged versions, use your repository tools such as `apt`, `brew`, `emerge`, or `yum`.

For manual installations, delete the directory, manpages, and remove it from your `$PATH`.
```sh
rm -rf ~/some/dir/git-tools  # and optionally ~/.local/share/man/man1/git-*.1
sed -i '/git-tools/d' ~/.profile
```
---

Tools
=====

This is a brief description of the tools. For more detailed instructions, see `--help` of each tool.

git-branches-rename
-------------------

*Batch renames branches with a matching prefix to another prefix*

Examples:

```console
$ git-rename-branches bug bugfix
bug/128  -> bugfix/128
bug_test -> bugfix_test

$ git-rename-branches ma backup/ma
master -> backup/master
main   -> backup/main
```

git-clone-subset
----------------

*Clones a subset of a git repository*

Uses `git clone` and `git filter-branch` to remove from the clone all but the requested files,
along with their associated commit history.

Clones a `repository` into a `destination` directory and runs
`git filter-branch --prune-empty --tree-filter 'git rm ...' -- --all`
on the clone to prune from history all files except the ones matching a `pattern`,
effectively creating a clone with a subset of files (and history) of the original repository.

Useful for creating a new repository out of a set of files from another repository,
migrating (only) their associated history.
Very similar to what `git filter-branch --subdirectory-filter` does,
but for a file pattern instead of just a single directory.


git-find-uncommitted-repos
--------------------------

*Recursively list repos with uncommitted changes*

Recursively finds all git repositories in the given directory(es), runs `git status` on them,
and prints the location of repositories with uncommitted changes. The tool I definitely use the most.


git-rebase-theirs
-----------------

*Resolve rebase conflicts and failed cherry-picks by favoring 'theirs' version*

When using `git rebase`, conflicts are usually wanted to be resolved by favoring the `working branch` version
(the branch being rebased, *'theirs'* side in a rebase), instead of the `upstream` version
(the base branch, *'ours'* side). But `git rebase --strategy -X theirs` is only available from git 1.7.3.
For older versions, `git-rebase-theirs` is the solution.
Despite the name, it's also useful for fixing failed cherry-picks.


git-restore-mtime
-----------------

*Restore original modification time of files based on the date of the most recent commit that modified them*

Probably the most popular and useful tool, and the reason this repository was packaged into distros.

Git, unlike other version control systems, does not preserve the original timestamp of committed files.
Whenever repositories are cloned, or branches/files are checked out, file timestamps are reset to the current date.
While this behavior has its justifications (notably when using `make` to compile software),
sometimes it is desirable to restore the original modification date of a file
(for example, when generating release tarballs).
As git does not provide any way to do that, `git-restore-mtime` tries to work around this limitation.

For more information and background, see http://stackoverflow.com/a/13284229/624066

For TravisCI users, simply add this setting to `.travis.yml` so it clones the full repository history:
```yaml
git:
  depth: false
```

Similarly, when using GitHub Actions, make sure to include `fetch-depth: 0` in your checkout workflow,
as described in its [documentation](https://github.com/actions/checkout#Fetch-all-history-for-all-tags-and-branches):
```yaml
- uses: actions/checkout@v2
  with:
    fetch-depth: 0
```


git-strip-merge
---------------

*A `git-merge` wrapper that delete files on a "foreign" branch before merging*

Answer for "*How to set up a git driver to ignore a folder on merge?*", see http://stackoverflow.com/questions/3111515

Example:
```console
$ git checkout master
$ git-strip-merge design photoshop/*.psd
```
---

Contributing
------------

Patches are welcome! Fork, hack, request pull!

If you find a bug or have any enhancement request, please open a
[new issue](https://github.com/MestreLion/git-tools/issues/new)


Author
------

Rodrigo Silva (MestreLion) <linux@rodrigosilva.com>

License and Copyright
---------------------
```
Copyright (C) 2012 Rodrigo Silva (MestreLion) <linux@rodrigosilva.com>.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
```

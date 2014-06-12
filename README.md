# mgit - meta git repository tracker

[![Code Climate](https://codeclimate.com/github/FlavourSys/mgit.png)](https://codeclimate.com/github/FlavourSys/mgit)

mgit let's you track all your git repositories at once. It is inspired by [App::GitGot](https://github.com/genehack/app-gitgot).

## Getting started

Install mgit:

```sh
gem install mgit
```

Add some repositories:

```sh
mgit add <path to some git repository>
```

See the status:

```sh
$ mgit status
repo A...        | master            | Clean
repo B...        | develop           | Clean
repo C...        | develop           | Behind of origin/develop by 4
repo D...        | feature/something | Clean
```

Get help:

```sh
$ mgit help
M[eta]Git - manage multiple git repositories at the same time

Usage:
mgit list
  - list all repositories
mgit grep <pattern>
  - grep for a pattern in each repository
mgit config <key> <value>
  - configure MGit
mgit removeall
  - removes all repositories from mgit (resets mgit's store)
mgit version
  - display mgit version
mgit fetch
  - fetch all remote repositories
mgit head
  - show repository HEADs
mgit status
  - display status for each repository
mgit remove <name/path>
  - remove a repository
mgit help [command]
  - display help information
mgit foreach <command...>
  - execute a command for each repository
mgit tags
  - display the latest tag in repository (master branch)
mgit add <path_to_git_repository> [name]
  - add a repository to mgit
mgit log
  - show unmerged commits for all remote-tracking branches
mgit show <commit-sha/obj>
  - display commit object from any repository
mgit ffmerge
  - merge all upstream tracking branches that can be fast-forwarded
mgit clone [options] <url> [<directory>]
  - clone repository and add to mgit
mgit cleanfd
  - git-clean -fd each directory
```

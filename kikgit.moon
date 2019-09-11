-- It's git, but quicker
-- By daelvn
import command, capture from require "lrunkit.v3"
argparse                   = require "argparse"

local args
with argparse!
  \name        "kikgit"
  \description "Git, but quicker"
  \epilog      "Homepage - https://github.com/daelvn/kikgit"

  \command_target "command"

  -- kikgit push
  --   [git pull <remote> <branch>]
  --   git add -A
  --   git commit
  --   git push <remote> <branch>
  with \command "push p", "Pushes a simple commmit to the remote"
    with \option "-r --remote", "Remote to perform the push on"
      \default "origin"
    with \option "-b --branch", "Branch to perform the push on"
      \default "master"
    with \option "-m --message", "Optional commit message"
      \args "?"
    \flag        "-j --just-push", "Just push"
    \flag        "-p --pull", "Pull before pushing"

  -- kikgit release <tag>
  --  [git pull <remote> <branch>]
  --  git add -A
  --  git commit
  --  git tag -a <tag>
  --  git push <remote> <branch> --tags
  with \command "release r", "Releases a new version to the remote"
    with \option    "-r --remote", "Remote to perform the push on"
      \default "origin"
    with \option   "-b --branch", "Branch to perform the push on"
      \default "master"
    with \option   "-m --message", "Optional commit message"
      \args "?"
    with \argument "tag", "Tag to release the commits with"
      \args 1
    \flag          "-p --pull", "Pull before pushing"
    \flag          "-j --just-release", "Just tag and push"

  args = \parse!

pull   = command "git pull"
add    = command "git add -A"
commit = command "git commit"
tag    = command "git tag -a"
push   = command "git push"

switch args.command
  when "push"
    unless args.just_push
      print ":: Pulling from #{args.remote}/#{args.branch}" if args.pull
      pull args.remote, args.branch if args.pull
      print ":: Adding files"
      add!
      print ":: Commiting changes#{args.message and " -> #{args.message[1]}" or ""}"
      commit (args.message and "-m \"#{args.message[1]}\"" or nil)
    print ":: Pushing changes to #{args.remote}/#{args.branch}"
    push args.remote, args.branch
  when "release"
    unless args.just_release
      print ":: Pulling from #{args.remote}/#{args.branch}" if args.pull
      pull args.remote, args.branch if args.pull
      print ":: Adding files"
      add!
      print ":: Commiting changes#{args.message and " -> #{args.message[1]}" or ""}"
      commit (args.message and "-m \"#{args.message[1]}\"" or nil)
    print ":: Tagging #{args.tag}"
    tag args.tag
    print ":: Pushing changes to #{args.remote}/#{args.branch}"
    push args.remote, args.branch, "--tags"

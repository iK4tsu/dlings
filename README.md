# Dlings
Welcome to `dlings`. This project aims to teach you how to program in D.
If the name doesn't sound strange, it's because you might have heard of [rustlings](https://github.com/rust-lang/rustlings) or [ziglings](https://github.com/ratfactor/ziglings). In fact, this is **heavily** based on [rustlings](https://github.com/rust-lang/rustlings). If you're familiar with how [rustlings](https://github.com/rust-lang/rustlings) work, you will have no trouble getting started with `dlings`.

# Getting started
```sh
git clone git@github.com:iK4tsu/dlings.git
cd dlings
dub build -b release
./dlings --help
```

# Dlings Command Line
## Arguments
| argument | description
| ------- | -----------
| --help \| -h | Prints the help menu

## Commands
| command | description
| ------- | -----------
| hint    | Prints an exercise's hint
| run     | Examines a single exercise
| verify  | Runs all exercises by the recommended order
| watch   | Verify in interactive mode

*Note: use '--help' with a command for more information about it.*
# Status
This project is in its early days. Currently, only exercises used for testing are
available.

# Discussions
This project is from a user in the D community to everyone in the D community.
If you have any ideas, projects, discussions, or other topics you'd like to
mention, head over to the discussions tab and start a discussion. Or you can
comment on an existing discussion.
* [Road Map](https://github.com/iK4tsu/dlings/discussions/2)
* [Exercises Vision Document](https://github.com/iK4tsu/dlings/discussions/4)

# Contributing
Any suggestion, enhancement, or fix, is appreciated.

## Guidelines
* Commit messages should comply with [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
* Commits should have code changes by context

## How to contribute
* Fork the repository
* Clone this repository `git clone git@github.com:iK4tsu/dlings.git`
* Add remote to **your** repository `git remote add <name> <remote>`
* Create a branch to develop your changes `git checkout -b <name>`
* Push to **your** remote when ready `git push --set-upstream <remote-name> <branch-name>`
* Head over to GitHub and create a Pull Request

### Example
Let's say the user with GitHub USER wants to contribute. After forking:
```sh
git clone git@github.com:iK4tsu/dlings.git
cd dlings
git remote add USER git@github.com:USER/dlings.git
git checkout -b fix-some-issue
```
When ready to push:
```sh
git push --set-upstream USER fix-some-issue
```
Now create a Pull Request in GitHub to this project's master branch.

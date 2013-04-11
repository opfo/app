# Code Stream
An iOS app for the EDA397 course made at Chalmers in the spring of 2013.

## Getting started

```shell
# Get the source from GitHub.
git clone https://github.com/opfo/app.git Code-Stream
cd Code-Stream

# Init the submodules and their submodules (might take a while).
git submodule update --recursive --init

# Start hacking.
open "Code Stream.xcodeproj"
```

Done, yay woop woop.

### Staying updated
Normally just do a `git pull` but when a new submodule has been added or one has been updated (see the commit history) you will also need to tell git to update the submodules. That is run `git submodule update --init --recursive`, that command could easily be a git alias* :wink:.

_*) Something like this: `git config --global alias.pulls '!f(){ git pull "$@" && git submodule update --init --recursive; }; f'` and then just use `git pulls`._

## Hacking
Please have a look at our [definition of done](https://github.com/opfo/resources/blob/master/Definition%20of%20done.md) as well as GitHub’s [Objective-C conventions](https://github.com/github/objective-c-conventions).

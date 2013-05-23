# Code Stream
An iOS app for the EDA397 course made at Chalmers in the spring of 2013.

[![Build Status](https://travis-ci.org/opfo/app.png?branch=master)](https://travis-ci.org/opfo/app)

## Getting started

```shell
# Get the source from GitHub.
git clone https://github.com/opfo/app.git Code-Stream
cd Code-Stream

# Bootstrap the project
./Scripts/bootstrap

# Download the databases if needed
./Scripts/update_dbs

# Start hacking.
open "Code Stream.xcworkspace"
```

Done, yay woop woop.

### Staying updated
Normally just do a `git pull` but when a submodule or CocoaPod has been added or updated (see the commit history) you will also need to run the bootstrap script again. That is, from the project root, `./Scripts/bootstrap`.

If changes are made to the auxiliary database, you need to rerun the database update script using the *force* option:

```shell
./Scripts/update_dbs force
```

## Hacking
Please have a look at our [definition of done](https://github.com/opfo/resources/blob/master/Definition%20of%20done.md) as well our [Coding Conventions](https://github.com/opfo/resources/blob/master/coding_convetions.md). Then you can open the Xcode workspace file (`open "Code Stream.xcworkspace"`).

## Testing and constant integration
You can view the status of the constant integration (run every time new commits are pushed to GitHub) on [Code Stream’s Travis CI status page](https://travis-ci.org/opfo/app).

If you want to configure when and why you receive build status notifications please have a look at Travis CI’s [notifications documentation](http://about.travis-ci.org/docs/user/notifications/).

# Screenshots of the App

![Questions View](https://raw.github.com/opfo/resources/master/Screenshots/screen-3.png)
![Sorting in Questions View](https://raw.github.com/opfo/resources/master/Screenshots/screen-11.png)
![Single Question View](https://raw.github.com/opfo/resources/master/Screenshots/screen-1.png)
![Answer to Question](https://raw.github.com/opfo/resources/master/Screenshots/screen-4.png)
![Searching for Posts](https://raw.github.com/opfo/resources/master/Screenshots/screen-2.png)
![Searching for User in Posts](https://raw.github.com/opfo/resources/master/Screenshots/screen-11.png)
![Comments View](https://raw.github.com/opfo/resources/master/Screenshots/screen-5.png)
![Tag Browser](https://raw.github.com/opfo/resources/master/Screenshots/screen-6.png)
![Users Search](https://raw.github.com/opfo/resources/master/Screenshots/screen-7.png)
![Profile View Top](https://raw.github.com/opfo/resources/master/Screenshots/screen-10.png)
![Profile View Buttom](https://raw.github.com/opfo/resources/master/Screenshots/screen-8.png)
![Activity View](https://raw.github.com/opfo/resources/master/Screenshots/screen-9.png)

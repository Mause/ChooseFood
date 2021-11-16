fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
### notify
```
fastlane notify
```
Notify via messaging services

----

## Android
### android create_notes
```
fastlane android create_notes
```
Creates notes
### android deploy
```
fastlane android deploy
```
Deploy a new version to the Google Play
### android validate
```
fastlane android validate
```
Validate json key

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).

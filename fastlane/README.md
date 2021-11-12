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
### android assemble_application
```
fastlane android assemble_application
```
Assemble App (for Firebase Test Lab)
### android assemble_test_application
```
fastlane android assemble_test_application
```
Assemble Android Test
### android assemble
```
fastlane android assemble
```
Assemble Build and Test Application
### android instrumentation_tests_testlab
```
fastlane android instrumentation_tests_testlab
```
Run instrumentation tests in Firebase Test Lab

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).

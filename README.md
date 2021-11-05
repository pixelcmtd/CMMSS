# CMMSS
chrissx Media macOS Setup Scripts is a set of scripts for easily installing a
load of packages and configuration, primarily on "Apple silicon" (ARM),
currently macOS 12 Monterey.

## How to use
* Install [iTerm](https://iterm2.com/downloads/stable/latest)
* Install [XCode](https://apps.apple.com/de/app/xcode/id497799835) from the
App Store (`open -a "App Store" https://apps.apple.com/de/app/xcode/id497799835`)
* Run `xcode-select --install`
* Click `Install` and wait until it's finished
* Run `sudo xcodebuild -license` and agree to the license
* Run `sudo softwareupdate --install-rosetta` and agree to the license
* Run `curl -L https://github.com/pixelcmtd/CMMSS/raw/master/bootstrap | sh`
* iTerm Preferences: General -> Preferences ->
`Load preferences from a custom folder or URL` -> `/Users/your_name/CMMSS`

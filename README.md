# CMMSS
chrissx Media macOS Setup Scripts is a set of scripts for easily installing a
load of packages and configuration, primarily on "Apple silicon" (ARM),
currently macOS 12 Monterey.

We won't bother to support older macOS versions, because there is virtually no
reason to not use the latest one. If you want to use it on another version,
patching it should be pretty easy though. Using CMMSS on Intel-based Macs is
also untested, but it _should_ work.

## How to use
* Install [iTerm](https://iterm2.com/downloads/stable/latest)
* Install [XCode](https://apps.apple.com/de/app/xcode/id497799835) from the
App Store (`open -a "App Store" https://apps.apple.com/de/app/xcode/id497799835`)
* Run `curl -L https://github.com/pixelcmtd/CMMSS/raw/master/bootstrap | sh`
* iTerm Preferences: General → Preferences →
`Load preferences from a custom folder or URL` → `/Users/your_name/CMMSS`

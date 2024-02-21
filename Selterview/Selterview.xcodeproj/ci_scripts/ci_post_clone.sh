#!/bin/sh.
# ci_post_clone.sh

# Target * must be enabled before it can be used 해결방법
defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES

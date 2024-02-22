#!/bin/sh
# ci_post_clone.sh

# Target * must be enabled before it can be used 해결방법
defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES

# Environment variable. Create API_Key.plist
PLIST_PATH="/Volumes/workspace/repository/Selterview/Selterview/Resources/API_Key.plist"

# plist 파일 생성 및 Key-Value 설정
/usr/libexec/PlistBuddy -c "Add :OpenAIAPIKey string" $PLIST_PATH
/usr/libexec/PlistBuddy -c "Set :OpenAIAPIKey '$API_Key'" $PLIST_PATH

exit 0

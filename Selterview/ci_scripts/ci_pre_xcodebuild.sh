#!/bin/sh
# ci_pre_xcodebuild.sh

plutil -replace OpenAIAPIKey -string $API_Key /Volumes/workspace/repository/Selterview/Selterview/Resources/CI_Key.plist

exit 0

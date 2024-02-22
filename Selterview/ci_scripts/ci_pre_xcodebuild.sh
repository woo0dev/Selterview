#!/bin/sh
# ci_pre_xcodebuild.sh

echo "Environment scripts has been activated .... "

cd   

plutil -create /Volumes/workspace/repository/Selterview/Selterview/Resources/API_Key.plist
plutil -insert OpenAIAPIKey -string $API_Key /Volumes/workspace/repository/Selterview/Selterview/Resources/API_Key.plist

echo "Environment scripts has been DONE .... "

exit 0

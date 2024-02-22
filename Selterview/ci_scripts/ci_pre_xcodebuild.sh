#!/bin/sh
# ci_pre_xcodebuild.sh

echo "Environment scripts has been activated .... "

cd ..

plutil -create ./Selterview/Selterview/Resources/API_Key.plist
plutil -insert OpenAIAPIKey -string $API_Key ./Selterview/Selterview/Resources/API_Key.plist

echo "Environment scripts has been DONE .... "

exit 0

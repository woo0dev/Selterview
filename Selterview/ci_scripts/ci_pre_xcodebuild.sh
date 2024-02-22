#!/bin/sh
# ci_pre_xcodebuild.sh

echo "Environment scripts has been activated .... "

echo '<?xml version="1.0" encoding="UTF-8"?>' > API_Key.plist
echo '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' >> API_Key.plist
echo '<plist version="1.0">' >> API_Key.plist
echo '<dict>' >> API_Key.plist
echo '    <key>OpenAIAPIKey</key>' >> API_Key.plist
echo '    <string>$API_Key</string>' >> API_Key.plist
echo '</dict>' >> API_Key.plist
echo '</plist>' >> API_Key.plist

echo "A.plist 생성이 완료되었습니다."

exit 0

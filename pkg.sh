#!/bin/bash
scheme="rss"
cur_time=$(date +%Y%m%d%H%M%S)
build_dir="build/$cur_time"

echo "[$cur_time] start build [$scheme] project, export ipa dir: $build_dir"

if [ ! -d build_dir ]; then
  mkdir build_dir
else
  rm -rf build_dir
fi

# fastlane versionLane

xcodebuild -project $scheme.xcodeproj -scheme $scheme -configuration Release -archivePath "$build_dir/$scheme.xcarchive" clean archive -UseModernBuildSystem=NO | xcpretty
xcodebuild -exportArchive -archivePath "$build_dir/$scheme.xcarchive" -exportPath "$build_dir" -exportOptionsPlist "ExportOptions.plist" -allowProvisioningUpdates | xcpretty


user="acumen1005@gmail.com"
password="llgq-xmdd-osgn-pfkb"

echo "valid app ..."
xcrun altool --validate-app -f "$build_dir/$scheme.ipa" -u $user -p $password -t ios --output-format xml
echo "upload app ..."
xcrun altool --upload-app -f "$build_dir/$scheme.ipa" -u $user -p $password -t ios --output-format xml
echo "upload done---f*cking enjoy!!!"

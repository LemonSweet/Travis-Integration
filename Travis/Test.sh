#!/bin/sh

#  Test.sh
#  Travis
#
#  Created by Galiev Aynur on 22.05.16.
#  Copyright © 2016 FlatStack. All rights reserved.

#!/bin/sh

if [[ "$TRAVIS_BRANCH" != "master" ]]; then
echo "Testing on a branch other than master. No deployment will be done."
exit 0
fi

# config github
git config --global user.name "Travis CI"
git config --global user.email travisci@aynurgaliev.com
git remote add travisci https://$GITHUB_TOKEN@github.com/LemonSweet/Travis-Integration
# if we have more than one worker we should pull before pushing
git checkout $TRAVIS_BRANCH
git pull travisci $TRAVIS_BRANCH

echo ""
echo "********************************"
echo "* Change build number *"
echo "********************************"
echo ""

/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $TRAVIS_BUILD_NUMBER" "$PWD/Travis/Info.plist"
echo "New build number - $TRAVIS_BUILD_NUMBER"

echo ""
echo "********************************"
echo "* Commit and push *"
echo "********************************"
echo ""

git add $PWD/Travis/Info.plist
git commit -m "Increase build number to $TRAVIS_BUILD_NUMBER by Travis CI [ci skip]"
git push travisci $TRAVIS_BRANCH:$TRAVIS_BRANCH

echo "Build success!"
#!/usr/bin/env bash

VERSION_FILE=$(__get_version_file)
VERSION_PREFIX=$(git config --get gitflow.prefix.versiontag)
PACKAGE_JSON_FILE=$(__get_package_json_file)

if [ ! -z "$VERSION_PREFIX" ]; then
    VERSION=${VERSION#$VERSION_PREFIX}
fi

if [ -z "$VERSION_BUMP_MESSAGE" ]; then
    VERSION_BUMP_MESSAGE="Bump version to %version%"
fi

# update package.json
if [ -f "$PACKAGE_JSON_FILE" ]; then
    npm version $VERSION --no-git-tag-version
    git add $PACKAGE_JSON_FILE
fi

# write version into version file
echo -n "$VERSION" > $VERSION_FILE
git add $VERSION_FILE

# commit changes
git commit -m "$(echo "$VERSION_BUMP_MESSAGE" | sed s/%version%/$VERSION/g)"

if [ $? -ne 0 ]; then
    __print_fail "Unable to write version to $VERSION_FILE."
    return 1
else
    return 0
fi

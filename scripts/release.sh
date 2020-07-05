#!/bin/bash
np=$(npm bin)"/np"

npm i || exit 1

echo "Enter release version (major/minor/patch)."
read -r version

echo "Executing dryrun..."
for package in packages/* ; do
  cd "$package" || exit 2
  echo "CWD: $PWD"
  "$np" "$version" --no-publish --no-release-draft --preview || exit 3
  cd ../.. || exit 4
done
echo "CWD: $PWD"
"$np" "$version" --preview || exit 5

echo "Are you sure? (Y/[N])"
read -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo "Executing release..."
  for package in packages/* ; do
    cd "$package" || exit 6
    echo "CWD: $PWD"
    "$np" "$version" --yolo --no-release-draft || exit 7
    cd .. || exit 8
  done
  echo "CWD: $PWD"
  "$np" "$version" --yolo --no-publish || exit 9
fi

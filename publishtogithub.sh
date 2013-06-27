#!/bin/bash

basedir=web
tmpdir=tmp
rootdir=`pwd`

rm -rf $tmpdir
mkdir -p $tmpdir

if ! test -d $tmpdir ; then
	echo "Invalid tmpdir! $tmpdir."
	exit 1
fi

$DART_SDK/bin/dart --package-root=packages/ packages/web_ui/dwc.dart --out $basedir/out/ $basedir/example.html

cd web/out/
$DART_SDK/bin/dart2js example.html_bootstrap.dart -oexample.html_bootstrap.dart.js
cd ../..

if ! test -f $basedir/example.html ; then
	echo "Unable to find example.html - in $basedir ?!"
	exit 1
fi

git clone -b gh-pages git@github.com:hpoul/dart-autocomplete-ui.git $tmpdir/gh-pages

export GIT_WORK_TREE=$tmpdir/gh-pages/
export GIT_DIR=$tmpdir/gh-pages/.git
rm -rf $tmpdir/gh-pages/examples
mkdir -p $tmpdir/gh-pages/examples

cp -r $basedir/out/packages $tmpdir/gh-pages/examples/
cp -a $basedir/out/* $tmpdir/gh-pages/examples/

sed -e "s#../packages/browser/dart.js#packages/browser/dart.js#" -i '' $tmpdir/gh-pages/examples/example.html

git add -A

git commit -m "fresh publish run. `date`"
git push

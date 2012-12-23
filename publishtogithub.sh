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
dart2js example.html_bootstrap.dart -o example.html_bootstrap.dart.js
cd ../..

if ! test -f $basedir/example.html  then
	echo "Unable to find example.html - in $basedir ?!"
	exit 1
fi

#git clone --single-branch -b gh-pages git@github.com:dc2f/DC2F.git $tmpdir/gh-pages
git clone -b dc2f.com git@github.com:hpoul/dart-autocomplete-ui.git $tmpdir/gh-pages

export GIT_WORK_TREE=$tmpdir/gh-pages/
export GIT_DIR=$tmpdir/gh-pages/.git
rm -rf $tmpdir/gh-pages/*

cp -a $basedir/out/* $tmpdir/gh-pages/

git add -A

git commit -m "fresh publish run. `date`"
git push

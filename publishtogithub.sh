#!/bin/bash

tmpdir=tmp
rootdir=`pwd`
basedir=`dirname $0`

rm -rf $tmpdir
mkdir -p $tmpdir

if ! test -d $tmpdir ; then
	echo "Invalid tmpdir! $tmpdir."
	exit 1
fi

$DART_SDK/bin/dart deploy.dart

if ! test -f $basedir/out/web/example.html ; then
	echo "Unable to find example.html - in $basedir ?!"
	exit 1
fi

git clone -b gh-pages git@github.com:hpoul/dart-autocomplete-ui.git $tmpdir/gh-pages

export GIT_WORK_TREE=$tmpdir/gh-pages/
export GIT_DIR=$tmpdir/gh-pages/.git
rm -rf $tmpdir/gh-pages/examples
mkdir -p $tmpdir/gh-pages/examples

#cp -r $basedir/out/web/packages $tmpdir/gh-pages/examples/
cp -a -L $basedir/out/web/* $tmpdir/gh-pages/examples/

git add -A

git commit -m "fresh publish run. `date`"
git push

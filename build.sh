#!/bin/bash
set -e
set -x

if [ -z "$VERSION" ]; then
    [ -z "`git tag -l | head -1`" ] && git tag 0.0.1
    export VERSION="`git describe --tags --dirty`"
fi
    
poetry install
poetry show
poetry export -f requirements.txt --output requirements.txt --without-hashes
pip install pyinstaller
sed -ri "s/VERSION *= *['\"].*['\"]/VERSION = \"${VERSION}\"/" ./backupdir/main.py
grep 'VERSION = ' ./backupdir/main.py
pyinstaller --clean --noupx --onefile backupdir/main.py

pyi-archive_viewer -l dist/main

cp ./dist/main ./dist/backupdir
ls -pilaF ./dist
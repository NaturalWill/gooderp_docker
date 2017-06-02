#!/bin/bash

set -e
service postgresql start
cd /~/gooderp_addons/
git pull
cd ..
cd /~/base/
python2.7 odoo-bin -c oe.conf
exit 1

#!/bin/bash

set -e
service postgresql start
cd /~/base/
python2.7 odoo-bin -c oe.conf
exit 1

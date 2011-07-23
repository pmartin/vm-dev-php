#!/bin/bash

aptitude -y install memcached
aptitude -y install couchdb
aptitude -y install gearman

aptitude clean

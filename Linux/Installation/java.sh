#!/bin/sh

sudo apt-get autoremove 'openjdk-*'
sudo apt-get autoremove 'oracle-java*'

sudo apt-get install oracle-java11-installer

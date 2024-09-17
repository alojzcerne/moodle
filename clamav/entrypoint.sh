#!/bin/sh
set -e

freshclam --foreground
freshclam --daemon --checks=49 --quiet --daemon-notify

exec clamd -F

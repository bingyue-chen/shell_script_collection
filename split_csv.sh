#!/bin/sh

parallel --header : --pipe -N"$3" "cat >$2_{#}.csv" < "$1"

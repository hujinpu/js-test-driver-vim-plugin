#!/usr/bin/env bash
java -jar $1 --port $2 &
echo `jobs -p`

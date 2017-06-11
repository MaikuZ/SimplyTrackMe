#!/bin/bash
(rm out.sql || true) &>/dev/null
touch out.sql
for file in ./input/*; do
echo 1 $file $1 $2 $3 $4 | ./main >> out.sql
done

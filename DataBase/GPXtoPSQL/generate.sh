#!/bin/bash
#$1 - typeID, $2 minV, $3 maxV
find -name "* *" -type f | rename 's/ /_/g'
#we first clean of whitespaces their names..
(rm out.sql || true) &>/dev/null
touch out.sql
maksymalne_id=30
predkosc=$(($(($RANDOM%$(($3-$2))))+$3))
#$1 to typ
#$2,3 to maksymalna i minimalna prędkość możliwa. losujemy liczbę z tego przedziału
for file in ./input/*; do
aktualne_id=$(($RANDOM%$maksymalne_id+1))
echo $aktualne_id
echo $predkosc
echo 1 $file $predkosc $(($predkosc+1)) $aktualne_id $1 | ./main >> out.sql
echo $file
done

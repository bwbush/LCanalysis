#!/usr/bin/env nix-shell
#!nix-shell -i bash --packages "octave.withPackages (ps: with ps; [ statistics ])"

for delta in 0.01 2.00 5.00
do
  for adversary in 0.025 0.050 0.075 0.100 0.125 0.150 0.175 0.200 0.225
  do
    sed -e "s/@ADVERSARY/$adversary/;s/@DELTA/$delta/" template.m > case-$adversary-$delta.m
    octave case-$adversary-$delta.m &
  done
done
wait

echo $'Delta [slots]\tAdversarial Stake [%/100]\tBound\tNumber of Blocks\tProbability of Failure' > prob-failure.tsv
for delta in 0.01 2.00 5.00
do
  for adversary in 0.025 0.050 0.075 0.100 0.125 0.150 0.175 0.200 0.225
  do
    for bound in LB UB
    do
      nl -s $'\t' -n ln case-$adversary-$delta-$bound.csv | sed -e "s/^/$delta\t$adversary\t$bound\t/" >> prob-failure.tsv
    done
  done
done

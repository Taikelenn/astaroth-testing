# Astaroth testing

This repository contains scripts and experimental results from testing [Astaroth](https://bitbucket.org/jpekkila/astaroth/src/master/) on NVIDIA and AMD hardware.

The files are structured as follows:
- `start.lua` - a script copying Astaroth to a temporary directory, compiling it, running the tests and cleaning up.
- `results_final.csv` - a CSV file with all results (run times for both NVIDIA and AMD aggregated by the "maximum threads per block" parameter)
- `intermediate_results/` - a directory containing all intermediate results (i.e. stdout and stderr from `benchmark-device`). Each file is named as follows: _\<architecture name\>\_\<max threads per block\>\_\<implementation\>_

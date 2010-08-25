directory ~/neurospaces_project/model-container/source/snapshots/0/neurospaces
directory ~/neurospaces_project/model-container/source/snapshots/0/neurospaces/components
directory ~/neurospaces_project/model-container/source/snapshots/0/hierarchy/output/symbols/
# set env NEUROSPACES_NMC_MODELS = /local_home/local_home/hugo/neurospaces_project/model-container/source/snapshots/0/library
# set env NEUROSPACES_NMC_PROJECT_MODELS = /local_home/local_home/hugo/EM/models
set args tests/scripts/readcell/purk2m9.g
set args tests/scripts/PurkM9_model/ACTIVE-soma1.g
set args tests/scripts/test-simplecell/simplecell-1.g
# set args tests/scripts/test-traub91-v0/traub91_asym.g
# set args tests/scripts/test-traub91-v0/traub91_asym_simple.g
set args tests/scripts/test-traub91-v0/traub91_asym_simple2.g
# set args tests/scripts/test-traub91-v0/traub91_asym_simple3.g
# set args tests/scripts/test-traub91-v0/traub91.g
#     $genesis -nox -altsimrc $simrc -batch -notty scale_cable $timestep 1000 cable
# set args -nox tests/scripts/rallpack1/scale_cable 500 1000 tests/scripts/rallpack1/cable
# set args -nox tests/scripts/rallpack1/cable 500 1000 tests/scripts/rallpack3/axon
# set args -nox tests/scripts/rallpack3/axon 500 1000 tests/scripts/rallpack3/axon
# set args tests/scripts/test-traub94cell-v0/traub94cell1.g 
# cd ..
file src/ns-sli
break parsererror
echo .gdbinit: Done .gdbinit\n

# set args
# file ./neurospacesparse
# directory ~/neurospaces_project/model-container/ 
# directory ~/neurospaces_project/model-container/neurospaces/
# directory ~/neurospaces_project/model-container/hierarchy/output/symbols/
# directory ~/neurospaces_project/heccer/
# directory ~/neurospaces_project/heccer/integrators/
# directory ~/neurospaces_project/heccer/integrators/heccer/
# directory ~/neurospaces_project/heccer/integrators/heccer/neurospaces/
# echo .gdbinit: Done .gdbinit in neurospacesparse dir\n
# set print pretty

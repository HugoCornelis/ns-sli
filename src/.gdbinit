# set env NEUROSPACES_NMC_MODELS = /local_home/local_home/hugo/neurospaces_project/model-container/source/snapshots/0/library
# set env NEUROSPACES_NMC_PROJECT_MODELS = /local_home/local_home/hugo/EM/models
set args tests/scripts/readcell/purk2m9.g
set args tests/scripts/PurkM9_model/PASSIVE9-current.g
set args tests/scripts/test-simplecell/simplecell-1.g
cd ..
file src/ns-sli
break parsererror
echo .gdbinit: Done .gdbinit\n

# set print pretty

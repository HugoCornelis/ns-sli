# set env NEUROSPACES_MODELS = /local_home/local_home/hugo/neurospaces_project/model_container/source/c/snapshots/0/library
# set env NEUROSPACES_PROJECT_MODELS = /local_home/local_home/hugo/EM/models
set args
file ./nsgenesis
break parsererror
echo .gdbinit: Done .gdbinit in nsgenesis dir\n
set print pretty

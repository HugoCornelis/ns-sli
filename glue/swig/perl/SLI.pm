#!/usr/bin/perl -w
#!/usr/bin/perl -w -d:ptkdb
#

package SLI;


use strict;


use SwiggableSLI;


sub include_script
{
    my $script = shift;

    # include the script, result is 1 for success, 0 for failure.

    my $result = SwiggableSLI::IncludeG2Script("$script");

    if (!$result)
    {
	print "$0: include_script() failed\n";
    }
}


sub include_model
{
    my $script = shift;

    my $model_container = shift;

    # set the directory where to find .p files

    $script =~ m(^(.*)/);

    my $morphology_directory = $1;

    $morphology_directory = "/local_home/local_home/hugo/neurospaces_project/ns-genesis-SLI/source/snapshots/0";

    # read the model, result is always 0 for some obscure reason.

    my $result = SwiggableSLI::IncludeG2Model("$morphology_directory", "$script", $model_container->backend());

    if (!$result)
    {
	print "$0: include_model() failed\n";
    }
}


sub interpreter
{
    SwiggableSLI::RunInterpreter(1);
}


sub run_model
{
    my $script = shift;

    my $model_container = shift;

    # set the directory where to find .p files

    $script =~ m(^(.*)/);

    my $morphology_directory = $1;

    $morphology_directory = "/local_home/local_home/hugo/neurospaces_project/ns-genesis-SLI/source/snapshots/0";

    # read the model, result is always 0 for some obscure reason.

    my $result = SwiggableSLI::IncludeG2Model("$morphology_directory", "$script", $model_container->backend());

    if (!$result)
    {
	print "$0: include_model() failed\n";
    }
}


1;



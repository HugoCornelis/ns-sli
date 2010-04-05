#!/usr/bin/perl -w
#!/usr/bin/perl -w -d:ptkdb
#

package SLI;


use strict;


use SwiggableSLI;


our $backend_initialized;


sub sli_list_objects
{
    if (!$backend_initialized)
    {
	run_model(undef, $GENESIS3::model_container);
    }

    my $result = SwiggableSLI::ListObjects();

    if (!$result)
    {
	print "$0: sli_list_objects() failed\n";
    }
}

sub sli_list_commands
{
    if (!$backend_initialized)
    {
	run_model(undef, $GENESIS3::model_container);
    }

    my $result = SwiggableSLI::ListCommands();

    if (!$result)
    {
	print "$0: sli_list_commands() failed\n";
    }
}

sub sli_print_command_list
{
    if (!$backend_initialized)
    {
	run_model(undef, $GENESIS3::model_container);
    }

    my $result = SwiggableSLI::PrintCommandList();

    if (!$result)
    {
	print "$0: sli_print_command_list() failed\n";
    }
}

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

    $morphology_directory = $ENV{HOME} . "/neurospaces_project/ns-sli/source/snapshots/0";

    # read the model, result is always 0 for some obscure reason.

    my $result
	= SwiggableSLI::IncludeG2Model
	    (
	     "$morphology_directory",
	     "$script",
	     $model_container->backend(),
	     $ENV{HOME} . "/neurospaces_project/ns-sli/source/snapshots/0/.simrc-ns-sli",
	    );

    if (!$result)
    {
	print "$0: include_model() failed\n";
    }
    else
    {
	$backend_initialized = 'initialized from include_model()';
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

    my $morphology_directory;

    if (defined $script)
    {
	$script =~ m(^(.*)/);

	$morphology_directory = $1;

	$morphology_directory = $ENV{HOME} . "/neurospaces_project/ns-sli/source/snapshots/0";

    }

    # read the model, result is always 0 for some obscure reason.

    my $result
	= SwiggableSLI::RunG2Model
	    (
	     (defined $morphology_directory ? "$morphology_directory" : undef),
	     (defined $script ? "$script" : undef),
	     $model_container->backend(),
	     $ENV{HOME} . "/neurospaces_project/ns-sli/source/snapshots/0/.simrc-ns-sli",
	    );

    if (!$result)
    {
	print "$0: run_model() failed\n";
    }
    else
    {
	$backend_initialized = 'initialized from run_model()';
    }
}


1;



#!/usr/bin/perl -w
#!/usr/bin/perl -w -d:ptkdb
#

package SLI::Integrators::Commands;


use strict;


use SLI;


our $g3_commands
    = [
       'sli_listcommands',
       'sli_listcommands_help',
       'sli_listobjects',
       'sli_listobjects_help',
       'sli_load',
       'sli_load_help',
       'sli_printcommandlist',
       'sli_printcommandlist_help',
       'sli_run',
       'sli_run_help',
       'sli_script',
       'sli_script_help',
      ];



sub sli_listcommands
{

  SLI::sli_list_commands();

}



sub sli_listcommands_help
{
    print "description: list all avaialable ns-sli commands.\n";

    print "synopsis: sli_listcommands\n";

    return "*** Ok";
}


sub sli_listobjects
{
  SLI::sli_list_objects();
}



sub sli_listobjects_help
{
    print "description: list all available ns-sli objects.\n";

    print "synopsis: sli_load <filename.g>\n";

    return "*** Ok";
}



sub sli_load
{
    my $filename = shift;

    if (!-e $filename)
    {
	$filename = "/usr/local/ns-sli/tests/scripts/$filename";
    }

    SLI::include_model($filename, $GENESIS3::model_container);

    return "*** Ok: sli_load $filename";
}


sub sli_load_help
{
    print "description: load and extract models from a GENESIS 2 .g file.\n";

    print "synopsis: sli_load <filename.g>\n";

    return "*** Ok";
}



sub sli_printcommandlist
{

  SLI::sli_print_command_list();

}

sub sli_printcommandlist_help
{
    print "description: outputs a list of available GENESIS 2 command into a YAML structure.\n";

    print "synopsis: sli_printcommandlist";

    return "*** Ok";
}


sub sli_run
{
    my $filename = shift;

    if (!-e $filename)
    {
	$filename = "/usr/local/ns-sli/tests/scripts/$filename";
    }

    SLI::run_model($filename, $GENESIS3::model_container);

    return "*** Ok: sli_run $filename";
}


sub sli_run_help
{
    print "description: load and run a GENESIS 2 .g file.\n";

    print "synopsis: sli_run <filename>\n";

    return "*** Ok";
}


sub sli_script
{
    my $filename = shift;

    if (!-e $filename)
    {
	$filename = "/usr/local/ns-sli/tests/scripts/$filename";
    }

    SLI::include_script($filename);

    return "*** Ok: sli_script $filename";
}


sub sli_script_help
{
    print "description: load and run a GENESIS 2 .g add-on.\n";

    print "synopsis: sli_script <filename>\n";

    return "*** Ok";
}


1;



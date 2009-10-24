#!/usr/bin/perl -w
#!/usr/bin/perl -w -d:ptkdb
#

package SLI::Integrators::Commands;


use strict;


use SLI;


our $g3_commands
    = [
       'sli_listcommands',
       'sli_listobjects',
       'sli_load',
       'sli_load_help',
       'sli_run',
       'sli_run_help',
       'sli_script',
       'sli_script_help',
      ];



sub sli_listcommands
{

  SLI::ListCommands();

}

sub sli_listobjects
{
  SLI::ListObjects();
}




sub sli_load
{
    my $filename = shift;

    SLI::include_model($filename, $GENESIS3::model_container);

    return "*** Ok: sli_load $filename";
}


sub sli_load_help
{
    print "description: load and extract models from a GENESIS 2 .g file.\n";

    print "synopsis: sli_load <filename.g>\n";

    return "*** Ok";
}


sub sli_run
{
    my $filename = shift;

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

    SLI::include_script($filename);

    return "*** Ok: sli_script $filename";
}


sub sli_script_help
{
    print "description: load and run a GENESIS 2 .g add-on.\n";

    print "synopsis: sli_script <filename>\n";

    return "*** Ok";
}



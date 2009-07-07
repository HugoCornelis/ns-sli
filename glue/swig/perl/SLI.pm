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

    # include the script, result is 1 for success, 0 for failure.

    my $result = SwiggableSLI::IncludeG2Model("$script");

    if (!$result)
    {
	print "$0: include_model() failed\n";
    }
}


1;



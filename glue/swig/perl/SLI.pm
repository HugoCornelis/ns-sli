#!/usr/bin/perl -w
#!/usr/bin/perl -w -d:ptkdb
#

package SLI;


use strict;


use SwiggableSLI;


sub include_script
{
    my $script = shift;

    my $result = SwiggableSLI::IncludeG2Script("$script");

    print "include_script(): result is $result\n";
}


1;



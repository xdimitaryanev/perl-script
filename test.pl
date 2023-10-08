use strict;
use warnings;
use DBI;
use HTML::Template;
use utf8;

my $db_host = 'localhost';
my $db_name = 'innovation_gaming';
my $db_user = 'root';
my $db_pass = '12345';

my $dbh = DBI->connect("dbi:mysql:database=$db_name;host=$db_host", $db_user, $db_pass, {
    PrintError => 0,
    RaiseError => 1,
    AutoCommit => 1,
    mysql_enable_utf8 => 1,
});

my $sql = "SELECT * FROM users";
my $sth = $dbh->prepare($sql);
$sth->execute;

my @data;
while (my $row = $sth->fetchrow_hashref) {
    push @data, $row;
}
 
my $template = HTML::Template->new(filename => 'users_list.html');

$template->param(USERS_LOOP => \@data);

my $output_filename = 'users_list_ready.html';
open my $output_file, '>', $output_filename or die "Cannot open $output_filename: $!";
binmode($output_file, ":utf8");
print $output_file $template->output;
close $output_file;

print "Data saved to $output_filename";
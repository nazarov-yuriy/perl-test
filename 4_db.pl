#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use DBI;
use Scalar::Util qw(looks_like_number);

use constant {
    COMMIT_BATCH => 1000000,
    DB_HOSTNAME  => "127.0.0.1",
    DB_NAME      => "postgres",
    DB_USER      => "postgres",
    DB_PASSWORD  => "postgres",
};

sub validated_record(@) {
    my ($id, undef, undef) = @_;
    die "Incorrect record size" unless ( 3 == scalar @_ );
    die "Incorrect format" unless looks_like_number($id);
    return @_;
}

my ($in_file_name) = @ARGV;
open my $in_fh, '<', $in_file_name or die $!;

my DBI::db $dbh = DBI->connect("dbi:Pg:dbname=${\DB_NAME};host=${\DB_HOSTNAME}", DB_USER, DB_PASSWORD, {
        PrintError => 0,
        RaiseError => 1,
        AutoCommit => 0
    });

my $statement = 'INSERT INTO banners (banner_id, title, url) VALUES (?, ?, ?)'.
    ' ON CONFLICT (banner_id) DO UPDATE SET (title, url) = (EXCLUDED.title, EXCLUDED.url)';
my DBI::st $sth = $dbh->prepare($statement);

my $uncommited = 0;
while (defined (my $line = <$in_fh>)) {
    $uncommited++;
    chomp $line;
    my @record = split /\t/, $line;
    $sth->execute(validated_record(@record));
    if ($uncommited >= COMMIT_BATCH) {
        $uncommited = 0;
        $dbh->commit();
    }
}
$dbh->commit();
$dbh->disconnect();
close $in_fh;

print "Records were updated successfully.";

=pod

=head1 Code

    #!/usr/bin/perl
    use strict;
    use warnings FATAL => 'all';

    use DBI;
    use Scalar::Util qw(looks_like_number);

    use constant {
        COMMIT_BATCH => 1000000,
        DB_HOSTNAME  => "127.0.0.1",
        DB_NAME      => "postgres",
        DB_USER      => "postgres",
        DB_PASSWORD  => "postgres",
    };

    sub validated_record(@) {
        my ($id, undef, undef) = @_;
        die "Incorrect record size" unless ( 3 == scalar @_ );
        die "Incorrect format" unless looks_like_number($id);
        return @_;
    }

    my ($in_file_name) = @ARGV;
    open my $in_fh, '<', $in_file_name or die $!;

    my DBI::db $dbh = DBI->connect("dbi:Pg:dbname=${\DB_NAME};host=${\DB_HOSTNAME}", DB_USER, DB_PASSWORD, {
            PrintError => 0,
            RaiseError => 1,
            AutoCommit => 0
        });

    my $statement = 'INSERT INTO banners (banner_id, title, url) VALUES (?, ?, ?)'.
        ' ON CONFLICT (banner_id) DO UPDATE SET (title, url) = (EXCLUDED.title, EXCLUDED.url)';
    my DBI::st $sth = $dbh->prepare($statement);

    my $uncommited = 0;
    while (defined (my $line = <$in_fh>)) {
        $uncommited++;
        chomp $line;
        my @record = split /\t/, $line;
        $sth->execute(validated_record(@record));
        if ($uncommited >= COMMIT_BATCH) {
            $uncommited = 0;
            $dbh->commit();
        }
    }
    $dbh->commit();
    $dbh->disconnect();
    close $in_fh;

    print "Records were updated successfully.";

=cut
#!/usr/bin/perl

sub improved() {
    my ($filename) = @ARGV;
    open my $fh, '<', $filename or die $!;
    my ($lines, $words) = (0, 0);
    while ( defined(my $line = <$fh>) ) {
        $lines++;
        $words += scalar split /\s+/, $line;
    }
    close $fh;
    printf "%8d %8d\n", $lines, $words;
    exit 0;
}

improved() if $0 =~ m!improved!;

open F, $ARGV[0] || die $!;
my @lines = <F>;
my @words = map {split /\s/} @lines;
printf "%8d %8d\n", scalar(@lines), scalar(@words); close(F);

=pod

=head1 Comments

=head2 C<< open F, $ARGV[0] || die $!; >>

Two-argument form of C<open> used. So it can be exploited to start process or rewrite file:

  perl wc.pl 'echo |'
  perl wc.pl '>test.txt'

C<||> operator has bigger priority than function call. So code is equal to

  open F, ($ARGV[0] || die $!);

which is unlikely to be expected because open error reporting idiom looks like

  open(F, $ARGV[0]) or die($!);

It's also a bad practice to use global filehandles.

=head2 C<< my @lines = <F>; >>

This code isn't very memory efficient. While loop will improve situation for texts with linebreaks.

  while ( defined(my $line = <$fh>) ) {
  }

=head2 C<< my @words = map {split /\s/} @lines; >>

At least \s+ should be used to skip empty strings(located between \s characters) counting.

=head1 Improved code

  my ($filename) = @ARGV;
  open my $fh, '<', $filename or die $!;
  my ($lines, $words) = (0, 0);
  while ( defined(my $line = <$fh>) ) {
      $lines++;
      $words += scalar split /\s+/, $line;
  }
  close $fh;
  printf "%8d %8d\n", $lines, $words;

=cut
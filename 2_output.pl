#!/usr/bin/perl
print "There's more than one way to do it!" =~ /\s(?:.*\s)?(\w+?)/;

=pod

=head1 Output

i

=cut

=head1 Comments

  my $t = "There's more than one way to do it!";
  #        00000000001111111111222222222233333
  #        01234567890123456789012345678901234

  \s - Space. == substr($t, 7, 1)
  (?:pattern)? - Greedy match whole cluster 1 or 0 times. == substr($t, 8, 24)
      (?:pattern) - Clustering.
          .* - Greedy match any character 0 or more times.
          \s - Space.
  () - Capture. == substr($t, 32, 1)
      \w+? - Non-greedy match word character 1 or more times.

=cut
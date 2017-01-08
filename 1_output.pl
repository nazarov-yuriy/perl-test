#!/usr/bin/perl
print join ' ', sort reverse qw/6 10 3/;

=pod

=head1 Output

10 3 6

=cut

=head1 Comments

Initial thoughts were:
6 3 10

because reverse looks like sort's sub name argument like in the following code:

C<sub backwards { $b cmp $a }; print join ' ', sort backwards qw/6 10 3/;>

However, there are function L<reverse|http://perldoc.perl.org/functions/reverse.html> that can be called in LIST context with LIST argument.

So code

C<print join " ", sort reverse qw/6 10 3/;>

is equal to

C<print join " ", sort(  reverse( qw/6 10 3/ )  );>

what can be proved by getting the same output from a command perl -MO=Concise -e '<code>' for both of them

  f  <@> leave[1 ref] vKP/REFC ->(end)
  1     <0> enter ->2
  2     <;> nextstate(main 1 -e:1) v:{ ->3
  e     <@> print vK ->f
  3        <0> pushmark s ->4
  d        <@> join[t2] sK/2 ->e
  4           <0> pushmark s ->5
  5           <$> const[PV " "] s ->6
  c           <@> sort lK ->d
  6              <0> pushmark s ->7
  b              <@> reverse[t1] lKP/1 ->c
  7                 <0> pushmark s ->8
  8                 <$> const[PV "6"] s ->9
  9                 <$> const[PV "10"] s ->a
  a                 <$> const[PV "3"] s ->b

So it's just lexicographical(and not numerical) array sorting.

=cut
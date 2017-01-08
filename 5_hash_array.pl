#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use Data::Dumper;

my @data = (
    { name => 3, val => "Three" },
    { name => 1, val => "One" },
    { name => 2, val => "Two" },
    { name => 10, val => "Ten" }
);

@data = sort { $a->{name} <=> $b->{name} } @data;

print Dumper @data;

=pod

=head1 Code

Numerically sorting @data array of hashes with numeric values in "name" elements without any hardening:

  @data = sort { $a->{name} <=> $b->{name} } @data;

=cut
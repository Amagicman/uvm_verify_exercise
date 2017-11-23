#!/usr/bin/perl -w
use strict;
use Cwd;
use Getopt::Long;
use Data::Dumper;

##################################################
#subs
##################################################
sub get_database;
sub print_log;

##################################################
#vars
##################################################
my %all_ast_summary;
my %all_property;

my @all_colunms;
my @all_properties;

my $cur_dir = getcwd();

##################################################
#get options
##################################################
my $self_name = $0;

my $ast_summary_dir = $cur_dir;
my $ast_sum_log = "sva_merge.log";

#########################################
#main
##################################################
&get_database;
&print_log;

##print Dumper (\%all_ast_summary);
##print Dumper (\%all_property);
##################################################
#subs
##################################################
sub get_database{
  opendir (ASTD, "$ast_summary_dir") or die "$!\n";
    my @all_files_in_ast_log = readdir ASTD;
    for my $file_name (@all_files_in_ast_log) {
      next if ($file_name eq "." or $file_name eq "..");
      next if (-d $file_name);
      open (ASTF, "<$ast_summary_dir/$file_name") or die "$!\n";
        while (my $line = <ASTF>) {
          chomp $line;
          next if ($line =~ /at time/);
          next if ($line =~ /Summary/);
          if ($line =~ /Assertion Name/) {
            my $columns = $line;
            $line =~ s/^\s+(.*)\s+Assertion Name/$1 Assertion_Name/g;
            @all_colunms = split /\s+/,$line;
            $all_ast_summary{$file_name}{total}{unchecked} = 0;
          } elsif ($line =~ /Total Assertion/) {
            $all_ast_summary{$file_name}{total}{string} = $line;
          } else {
            $line =~ s/never/0/g;
            $line =~ s/(\s+)off(\s+)(\d)+/$1$3$2$3/g;
            $line =~ s/^\s+(.*)/$1/g;
            my @tmp_column = split /\s+/,$line;
            my $property_name = pop @tmp_column;
            for my $i(0 .. $#tmp_column) {
              if (exists $all_property{$property_name}) {
              } else {
                push @all_properties,$property_name;
              }
              if (exists $all_property{$property_name}{$all_colunms[$i]}) {
                $all_property{$property_name}{$all_colunms[$i]} += $tmp_column[$i];
              } else {
                $all_property{$property_name}{$all_colunms[$i]} = $tmp_column[$i];
              }
            }
            #if ($tmp_column[0] == 0 && $tmp_column[1] == 0 && $tmp_column[2] == 0) {
            if ($tmp_column[1] == 0 && $tmp_column[2] == 0) {
              $all_ast_summary{$file_name}{total}{unchecked} +=1;
            }
            for my $i(0 .. $#tmp_column) {
              $all_ast_summary{$file_name}{$property_name}{$all_colunms[$i]} = $tmp_column[$i];
            }
          }
        }
      close ASTF;
    }
  closedir ASTD;
}

sub print_log {
  open (OUTF,">$ast_sum_log") or die "$!\n";
  my @print_columns = ("Disabled","Finish","Failed");
  printf OUTF "%10s%10s%10s    Assertion Name\n",$print_columns[0],$print_columns[1],$print_columns[2];

  for my $property_name (@all_properties) {
    for my $i (0 .. $#print_columns) {
      printf OUTF "%10s",$all_property{$property_name}{$all_colunms[$i]};
    }
    printf OUTF "    %s\n",$property_name;
  }

  print OUTF "\nTotal:\n";
  for my $ast_sum_name (sort keys %all_ast_summary) {
    my $total_line = $all_ast_summary{$ast_sum_name}{total}{string};
    my $cur_unchecked = $all_ast_summary{$ast_sum_name}{total}{unchecked};
    if ($cur_unchecked == 0 ) {
      printf OUTF "%-108s:%s\n",$ast_sum_name,$total_line;
    } else {
      $total_line =~ s/Unchecked Assertions = 0/Unchecked Assertions = $cur_unchecked/g;
      printf OUTF "%-108s:%s\n",$ast_sum_name,$total_line;
    }
  }

  close OUTF;

  print "Done! Please check $ast_sum_log\n";
}




#!/usr/bin/perl

@dictionary = ("cd", "echo", "ls", "cat", "man",
    "which", "chsh", "whereis", "passwd", "date",
    "cal", "clear", "sleep", "alias", "unalias",
    "history", "apropos", "exit", "logout", "shutdown",
    "more", "less", "touch", "cp", "mv",
    "rm", "script", "find", "mkdir", "pwd",
    "rmdir", "chmod", "grep", "awk", "exit",
    "expr", "sudo", "tar", "sort", "fgrep",
    "input", "output", "computer", "chocolate",
    "rabbit", "tiger", "elephant", "giraffe",
    "pizza", "burger", "zebra", "rhinoceroses",
    "cheese", "touch", "script", "terminal");

$threshold = 2;
$dict_size = @dictionary;

print ("Enter the input:\n");
while(<STDIN>)
{
    my $variable1;
    my @input=();
    my @output=();
    for my $word (split)
    {
        push(@input, $word);
    }
    my $num_inputs = @input;
    for( my $i = 0; $i < $num_inputs; $i++)
    {
        my $min_dist = 100;
        my $dist;
        for( my $j = 0; $j < $dict_size; $j++)
        {
            $dist = levenshtein($input[$i], $dictionary[$j]);
            if ( $dist < $min_dist )
            {
                $min_dist = $dist;
            }
        }
        if ( $min_dist == 0 )
        {
            push(@output, $input[$i]);
        }
        elsif ( $min_dist > $threshold )
        {
            push(@output, $input[$i]);
            print "\n";
            print "No word found in dictionary similar to $input[$i]. Hence can't tell if it's correct or not.";
            print "\n";
        }
        else
        {
            print "\n";
            print "Suggesting correct words for $input[$i]:";
            print "\n";
            my $yn;
            for ( my $j = 0; $j < $dict_size; $j++)
            {
                $dist = levenshtein($input[$i], $dictionary[$j]);
                if ( $dist <= $threshold )
                {
                    print "$dictionary[$j] [y/n] ?";
                    print "\n";
                    $yn = <STDIN>;
                    chomp $yn;
                    if ( $yn eq "y" )
                    {
                        print "Corrected the word.";
                        print "\n";
                        push(@output, $dictionary[$j]);
                        last;
                    }
                    elsif ( $yn eq "n" )
                    {
                        next;
                    }
                }
            }
            if ( $yn eq "n" )
            {
                print "Keeping the word as it is since all the suggestions have been rejected.";
                print "\n";
                push(@output, $input[$i]);
            }
        }
    }
    print "\n";
    print "The corrected input is:";
    print "\n";
    for ( $i = 0; $i < $num_inputs; $i++)
    {
        print "$output[$i] ";
    }
    print "\n";
    print "\n";
    print "Do you want to give another input? [y/n] ?";
    print "\n";
    my $yn = <STDIN>;
    chomp $yn;
    if ( $yn eq "n" )
    {
        print "Quitting.";
        print "\n";
        last;
    }
    elsif ( $yn eq "y" )
    {
        print ("\nEnter the input:\n");
    }
}

sub levenshtein
{
    my ($abcd, $pqrs) = @_;
    my ($length1, $length2) = (length $abcd, length $pqrs);

    my %myMatrix;

    for (my $i = 0; $i <= $length1; ++$i)
    {
        for (my $j = 0; $j <= $length2; ++$j)
        {
            $myMatrix{$i}{$j} = 0;
            $myMatrix{0}{$j} = $j;
        }

        $myMatrix{$i}{0} = $i;
    }

    my @ar1 = split(//, $abcd);
    my @ar2 = split(//, $pqrs);

    for (my $i = 1; $i <= $length1; ++$i)
    {
        for (my $j = 1; $j <= $length2; ++$j)
        {
            my $cost;
            if ($ar1[$i-1] eq $ar2[$j-1]){
                $cost = 0;
            }
            else{
                $cost = 1;
            }

            $myMatrix{$i}{$j} = min([$myMatrix{$i-1}{$j} + 1, $myMatrix{$i}{$j-1} + 1, $myMatrix{$i-1}{$j-1} + $cost]);
        }
    }

    return $myMatrix{$length1}{$length2};
}

sub min
{
    my @list = @{$_[0]};
    my $min = $list[0];

    foreach my $i (@list)
    {
        $min = $i if ($i < $min);
    }

    return $min;
}
#!/usr/bin/perl -w
#
# $Id: check_log2.pl 1300 2005-12-16 18:41:45Z harpermann $
#
# Log file regular expression detector for Nagios.
# Written by Aaron Bostick (abostick@mydoconline.com)
# Last modified: 05-02-2002
#
# Thanks and acknowledgements to Ethan Galstad for Nagios and the check_log
# plugin this is modeled after.
#
# Usage: check_log2 -l <log_file> -s <seek_file> -p <pattern> [-n <negpattern>]
#
# Description:
#
# This plugin will scan arbitrary text files looking for regular expression 
# matches.  The text file to scan is specified with <log_file>.
# <log_seek_file> is a temporary file used to store the seek byte position
# of the last scan.  This file will be created automatically on the first 
# scan.  <pattern> can be any RE pattern that perl's s/// syntax accepte.  Be
# forewarned that a bad pattern will send this script into never never land!
#
# Output:
#
# This plugin returns OK when a file is successfully scanned and no pattern
# matches are found.  WARNING is returned when 1 or more patterns are found 
# along with the pattern count and the line of the last pattern matched.
# CRITICAL is returned when an error occurs, such as file not found, etc.
#
# Notes (paraphrased from check_log's notes):
#
#    1.  The "max_attempts" value for the service should be 1, as this
#        will prevent Nagios from retrying the service check (the
#        next time the check is run it will not produce the same results).
#
#    2.  The "notify_recovery" value for the service should be 0, so that
#        Nagios does not notify you of "recoveries" for the check.  Since
#        pattern matches in the log file will only be reported once and not
#        the next time, there will always be "recoveries" for the service, even
#        though recoveries really don't apply to this type of check.
#
#    3.  You *must* supply a different <log_Seek_file> for each service that
#        you define to use this plugin script - even if the different services
#        check the same <log_file> for pattern matches.  This is necessary
#        because of the way the script operates.
#
# Examples:
#
# Check for error notices in messages
#   check_log2 -l /var/log/messages -s ./check_log2.messages.seek -p 'err'
#


BEGIN {
    if ($0 =~ s/^(.*?)[\/\\]([^\/\\]+)$//) {
        $prog_dir = $1;
        $prog_name = $2;
    }
}

require 5.004;
use Time::Local;
use lib $main::prog_dir;
use lib "/tecnol/util";
use utils qw($TIMEOUT %ERRORS &print_revision &support &usage);
use Getopt::Long;
use POSIX qw(strftime);
my  ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks);
my $email = 'operaciones@coto.com.ar';
my $subject = 'Alerta Firewall IPTables';
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$year += 1900;
$mon++;

################
sub envia_mail(){

my $sourceip = $1 if $pattern_line =~ m/(SRC=.*DST)/;
my $destip = $1 if $pattern_line =~ m/(DST=.*LEN)/;
my $sourceport = $1 if $pattern_line =~ m/(SPT=.*DPT)/;
my $destport = $1 if $pattern_line =~ m/(DPT=.*WINDOW)/;
my $porttype = $1 if $pattern_line =~ m/(PROTO=.*SPT)/;
my $tcpudp = '';

$sourceip =~ s/DST//g;
$destip =~ s/LEN//g;
$sourceport =~ s/DPT//g;
$destport =~ s/WINDOW//g;
$porttype =~ s/PROTO=//g;
$tcpudp = $porttype =~ s/SPT//g; 
$sucursal = substr($pattern_line, 16, 6);

	open MAIL, "| /bin/mailx -s '$subject' -v $email";
	print MAIL "***** ALERTA IPTABLES *****\n\n";	
	print MAIL "Tipo de Notificacion: BLOQUEO DE CONEXION:\n";
	print MAIL "Equipo: $sucursal\n\n";	
	print MAIL "DESCRIPCION:\n\n";
	print MAIL "IP De Origen: $sourceip \n";
	print MAIL "IP De Destino: $destip \n";
	print MAIL "Puerto De Origen: $sourceport \n";
	print MAIL "Puerto De Destino: $destport \n";
	print MAIL "Tipo de Conexion: $porttype \n";
	 
	print MAIL "\n";
	print MAIL "Fecha/Hora: $mday/$mon/$year $hour:$min:$sec\n";
	print MAIL "Departamento de Sistemas / Administracion UNIX \n\n";

}


##############

sub print_usage ();
sub print_version ();
sub print_help ();

    # Initialize strings
    $log_file = '';
    $seek_file = '';
    $critical = '';
    
    # Cuando lo ejecutaba desde el cron, pasandole el pattern como parametro
    # era lo primero que marcheaba, DENEGADO, asi que nunca cumplia con la
    # condicion de buscar mismo DENEGADO de lo que tiraba el firewall, asi
    # que se lo dejo embebido. Lo que inventan estos chinos!!
    $re_pattern = 'DENEGADO';
    
    $neg_re_pattern = '';
    $pattern_count = 0;
    $pattern_line = '';
    $plugin_revision = '$Revision: 1300 $ ';

    # Grab options from command line
    GetOptions
    ("l|logfile=s"      => \$log_file,
     "s|seekfile=s"     => \$seek_file,
     "c|critical"       => \$critical,
     "p|pattern=s"      => \$re_pattern,
     "n|negpattern:s"   => \$neg_re_pattern,
     "v|version"        => \$version,
     "h|help"           => \$help);

    !($version) || print_version ();
    !($help) || print_help ();

    # Make sure log file is specified
    ($log_file) || usage("Log file not specified.\n");
    # Make sure seek file is specified
    ($seek_file) || usage("Seek file not specified.\n");
    # Make sure re pattern is specified
    ($re_pattern) || usage("Regular expression not specified.\n");

    # Open log file
    open (LOG_FILE, $log_file) || die "Unable to open log file $log_file: $!";

    # Try to open log seek file.  If open fails, we seek from beginning of
    # file by default.
    if (open(SEEK_FILE, $seek_file)) {
        chomp(@seek_pos = <SEEK_FILE>);
        close(SEEK_FILE);

        #  If file is empty, no need to seek...
        if ($seek_pos[0] != 0) {
            
            # Compare seek position to actual file size.  
			# If file size is smaller
            # then we just start from beginning i.e. file was rotated, etc.
            ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks) = stat(LOG_FILE);

            if ($seek_pos[0] <= $size) {
                seek(LOG_FILE, $seek_pos[0], 0);
            }
        }
    }

    # Loop through every line of log file and check for pattern matches.
    # Count the number of pattern matches and remember the full line of 
    # the most recent match.
    while (<LOG_FILE>) {
        if ($neg_re_pattern) {
            if ((/$re_pattern/) && !(/$neg_re_pattern/)) {
                $pattern_count += 1;
                $pattern_line = $_;
            }
        } elsif (/$re_pattern/) {
                $pattern_count += 1;
                $pattern_line = $_;

        }
    }

    # Overwrite log seek file and print the byte position we have seeked to.
    open(SEEK_FILE, "> $seek_file") || die "Unable to open seek count file $seek_file: $!";
    print SEEK_FILE tell(LOG_FILE);

    # Close seek file.
    close(SEEK_FILE);
    # Close the log file.
    close(LOG_FILE);

    # Print result and return exit code.
    if ($pattern_count) {
		if ($critical) { 
			print "CRITICAL: ";
		} else {
			print "WARNING: ";
		}
        print "($pattern_count): $pattern_line";
		if ($critical) {
			envia_mail();
			exit $ERRORS{'CRITICAL'};
		} else {
			exit $ERRORS{'WARNING'}; 
		}
    } else {
        print "OK - No matches found.\n";
        exit $ERRORS{'OK'};
    }

#
# Subroutines
#

##############
#
sub print_usage () {
    print "Usage: $prog_name -l <log_file> -s <log_seek_file> -p <pattern> [-n <negpattern>] -c | --critical\n";
    print "Usage: $prog_name [ -v | --version ]\n";
    print "Usage: $prog_name [ -h | --help ]\n";
}

sub print_version () {
    print_revision($prog_name, $plugin_revision);
    exit $ERRORS{'OK'};
}

sub print_help () {
    print_revision($prog_name, $plugin_revision);
    print "\n";
    print "Scan arbitrary log files for regular expression matches.\n";
    print "\n";
    print_usage();
    print "\n";
    print "-l, --logfile=<logfile>\n";
    print "    The log file to be scanned\n";
    print "-s, --seekfile=<seekfile>\n";
    print "    The temporary file to store the seek position of the last scan\n";
    print "-p, --pattern=<pattern>\n";
    print "    The regular expression to scan for in the log file\n";
    print "-n, --negpattern=<negpattern>\n";
    print "    The regular expression to skip in the log file\n";
    print "-c, --critical\n";
    print "    Return critical instead of warning on error\n";
    print "\n";
    support();
    exit $ERRORS{'OK'};
}

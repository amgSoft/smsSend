#!/usr/bin/perl -w

## Sending sms through local gateway


use strict;
use DBI;
use MIME::Lite;
use Routine;

my $dbh = DBI->connect($INSTANCE_My,$USER_My,$PASSWD_My,{PrintError => 1, RaiseError => 1, LongReadLen => 64000, LongTruncOk => 0}) or die "DB connect is failed\n";

my $sth1 = $dbh->prepare(qq{SELECT * FROM sms_send_w});

my $sth2 = $dbh->prepare(qq{INSERT INTO sms_log SET aid = ?, balance = ?, contract = ?, tell = ?, prz = '1',date = sysdate()});

$sth1->execute() or die "$sth1->errstr";
my $arr_data = $sth1->fetchall_arrayref;
my $rc = $sth1->finish;
my $count = 0;

for my $i (0..$#{$arr_data})
        {
         my ($aid,$balance,$contract,$tell,$dat); 
         $aid = $arr_data->[$i][0];
         $balance = $arr_data->[$i][1];
         $contract = $arr_data->[$i][2];
         $tell = $arr_data->[$i][3];
         $dat = $arr_data->[$i][4];
         
         $tell = format_number($tell);
         
         if ($tell ne "")
            { 

my $text = "Shanovnyi abonente, na $dat stan rakhunku
 po dohovoru $contract stanovyt $balance UAH.
 Popovniuite rakhunok myttievo ta bez cherh: damain.com/portmone";

&sms_send($tell, $text);
                $sth2->execute($aid,$balance,$contract,$tell);
                $count++;
            }
            sleep(3);
          }
          mail(my $sms_info="-- it have been sent  today $count СМС today --");
exit;

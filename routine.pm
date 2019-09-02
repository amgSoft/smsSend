package Routine;

BEGIN
    {
    use Exporter();
    @ISA = qw(Exporter);
    @EXPORT = qw($USER_My $PASSWD_My $INSTANCE_My &crop &format_number &sms_send &mail);
  #  @EXPORT = '&crop()';
    }
$USER_My = "dbname";
$PASSWD_My = "dbpass";
$INSTANCE_My = join ';','DBI:mysql:database=127.0.0.1','mysql_read_default_group=perl','mysql_read_default_file=/etc/my.cnf';


sub crop($) {my $go=$_[0];$go=~s/^\s+//;$go=~s/\n+$//;$go=~s/\s+$//;return $go;};


sub mail($){
      my $text = $_[0];
      my $msg = MIME::Lite->new (
      From =>'SMS Info <sms_info@domain.com.>',
      To =>'admin@domain.com.',
      Subject =>'ATTENTION - sms info.',
      Type => 'text/plain; charset=UTF-8',
      Data =>"$text"
      );
      $msg->send;
};

sub sms_send($$)
{
      my($number,$text)=@_;
     # my $text = $_[0];
      my $msg = MIME::Lite->new (
      From =>'sms_info <SMS@domain.com.>',
      To =>"sms$number\@gsm.domain.",

      Data => $text
      );
      $msg->send;
};

sub format_number($)
      {
            my $number=$_[0];
            $number =~ s/\D+//g; # удаляем лишние символы в номере
            if ($number =~ m/^\d{9}$/){$number = "0$number";} # добавляем нуль в начале номера
            if ($number =~ m/^\d{12}$/){$number =~ /(\d{10})$/;$number = $1;} #отрезаем лишние цивры в номере
            if ($number =~ m/^\d{10,12}$/){$number =~ /(\d{10})$/;$number = $1;} #отрезаем лишние цивры в номере
            if ($number =~ m/^\d{0,8}$/){$number = "";} #возвращеем пустую строку в случаи не правильного номера
            
            if ($number =~ m/^[0][0-4]\d+$/){$number = "";} #возвращаем пустую значение если код оператора не начинается с 5
            if ($number =~ m/^[1-9]\d+$/){$number = "";} #возвращаем пустую строку если первая цифра не 0
      return $number;
      }
      
return 1;
END{}

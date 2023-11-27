use Plack::App::CGIBin;
use Plack::Builder;
use HTTP::Server::PSGI;
use Plack::App::File;
use lib "/opt/ofork";
use lib "/opt/ofork/Kernel/cpan-lib";

my $app = Plack::App::CGIBin->new(
    root => "/opt/ofork/bin/cgi-bin",
    exec_cb => sub { 1 }
    )->to_app;
my $app_web = Plack::App::File->new(root => "/opt/ofork/var/httpd/htdocs")->to_app;
builder {
      enable "StackTrace", force => $ENV{DEBUG_MODE};
      mount "/ofork" => $app;
      mount "/ofork-web" => $app_web;
};
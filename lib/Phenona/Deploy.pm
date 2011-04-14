package Phenona::Deploy;
BEGIN {
  $Phenona::Deploy::VERSION = '0.003';
}

# ABSTRACT: Phenona's internal deploy logic

use strict;
use warnings;

use Net::SFTP::Foreign;
use LWP::UserAgent;
use Carp;
use File::Path qw(make_path);

sub deploy {
    my $self = shift;
    my $params = shift;
    
    my $apikey    = $params->{apikey};
    my $projectid = $params->{projectid}; 
    
    my $sftp_host = 'deploy.phenona.com';
    
    my $sftp_user = substr($projectid, 0, 8);
    my $sftp_loc = '/phenona/code/' . $sftp_user . '/code';
    my $sftp_port = 22;

    warn "Pushing code to Phenona...\n";
    
    my $sftp = Net::SFTP::Foreign->new( host => $sftp_host, user => $sftp_user, port => $sftp_port );

    warn "Copying new code...\n";

    $sftp->rput( '.', $sftp_loc );
    die 'Unable to push code to Phenona: ' . $sftp->error . "\n. Did you update your SSH keys in the web interface?\n" if $sftp->error;
    
    my $deploy_url = 'http://www.phenona.com/api/deploy';
    my $data = {
	projectid  => $projectid,
	apikey     => $apikey,
    };
    
    warn "Deploying... (this will take a minute)\n";
    
    my $ua = LWP::UserAgent->new();
    my $res = $ua->post( $deploy_url, $data );
    
    if( $res->is_success ) {
	warn "App deployed successfully.\n";
    }
    else {
	warn "App did not deploy successfully. Please try again.\n";
    }
}

1;


__END__
=pod

=head1 NAME

Phenona::Deploy - Phenona's internal deploy logic

=head1 VERSION

version 0.003

=head1 DESCRIPTION

For now, an internal module used by the L<phenona> script to deploy the app.

=head1 AUTHOR

Daniil Kulchenko <daniil@kulchenko.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Daniil Kulchenko.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


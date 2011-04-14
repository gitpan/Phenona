
use strict;
use warnings;



use ExtUtils::MakeMaker 6.31;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'Deploy your code to the Phenona platform',
  'AUTHOR' => 'Daniil Kulchenko <daniil@kulchenko.com>',
  'BUILD_REQUIRES' => {
    'Test::More' => '0'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.31'
  },
  'DISTNAME' => 'Phenona',
  'EXE_FILES' => [
    'bin/phenona'
  ],
  'LICENSE' => 'perl',
  'NAME' => 'Phenona',
  'PREREQ_PM' => {
    'Carp' => '0',
    'File::Path' => '0',
    'IO::Prompt' => '0',
    'LWP::Simple' => '0',
    'LWP::UserAgent' => '0',
    'Net::SFTP::Foreign' => '0',
    'YAML::Any' => '0'
  },
  'VERSION' => '0.003',
  'test' => {
    'TESTS' => 't/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);




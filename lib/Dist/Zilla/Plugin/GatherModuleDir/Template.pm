package Dist::Zilla::Plugin::GatherModuleDir::Template;
use Moose;
use namespace::autoclean;

# ABSTRACT: A FileGatherer for Module Directories

extends qw(Dist::Zilla::Plugin::GatherDir::Template);

use String::Formatter method_stringf => {
    -as   => '_format_string',
    codes => {
        N => sub {
            my $seperator = $_[1] || '/';
            ( my $name = $_[0]->zilla->name ) =~ s[-][$seperator]g;
            return $name;
        },
    },
};

around prefix => sub {
    my ( $next, $self ) = @_;
    my $prefix = $self->$next();
    return _format_string( $prefix, $self );
};

__PACKAGE__->meta->make_immutable;
1;
__END__

package Dist::Zilla::Plugin::GatherModuleDir::Template;
use Moose;
use namespace::autoclean;

# ABSTRACT: A FileGatherer for Module Directories

extends qw(Dist::Zilla::Plugin::GatherDir);

has replace_dirname => (
    isa     => 'Str',
    is      => 'ro',
    default => 'Module'
);

sub _file_from_filename {
    my ( $self, $filename ) = @_;

    my $replace_dirname = $self->replace_dirname;
    my $name            = $self->zilla->name;
    ( my $newname = $filename ) =~ s/\Q$replace_dirname\E/$name/g;

    my $template = do {
        open my $fh, '<', $filename;
        local $/;
        <$fh>;
    };

    return Dist::Zilla::File::FromCode->new(
        {   name => $newname,
            mode => ( ( stat $filename )[2] & 0755 )
                | 0200,   # kill world-writeability, make sure owner-writable.
            code => sub {
                my ($file_obj) = @_;
                $self->fill_in_string(
                    $template,
                    {   dist   => \( $self->zilla ),
                        plugin => \($self),
                    },
                );
            },
        }
    );
}

__PACKAGE__->meta->make_immutable;
1;
__END__

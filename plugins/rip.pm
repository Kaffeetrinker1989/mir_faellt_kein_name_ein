# Copyright (C) 2005-2007 Quentin Sculo <squentin@free.fr>
#
# This file is part of Gmusicbrowser.
# Gmusicbrowser is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3, as
# published by the Free Software Foundation

=gmbplugin RIP
Rip
Rip plugin
Add a button to rip a CD
=cut

package GMB::Plugin::RIP;
use strict;
use warnings;
use constant
{	OPT => 'PLUGIN_RIP_',#used to identify the plugin and its options
};

::SetDefaultOptions(OPT, program => 'soundjuicer');

my %Programs= #id => [name,cmd]
(	soundjuicer => ['sound-juicer','sound-juicer'],
	grip => ['grip','grip'],
	xcfa => ['xcfa','xcfa'],
	custom => [_"custom"],
);

sub Start
{	ExtraWidgets::AddWidget(OPT.'button','button',\&CreateButton);
}
sub Stop
{	ExtraWidgets::RemoveWidget(OPT.'button');
}

sub prefbox
{	my $vbox=Gtk2::VBox->new(::FALSE, 2);
	my $sg1=Gtk2::SizeGroup->new('horizontal');
	my $sg2=Gtk2::SizeGroup->new('horizontal');
	my $entry=::NewPrefEntry(OPT.'custom', _"Custom command :",undef,$sg1,$sg2,undef,_('Command to launch when the button is pressed'));
	my %list= map {$_,$Programs{$_}[0]} keys %Programs;
	my $combo= ::NewPrefCombo
	 (	OPT.'program', \%list,
		_"Ripping software :",
		sub { $entry->set_sensitive( $::Options{OPT.'program'} eq 'custom' ) },
		$sg1,$sg2
	 );
	$entry->set_sensitive( $::Options{OPT.'program'} eq 'custom' );
	$vbox->pack_start($_,::FALSE,::FALSE,2) for $combo,$entry;
	return $vbox;
}

sub CreateButton
{	my $button=::NewIconButton('plugin-rip',undef,\&Launch);
	return $button;
}

sub Launch
{	my $program=$::Options{OPT.'program'};
	my $cmd=$program eq 'custom' ?
		 $::Options{OPT.'custom'} :
		 $Programs{$program}[1];
	::forksystem($cmd) if $cmd;
}

1;

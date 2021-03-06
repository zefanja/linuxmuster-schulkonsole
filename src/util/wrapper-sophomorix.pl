#! /usr/bin/perl

=head1 NAME

wrapper-sophomorix.pl - wrapper for sophomorix access

=head1 SYNOPSIS

 my $id = $userdata{id};
 my $password = 'secret';
 my $app_id = Schulkonsole::Config::PRINTERINFOAPP;

 open SCRIPT, "| $Schulkonsole::Config::_wrapper_sophomorix";
 print SCRIPT <<INPUT;
 $id
 $password
 $app_id

 INPUT

=head1 DESCRIPTION

=cut
use strict;
use lib '/usr/share/schulkonsole';
use open ':utf8';
use open ':std';
use Schulkonsole::Wrapper;
use POSIX;
use Data::Dumper;
use Encode;
use Sophomorix::SophomorixAPI;
use Sophomorix::SophomorixConfig;
use Schulkonsole::Config;
use Schulkonsole::DB;
use Schulkonsole::Error::Error;
use Schulkonsole::Error::SophomorixError;

# --encoding-*-*
my %supported_encodings = qw(
    ascii    ascii
    8859-1   iso-8859-1
    8859-15  iso-8859-15
    win1252  cp1252
    utf8     utf8
);
my $userdata=Schulkonsole::Wrapper::wrapper_authenticate();
my $id = $$userdata{id};

my $app_id = Schulkonsole::Wrapper::wrapper_authorize($userdata);

SWITCH: {
$app_id == Schulkonsole::Config::SHARESTATESAPP and do {
	sharestatesapp();
	last SWITCH;
};

$app_id == Schulkonsole::Config::SHARESONOFFAPP and do {
	sharesonoff();
	last SWITCH;
};

$app_id == Schulkonsole::Config::FILEMANAPP and do {
	filemanapp();
	last SWITCH;
};

$app_id == Schulkonsole::Config::STUDENTSFILEMANAPP and do {
	studentsfilemanapp();
	last SWITCH;
};

$app_id == Schulkonsole::Config::LSHANDEDOUTAPP and do {
	lshandedoutapp();
	last SWITCH;
};

$app_id == Schulkonsole::Config::LSHANDOUTAPP and do {
	lshandoutapp();
	last SWITCH;
};

$app_id == Schulkonsole::Config::LSCOLLECTAPP and do {
	lscollectapp();
	last SWITCH;
};

$app_id == Schulkonsole::Config::HANDOUTAPP and do {
	handoutapp();
	last SWITCH;
};

$app_id == Schulkonsole::Config::COLLECTAPP and do {
	collectapp();
	last SWITCH;
};

$app_id == Schulkonsole::Config::RESETROOMAPP and do {
	resetroomapp();
	last SWITCH;
};

$app_id == Schulkonsole::Config::EDITOWNCLASSMEMBERSHIPAPP and do {
	editownclassmembershipapp();
	last SWITCH;
};

$app_id == Schulkonsole::Config::PROJECTMEMBERSAPP and do {
	projectmembersapp();
	last SWITCH;
};

$app_id == Schulkonsole::Config::PROJECTCREATEDROPAPP and do {
	projectcreatedropapp();
	last SWITCH;
};

$app_id == Schulkonsole::Config::PROJECTWLANDEFAULTSAPP and do {
	project_wlan_defaults();
	last SWITCH;
};

$app_id == Schulkonsole::Config::PRINTCLASSAPP and do {
	printclassapp();
	last SWITCH;
};

$app_id == Schulkonsole::Config::PRINTALLUSERSAPP and do {
	print_allusers();
	last SWITCH;
};
$app_id == Schulkonsole::Config::PRINTCOMMITAPP and do {
	print_commit();
	last SWITCH;
};
$app_id == Schulkonsole::Config::LSCOMMITSAPP and do {
	ls_commits();
	last SWITCH;
};
$app_id == Schulkonsole::Config::LSCOMMITAPP and do {
	ls_commit();
	last SWITCH;
};
$app_id == Schulkonsole::Config::PRINTTEACHERSAPP and do {
	printteachersapp();
	last SWITCH;
};

$app_id == Schulkonsole::Config::PRINTPROJECTAPP and do {
	printprojectapp();
	last SWITCH;
};

$app_id == Schulkonsole::Config::SETPASSWORDSAPP and do {
	setpasswordsapp();
	last SWITCH;
};

$app_id == Schulkonsole::Config::READSOPHOMORIXFILEAPP and do {
	readsophomorixfileapp();
	last SWITCH;
};

$app_id == Schulkonsole::Config::WRITESOPHOMORIXFILEAPP and do {
	writesophomorixfileapp();
	last SWTICH;
};

$app_id == Schulkonsole::Config::USERSCHECKAPP and do {
	userscheckapp();
	last SWITCH;
};

(   $app_id == Schulkonsole::Config::USERSADDAPP
 or $app_id == Schulkonsole::Config::USERSMOVEAPP
 or $app_id == Schulkonsole::Config::USERSKILLAPP) and do {
	users_add_or_move_or_killapp();
	last SWITCH;
};
 
$app_id == Schulkonsole::Config::USERSADDMOVEKILLAPP and do {
	usersaddmovekillapp();
	last SWITCH;
};

$app_id == Schulkonsole::Config::TEACHINAPP and do {
	teachinapp();
	last SWITCH;
}; 

$app_id == Schulkonsole::Config::CHMODAPP and do {
	chmodapp();
	last SWITCH;
};

$app_id == Schulkonsole::Config::SETQUOTAAPP and do {
	setquotaapp();
	last SWITCH;
};

$app_id == Schulkonsole::Config::SETOWNPASSWORDAPP and do {
	setownpasswordapp();
	last SWITCH;
};

$app_id == Schulkonsole::Config::HIDEUNHIDECLASSAPP and do {
	hideunhideclassapp();
	last SWITCH;
};

$app_id == Schulkonsole::Config::SETMYMAILAPP and do {
	set_mymailapp();
	last SWITCH;
};

$app_id == Schulkonsole::Config::CHANGEMAILALIASCLASSAPP and do {
	changemailaliasclassapp();
	last SWITCH;
};

$app_id == Schulkonsole::Config::CHANGEMAILLISTCLASSAPP and do {
	changemaillistclassapp();
	last SWITCH;
};

$app_id == Schulkonsole::Config::CHANGEMAILALIASPROJECTAPP and do {
	changemailaliasprojectapp();
	last SWITCH;
};

$app_id == Schulkonsole::Config::CHANGEMAILLISTPROJECTAPP and do {
	changemaillistprojectapp();
	last SWITCH;
};

$app_id == Schulkonsole::Config::PROJECTJOINNOJOINAPP and do {
	projectjoinnojoinapp();
	last SWITCH;
};

}



exit -2;	# program error

=head3 share_states

numeric constant: C<Schulkonsole::Config::SHARESTATESAPP>

=head4 Parameters from standard input

=over

=item login_id

IDs (not UIDs) of users. One per line, end with empty line

=back

=cut
sub sharestatesapp() {
	my @login_ids;

	while (my $login_id = <>) {
		last if $login_id =~ /^$/;
		($login_id) = $login_id =~ /^(\d+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_USERID )
			unless $login_id;

		push @login_ids, $login_id;
	}
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_NO_USERIDS )
		unless @login_ids;

	my %share_states;
        # this is badly hard coded...
	my $acl_list=`getfacl /home/share 2> /dev/null`;

	foreach my $login_id (@login_ids) {
		my $login_userdata = Schulkonsole::DB::get_userdata_by_id($login_id);
		next unless $login_userdata;
	
	        my $login_name= $$login_userdata{uid};
		my $denystring="user:".$login_name.":---";

                if ( $acl_list =~ m/$denystring/ ) {
			$share_states{$login_id} = '';
		} else {
			$share_states{$login_id} = 1;
		}
	}

	my $data = Data::Dumper->new([ \%share_states ]);
	$data->Terse(1);
	$data->Indent(0);
	print $data->Dump;

	exit 0;
}

=head3 shares_on_off

numeric constant: C<Schulkonsole::Config::SHARESONOFF>

=head4 Parameters from standard input

=over

=item on

C<1> (on) or C<0> (off)

=item users

UIDs one per line, end with empty line

=back

=cut
sub sharesonoff() {
	my $on = <>;
	($on) = $on =~ /^(\d+)$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_ON_UNDEFINED )
		unless defined $on;


	my @users;

	while (my $user = <>) {
		last if $user =~ /^$/;
		($user) = $user =~ /^(.+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_USER )
			unless $user;

		push @users, "\Q$user";
	}
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_NO_USERS )
		unless @users;

	my $opts = "--teacher \Q$$userdata{uid}\E "
		. ($on ? '--shares' : '--noshares')
		. ' --users ' . join(',', @users);

	# sophomorix-teacher cannot be invoked with taint checks enabled
	$< = $>;
	$( = $);
	exec Schulkonsole::Encode::to_cli(
	     	"$Schulkonsole::Config::_cmd_sophomorix_teacher $opts")
		or return;
}

=head3 fileman

numeric constant: C<Schulkonsole::Config::FILEMANAPP>

=head4 Parameters from standard input

=over

=item action

action to do: remove - 1/add - 2/download - 3

=item category

dir to work on: 0-handout, 1-handoutcopy, 2-collect

=item type

=item project (if type 8)

=item filename

=back

=cut

sub filemanapp() {
	my $action = <>;
	($action) = $action =~ /^(\d+)$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_ACTION )
		unless defined $action;
	
	my $category = <>;
	($category) = $category =~ /^(\d+)$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_DO_COPY )
		unless defined $category;


	my $share_dir = "$$userdata{homedirectory}/";

	if ($category == 2) {
		$share_dir .=
			"$Language::collected_dir/$Language::collected_string";
	} elsif ($category == 1) {
		$share_dir .=
			"$Language::to_handoutcopy_dir/$Language::to_handoutcopy_string";
	} else {
		$share_dir .= "$Language::handout_dir/$Language::handout_string";
	}

	my $type = <>;
	($type) = $type =~ /^(\d+)/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_TYPE )
		unless defined $type;

	LSHANDOUTTYPE: {
	($type & 1 or $type & 2) and do {
		if ($category == 1) {
				$share_dir .= $Language::current_room;
		} else {
				$share_dir .= $Language::exam;
		}
		last LSHANDOUTTYPE;
	};
	($type & 4) and do {
		my $project = <>;
		($project) = $project =~ /^(.+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_PROJECT )
			unless $project;
		$share_dir .= $project;
		last LSHANDOUTTYPE;
	};
	($type & 8) and do {
		my $class = <>;
		($class) = $class =~ /^(.+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_CLASS )
			unless $class;
		$share_dir .= $class;
		last LSHANDOUTTYPE;
	};
	($type & 16) and do {
		my $subclass = <>;
		($subclass) = $subclass =~ /^(.+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_SUBCLASS )
			unless $subclass;
		$share_dir .= $subclass;
		last LSHANDOUTTYPE;
	};
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FROM );
	}
	chdir Schulkonsole::Encode::to_fs($share_dir)
		or exit (  Schulkonsole::Error::SophomorixError::WRAPPER_NO_SUCH_DIRECTORY );
	
	my $filename = <>;
	$filename =~ s/\R//g;
	($filename) = $filename =~ /^([^\.\/][^\0]*)$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FILENAME )
		unless defined $filename;
	$filename = get_decoded($filename);
	my $isdir = <>;
	($isdir) = $isdir =~ /^(\d+)$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FILETYPE )
		  unless (defined $isdir) and ($isdir =~ /0|1/);
	
	if($action == 1) { # remove
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_NO_SUCH_FILE )
			  unless -e "$share_dir/$filename";
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FILETYPE )
			  unless (-d "$share_dir/$filename" and $isdir) or 
			  		 (! -d "$share_dir/$filename" and ! $isdir);
		if($isdir) {
			system("rm -rf \"$share_dir/$filename\"");
		} else {
			system("rm -f \"$share_dir/$filename\"");
		}
	} elsif($action == 2) { # add
		my $fromfile = <>;
		$fromfile =~ s/\R//g;
		($fromfile) = $fromfile =~ /^([^\0]+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FILENAME )
			  unless defined $fromfile;
		$fromfile = get_decoded($fromfile);
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_NO_SUCH_FILE )
			  unless -e "$Schulkonsole::Config::_runtimedir/$fromfile";
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FILETYPE )
			  unless (-d "$Schulkonsole::Config::_runtimedir/$fromfile" and $isdir) or 
			  		 (! -d "$Schulkonsole::Config::_runtimedir/$fromfile" and ! $isdir);
		if( -e "$share_dir/$filename") { # make room for new file
			if( -d "$share_dir/$filename") {
				system("rm -rf \"$share_dir/$filename\"");
			} else {
				system("rm -f \"$share_dir/$filename\"");
			}
		}
		system("mv -f \"$Schulkonsole::Config::_runtimedir/$fromfile\" \"$share_dir/$filename\"");
		system("chown " . $$userdata{uid} . ":root \"$share_dir/$filename\"");
		system("chmod 640 \"$share_dir/$filename\"");
	} elsif($action == 3) { # download
		my $tofile = <>;
		$tofile =~ s/\R//g;
		($tofile) = $tofile =~ /^([^\0]+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FILENAME )
			  unless defined $tofile;
		$tofile = get_decoded($tofile);
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_NO_SUCH_FILE )
			  unless -e "$share_dir/$filename";
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FILETYPE )
			  unless (-d "$share_dir/$filename" and $isdir) or 
			  		 (! -d "$share_dir/$filename" and ! $isdir);
		if( -e "$Schulkonsole::Config::_runtimedir/$tofile") { # make room for the file
			if( -e "$Schulkonsole::Config::_runtimedir/$tofile") {
				system("rm -rf \"$Schulkonsole::Config::_runtimedir/$tofile\"");
			} else {
				system("rm -f \"$Schulkonsole::Config::_runtimedir/$tofile\"");
			}
		}
		if($isdir){
			system("mkdir -p \"$Schulkonsole::Config::_runtimedir/$tofile\"");
			system("cd \"$share_dir/$filename\";cp -R * \"$Schulkonsole::Config::_runtimedir/$tofile\"");
			system("cd \"$Schulkonsole::Config::_runtimedir/$tofile\";zip -r \"../${tofile}.zip\" .");
			system("chown www-data:www-data \"$Schulkonsole::Config::_runtimedir/${tofile}.zip\"");
			system("rm -rf $Schulkonsole::Config::_runtimedir/$tofile");
		} else {
			system("cp \"$share_dir/$filename\" \"$Schulkonsole::Config::_runtimedir/$tofile\"");			
			system("chown www-data:www-data \"$Schulkonsole::Config::_runtimedir/$tofile\"");
		}
	} else {
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_ACTION_NOT_SUPPORTED );
	}
	
	exit 0;
}

=head3 studentsfileman

numeric constant: C<Schulkonsole::Config::STUDENTSFILEMANAPP>

=head4 Parameters from standard input

=over

=item action (one of dl - 3/rm - 1/ul - 2)

=item category (one of 0 - handedout, 1 - handedoutcopy, 2 - tocollect)

=item type (one of 1/2 - current_room/exam, 4 - project, 8 - class, 16 - subclass)

=item project (if type 4)/teacher (if type 8 and category 0)/subclass (if type 16)

=item teacher (if type 4 and category 0)

=item filename

=back

=cut
sub studentsfilemanapp() {
	my $action = <>;
	($action) = $action =~ /^(\d+)$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_ACTION )
		unless defined $action;
	
	my $category = <>;
	($category) = $category =~ /^(\d+)$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_DO_COPY )
		unless defined $category;


	my $share_dir = "$$userdata{homedirectory}/";

	if ($category == 2) {
		$share_dir .=
			"$Language::collect_dir";
	} elsif ($category == 1) {
		$share_dir .=
			"$Language::handoutcopy_dir/$Language::handoutcopy_string";
	} else {
		$share_dir = "$DevelConf::tasks_tasks";
	}

	my $type = <>;
	($type) = $type =~ /^(\d+)$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_TYPE )
		unless defined $type;

	LSHANDOUTTYPE: {
	($type =~ /^1|2|4|8|16$/) and ($category == 2) and do {
		last LSHANDOUTTYPE;
	};
	($type & 1 or $type & 2) and do {
		if ($category) {
				$share_dir .= $Language::current_room;
		} else {
				$share_dir .= $Language::exam;
		}
		last LSHANDOUTTYPE;
	};
	($type & 4) and do {
		my $project = <>;
		($project) = $project =~ /^(.+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_PROJECT )
			unless $project;
		$share_dir .= ($category?"":"/projects/") . $project;
		if($category == 0) {
			my $teacher = <>;
			($teacher) = $teacher =~ /^(.+)$/;
			exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_PROJECT_TEACHER )
				unless $teacher;
			$share_dir .= '/' . $teacher;
		}
		last LSHANDOUTTYPE;
	};
	($type & 8) and do {
		$share_dir .= ($category?"":"/classes/") . $$userdata{gid};
		if($category == 0){
			my $teacher = <>;
			($teacher) = $teacher =~ /^(.+)$/;
			exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_CLASS_TEACHER )
				unless $teacher;
			$share_dir .= '/' . $teacher;
		}
		last LSHANDOUTTYPE;
	};
	($type & 16) and do {
		my $subclass = <>;
		($subclass) = $subclass =~ /^(.+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_SUBCLASS )
			unless $subclass;
		$share_dir .= ($category?"":"/subclasses/") . $subclass;
		last LSHANDOUTTYPE;
	};
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FROM );
	}

	chdir Schulkonsole::Encode::to_fs($share_dir)
		or exit (  Schulkonsole::Error::SophomorixError::WRAPPER_NO_SUCH_DIRECTORY );
	
	my $filename = <>;
	$filename =~ s/\R//g;
	($filename) = $filename =~ /^([^\.\/][^\0]*)$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FILENAME )
		unless defined $filename;
	$filename = get_decoded($filename);
	my $isdir = <>;
	($isdir) = $isdir =~ /^(\d+)$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FILETYPE )
		  unless (defined $isdir) and ($isdir =~ /0|1/);
	
	if($action == 1) { # remove
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_NO_SUCH_FILE )
			  unless -e "$share_dir/$filename";
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FILETYPE )
			  unless (-d "$share_dir/$filename" and $isdir) or 
			  		 (! -d "$share_dir/$filename" and ! $isdir);
		if($isdir) {
			system("rm -rf \"$share_dir/$filename\"");
		} else {
			system("rm -f \"$share_dir/$filename\"");
		}
	} elsif($action == 2) { # upload
		my $fromfile = <>;
		$fromfile =~ s/\R//g;
		($fromfile) = $fromfile =~ /^([^\0]+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FILENAME )
			  unless defined $fromfile;
		$fromfile = get_decoded($fromfile);
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_NO_SUCH_FILE )
			  unless -e "$Schulkonsole::Config::_runtimedir/$fromfile";
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FILETYPE )
			  unless (-d "$Schulkonsole::Config::_runtimedir/$fromfile" and $isdir) or 
			  		 (! -d "$Schulkonsole::Config::_runtimedir/$fromfile" and ! $isdir);
		if( -e "$share_dir/$filename") { # make room for new file
			if( -d "$share_dir/$filename") {
				system("rm -rf \"$share_dir/$filename\"");
			} else {
				system("rm -f \"$share_dir/$filename\"");
			}
		}
		system("mv -f \"$Schulkonsole::Config::_runtimedir/$fromfile\" \"$share_dir/$filename\"");
		system("chown " . $$userdata{uid} . ":teachers \"$share_dir/$filename\"");
		system("chmod 640 \"$share_dir/$filename\"");
	} elsif($action == 3) { # download
		my $tofile = <>;
		$tofile =~ s/\R//g;
		($tofile) = $tofile =~ /^([^\0]+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FILENAME )
			  unless defined $tofile;
		$tofile = get_decoded($tofile);
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_NO_SUCH_FILE )
			  unless -e "$share_dir/$filename";
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FILETYPE )
			  unless (-d "$share_dir/$filename" and $isdir) or 
			  		 (! -d "$share_dir/$filename" and ! $isdir);
		if( -e "$Schulkonsole::Config::_runtimedir/$tofile") { # make room for the file
			if( -e "$Schulkonsole::Config::_runtimedir/$tofile") {
				system("rm -rf \"$Schulkonsole::Config::_runtimedir/$tofile\"");
			} else {
				system("rm -f \"$Schulkonsole::Config::_runtimedir/$tofile\"");
			}
		}
		if($isdir){
			system("mkdir -p \"$Schulkonsole::Config::_runtimedir/$tofile\"");
			system("cd \"$share_dir/$filename\";cp -R * \"$Schulkonsole::Config::_runtimedir/$tofile\"");
			system("cd \"$Schulkonsole::Config::_runtimedir/$tofile\";zip -r \"../${tofile}.zip\" .");
			system("chown www-data:www-data \"$Schulkonsole::Config::_runtimedir/${tofile}.zip\"");
			system("rm -rf \"$Schulkonsole::Config::_runtimedir/$tofile\"");
		} else {
			system("cp \"$share_dir/$filename\" \"$Schulkonsole::Config::_runtimedir/$tofile\"");			
			system("chown www-data:www-data \"$Schulkonsole::Config::_runtimedir/$tofile\"");
		}
	} else {
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_ACTION_NOT_SUPPORTED );
	}
	
	exit 0;
}

=head3 ls_handedout

numeric constant: C<Schulkonsole::Config::LSHANDEDOUTAPP>

=head4 Parameters from standard input

=over

=item category (2 - tocollect, 1 - handedoutcopy, 0 - handedout)

=item type (current_room, examn, myclass, project, subclass)

=item subclass (if type 16)

=back

=cut

sub lshandedoutapp() {
	my $category = <>;
	($category) = $category =~ /^(\d+)$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_DO_COPY )
		unless defined $category;


	my $share_dir = "$$userdata{homedirectory}/";

	if ($category == 2) {
		$share_dir .= "$Language::collect_dir";
	} elsif ($category) {
		$share_dir .=
			"$Language::handoutcopy_dir/$Language::handoutcopy_string";
	} else {
		$share_dir = "$DevelConf::tasks_tasks";
	}

	my $type = <>;
	($type) = $type =~ /^(\d+)$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_TYPE )
		unless defined $type;

	LSHANDOUTTYPE: {
	($type =~ /^1|2|4|8|16$/) and ($category == 2) and do {
		last LSHANDOUTTYPE;
	};
	($type & 1 or $type & 2) and do {
		if ($category) {
				$share_dir .= $Language::current_room;
		} else {
				$share_dir .= $Language::exam;
		}
		last LSHANDOUTTYPE;
	};
	($type & 4) and do {
		my $project = <>;
		($project) = $project =~ /^(.+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_PROJECT )
			unless $project;
		$share_dir .= ($category?"":"/projects/") . $project;
		last LSHANDOUTTYPE;
	};
	($type & 8) and do {
		my $myclass = $$userdata{gid};
		($myclass) = $myclass =~ /^(.+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_CLASS )
			unless $myclass;
		$share_dir .= ($category?"":"/classes/") . $myclass;
		last LSHANDOUTTYPE;
	};
	($type & 16) and do {
		my $subclass = <>;
		($subclass) = $subclass =~ /^(.+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_SUBCLASS )
			unless $subclass;
		$share_dir .= ($category?"":"/subclasses/") . $subclass;
		last LSHANDOUTTYPE;
	};
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FROM );
	}

	chdir Schulkonsole::Encode::to_fs($share_dir)
		or exit (  Schulkonsole::Error::SophomorixError::WRAPPER_NO_SUCH_DIRECTORY );

	my %files;
	if($category) {
		my @files = glob '*';
		foreach my $file (@files) {
			if (-d $file) {
				$files{get_decoded($file)} = 'd';
			} else {
				$files{get_decoded($file)} = 0;
			}
		}
	} else {
		my @teachers = glob '*';
		foreach my $teacher (@teachers) {
			($teacher) = $teacher =~ /^(.+)$/;
			chdir Schulkonsole::Encode::to_fs("$share_dir/$teacher")
				or exit (  Schulkonsole::Error::SophomorixError::WRAPPER_NO_SUCH_DIRECTORY );

			my @files = glob '*';
			foreach my $file (@files) {
				if (-d $file) {
					$files{get_decoded($teacher)}{get_decoded($file)} = 'd';
				} else {
					$files{get_decoded($teacher)}{get_decoded($file)} = 0;
				}
			}
		}
	}

	my $data = Data::Dumper->new([ \%files ]);
	$data->Terse(1);
	$data->Indent(0);
	print $data->Dump;

	exit 0;
}

=head3 ls_handout

numeric constant: C<Schulkonsole::Config::LSHANDOUTAPP>

=head4 Parameters from standard input

=over

=item category

=item type

=item project (if type 8)

=back

=cut

sub lshandoutapp() {
	my $category = <>;
	($category) = $category =~ /^(\d+)$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_DO_COPY )
		unless defined $category;


	my $share_dir = "$$userdata{homedirectory}/";

	if ($category == 2) {
		$share_dir .=
			"$Language::collected_dir/$Language::collected_string";
	} elsif ($category) {
		$share_dir .=
			"$Language::to_handoutcopy_dir/$Language::to_handoutcopy_string";
	} else {
		$share_dir .= "$Language::handout_dir/$Language::handout_string";
	}

	my $type = <>;
	($type) = $type =~ /^(\d+)/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_TYPE )
		unless defined $type;

	LSHANDOUTTYPE: {
	($type & 1 or $type & 2) and do {
		if ($category == 1) {
				$share_dir .= $Language::current_room;
		} else {
				$share_dir .= $Language::exam;
		}
		last LSHANDOUTTYPE;
	};
	($type & 4) and do {
		my $project = <>;
		($project) = $project =~ /^(.+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_PROJECT )
			unless $project;
		$share_dir .= $project;
		last LSHANDOUTTYPE;
	};
	($type & 8) and do {
		my $class = <>;
		($class) = $class =~ /^(.+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_CLASS )
			unless $class;
		$share_dir .= $class;
		last LSHANDOUTTYPE;
	};
	($type & 16) and do {
		my $subclass = <>;
		($subclass) = $subclass =~ /^(.+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_SUBCLASS )
			unless $subclass;
		$share_dir .= $subclass;
		last LSHANDOUTTYPE;
	};
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FROM );
	}

	chdir Schulkonsole::Encode::to_fs($share_dir)
		or exit (  Schulkonsole::Error::SophomorixError::WRAPPER_NO_SUCH_DIRECTORY );
	my @files = glob '*';
	my %files;
	foreach my $file (@files) {
		if (-d $file) {
			$files{get_decoded($file)} = 'd';
		} else {
			$files{get_decoded($file)} = 0;
		}
	}

	my $data = Data::Dumper->new([ \%files ]);
	$data->Terse(1);
	$data->Indent(0);
	print $data->Dump;

	exit 0;
}

=head3 ls_collect

numeric constant: C<Schulkonsole::Config::LSCOLLECTAPP>

=head4 Parameters from standard input

=over

=item login_ids

=back

=cut

sub lscollectapp() {
	my @login_ids;
	while (my $login_id = <>) {
		last if $login_id =~ /^$/;
		($login_id) = $login_id =~ /^(\d+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_USERID )
			unless $login_id;

		push @login_ids, $login_id;
	}
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_NO_USERIDS )
		unless @login_ids;



	my %user_share_files;
	foreach my $login_id (@login_ids) {
		my $login_userdata = Schulkonsole::DB::get_userdata_by_id($login_id);
		next unless $login_userdata;

		my $share_dir = Schulkonsole::Encode::to_fs(
			"$$login_userdata{homedirectory}/$Language::collect_dir");

		if (chdir $share_dir) {
			my @files = glob '*';
			my %files;
			foreach my $file (@files) {
				if (-d $file) {
					$files{get_decoded($file)} = 'd';
				} else {
					$files{get_decoded($file)} = 0;
				}
			}

			$user_share_files{$login_id} = \%files;
		}
	}

	my $data = Data::Dumper->new([ \%user_share_files ]);
	$data->Terse(1);
	$data->Indent(0);
	print $data->Dump;

	exit 0;
}

=head3 handout

numeric constant: C<Schulkonsole::Config::HANDOUTAPP>

=head4 Parameters from standard input

=over

=item do_copy

=back

if do_copy:

=over

=item from

=item project if (from == 4)

=item class if (from == 8)

=item users

=back

else:

=over

=item type

=item room (if type & 2)

=item project if (type & 4)

=item class if (type & 8)

=item subclass if (type & 16)

=back

=cut

sub handoutapp() {
	my $do_copy = <>;
	($do_copy) = $do_copy =~ /^([01])$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_DO_COPY )
		unless defined $do_copy;

	my $opts = "--teacher \Q$$userdata{uid}";
	if ($do_copy) {
		my $from = <>;
		($from) = $from =~ /^([1248])$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FROM )
			unless defined $from;

		FROMHANDOUT: {
		($from == 1 or $from == 2) and do {
			$opts .= ' --fromroom';
			last FROMHANDOUT;
		};
		$from == 4 and do {
			my $project = <>;
			($project) = $project =~ /^(.+)$/;
			exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_PROJECT )
				unless $project;
			$opts .= " --fromproject \Q$project";
			last FROMHANDOUT;
		};
		$from == 8 and do {
			my $class = <>;
			($class) = $class =~ /^(.+)$/;
			exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_CLASS )
				unless $class;
			$opts .= " --fromclass \Q$class";
			last FROMHANDOUT;
		};
		}


		my @users;
		while (my $user = <>) {
			last if $user =~ /^$/;
			($user) = $user =~ /^(.+)$/;
			exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_USER )
				unless $user;

			push @users, "\Q$user";
		}
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_NO_USERS )
			unless @users;

		$opts .= ' --users ' . join(',', @users);
		$opts .= ' --handoutcopy';
	} else {
		my $type = <>;
		($type) = $type =~ /^(\d+)/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_TYPE )
			unless defined $type;


		# sophomorix-teacher allows more than one type option
		if ($type & 2) {
			my $room = <>;
			($room) = $room =~ /^(.+)$/;
			exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_ROOM )
				unless $room;
			$opts .= " --room \Q$room";
		}
		if ($type & 4) {
			my $project = <>;
			($project) = $project =~ /^(.+)$/;
			exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_PROJECT )
				unless $project;
			$opts .= " --project \Q$project";
		}
		if ($type & 8) {
			my $class = <>;
			($class) = $class =~ /^(.+)$/;
			exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_CLASS )
				unless $class;
			$opts .= " --class \Q$class";
		};
		if ($type & 16) {
			my $subclass = <>;
			($subclass) = $subclass =~ /^(.+)$/;
			exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_SUBCLASS )
				unless $subclass;
			$opts .= " --subclass \Q$subclass";
		};


		$opts .= ' --handout';
	}

	# sophomorix-teacher cannot be invoked with taint checks enabled
	$< = $>;
	$( = $);
	exec Schulkonsole::Encode::to_cli(
	     	"$Schulkonsole::Config::_cmd_sophomorix_teacher $opts")
		or return;
}

=head3 collect

numeric constant: C<Schulkonsole::Config::COLLECTAPP>

=head4 Parameters from standard input

=over

=item do_copy

=item is_exam

=item from

=item type (if not from)

=item room (if type & 2)

=item project (if type & 4 or from == 4)

=item class (if type & 8 or from == 8)

=item subclass (if type & 16)

=item users (if from)

=back

=cut

sub collectapp() {
	my $do_copy = <>;
	($do_copy) = $do_copy =~ /^([01])$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_DO_COPY )
		unless defined $do_copy;

	my $is_exam = <>;
	($is_exam) = $is_exam =~ /^([01])$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_IS_EXAM )
		unless defined $is_exam;

	my $from = <>;
	($from) = $from =~ /^([01248])$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FROM )
		unless defined $from;

	my $opts = "--teacher \Q$$userdata{uid}";


	if ($from) {
		FROMCOLLECT: {
		($from == 1 or $from == 2) and do {
			$opts .= ' --fromroom';
			last FROMCOLLECT;
		};
		$from == 4 and do {
			my $project = <>;
			($project) = $project =~ /^(.+)$/;
			exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_PROJECT )
				unless $project;
			$opts .= " --fromproject \Q$project";
			last FROMCOLLECT;
		};
		$from == 8 and do {
			my $class = <>;
			($class) = $class =~ /^(.+)$/;
			exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_CLASS )
				unless $class;
			$opts .= " --fromclass \Q$class";
			last FROMCOLLECT;
		};
		}


		my @users;
		while (my $user = <>) {
			last if $user =~ /^$/;
			($user) = $user =~ /^(.+)$/;
			exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_USER )
				unless $user;

			push @users, "\Q$user";
		}
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_NO_USERS )
			unless @users;

		$opts .= ' --users ' . join(',', @users);
	} else {
		my $type = <>;
		($type) = $type =~ /^(\d+)/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_TYPE )
			unless $type;


		# sophomorix-teacher allows more than one type option
		if ($type & 2) {
			my $room = <>;
			($room) = $room =~ /^(.+)$/;
			exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_ROOM )
				unless $room;
			$opts .= " --room \Q$room";
		}
		if ($type & 4) {
			my $project = <>;
			($project) = $project =~ /^(.+)$/;
			exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_PROJECT )
				unless $project;
			$opts .= " --project \Q$project";
		}
		if ($type & 8) {
			my $class = <>;
			($class) = $class =~ /^(.+)$/;
			exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_CLASS )
				unless $class;
			$opts .= " --class \Q$class";
		}
		if ($type & 16) {
			my $subclass = <>;
			($subclass) = $subclass =~ /^(.+)$/;
			exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_SUBCLASS )
				unless $subclass;
			$opts .= " --subclass \Q$subclass";
		}
	}


	$opts .= ' --exam' if $is_exam;
	$opts .= ($do_copy ? ' --collectcopy' : ' --collect');

	# sophomorix-teacher cannot be invoked with taint checks enabled
	$< = $>;
	$( = $);
	exec Schulkonsole::Encode::to_cli(
	     	"$Schulkonsole::Config::_cmd_sophomorix_teacher $opts")
		or return;
}

=head3 room_reset

numeric constant: C<Schulkonsole::Config::RESETROOMAPP>

=head4 Parameters from standard input

=over

=item room

=back

=cut

sub resetroomapp() {
	my $room = <>;
	($room) = $room =~ /^(.+)$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_ROOM )
		unless $room;

	my $opts = "--reset-room \Q$room";

	# sophomorix-room cannot be invoked with taint checks enabled
	$< = $>;
	$( = $);
	exec Schulkonsole::Encode::to_cli(
	     	"$Schulkonsole::Config::_cmd_sophomorix_room $opts")
		or return;
}

=head3 edit_own_class_membership

numeric constant: C<Schulkonsole::Config::EDITOWNCLASSMEMBERSHIPAPP>

=head4 Parameters from standard input

=over

=item class_gid

=item do_add

=back

=cut

sub editownclassmembershipapp() {
	my $class_gid = <>;
	($class_gid) = $class_gid =~ /^(.+)$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_CLASS )
		unless defined $class_gid;

	my $do_add = <>;
	($do_add) = $do_add =~ /^(\d+)$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_DO_ADD )
		unless defined $do_add;

	my $opts = "--teacher \Q$$userdata{uid}\E "
		. ($do_add ? '--add' : '--remove') . " \Q$class_gid";

	# sophomorix-teacher cannot be invoked with taint checks enabled
	$< = $>;
	$) = 0;
	$( = $);
	umask(022);
	exec Schulkonsole::Encode::to_cli(
	     	"$Schulkonsole::Config::_cmd_sophomorix_teacher $opts")
		or return;
}

=head3 project_members

numeric constant: C<Schulkonsole::Config::PROJECTMEMBERSAPP>

=head4 Parameters from standard input

=over

=item project_gid

=item do_add

=item users

=back

=cut

sub projectmembersapp() {
	my $project_gid = <>;
	($project_gid) = $project_gid =~ /^((?:p_)?[a-z0-9_-]{3,14})$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_PROJECTGID )
		unless defined $project_gid;

	my $do_add = <>;
	($do_add) = $do_add =~ /^([01])$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_DO_ADD )
		unless defined $do_add;

	my $scope = <>;
	($scope) = $scope =~ /^([0123])$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_MEMBERSCOPE )
		unless defined $scope;

	my @users;
	while (my $user = <>) {
		last if $user =~ /^$/;
		($user) = $user =~ /^(.+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_USER )
			unless $user;

		push @users, "\Q$user";
	}
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_NO_USERS )
		unless @users;

	my $opts = "--caller \Q$$userdata{uid}\E "
		. ($do_add ? '--add' : '--remove');

	MEMBERSSCOPE: {
	$scope == 0 and do {
		$opts .= 'members ';
		last MEMBERSSCOPE;
	};
	$scope == 1 and do {
		$opts .= 'admins ';
		last MEMBERSSCOPE;
	};
	$scope == 2 and do {
		$opts .= 'membergroups ';
		last MEMBERSSCOPE;
	};
	$scope == 3 and do {
		$opts .= 'memberprojects ';
		last MEMBERSSCOPE;
	};
	}

	$opts .= join(',', @users) . " --project \Q$project_gid";

	# sophomorix-project cannot be invoked with taint checks enabled
	$< = $>;
	$) = 0;
	$( = $);
	umask(022);
	exec Schulkonsole::Encode::to_cli(
	     	"$Schulkonsole::Config::_cmd_sophomorix_project $opts")
		or return;
}

=head3 project_create_drop

numeric constant: C<Schulkonsole::Config::PROJECTCREATEDROPAPP>

=head4 Parameters from standard input

=over

=item project_gid

=item do_add

=item users

=item is_open

=back

=cut

sub projectcreatedropapp() {
	my $project_gid = <>;
	($project_gid) = $project_gid =~ /^((?:p_)?[a-z0-9_-]{3,14})$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_PROJECTGID )
		unless defined $project_gid;

	my $do_create = <>;
	($do_create) = $do_create =~ /^([01])$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_DO_CREATE )
		unless defined $do_create;


	my $opts = " --caller \Q$$userdata{uid}\E --project \Q$project_gid\E ";
	if ($do_create) {
		my $is_open = <>;
		($is_open) = $is_open =~ /^([01])$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_IS_JOIN )
			unless defined $is_open;

		$opts .= ' --create'
		         . ($is_open ? ' --join' : ' --nojoin')
		         . ($Schulkonsole::Config::_project_mailalias eq $Schulkonsole::Config::on? ' --mailalias' : ' --nomailalias')
		         . ($Schulkonsole::Config::_project_maillist eq $Schulkonsole::Config::on? ' --maillist' : ' --nomaillist' )
		         . " --admins \Q$$userdata{uid}";
	} else {
		$opts .= ' --kill';
	}

	# sophomorix-project cannot be invoked with taint checks enabled
	$< = $>;
	$) = 0;	# sophomorix-project will re-create /etc/aliases
	$( = $);
	umask(022);
	exec Schulkonsole::Encode::to_cli("$Schulkonsole::Config::_cmd_sophomorix_project $opts")
		or return;
}

=head3 project_wlan_defaults

numeric constant: C<Schulkonsole::Config::PROJECTWLANDEFAULTSAPP>

=head4 Parameters from standard input

=over

=item project_gid

=item add = 1, remove = 0

=back

=cut

sub project_wlan_defaults() {
	my $project_gid = <>;
	($project_gid) = $project_gid =~ /^((?:p_)?[a-z0-9_-]{3,14})$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_PROJECTGID )
		unless defined $project_gid;

	my $do_add = <>;
	($do_add) = $do_add =~ /^([01])$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_ACTION )
		unless defined $do_add;


	# sophomorix-project cannot be invoked with taint checks enabled
	$< = $>;
	$) = 0;	# sophomorix-project will re-create /etc/aliases
	$( = $);
	umask(022);
	if($do_add){
		exec Schulkonsole::Encode::to_cli("echo 'g:" . $project_gid) . "\t\t" 
				. Schulkonsole::Encode::to_cli($Schulkonsole::Config::_project_wlan 
				. "' >>$Schulkonsole::Config::_wlan_defaults_file")
			or return;
	} else {
		exec Schulkonsole::Encode::to_cli("sed -i '/^g:" . $project_gid . "[[:space:]]/d' " . $Schulkonsole::Config::_wlan_defaults_file)
			or return;
	}
}

=head3 print_class

numeric constant: C<Schulkonsole::Config::PRINTCLASSAPP>

=head4 Parameters from standard input

=over

=item class_gid

The class' GID

=item filetype

The filetype, 0 (PDF) or 1 (CSV)

=back

=cut

sub printclassapp() {
	my $class_gid = <>;
	($class_gid) = $class_gid =~ /^(.+)$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_CLASS )
		unless defined $class_gid;

	my $filetype = <>;
	($filetype) = $filetype =~ /^([01])$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FILE_TYPE )
		unless defined $filetype;

	my $opts = "--class \Q$class_gid\E --postfix \Q$$userdata{uid}";

	# sophomorix-print cannot be invoked with taint checks enabled
	$< = $>;
	$( = $);
	$ENV{HOME}="/root" if not defined $ENV{HOME};
	system(Schulkonsole::Encode::to_cli("$Schulkonsole::Config::_cmd_sophomorix_print $opts >/dev/null 2>/dev/null")) == 0
		or exit ($? >> 8);

	my $filename;
	SWITCHFILETYPE: {
	$filetype == 0 and do {
		$filename = Schulkonsole::Encode::to_fs(
		            	"$DevelConf::druck_pfad/$class_gid-$$userdata{uid}.pdf");
		last SWITCHFILETYPE;
	};
	$filetype == 1 and do {
		$filename = Schulkonsole::Encode::to_fs(
		            	"$DevelConf::druck_pfad/$class_gid-$$userdata{uid}.csv");
		last SWITCHFILETYPE;
	};
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FILE_TYPE );
	}
	
	open DATA, '<:raw', $filename
		or (    print STDERR "$filename: $!\n"
	        and exit (  Schulkonsole::Error::SophomorixError::WRAPPER_CANNOT_OPEN_FILE ));

	SWITCHDATATYPE: {
	$filetype == 0 and do {
		binmode STDOUT, ':raw';
		local $/ = undef;
		while (<DATA>) {
			print;
		}
		last SWITCHDATATYPE;
	};
	$filetype == 1 and do {
		while (<DATA>) {
			print get_decoded($_);
		}
		last SWITCHDATATYPE;
	};
	}

	close DATA;

	exit 0;
}

=head3 print_commit

numeric constant: C<Schulkonsole::Config::PRINTCOMMITAPP>

=head4 Parameters from standard input

=over

=item back_in_time

The commit run to print (0=last commit)

=item filetype

The filetype, 0 (PDF) or 1 (CSV)

=item one_per_page

For file type PDF print one user per page(1)

=back

=cut

sub print_commit() {
	my $commit = <>;
	($commit) = $commit =~ /^(\d+)$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_COMMIT )
		unless defined $commit;

	my $filetype = <>;
	($filetype) = $filetype =~ /^([0|1])$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FILE_TYPE )
		unless defined $filetype;

	my $one_per_page = <>;
	($one_per_page) = $one_per_page =~ /^([0|1])$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_PAGING )
	    unless defined $one_per_page;
	$one_per_page = 0 if $filetype == 1;
	
	my $opts = "--back-in-time \Q$commit\E --postfix \Q$$userdata{uid}";
	$opts .= " --one-per-page" if $one_per_page;
	
	# sophomorix-print cannot be invoked with taint checks enabled
	$< = $>;
	$( = $);
	$ENV{HOME}="/root" if not defined $ENV{HOME};
	system(Schulkonsole::Encode::to_cli("$Schulkonsole::Config::_cmd_sophomorix_print $opts >/dev/null 2>/dev/null")) == 0
		or exit ($? >> 8);

	my $filename;
	SWITCHFILETYPE: {
	$filetype == 0 and do {
		$filename = Schulkonsole::Encode::to_fs(
		            	"$DevelConf::druck_pfad/add-$$userdata{uid}.pdf");
		last SWITCHFILETYPE;
	};
	$filetype == 1 and do {
		$filename = Schulkonsole::Encode::to_fs(
		            	"$DevelConf::druck_pfad/add-$$userdata{uid}.csv");
		last SWITCHFILETYPE;
	};
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FILE_TYPE );
	}
	
	open DATA, '<:raw', $filename
		or (    print STDERR "$filename: $!\n"
	        and exit (  Schulkonsole::Error::SophomorixError::WRAPPER_CANNOT_OPEN_FILE ));

	SWITCHDATATYPE: {
	$filetype == 0 and do {
		binmode STDOUT, ':raw';
		local $/ = undef;
		while (<DATA>) {
			print;
		}
		last SWITCHDATATYPE;
	};
	$filetype == 1 and do {
		while (<DATA>) {
			print get_decoded($_);
		}
		last SWITCHDATATYPE;
	};
	}

	close DATA;

	exit 0;
}

=head3 ls_commits

numeric constant: C<Schulkonsole::Config::LSCOMMITSAPP>

=head4 Return value to standard output

=over

Print lines to standard output with commit "date (time)".

=back

=cut

sub ls_commits() {

	my $opts = "--info --postfix \Q$$userdata{uid}";
	
	# sophomorix-print cannot be invoked with taint checks enabled
	$< = $>;
	$( = $);
	$ENV{HOME}="/root" if not defined $ENV{HOME};
	open(PRINT, Schulkonsole::Encode::to_cli("$Schulkonsole::Config::_cmd_sophomorix_print $opts |"))
		or exit Schulkonsole::Error::Error::WRAPPER_SCRIPT_EXEC_FAILED;
	while(<PRINT>){
		my $line = $_;
		my ($date,$time) = $_ =~ /^\s*--back-in-time\s*\d+\s*-->\s*(\S+)(?: (\S+))?.*$/;
		next unless $date;
		print "$date" . ($time?" $time\n":"\n");
	}
	close(PRINT) or exit ($? >> 8);
	
	exit 0;
}

=head3 ls_commit

numeric constant: C<Schulkonsole::Config::LSCOMMITAPP>

=head4 Parameters from standard input

=over

=item C<$commit>

No. of the commit to read added users from

=back

=head4 Return value to standard output

=over

Print user uids one per line to standard output

=back

=cut

sub ls_commit() {
	my $commit = <>;
	($commit) = $commit =~ /^(\d+)$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_COMMIT )
		  unless defined $commit;
	
	my $opts = "--info --back-in-time \Q$commit\E --postfix \Q$$userdata{uid}";

	# sophomorix-print cannot be invoked with taint checks enabled
	$< = $>;
	$( = $);
	$ENV{HOME}="/root" if not defined $ENV{HOME};
	open(SCRIPTIN, Schulkonsole::Encode::to_cli("$Schulkonsole::Config::_cmd_sophomorix_print $opts |"))
		or exit Schulkonsole::Error::Error::WRAPPER_SCRIPT_EXEC_FAILED;

	my $start = 0;
	my @uids;
	while(<SCRIPTIN>){
		s/\R//g;
		if(not $start){
			$start = 1 if /^Printing users:.*$/;
			next;
		}
		next if not $start;
		my ($uid) = $_ =~ /^\s*\d+\)\s*([a-z0-9]+)\s*$/;
		next unless $uid;
		push @uids,$uid;
	}
	close(SCRIPTIN) or exit ($? >> 8);
	
	my @uuids = keys { map { $_ => 1 } @uids }; 
	print join("\n", @uuids);
	exit 0;
}

=head3 print_allusers

numeric constant: C<Schulkonsole::Config::PRINTALLUSERSAPP>

=head4 Parameters from standard input

=over

=item filetype

The filetype, 0 (PDF) or 1 (CSV)

=item one_per_page

For PDF print one user per page(1)

=back

=cut

sub print_allusers() {
	my $filetype = <>;
	($filetype) = $filetype =~ /^([01])$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FILE_TYPE )
		unless defined $filetype;

	my $one_per_page = <>;
	($one_per_page) = $one_per_page =~ /^([0|1])$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_PAGING )
	    unless defined $one_per_page;
	$one_per_page = 0 if $filetype == 1;
	
	my $opts = "--all --postfix \Q$$userdata{uid}";
	$opts .= " --one-per-page" if $one_per_page;
	
	# sophomorix-print cannot be invoked with taint checks enabled
	$< = $>;
	$( = $);
	$ENV{HOME}="/root" if not defined $ENV{HOME};
	system(Schulkonsole::Encode::to_cli("$Schulkonsole::Config::_cmd_sophomorix_print $opts >/dev/null 2>/dev/null")) == 0
		or exit ($? >> 8);

	my $filename;
	SWITCHFILETYPE: {
	$filetype == 0 and do {
		$filename = Schulkonsole::Encode::to_fs(
		            	"$DevelConf::druck_pfad/all-$$userdata{uid}.pdf");
		last SWITCHFILETYPE;
	};
	$filetype == 1 and do {
		$filename = Schulkonsole::Encode::to_fs(
		            	"$DevelConf::druck_pfad/all-$$userdata{uid}.csv");
		last SWITCHFILETYPE;
	};
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FILE_TYPE );
	}
	
	open DATA, '<:raw', $filename
		or (    print STDERR "$filename: $!\n"
	        and exit (  Schulkonsole::Error::SophomorixError::WRAPPER_CANNOT_OPEN_FILE ));

	SWITCHDATATYPE: {
	$filetype == 0 and do {
		binmode STDOUT, ':raw';
		local $/ = undef;
		while (<DATA>) {
			print;
		}
		last SWITCHDATATYPE;
	};
	$filetype == 1 and do {
		while (<DATA>) {
			print get_decoded($_);
		}
		last SWITCHDATATYPE;
	};
	}

	close DATA;

	exit 0;
}

=head3 print_teachers

numeric constant: C<Schulkonsole::Config::PRINTTEACHERSAPP>

=head4 Parameters from standard input

=over

=item filetype

The filetype, 0 (PDF) or 1 (CSV)

=back

=cut

sub printteachersapp(){
	my $filetype = <>;
	($filetype) = $filetype =~ /^([01])$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FILE_TYPE )
		unless defined $filetype;

	my $opts = "--teacher";

	# sophomorix-print cannot be invoked with taint checks enabled
	$< = $>;
	$( = $);
        $ENV{HOME}="/root" if not defined $ENV{HOME};
	system(Schulkonsole::Encode::to_cli("$Schulkonsole::Config::_cmd_sophomorix_print $opts >/dev/null 2>/dev/null")) == 0
		or exit ($? >> 8);

	my $filename;
	SWITCHFILETYPE: {
	$filetype == 0 and do {
		$filename = Schulkonsole::Encode::to_fs(
		            	"$DevelConf::druck_pfad/teachers.pdf");
		last SWITCHFILETYPE;
	};
	$filetype == 1 and do {
		$filename = Schulkonsole::Encode::to_fs(
		            	"$DevelConf::druck_pfad/teachers.csv");
		last SWITCHFILETYPE;
	};
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FILE_TYPE );
	}
	
	open DATA, '<:raw', $filename
		or (    print STDERR "$filename: $!\n"
		    and exit (  Schulkonsole::Error::SophomorixError::WRAPPER_CANNOT_OPEN_FILE ));

	SWITCHDATATYPE: {
	$filetype == 0 and do {
		binmode STDOUT, ':raw';
		local $/ = undef;
		while (<DATA>) {
			print;
		}
		last SWITCHDATATYPE;
	};
	$filetype == 1 and do {
		while (<DATA>) {
			print get_decoded($_);
		}
		last SWITCHDATATYPE;
	};
	}

	close DATA or exit ($? >> 8);

	exit 0;
}

=head3 print_project

numeric constant: C<Schulkonsole::Config::PRINTPROJECTAPP>

=head4 Parameters from standard input

=over

=item project_gid

The project' GID

=item filetype

The filetype, 0 (PDF) or 1 (CSV)

=back

=cut

sub printprojectapp() {
        my $project_gid = <>;
        ($project_gid) = $project_gid =~ /^(.+)$/;
        exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_PROJECT )
                unless defined $project_gid;

        my $filetype = <>;
        ($filetype) = $filetype =~ /^([01])$/;
        exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FILE_TYPE )
                unless defined $filetype;

        my $opts = "--project \Q$project_gid\E --postfix \Q$$userdata{uid}";

        # sophomorix-print cannot be invoked with taint checks enabled
        $< = $>;
        $( = $);
        $ENV{HOME}="/root" if not defined $ENV{HOME};
        system(Schulkonsole::Encode::to_cli("$Schulkonsole::Config::_cmd_sophomorix_print $opts >/dev/null 2>/dev/null")) == 0
                or exit ($? >> 8);

        my $filename;
        SWITCHFILETYPE: {
        $filetype == 0 and do {
                $filename = Schulkonsole::Encode::to_fs(
                                "$DevelConf::druck_pfad/$project_gid-$$userdata{uid}.pdf");
                last SWITCHFILETYPE;
        };
        $filetype == 1 and do {
                $filename = Schulkonsole::Encode::to_fs(
                                "$DevelConf::druck_pfad/$project_gid-$$userdata{uid}.csv");
                last SWITCHFILETYPE;
        };
        exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FILE_TYPE );
        }
        
        open DATA, '<:raw', $filename
                or (    print STDERR "$filename: $!\n"
                and exit (  Schulkonsole::Error::SophomorixError::WRAPPER_CANNOT_OPEN_FILE ));

        SWITCHDATATYPE: {
        $filetype == 0 and do {
                binmode STDOUT, ':raw';
                local $/ = undef;
                while (<DATA>) {
                        print;
                }
                last SWITCHDATATYPE;
        };
        $filetype == 1 and do {
                while (<DATA>) {
                        print get_decoded($_);
                }
                last SWITCHDATATYPE;
        };
        }

        close DATA;

        exit 0;
}

=head3 set_passwords

numeric constant: C<Schulkonsole::Config::SETPASSWORDSAPP>

=head4 Parameters from standard input

=over

=item type

reset (0)/password (1)/random (2)

=item scope

users (0)/rooms (1)

=item password (for type = 1)

password to set if type is 1

=item users (for scope = 0)

the users for whom to set the passwords

=item rooms (for scope = 1)

the rooms for which to set the workstation passwords

=back

=cut

sub setpasswordsapp() {
	my $type = <>;
	($type) = $type =~ /^([012])$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_SET_PASSWORD_TYPE )
		unless defined $type;

	my $scope = <>;
	($scope) = $scope =~ /^([01])$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_MEMBERSCOPE )
		unless defined $scope;


	my $opts = '--hide ';
	TYPE: {
	$type == 0 and do {
		$opts .= '--reset';
		last TYPE;
	};
	$type == 1 and do {
		my $password = <>;
		($password) = $password =~ /^(.+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_PASSWORD )
			unless $password;

		$opts .= "--password \Q$password";
		last TYPE;
	};
	$type == 2 and do {
		$opts .= '--random';
		last TYPE;
	};
	}

	my @users;
	while (my $user = <>) {
		last if $user =~ /^$/;
		($user) = $user =~ /^(.+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_USER )
			unless $user;

		push @users, "\Q$user";
	}
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_NO_USERS )
		unless @users;

	if ($scope == 0) {
		$opts .= ' --users ' . join(',', @users);
	} else {
		$opts .= ' --rooms ' . join(',', @users);
	}

	# sophomorix-passwd cannot be invoked with taint checks enabled
	$< = $>;
	$( = $);
	exec Schulkonsole::Encode::to_cli(
	     	"$Schulkonsole::Config::_cmd_sophomorix_passwd $opts")
		or return;
}

=head3 read_sophomorix_file

numeric constant: C<Schulkonsole::Config::READSOPHOMORIXFILEAPP>

=head4 Parameters from standard input

=over

=item number

number of the file to read (0 = lehrer.txt, 1 = schueler.txt,
2 = sophomorix.add, 3 = sophomorix.move, 4 = sophomorix.kill,
5 = report.admin, 6 = report.office, 10 = extraschueler.txt,
11 = extrakurse.txt, 7 = last of sophomorix-add.txt.*,
8 = last of sophomorix-move.txt.*, 9 = last of sophomorix-kill.txt.*,
12 = last of sophomorix-quota.txt.*)

=back

=cut

sub readsophomorixfileapp(){
	my $number = <>;
	($number) = $number =~ /^([0-9]|1[0-2])$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FILENUMBER )
		unless defined $number;

	my $filename;
	my $encoding = "utf8";
	SWITCHREADFILE: {
	$number == 0 and do {
		$filename = Schulkonsole::Encode::to_fs(
		            	"$DevelConf::users_pfad/lehrer.txt");
		if (defined $Conf::encoding_teachers) {
			$encoding = $Conf::encoding_teachers;
		} elsif (defined $DevelConf::encoding_teachers) {
			$encoding = $DevelConf::encoding_teachers;
		}
		last SWITCHREADFILE;
	};
	$number == 1 and do {
		$filename = Schulkonsole::Encode::to_fs(
		            	"$DevelConf::users_pfad/schueler.txt");
		if (defined $Conf::encoding_students) {
			$encoding = $Conf::encoding_students;
		} elsif (defined $DevelConf::encoding_students) {
			$encoding = $DevelConf::encoding_students;
		}
		last SWITCHREADFILE;
	};
	$number == 2 and do {
		$filename = Schulkonsole::Encode::to_fs(
		            	"$DevelConf::ergebnis_pfad/sophomorix.add");
		last SWITCHREADFILE;
	};
	$number == 3 and do {
		$filename = Schulkonsole::Encode::to_fs(
		            	"$DevelConf::ergebnis_pfad/sophomorix.move");
		last SWITCHREADFILE;
	};
	$number == 4 and do {
		$filename = Schulkonsole::Encode::to_fs(
		            	"$DevelConf::ergebnis_pfad/sophomorix.kill");
		last SWITCHREADFILE;
	};
	$number == 5 and do {
		$filename = Schulkonsole::Encode::to_fs(
		            	"$DevelConf::ergebnis_pfad/report.admin");
		last SWITCHREADFILE;
	};
	$number == 6 and do {
		$filename = Schulkonsole::Encode::to_fs(
		            	"$DevelConf::ergebnis_pfad/report.office");
		last SWITCHREADFILE;
	};
	$number == 10 and do {
		$filename = Schulkonsole::Encode::to_fs(
		            	"$DevelConf::users_pfad/extraschueler.txt");
		if (defined $Conf::encoding_students_extra) {
			$encoding = $Conf::encoding_students_extra;
		} elsif (defined $DevelConf::encoding_students_extra) {
			$encoding = $DevelConf::encoding_students_extra;
		}
		last SWITCHREADFILE;
	};
	$number == 11 and do {
		$filename = Schulkonsole::Encode::to_fs(
		            	"$DevelConf::users_pfad/extrakurse.txt");
		if (defined $Conf::encoding_courses_extra) {
			$encoding = $Conf::encoding_courses_extra;
		} elsif (defined $DevelConf::encoding_courses_extra) {
			$encoding = $DevelConf::encoding_courses_extra;
		}
		last SWITCHREADFILE;
	};
	my $filename_base;
	BASENAME: {
		$number == 7 and do {
			$filename_base = Schulkonsole::Encode::to_fs(
			                 	"$DevelConf::log_files/sophomorix-add.txt.");
			last BASENAME;
		};
		$number == 8 and do {
			$filename_base = Schulkonsole::Encode::to_fs(
			                 	"$DevelConf::log_files/sophomorix-move.txt.");
			last BASENAME;
		};
		$number == 9 and do {
			$filename_base = Schulkonsole::Encode::to_fs(
			                 	"$DevelConf::log_files/sophomorix-kill.txt.");
			last BASENAME;
		};
		$number == 12 and do {
			$filename_base = Schulkonsole::Encode::to_fs(
			                 	"$DevelConf::log_files/sophomorix-quota.txt.");
			last BASENAME;
		};
	}
	my @filenames = sort glob "$filename_base*";
	($filename) = $filenames[-1] =~ /^(.*)$/;
	
	} # end SWITCHREADFILE

	if (not exists $supported_encodings{$encoding}){
		$encoding = "utf8";
	}
	else {
		$encoding = $supported_encodings{$encoding};
	}
	open FILE, "<:encoding($encoding)", $filename
		or exit (  Schulkonsole::Error::SophomorixError::WRAPPER_CANNOT_OPEN_FILE );

	while (<FILE>) {
		print $_;
	}
	close FILE;

	exit 0;
}

=head3 write_sophomorix_file

numeric constant: C<Schulkonsole::Config::WRITESOPHOMORIXFILEAPP>

=head4 Parameters from standard input

=over

=item number

number of the file to read (0 = lehrer.txt, 1 = schueler.txt,
2 = sophomorix.conf, 3 = quota.conf , 4 = mailquota.conf)

=item lines

the lines to be written in the file

=back

=cut

sub writesophomorixfileapp(){
	my $number = <>;
	($number) = $number =~ /^([0123456])$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FILENUMBER )
		unless defined $number;

	my $path;
	my $filename;
	my $encoding = "utf8";
	my @stat;
	SWITCHWRITEFILE: {
	$number == 0 and do {
		$path = $DevelConf::users_pfad;
		$filename = 'lehrer.txt';
		$stat[2] = 0600;	# set default permissions for this file
		if (defined $Conf::encoding_teachers) {
			$encoding = $Conf::encoding_teachers;
		} elsif (defined $DevelConf::encoding_teachers) {
			$encoding = $DevelConf::encoding_teachers;
		}
		last SWITCHWRITEFILE;
	};
	$number == 1 and do {
		$path = $DevelConf::users_pfad;
		$filename = 'schueler.txt';
		$stat[2] = 0600;
		if (defined $Conf::encoding_students) {
			$encoding = $Conf::encoding_students;
		} elsif (defined $DevelConf::encoding_students) {
			$encoding = $DevelConf::encoding_students;
		}
		last SWITCHWRITEFILE;
	};
	$number == 2 and do {
		$path = $DevelConf::config_pfad;
		$filename = 'sophomorix.conf';
		$stat[2] = 0644;
		last SWITCHWRITEFILE;
	};
	$number == 3 and do {
		$path = $DevelConf::config_pfad;
		$filename = 'quota.txt';
		$stat[2] = 0644;
		last SWITCHWRITEFILE;
	};
	$number == 4 and do {
		$path = $DevelConf::config_pfad;
		$filename = 'mailquota.txt';
		$stat[2] = 0644;
		last SWITCHWRITEFILE;
	};
	$number == 5 and do {
		$path = $DevelConf::users_pfad;
		$filename = 'extraschueler.txt';
		$stat[2] = 0600;
		if (defined $Conf::encoding_students_extra) {
			$encoding = $Conf::encoding_students_extra;
		} elsif (defined $DevelConf::encoding_students_extra) {
			$encoding = $DevelConf::encoding_students_extra;
		}
		last SWITCHWRITEFILE;
	};
	$number == 6 and do {
		$path = $DevelConf::users_pfad;
		$filename = 'extrakurse.txt';
		$stat[2] = 0600;
		if (defined $Conf::encoding_courses_extra) {
			$encoding = $Conf::encoding_courses_extra;
		} elsif (defined $DevelConf::encoding_courses_extra) {
			$encoding = $DevelConf::encoding_courses_extra;
		}
		last SWITCHWRITEFILE;
	};
	}

	
	my $full_filename = Schulkonsole::Encode::to_fs("$path/$filename");
	if (-e $full_filename) {
		@stat = stat $full_filename;

		my $suffix_base = POSIX::strftime("-%Y-%m-%d_%H-%M", localtime);
		my $suffix = $suffix_base;

		my $backup_path = "$DevelConf::log_pfad/history";

		if (not -e Schulkonsole::Encode::to_fs($backup_path)) {
			my @dirs = split '/', Schulkonsole::Encode::to_fs($backup_path);

			my $dir = shift @dirs;
			foreach my $next_dir (@dirs) {
				$dir .= "/$next_dir";
				mkdir $dir unless -e $dir;
			}
		} else {
			my $cnt = 0;
			while (-e Schulkonsole::Encode::to_fs(
			          	"$backup_path/$filename$suffix")) {
				$cnt++;
				$suffix = "$suffix_base-$cnt";
			}
		}

		if (not rename Schulkonsole::Encode::to_fs($full_filename),
		               Schulkonsole::Encode::to_fs("$backup_path/$filename$suffix")) {
			system(Schulkonsole::Encode::to_cli("mv \Q$full_filename\E \Q$backup_path/$filename$suffix"))
				== 0
				or exit (  Schulkonsole::Error::SophomorixError::WRAPPER_PROCESS_RUNNING );
		}
	} else {
		$stat[4] = $>;
		$stat[5] = 0;
	}

	if (not exists $supported_encodings{$encoding}){
		$encoding = "utf8";
	}
	else {
		$encoding = $supported_encodings{$encoding};
	}

	open FILE, ">:encoding($encoding)",
	           $full_filename
		or exit (  Schulkonsole::Error::SophomorixError::WRAPPER_CANNOT_OPEN_FILE );
	while (<>) {
		print FILE;
	}
	close FILE;

	chown $stat[4], $stat[5], $full_filename;
	chmod $stat[2], $full_filename;


	exit 0;
}

=head3 check_users

numeric constant: C<Schulkonsole::Config::USERSCHECKAPP>

=cut

sub userscheckapp(){
	$< = $>;
	$) = 0;
	$( = $);

	system $Schulkonsole::Config::_cmd_sophomorix_check;

	exit 0;
}

=head3 add_users

numeric constant: C<Schulkonsole::Config::USERSADDAPP>

=head3 move_users

numeric constant: C<Schulkonsole::Config::USERSMOVEAPP>

=head3 kill_users

numeric constant: C<Schulkonsole::Config::USERSKILLAPP>

=cut

sub users_add_or_move_or_killapp(){
	my $action;
	my $cmd;
	ACTIONNAME: {
	$app_id == Schulkonsole::Config::USERSADDAPP and do {
		$action = 'add';
		$cmd = $Schulkonsole::Config::_cmd_sophomorix_add;
		last ACTIONNAME;
	};
	$app_id == Schulkonsole::Config::USERSMOVEAPP and do {
		$action = 'move';
		$cmd = $Schulkonsole::Config::_cmd_sophomorix_move;
		last ACTIONNAME;
	};
	$app_id == Schulkonsole::Config::USERSKILLAPP and do {
		$action = 'kill';
		$cmd = $Schulkonsole::Config::_cmd_sophomorix_kill;
		last ACTIONNAME;
	};
	}


	my $lockfile = Schulkonsole::Config::lockfile("user$action");
	open LOCK, '+>>', $lockfile
		or exit (  Schulkonsole::Error::SophomorixError::WRAPPER_CANNOT_OPEN_FILE );
	if (not flock(LOCK, 4 | 2)) {
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_PROCESS_RUNNING );
	} else {
		use Proc::ProcessTable;

		my $process_table = new Proc::ProcessTable;
		my $app_cmnd = Schulkonsole::Encode::to_cli($cmd);
		$app_cmnd =~ s:.*/::;
		foreach my $process (@{ $process_table->table }) {
			if (    $process->uid == $>
			    and $process->fname =~ /^sophomor/
			    and $process->cmndline =~ /$app_cmnd/) {
				exit (  Schulkonsole::Error::SophomorixError::WRAPPER_PROCESS_RUNNING );
			}
		}
	}

	my $log_file_base = POSIX::strftime(
		"$DevelConf::log_files/sophomorix-$action.txt.%Y-%m-%d_%H-%M-%S",
		localtime);
	my $log_file = $log_file_base;
	my $cnt = 0;
	while (-e Schulkonsole::Encode::to_fs($log_file)) {
		$cnt++;
		$log_file = sprintf "$log_file_base-%02d", $cnt;
	}
	print "$log_file\n";

	my $pid = fork;
	exit (  Schulkonsole::Error::Error::WRAPPER_CANNOT_FORK )
		unless defined $pid;

	if (not $pid) {
		close STDIN;
		$< = $>;
		$) = 0;
		$( = $);
		umask(022);
		open STDOUT, '>>', Schulkonsole::Encode::to_fs($log_file);	# ignore errors
		open STDERR, '>>&', *STDOUT;

		$ENV{PATH} = '/bin:/sbin:/usr/sbin:/usr/bin';
		$ENV{DEBIAN_FRONTEND} = 'teletype';
		exec $cmd or return;
	} else {
		seek LOCK, 0, 0;
		truncate LOCK, 0;
		print LOCK "$pid\n";
	}


	exit 0;
}

=head3 addmovekill_users

numeric constant: C<Schulkonsole::Config::USERSADDMOVEKILLAPP>

=cut

sub usersaddmovekillapp(){
	my $action = 'addmovekill';

	my $addmovekill_lockfile = Schulkonsole::Config::lockfile("user$action");
	open ALLLOCK, '+>>', $addmovekill_lockfile
		or exit (  Schulkonsole::Error::SophomorixError::WRAPPER_CANNOT_OPEN_FILE );
	if (not flock(ALLLOCK, 4 | 2)) {
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_PROCESS_RUNNING );
	}


	my $pid = fork;
	exit (  Schulkonsole::Error::Error::WRAPPER_CANNOT_FORK )
		unless defined $pid;

	if (not $pid) {
		close STDIN;
		$< = $>;
		$) = 0;
		$( = $);
		umask(022);
		$ENV{PATH} = '/bin:/sbin:/usr/sbin:/usr/bin';
		$ENV{DEBIAN_FRONTEND} = 'teletype';


		my @action = ('add', 'move', 'kill');
		my @cmds = (
			$Schulkonsole::Config::_cmd_sophomorix_add,
			$Schulkonsole::Config::_cmd_sophomorix_move,
			$Schulkonsole::Config::_cmd_sophomorix_kill,
		);
		USERAPPS: for my $i (0..2) {
			my $lockfile = Schulkonsole::Config::lockfile("user$action[$i]");
			open LOCK, '+>>', $lockfile
				or exit (  Schulkonsole::Error::SophomorixError::WRAPPER_CANNOT_OPEN_FILE );
			if (not flock(LOCK, 4 | 2)) {
				next USERAPPS;
			} else {
				use Proc::ProcessTable;

				my $process_table = new Proc::ProcessTable;
				my $app_cmnd = Schulkonsole::Encode::to_cli($cmds[$i]);
				$app_cmnd =~ s:.*/::;
				foreach my $process (@{ $process_table->table }) {
					if (    $process->uid == $>
					    and $process->fname =~ /^sophomor/
					    and $process->cmndline =~ /$app_cmnd/) {
						next USERAPPS;
					}
				}
			}

			my $log_file_base = POSIX::strftime(
				"$DevelConf::log_files/sophomorix-$action[$i].txt.%Y-%m-%d_%H-%M-%S",
				localtime);
			my $log_file = Schulkonsole::Encode::to_fs($log_file_base);
			my $cnt = 0;
			while (-e $log_file) {
				$cnt++;
				$log_file = Schulkonsole::Encode::to_fs(
				            	sprintf "$log_file_base-%02d", $cnt);
			}
			open STDOUT, '>>', $log_file;	# ignore errors
			open STDERR, '>>&', *STDOUT;

			system Schulkonsole::Encode::to_cli($cmds[$i]);

			close LOCK;
		}

		close ALLLOCK;
		exit 0;
	} else {
		truncate ALLLOCK, 0;
		seek ALLLOCK, 0, 0;
		print ALLLOCK "$pid\n";

		close ALLLOCK;
	}


	exit 0;
}

=head3 teachin

numeric constant: C<Schulkonsole::Config::TEACHINAPP>

=head4 Parameters from standard input

=over

=item mode

0 = check, 1 = list, 2 = set

=back

=cut

sub teachinapp() {
	my $mode = <>;
	($mode) = $mode =~ /^([012])$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_MODE )
		unless defined $mode;

	$< = $>;
	$) = 0;
	$( = $);
	umask(022);

	my $opts;

	TEACHINMODE: {
	$mode == 0 and do {
		$opts = '--next 1';
		last TEACHINMODE;
	};
	$mode == 1 and do {
		$opts = '--all';
		last TEACHINMODE;
	};
	$mode == 2 and do {
		my @teachin_users;
		my @ignore_users;
		while (<>) {
			last if /^$/;
			chomp;

			my ($username, $id) = /^(.+)\t(.*)$/;
			exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_USER )
				unless $username;

			if ($id) {
				push @teachin_users, "${username}::${id}";
			} else {
				push @ignore_users, $username;
			}
		}
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_NO_USERS )
			unless (@teachin_users or @ignore_users);

		while (    @ignore_users
		       and length(join(',', @ignore_users, @teachin_users)) > 800) {
			my $end = (@ignore_users < 50) ? @ignore_users : 50;
			$opts = '--all --ignore ' . quotemeta(join(',', @ignore_users[0..$end]));

			system Schulkonsole::Encode::to_cli(
			       	"$Schulkonsole::Config::_cmd_sophomorix_teachin $opts");
			@ignore_users = @ignore_users[$end + 1..$#ignore_users];
		}

		while (    @teachin_users
		       and length(join(',', @teachin_users)) > 800) {
			my $end = (@teachin_users < 20) ? @teachin_users : 20;
			$opts = '--all --teachin ' . quotemeta(join(',', @teachin_users[0..$end]));
			system Schulkonsole::Encode::to_cli(
			       	"$Schulkonsole::Config::_cmd_sophomorix_teachin $opts");
			@teachin_users = @teachin_users[$end + 1..$#teachin_users];
		}

		if (@ignore_users) {
			$opts = '--all --ignore ' . quotemeta(join(',', @ignore_users)) . ' ';
		} else {
			$opts = '--all ';
		}
		if (@teachin_users) {
			$opts .= '--teach-in ' . quotemeta(join(',', @teachin_users));
		}

		exit 0 unless $opts;

		last TEACHINMODE;
	};
	}

	exec Schulkonsole::Encode::to_cli(
	     	"$Schulkonsole::Config::_cmd_sophomorix_teachin $opts")
		or return;
}

=head3 chmod

numeric constant: C<Schulkonsole::Config::CHMODAPP>

=head4 Parameters from standard input

=over

=item on

1 for permissive mode, 0 otherwise

=item number

number of the directory

=back

=cut

sub chmodapp(){
	my $number = <>;
	($number) = $number =~ /^([01])$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FILENUMBER )
		unless defined $number;

	my $on = <>;
	($on) = $on =~ /^([01])$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_ON_UNDEFINED )
		unless defined $on;

	my $filename;
	my $mode;
	SWITCHDIR: {
	$number == 0 and do {
		$filename = Schulkonsole::Encode::to_fs($DevelConf::share_school);
		$mode = $on ? 03777 : 0700;
		last SWITCHDIR;
	};
	}

	chmod $mode, $filename
		or exit (  Schulkonsole::Error::SophomorixError::WRAPPER_CHMOD_FAILED );

	exit 0;
}

=head3 quota

numeric constant: C<Schulkonsole::Config::SETQUOTAAPP>

=head4 Parameters from standard input

=over

=item mode

bitwise or: 1 = set, 2 = teachers, 4 = students, 8 = force
or
16 = class, 17 = project

=item diskquota (if mode == 16 or mode == 17)

=item mailquota (if mode == 16 or mode == 17)

=back

=cut

sub setquotaapp() {
	my $flags = <>;
	($flags) = $flags =~ /^(\d+)$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_FLAGS )
		unless defined $flags || $flags > 17;

	my $app_opts;
	if ($flags > 15) {
		my $gid = <>;
		if ($flags == 16) {
			($gid) = $gid =~ /^(.+)$/;
			exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_CLASS )
				unless $gid;
		} else {
			($gid) = $gid =~ /^((?:p_)?[a-z0-9_-]{3,14})$/;
			exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_PROJECTGID )
				unless defined $gid;
		}

		my $diskquota = <>;
		($diskquota) = $diskquota =~ /^((?:\d+(?:\+\d+)*)?|quota)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_DISKQUOTA )
			unless defined $diskquota;

		my $mailquota = <>;
		($mailquota) = $mailquota =~ /^(\d*|-1)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_MAILQUOTA )
			unless defined $mailquota;

		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_DISKQUOTA )
			unless length($diskquota) || length($mailquota);


		if ($flags == 16) {
			$app_opts
				= "$Schulkonsole::Config::_cmd_sophomorix_class --class \Q$gid";
			if (length($diskquota)) {
				if ($diskquota eq 'quota') {
					$app_opts .= ' --quota standard';
				} else {
					$app_opts .= " --quota \Q$diskquota";
				}
			}
			if (length($mailquota)) {
				$app_opts .= " --mailquota $mailquota";
			}
		} else {
			$app_opts =   $Schulkonsole::Config::_cmd_sophomorix_project
			            . " --caller \Q$$userdata{uid}\E --project \Q$gid";
			if (length($diskquota)) {
				if ($diskquota eq 'quota') {
					$app_opts .= ' --addquota ""';
				} else {
					$app_opts .= " --addquota \Q$diskquota";
				}
			}
			if (length($mailquota)) {
				$app_opts .= " --addmailquota $mailquota";
			}
		}
	} else {
		$app_opts = "$Schulkonsole::Config::_cmd_sophomorix_quota ";
		$app_opts .= '--set ' if $flags & 1;
		$app_opts .= '--teachers ' if $flags & 2;
		$app_opts .= '--students ' if $flags & 4;
		$app_opts .= '--force ' if $flags & 8;
	}

	my $pid = fork;
	exit (  Schulkonsole::Error::Error::WRAPPER_CANNOT_FORK )
		unless defined $pid;

	if (not $pid) {
		close STDIN;
		my $log_file_base = POSIX::strftime(
			"$DevelConf::log_files/sophomorix-quota.txt.%Y-%m-%d_%H-%M-%S",
			localtime);
		my $log_file = Schulkonsole::Encode::to_fs($log_file_base);
		my $cnt = 0;
		while (-e $log_file) {
			$cnt++;
			$log_file = Schulkonsole::Encode::to_fs(
			            	sprintf "$log_file_base-%02d", $cnt);
		}
		open STDOUT, '>>', $log_file; # ignore errors
		open STDERR, '>>&', *STDOUT;

		$< = $>;
		$) = 0;
		$( = $);
		umask(022);

		my $lockfile = Schulkonsole::Config::lockfile('processquota');
		open LOCK, '>>', $lockfile
			or exit (  Schulkonsole::Error::SophomorixError::WRAPPER_CANNOT_OPEN_FILE );
		flock LOCK, 2;
		truncate LOCK, 0;
		seek LOCK, 0, 0;
		print LOCK "$$\n";

		exec Schulkonsole::Encode::to_cli($app_opts) or return;
	}

	exit 0;
}

=head3 set_own_password

numeric constant: C<Schulkonsole::Config::SETOWNPASSWORDAPP>

=head4 Parameters from standard input

=over

=item newpassword

The new password

=back

=cut

sub setownpasswordapp() {
	my $password = <>;
	($password) = $password =~ /^(.+)$/;
	exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_PASSWORD )
		unless $password;

	my $opts = "--nofirstpassupdate --user \Q$$userdata{uid}\E --pass \Q$password\E";

	# sophomorix-passwd cannot be invoked with taint checks enabled
	$< = $>;
	$( = $);
	exec Schulkonsole::Encode::to_cli(
	    "$Schulkonsole::Config::_cmd_sophomorix_passwd $opts") or
	    exit (  Schulkonsole::Error::Error::WRAPPER_GENERAL_ERROR );
	exit 0;
}

=head3 hide_unhide_class

numeric constant: C<Schulkonsole::Config::HIDEUNHIDECLASSAPP>

=head4 Parameters from standard input

=over

=item hide_classs

Classes to hide

=item unhide_classs

Classes to unhide

=back

=cut

sub hideunhideclassapp() {
	my @hides;
	my @nohides;
	while (<>) {
		last if /^$/;

		my ($gid) = /^(.+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_CLASS )
			unless $gid;

		push @hides, $gid;
	}
	while (<>) {
		last if /^$/;

		my ($gid) = /^(.+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_CLASS )
			unless $gid;

		push @nohides, $gid;
	}


	# sophomorix-class cannot be invoked with taint checks enabled
	$< = $>;
	$( = $);
        $) = 0;
        umask(022);

	my $opts = '--hide';
	foreach my $gid (@hides) {
		system(Schulkonsole::Encode::to_cli("$Schulkonsole::Config::_cmd_sophomorix_class $opts --class \Q$gid\E")) == 0
			or exit ($? >> 8);
	}
	$opts = '--nohide';
	foreach my $gid (@nohides) {
		system(Schulkonsole::Encode::to_cli("$Schulkonsole::Config::_cmd_sophomorix_class $opts --class \Q$gid\E")) == 0
			or exit ($? >> 8);
	}


	exit 0;
}

=head3 set_mymailapp

numeric constant: C<Schulkonsole::Config::SETMYMAILAPP>

=head4 Parameters from standard input

=over

=item mymail

String containing users mail address (can be empty)

=back

=cut

sub set_mymailapp(){
	my $mymail = <>;
	$mymail =~ s/^\s+|\s+$//g;
	$mymail ne "" and $mymail !~ /\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b/
		and exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_MAILADDRESS );
	
	&Schulkonsole::DB::set_user_mymail($$userdata{uid}, $mymail);
	
	exit 0;
}

=head3 change_mailalias_classes

numeric constant: C<Schulkonsole::Config::CHANGEMAILALIASCLASSAPP>

=head4 Parameters from standard input

=over

=item create_mailalias_classes

Classes to create mailaliases

=item remove_mailalias_classes

Classes to remove mailaliases

=back

=cut

sub changemailaliasclassapp() {
	my @creates;
	my @removes;
	while (<>) {
		last if /^$/;

		my ($gid) = /^(.+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_CLASS )
			unless $gid;

		push @creates, $gid;
	}
	while (<>) {
		last if /^$/;

		my ($gid) = /^(.+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_CLASS )
			unless $gid;

		push @removes, $gid;
	}


	# sophomorix-class cannot be invoked with taint checks enabled
	$< = $>;
	$( = $);
        $) = 0;
        umask(022);

	my $opts = '--mailalias';
	foreach my $gid (@creates) {
		system(Schulkonsole::Encode::to_cli("$Schulkonsole::Config::_cmd_sophomorix_class $opts --class \Q$gid\E")) == 0
			or exit ($? >> 8);
	}
	$opts = '--nomailalias';
	foreach my $gid (@removes) {
		system(Schulkonsole::Encode::to_cli("$Schulkonsole::Config::_cmd_sophomorix_class $opts --class \Q$gid\E")) == 0
			or exit ($? >> 8);
	}

	system(Schulkonsole::Encode::to_cli("$Schulkonsole::Config::_cmd_sophomorix_mail")) == 0
			or exit ($? >> 8);


	exit 0;
}

=head3 change_maillist_classes

numeric constant: C<Schulkonsole::Config::CHANGEMAILLISTCLASSAPP>

=head4 Parameters from standard input

=over

=item create_maillist_classes

Classes to create maillistes

=item remove_maillist_classes

Classes to remove maillistes

=back

=cut

sub changemaillistclassapp() {
	my @creates;
	my @removes;
	while (<>) {
		last if /^$/;

		my ($gid) = /^(.+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_CLASS )
			unless $gid;

		push @creates, $gid;
	}
	while (<>) {
		last if /^$/;

		my ($gid) = /^(.+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_CLASS )
			unless $gid;

		push @removes, $gid;
	}


	# sophomorix-class cannot be invoked with taint checks enabled
	$< = $>;
	$( = $);
        $) = 0;
        umask(022);

	my $opts = '--maillist';
	foreach my $gid (@creates) {
		system(Schulkonsole::Encode::to_cli("$Schulkonsole::Config::_cmd_sophomorix_class $opts --class \Q$gid\E")) == 0
			or exit ($? >> 8);
	}
	$opts = '--nomaillist';
	foreach my $gid (@removes) {
		system(Schulkonsole::Encode::to_cli("$Schulkonsole::Config::_cmd_sophomorix_class $opts --class \Q$gid\E")) == 0
			or exit ($? >> 8);
	}

	system(Schulkonsole::Encode::to_cli("$Schulkonsole::Config::_cmd_sophomorix_mail")) == 0
			or exit ($? >> 8);


	exit 0;
}

=head3 change_mailalias_projects

numeric constant: C<Schulkonsole::Config::CHANGEMAILALIASPROJECTAPP>

=head4 Parameters from standard input

=over

=item create_mailalias_projects

Classes to create mailaliases

=item remove_mailalias_projects

Classes to remove mailaliases

=back

=cut

sub changemailaliasprojectapp() {
	my @creates;
	my @removes;
	while (<>) {
		last if /^$/;

		my ($gid) = /^(.+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_PROJECT )
			unless $gid;

		push @creates, $gid;
	}
	while (<>) {
		last if /^$/;

		my ($gid) = /^(.+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_PROJECT )
			unless $gid;

		push @removes, $gid;
	}


	# sophomorix-class cannot be invoked with taint checks enabled
	$< = $>;
	$( = $);
        $) = 0;
        umask(022);

	my $opts = '--mailalias';
	foreach my $gid (@creates) {
		system(Schulkonsole::Encode::to_cli("$Schulkonsole::Config::_cmd_sophomorix_project $opts --project \Q$gid\E")) == 0
			or exit ($? >> 8);
	}
	$opts = '--nomailalias';
	foreach my $gid (@removes) {
		system(Schulkonsole::Encode::to_cli("$Schulkonsole::Config::_cmd_sophomorix_project $opts --project \Q$gid\E")) == 0
			or exit ($? >> 8);
	}

	system(Schulkonsole::Encode::to_cli("$Schulkonsole::Config::_cmd_sophomorix_mail")) == 0
			or exit ($? >> 8);

	exit 0;
}

=head3 change_maillist_projects

numeric constant: C<Schulkonsole::Config::CHANGEMAILLISTPROJECTAPP>

=head4 Parameters from standard input

=over

=item create_maillist_projects

Classes to create maillistes

=item remove_maillist_projects

Classes to remove maillistes

=back

=cut

sub changemaillistprojectapp() {
	my @creates;
	my @removes;
	while (<>) {
		last if /^$/;

		my ($gid) = /^(.+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_PROJECT )
			unless $gid;

		push @creates, $gid;
	}
	while (<>) {
		last if /^$/;

		my ($gid) = /^(.+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_PROJECT )
			unless $gid;

		push @removes, $gid;
	}


	# sophomorix-class cannot be invoked with taint checks enabled
	$< = $>;
	$( = $);
        $) = 0;
        umask(022);

	my $opts = '--maillist';
	foreach my $gid (@creates) {
		system(Schulkonsole::Encode::to_cli("$Schulkonsole::Config::_cmd_sophomorix_project $opts --project \Q$gid\E")) == 0
			or exit ($? >> 8);
	}
	$opts = '--nomaillist';
	foreach my $gid (@removes) {
		system(Schulkonsole::Encode::to_cli("$Schulkonsole::Config::_cmd_sophomorix_project $opts --project \Q$gid\E")) == 0
			or exit ($? >> 8);
	}

	system(Schulkonsole::Encode::to_cli("$Schulkonsole::Config::_cmd_sophomorix_mail")) == 0
			or exit ($? >> 8);


	exit 0;
}

=head3 join_no_join_project

numeric constant: C<Schulkonsole::Config::PROJECTJOINNOJOINAPP>

=head4 Parameters from standard input

=over

=item hide_classs

Classes to hide

=item unhide_classs

Classes to unhide

=back

=cut

sub projectjoinnojoinapp() {
	my @joins;
	my @nojoins;
	while (<>) {
		last if /^$/;

		my ($gid) = /^(.+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_PROJECT )
			unless $gid;

		push @joins, $gid;
	}
	while (<>) {
		last if /^$/;

		my ($gid) = /^(.+)$/;
		exit (  Schulkonsole::Error::SophomorixError::WRAPPER_INVALID_PROJECT )
			unless $gid;

		push @nojoins, $gid;
	}


	# sophomorix-project cannot be invoked with taint checks enabled
	$< = $>;
	$( = $);

	my $opts = "--caller \Q$$userdata{uid}\E --join";
	foreach my $gid (@joins) {
		system(Schulkonsole::Encode::to_cli("$Schulkonsole::Config::_cmd_sophomorix_project $opts --project \Q$gid\E")) == 0
			or exit ($? >> 8);
	}
	$opts = "--caller \Q$$userdata{uid}\E --nojoin";
	foreach my $gid (@nojoins) {
		system(Schulkonsole::Encode::to_cli("$Schulkonsole::Config::_cmd_sophomorix_project $opts --project \Q$gid\E")) == 0
			or exit ($? >> 8);
	}


	exit 0;
}

sub get_decoded {
	my $data = shift;
	my $utf8 = $data;

	utf8::decode($utf8);

	return $utf8;
}


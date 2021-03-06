#
# $Id$
#
=head1 NAME

Schulkonsole::Config - access to schulkonsole configuration

=head1 SYNOPSIS

 use Schulkonsole::Config;

 my %db_config = db();

 my $page_permissions = permissions_pages();
 my $app_permissions = permissions_apps();

 my ($room, $workstation) = workstation_info('localhost', 127.0.0.1);
 open INFO, '<', workstation_file($workstation);
 my $workstations =  workstations_room($room);
 my $printers = printers_room($room);
 my $classrooms = classrooms();

=cut

use strict;
use utf8;
use open ':utf8';

package Schulkonsole::Config;
require Exporter;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
$VERSION = 0.06;
@ISA = qw(Exporter);
@EXPORT_OK = qw(
	SKPREFS
	PATHPREFS
	PROJECTPREFS
	CLASSPREFS
	
	db
	ldap
	permissions_pages
	permissions_apps
	workstation_info
	workstations_room

	rooms
	hosts
	workstations
	linbogroups

	_repair_path

	printers_room
	printers
	classrooms
	workstation_file
	lockfile

	expire_seconds

	$_lml_majorversion
	$_sysconfdir
	$_templatedir
	$_runtimedir
	$_lockdir

	$_project_mailalias
	$_project_maillist
	$_project_wlan
	$_class_mailalias
	$_class_maillist
	$_class_wlan
	
	$_preferences_conf_file
	$_permissions_conf_file
	$_db_conf_file
	$_workstations_file
	$_workstations_log_file
	$_workstations_tmp_log_file
	$_room_defaults_file
	$_dhcpd_conf_file
	$_printers_file
	$_classrooms_file
	$_blocked_hosts_internet_file
	$_blocked_hosts_intranet_file
	$_unfiltered_hosts_file
	$_cups_printers_conf_file
	$_wlan_defaults_file
	$_wlan_ldap_group

	$_login_template

	$_max_idle_time
	$_session_expire_time
	$_login_expire_time
	$_tmp_valid_time

	$_check_passwords
	$_min_password_len
	$_http_root
	$_htaccess_filename

	$_imap_host
	$_wrapper_user
	$_wrapper_firewall
	$_wrapper_ovpn
	$_wrapper_printer
	$_wrapper_sophomorix
	$_wrapper_cyrus
	$_wrapper_collab
	$_wrapper_files
	$_wrapper_linbo
	$_wrapper_radius
	$_wrapper_debconf
	$_wrapper_repair
	$_wrapper_horde

	%_id_root_app_names
	$_cmd_internet_on_off
	$_cmd_intranet_on_off
	$_cmd_update_logins
	$_cmd_update_linbofs
	$_cmd_urlfilter_check
	$_cmd_urlfilter_on_off
	$_cmd_linuxmuster_reset
	$_cmd_printer_accept
	$_cmd_printer_reject
	$_cmd_printer_lpadmin
	$_cmd_printer_info
	$_cmd_sophomorix_teacher
	$_cmd_sophomorix_room
	$_cmd_sophomorix_print
	$_cmd_sophomorix_passwd
	$_cmd_sophomorix_project
	$_cmd_sophomorix_check
	$_cmd_sophomorix_add
	$_cmd_sophomorix_move
	$_cmd_sophomorix_kill
	$_cmd_sophomorix_teachin
	$_cmd_sophomorix_quota
	$_cmd_sophomorix_class
	$_cmd_sophomorix_mail
	$_cmd_sophomorix_repair
	$_cmd_import_workstations
	$_cmd_import_printers
	$_cmd_ovpn_client_cert
	$_cmd_wlan_on_off
	$_cmd_linuxmuster_wlan_reset
	$_cmd_horde_mail
	$_cmd_linbo_remote

	$_shell

	$true
	$false
	$on
	$off
	
	QUOTAAPP
	CYRQUOTAAPP

	INTERNETONOFFAPP
	INTRANETONOFFAPP
	UPDATELOGINSAPP
	UPDATELINBOFSAPP
	URLFILTERCHECKAPP
	URLFILTERONOFFAPP
	ALLONAPP
	ALLONATAPP
	WLANALLOWEDAPP
	WLANONOFFAPP
	WLANRESETATAPP
	WLANRESETAPP
	PRINTERINFOAPP
	PRINTERONOFFAPP
	PRINTERALLOWDENYAPP
	SHARESTATESAPP
	SHARESONOFFAPP
	FILEMANAPP
	STUDENTSFILEMANAPP
	LSHANDEDOUTAPP
	LSHANDOUTAPP
	LSCOLLECTAPP
	LSCOMMITSAPP
	LSCOMMITAPP
	HANDOUTAPP
	COLLECTAPP
	RESETROOMAPP
	EDITOWNCLASSMEMBERSHIPAPP
	PRINTCLASSAPP
	PRINTALLUSERSAPP
	PRINTCOMMITAPP
	PRINTTEACHERSAPP
	PRINTPROJECTAPP
	SETPASSWORDSAPP
	PROJECTMEMBERSAPP
	PROJECTCREATEDROPAPP
	PROJECTJOINNOJOINAPP
	PROJECTWLANDEFAULTSAPP
	READSOPHOMORIXFILEAPP
	WRITESOPHOMORIXFILEAPP
	USERSCHECKAPP
	USERSADDAPP
	USERSMOVEAPP
	USERSKILLAPP
	USERSADDMOVEKILLAPP
	TEACHINAPP
	CHMODAPP
	SETQUOTAAPP
	SETOWNPASSWORDAPP
	HIDEUNHIDECLASSAPP
	WRITEFILEAPP
	IMPORTWORKSTATIONSAPP
	IMPORTPRINTERSAPP
	OVPNCHECKAPP
	OVPNDOWNLOADAPP
	OVPNCREATEAPP
	LINBOWRITESTARTCONFAPP
	LINBOCOPYSTARTCONFAPP
	LINBOCOPYREGPATCHAPP
	LINBOIMAGEAPP
	LINBOREMOTESTATUSAPP
	LINBOREMOTEWINDOWAPP
	LINBOREMOTEAPP
	LINBOREMOTEPLANNEDAPP
	LINBOREMOTEREMOVEAPP

	TEST_NONE
	TEST_HANDOUT
	TEST_PASSWORD
	TEST_COLLECT

	REPAIRPERMISSIONSAPP
	REPAIRMYHOMEAPP
	REPAIRCLASSHOMESAPP
	REPAIRPROJECTHOMESAPP
	REPAIRHOMESAPP
	REPAIRGETINFOAPP
	
	GETMAILFORWARDS
	SETMAILFORWARDS
	REMOVEMAILFORWARDS
);

use Env::Bash;
use Schulkonsole::Encode;


=head1 DESCRIPTION

=head2 Constants

The following constants are used by the wrappers to identify which
application to invoke. A user can only use these applications if the
corresponding string is listed for his group in the section
C<[External Programs]> in C<$_permissions_conf_file>.

=head3 Constants for preferences file

=over

=item C<SKREFS>

Section name for Schulkonsole preferences

=item C<PATHPREFS>

Section name for program repair paths

=item C<DBPREFS>

Section name for DB preferences to access in db.conf (used only internal)

=item C<PROJECTPREFS>

Section name for project creating preferences

=item C<CLASSPREFS>

Section name for class creating preferences

=cut

use vars qw($SKPREFS $PATHPREFS $PROJECTPREFS $CLASSPREFS);
	
=head3 Constants for wrapper-user

=over

=item C<QUOTAAPP>

C<quota>

=back

=cut

use constant {
	QUOTAAPP => 0,
};

=head3 Constants for wrapper-firewall

=over

=item C<INTERNETONOFFAPP>

C<internet_on_off>

=item C<INTRANETONOFFAPP>

C<intranet_on_off>

=item C<UPDATELOGINSAPP>

C<update_logins>

=item C<UPDATELINBOFSAPP>

C<update_logins>

=item C<URLFILTERCHECKAPP>

C<urlfilter_check>

=item C<URLFILTERONOFFAPP>

C<urlfilter_on_off>

=item C<ALLONAPP>

C<all_on>

=item C<ALLONATAPP>

C<all_on_at>

=item C<ROOMSRESETAPP>

C<rooms_reset>

=item C<WLANALLOWEDAPP>

C<allowed_groups_users_wlan>

=item C<WLANONOFFAPP>

C<wlan_on_off>

=item C<WLANRESETATAPP>

C<wlan_reset_at>

=item C<WLANRESETAPP>

C<wlan_reset>

=back

=cut

use constant {
	INTERNETONOFFAPP => 6001,
	INTRANETONOFFAPP => 6002,
	UPDATELOGINSAPP => 6003,
	UPDATELINBOFSAPP => 6004,
	URLFILTERCHECKAPP => 6005,
	URLFILTERONOFFAPP => 6006,
	ALLONAPP => 6007,
	ALLONATAPP => 6008,
	ROOMSRESETAPP => 6009,
	WLANALLOWEDAPP => 6010,
	WLANONOFFAPP => 6011,
	WLANRESETATAPP => 6012,
	WLANRESETAPP => 6013,
};

=head3 Constants for wrapper-printer

=over

=item C<PRINTERINFOAPP>

C<printer_info>

=item C<PRINTERONOFFAPP>

C<printer_on_off>

=item C<PRINTERALLOWDENYAPP>

C<printer_allow_deny>

=back

=cut

use constant {
	PRINTERINFOAPP => 7001,
	PRINTERONOFFAPP => 7002,
	PRINTERALLOWDENYAPP => 7003,
};

=head3 Constants for wrapper-sophomorix

=over

=item C<SHARESTATESAPP>

C<share_states>

=item C<SHARESONOFFAPP>

C<shares_on_off>

=item C<FILEMANAPP>

C<fileman>

=item C<STUDENTSFILEMANAPP>

C<studentsfileman>

=item C<LSHANDEDOUTAPP>

C<ls_handedout>

=item C<LSHANDOUTAPP>

C<ls_handout>

=item C<LSCOLLECTAPP>

C<ls_collect>

=item C<LSCOMMITSAPP>

C<ls_commits>

=item C<LSCOMMITAPP>

C<ls_commit>

=item C<HANDOUTAPP>

C<handout>

=item C<COLLECTAPP>

C<collect>

=item C<RESETROOMAPP>

C<room_reset>

=item C<EDITOWNCLASSMEMBERSHIPAPP>

C<edit_own_class_membership>

=item C<PRINTCLASSAPP>

C<print_class>

=item C<PRINTALLUSERSAPP>

C<print_allusers>

=item C<PRINTCOMMITAPP>

C<print_commit>

=item C<PRINTTEACHERSAPP>

C<print_teachers>

=item C<PRINTPROJECTAPP>

C<print_project>

=item C<SETPASSWORDSAPP>

C<set_passwords>

=item C<PROJECTMEMBERSAPP>

C<project_members>

=item C<PROJECTCREATEDROPAPP>

C<project_create_drop>

=item C<PROJECTJOINNOJOINAPP>

C<project_join_no_join>

=item C<PROJECTWLANDEFAULTSAPP>

C<project_wlan_defaults>

=item C<READSOPHOMORIXFILEAPP>

C<read_sophomorix_file>

=item C<WRITESOPHOMORIXFILEAPP>

C<write_sophomorix_file>

=item C<USERSCHECKAPP>

C<check_users>

=item C<USERSADDAPP>

C<add_users>

=item C<USERSMOVEAPP>

C<move_users>

=item C<USERSKILLAPP>

C<kill_users>

=item C<USERSADDMOVEKILLAPP>

C<addmovekill_users>

=item C<TEACHINAPP>

C<teachin>

=item C<CHMODAPP>

C<chmod>

=item C<SETQUOTAAPP>

C<quota>

=item C<SETOWNPASSWORDAPP>

C<set_own_password>

=item C<HIDEUNHIDECLASSAPP>

C<hide_unhide_class>

=item C<CHANGEMAILALIASCLASSAPP>

C<change_mailalias_classes>

=item C<CHANGEMAILLISTCLASSAPP>

C<change_maillist_classes>

=item C<CHANGEMAILALIASPROJECTAPP>

C<change_mailalias_projects>

=item C<CHANGEMAILLISTPROJECTAPP>

C<change_maillist_projects>

=item C<SETMYMAILAPP>

C<set_user_mymail>

=back


=cut

use constant {
	SHARESTATESAPP => 8001,
	SHARESONOFFAPP => 8002,
	LSHANDOUTAPP => 8003,
	LSCOLLECTAPP => 8004,
	HANDOUTAPP => 8005,
	COLLECTAPP => 8006,
	RESETROOMAPP => 8007,
	EDITOWNCLASSMEMBERSHIPAPP => 8008,
	PRINTCLASSAPP => 8009,
	PRINTTEACHERSAPP => 8010,
	PRINTPROJECTAPP => 8011,
	SETPASSWORDSAPP => 8012,
	WWWPERMISSIONSAPP => 8013,
	PROJECTMEMBERSAPP => 8014,
	PROJECTCREATEDROPAPP => 8015,
	PROJECTJOINNOJOINAPP => 8016,
	PROJECTWLANDEFAULTSAPP => 8017,
	READSOPHOMORIXFILEAPP => 8018,
	WRITESOPHOMORIXFILEAPP => 8019,
	USERSCHECKAPP => 8020,
	USERSADDAPP => 8021,
	USERSMOVEAPP => 8022,
	USERSKILLAPP => 8023,
	USERSADDMOVEKILLAPP => 8024,
	TEACHINAPP => 8025,
	CHMODAPP => 8026,
	SETQUOTAAPP => 8027,
	SETOWNPASSWORDAPP => 8028,
	HIDEUNHIDECLASSAPP => 8029,
	CHANGEMAILALIASCLASSAPP => 8030,
	CHANGEMAILLISTCLASSAPP => 8031,
	CHANGEMAILALIASPROJECTAPP => 8032,
	CHANGEMAILLISTPROJECTAPP => 8033,
	FILEMANAPP => 8034,
	STUDENTSFILEMANAPP => 8035,
	LSHANDEDOUTAPP =>8036,
	LSCOMMITSAPP => 8037,
	LSCOMMITAPP => 8038,
	PRINTALLUSERSAPP => 8039,
	PRINTCOMMITAPP => 8040,
	SETMYMAILAPP => 8041,
};

=head3 Constants for wrapper-cyrus

=over

=item C<CYRUSQUOTAAPP>

C<cyrusquota>

=back

=cut

use constant {
	CYRUSQUOTAAPP => 9001,
};


=head3 Constants for wrapper-files

=over

=item C<WRITEFILEAPP>

C<write_file>

=item C<IMPORTWORKSTATIONSAPP>

C<import_workstations>

=item C<IMPORTPRINTERSAPP>

C<import_printers>

=back

=cut

use constant {
	WRITEFILEAPP => 11001,
	IMPORTWORKSTATIONSAPP => 11002,
	IMPORTPRINTERSAPP => 11003,
};


=head3 Constants for wrapper-ovpn

=over

=item C<OVPNCHECKAPP>

C<ovpn_check>

=item C<OVPNDOWNLOADAPP>

C<ovpn_download>

=item C<OVPNCREATEAPP>

C<ovpn_download>

=back

=cut

use constant {
	OVPNCHECKAPP => 12001,
	OVPNDOWNLOADAPP => 12002,
	OVPNCREATEAPP => 12003,
};


=head3 Constants for wrapper-linbo

=over

=item C<LINBOWRITESTARTCONFAPP>

C<write_start_conf>

=item C<LINBOCOPYSTARTCONFAPP>

C<copy_start_conf>

=item C<LINBOCOPYREGPATCHAPP>

C<copy_regpatch>

=item C<LINBODELETEAPP>

C<linbo_delete>

=item C<LINBOWRITEAPP>

C<linbo_write>

=item C<LINBOIMAGEAPP>

C<linbo_manage_images>

=item C<LINBOWRITEGRUBCFGAPP>

C<linbo_write_grub_cfg>

=item C<LINBOREMOTESTATUSAPP>

C<linbo_remote_status>

=item C<LINBOREMOTEWINDOWAPP>

C<linbo_remote_window>

=item C<LINBOREMOTEAPP>

C<linbo_remote>

=item C<LINBOREMOTEPLANNEDAPP>

C<linbo_remote_planned>

=item C<LINBOREMOTEREMOVEAPP>
C<linbo_remote_remove>

=item C<LINBOWRITEPXEAPP>

C<linbo_write_pxe>

=back

=cut

use constant {
	LINBOWRITESTARTCONFAPP => 13001,
	LINBOCOPYSTARTCONFAPP => 13002,
	LINBOCOPYREGPATCHAPP => 13003,
	LINBODELETEAPP => 13004,
	LINBOWRITEAPP => 13005,
	LINBOIMAGEAPP => 13006,
	LINBOWRITEGRUBCFGAPP => 13007,
	LINBOREMOTESTATUSAPP => 13008,
	LINBOREMOTEWINDOWAPP => 13009,
	LINBOREMOTEAPP => 13010,
	LINBOREMOTEPLANNEDAPP => 13011,
	LINBOREMOTEREMOVEAPP => 13012,
	LINBOWRITEPXEAPP => 13013,
};


=head3 Constants for wrapper-debconf

=over

=item C<DEBCONFREADAPP>

=item C<DEBCONFREADSMTPRELAYAPP>

=back

=cut

use constant {
	DEBCONFREADAPP => 15001,
	DEBCONFREADSMTPRELAYAPP => 15002,
};


=head3 Constants that describe the state of an exam

=over

=item C<TEST_NONE>

=item C<TEST_HANDOUT>

=item C<TEST_PASSWORD>

=item C<TEST_COLLECT>

=back

=cut

use constant {
	TEST_NONE => 0,
	TEST_HANDOUT => 1,
	TEST_PASSWORD => 2,
	TEST_COLLECT => 3,
};



=head3 Constants for wrapper-repair

=over

=item C<REPAIRPERMISSIONSAPP>

=item C<REPAIRMYHOMEAPP>

=item C<REPAIRCLASSHOMESAPP>

=item C<REPAIRPROJECTHOMESAPP>

=item C<REPAIRHOMESAPP>

=item C<REPAIRGETINFOAPP>

=back

=cut

use constant {
	REPAIRPERMISSIONSAPP => 16001,
	REPAIRMYHOMEAPP => 16002,
	REPAIRCLASSHOMESAPP => 16003,
	REPAIRPROJECTHOMESAPP => 16004,
	REPAIRHOMESAPP => 16005,
	REPAIRGETINFOAPP => 16006,
};


=head3 Constants for wrapper-horde

=over

=item C<GETMAILFORWARDS>

=item C<SETMAILFORWARDS>

=item C<REMOVEMAILFORWARDS>
=back

=cut

use constant {
      GETMAILFORWARDS => 17001,
      SETMAILFORWARDS => 17002,
      REMOVEMAILFORWARDS => 17003,
};

=head2 Predefined variables

=over

=item C<$_version>

The version of Schulkonsole

=back

=head3 Directories

=over

=item C<$_sysconfdir>

The path to the directory that holds the schulkonsole configuration files

=item C<$_templatedir>

The path to the directory that holds the template files

=item C<$_runtimedir>

The path to the directory to store runtime information

=item C<$_lockdir>

The path to the directory to store lock files

=back

=cut

use vars qw($_version $_sysconfdir $_templatedir $_runtimedir $_lockdir);


=head3 Schulkonsole configuration files

=over

=item C<$_preferences_conf_file>

User set preferences

=item C<$_permissions_conf_file>

Defines which user groups can access pages and applications

=item C<$_db_conf_file>

Data to access the database

=back

=cut

use vars qw($_preferences_conf_file $_permissions_conf_file $_db_conf_file);


=head3 Linuxmuster configuration files

=over

=item C<$_workstations_file>

This file lists the workstations

=item C<$_workstations_log_file>

This file is the log file of the last run of import_workstations

=item C<$_workstations_tmp_log_file>

This file is the log file of the current run of import_workstations

=item C<$_room_defaults_file>

This file defines the default internet, intranet, and webfilter settings

=item C<$_dhcpd_conf_file>

DHCPD configuration file

=item C<$_printers_file>

This file lists the printers

=item C<$_classrooms_file>

This file lists the classrooms

=item C<$_network_settings_file>

Default network settings

=item C<$_linbo_dir>

LINBO directory

=item C<$_grub_config_dir>

Grub Config directory

=item C<$_pxe_config_dir>

PXE Config directory

=item C<$_grub_templates_dir>

Grub templates directory

=item C$_linbo_log_dir>

LINBO log directory

=item C<$_linbo_start_conf_prefix>

Prefix of start.conf.* files

=item C<$_linbo_examples_dir>

Directory holding LINBO examples for start.conf files

=item C<$_linbo_templates_os_dir>

Directory holding LINBO templates for section [OS]

=item C<$_linbo_template_partition>

The LINBO template for section [Partition]

=item C<$_wlan_defaults_file>

This file defines the default wlan settings

=item C<$_wlan_ldap_group>

This variable holds the ldap group name, that wlan access is granted to.

=back

=cut

use vars qw($_workstations_file $_workstations_log_file 
            $_workstations_tmp_log_file 
            $_room_defaults_file $_classrooms_file
            $_printers_file
            $_network_settings_file
            $_linbo_dir $_grub_config_dir
            $_pxe_config_dir
            $_grub_templates_dir
            $_linbo_log_dir $_linbo_start_conf_prefix
            $_linbo_examples_dir
            $_linbo_templates_dir $_linbo_templates_os_dir
            $_linbo_template_partition
            $_dhcpd_conf_file
            $_wlan_defaults_file $_wlan_ldap_group);


=head3 Files with status information

=over

=item C<$_lml_majorversion>

Major version of linuxmuster.net distribution

=item C<$_lml_cache_dir>

Directory where Linuxmusterloesung caches information

=item C<$_blocked_hosts_internet_file>

This file contains a cached list of hosts that are blocked from the internet

=item C<$_blocked_hosts_intranet_file>

This file contains a cached list of hosts that are blocked from the intranet

=item C<$_unfiltered_hosts_file>

This files contains a cached list of hosts that are not filtered by the
web-filter

=item C<$_cups_printers_conf_file>

CUPS printer configuration file

=item C<$_workstation_file>

A format-string to generate the filename for workstation information

=item C<$_lml_start>

True if linuxmuster is started at boot time

=back

=cut

use vars qw($_lml_majorversion
            $_lml_cache_dir
            $_blocked_hosts_internet_file $_blocked_hosts_intranet_file
            $_unfiltered_hosts_file $_cups_printers_conf_file
            $_workstation_file
            $_lml_start);


=head3 Special template files

=over

=item C<$_login_template>

The template to display the login form

=back

=cut

use vars qw($_login_template);


=head3 Time and other limits

=over

=item C<$_max_idle_time>

Time after which to ask for the password if the user was idle

=item C<$_session_expire_time>

Time after which to delete the session if the user was idle

=item C<$_login_expire_time>

Time after which to delete the session if the user did not log in

=item C<$_tmp_valid_time>

Time after which to invalidate temporarily stored data

=item C<$_check_passwords>

Ensure password quality.

=item C<$_min_password_len>

Minimal password length enforced.

=back

=cut

use vars qw($_max_idle_time $_session_expire_time $_login_expire_time
            $_tmp_valid_time 
            $_check_passwords $_min_password_len);

=head3 Program repair paths

=item C<%_repair_path>

Program repair paths as hash of arrays, f.e.

%_repair_path = (
	program1 => [
		path1,
		path2,
	],
	program2 => [
		path3,
	],
);

These paths are used to clean users settings for
specific programs

=cut

use vars qw(%_repair_path);

=head3 Project preferences

=item C<$_project_mailalias>

Create project with mailalias (on,off)

=item C<$_project_maillist>

Create project with maillist (on,off)

=item C<$_project_wlan>

Create project with wlan (on,off,-)

=head3 Class preferences

=item C<$_class_mailalias>

Create class with mailalias (on,off)

=item C<$_class_maillist>

Create class with maillist (on,off)

=item C<$_class_wlan>

Create class with wlan (on,off,-)

=cut

use vars qw($_project_mailalias $_project_maillist $_project_wlan $_class_mailalias $_class_maillist $_class_wlan);

=head3 Web server settings

=over

=item C<$_http_root>

The root directory of schulkonsole in the URL

=item C<$_htaccess_filename>

The name of the configuration file usually named .htaccess

=back

=cut

use vars qw($_http_root $_htaccess_filename);


=head3 IMAP

=over

=item C<$_imap_host>

The hostname of the IMAP server

=back

=cut

use vars qw($_imap_host);


=head3 SUID-Wrappers

=over

=item C<$_wrapper_user>

Path to wrapper to execute commands as a user

=item C<$_wrapper_firewall>

Path to wrapper to access the firewall

=item C<$_wrapper_ovpn>

Path to wrapper to handle OpenVPN certificates

=item C<$_wrapper_printer>

Path to wrapper to access printers

=item C<$_wrapper_sophomorix>

Path to wrapper to access the Sophomorix scripts

=item C<$_wrapper_cyrus>

Path to wrapper to access the Cyrus IMAP server

=item C<$_wrapper_collab>

Path to wrapper to control databases and revision control

=item C<$_wrapper_files>

Path to wrapper to write files with root permissions

=item C<$_wrapper_linbo>

Path to wrapper to write linbo configuration files

=item C<$_wrapper_debconf>

Path to wrapper to read debconf configuration secion/values

=back

Path to wrapper to write files with root permissions

=item C<$_wrapper_radius>

Path to wrapper to write radius configuration files

=back

=item C<$_wrapper_repair>

Path to wrapper to repair directories / permissions

=back

=item C<$_wrapper_horde>

Path to wrapper to get/set mail forwards

=back

=cut

use vars qw($_wrapper_user $_wrapper_firewall $_wrapper_ovpn $_wrapper_printer
            $_wrapper_sophomorix $_wrapper_cyrus $_wrapper_collab
            $_wrapper_files $_wrapper_linbo $_wrapper_radius
	    $_wrapper_debconf $_wrapper_repair $_wrapper_horde);


=head3 Variables used by wrappers

=over

=item C<%_id_root_app_names>

Hash that maps the numerical ID of an application in the permissions 
configuration file to its name

=item C<$_cmd_internet_on_off>

Path to command used to block/unblock access to internet C<internet_on_off.sh>

=item C<$_cmd_intranet_on_off>

Path to command used to block/unblock access to intranet C<intranet_on_off.sh>

=item C<$_cmd_update_logins>

Path to command to update logins of room C<update-logins.sh>

=item C<$_cmd_update_linbofs>

Path to command to update Linbo filesystem C<update-linbofs.sh>

=item C<$_cmd_urlfilter_check>

Path to command to check if URL filter is active C<check_urlfilter.sh>

=item C<$_cmd_urlfilter_on_off>

Path to command to activate/deactivate URL filter C<urlfilter_on_off.sh>

=item C<$_cmd_linuxmuster_reset>

Path to command to reset room settings C<linuxmuster-reset>

=item C<$_cmd_printer_accept>

Path to command to set printer to accept jobs C<accept>

=item C<$_cmd_printer_reject>

Path to command to set printer to reject jobs C<reject>

=item C<$_cmd_printer_lpadmin>

Path to command to administrate printers C<lpadmin>

=item C<$_cmd_printer_info>

Path to command to read printer infos C<lpstat>

=item C<$_cmd_sophomorix_teacher>

Path to Sophomorix command C<sophomorix-teacher>

=item C<$_cmd_sophomorix_room>

Path to Sophomorix command C<sophomorix-room>

=item C<$_cmd_sophomorix_print>

Path to Sophomorix command C<sophomorix-print>

=item C<$_cmd_sophomorix_passwd>

Path to Sophomorix command C<sophomorix-passwd>

=item C<$_cmd_sophomorix_project>

Path to Sophomorix command C<sophomorix-project>

=item C<$_cmd_sophomorix_check>

Path to Sophomorix command C<sophomorix-check>

=item C<$_cmd_sophomorix_add>

Path to Sophomorix command C<sophomorix-add>

=item C<$_cmd_sophomorix_move>

Path to Sophomorix command C<sophomorix-move>

=item C<$_cmd_sophomorix_kill>

Path to Sophomorix command C<sophomorix-kill>

=item C<$_cmd_sophomorix_teachin>

Path to Sophomorix command C<sophomorix-teach-in>

=item C<$_cmd_sophomorix_quota>

Path to Sophomorix command C<sophomorix-quota>

=item C<$_cmd_sophomorix_class>

Path to Sophomorix command C<sophomorix-class>

=item C$_cmd_sophomorix_mail>

Path to Sophomorix command C<sophomorix-mail>

=item C$_cmd_sophomorix_repair>

Path to Sophomorix command C<sophomorix-repair>

=item C<$_cmd_import_workstations>

Path to command to import workstations into room C<import_workstations>

=item C<$_cmd_import_printers>

Path to command to import printers into room C<import_printers>

=item C<$_cmd_ovpn_client_cert>

Path to command to administer OVPN certificates C<ovpn-client-cert.sh>

=item C<$_cmd_wlan_on_off>

Path to command to administer wlan configuration C<wlan_on_off>

=item C<$_cmd_linuxmuster_wlan_reset>

Path to command to reset group settings C<group-reset>

=item C<$_cmd_horde_mail>

Path to command to read mail forwards C<schulkonsole.php>

=item C<$_cmd_linbo_remote>

Path to command to schedule linbo-remote tasks.

=back

=cut

use vars qw(%_id_root_app_names
            $_cmd_internet_on_off
            $_cmd_intranet_on_off
            $_cmd_update_logins
            $_cmd_update_linbofs
            $_cmd_urlfilter_check
            $_cmd_urlfilter_on_off
            $_cmd_linuxmuster_reset
            $_cmd_printer_accept
            $_cmd_printer_reject
            $_cmd_printer_lpadmin
            $_cmd_printer_info
            $_cmd_sophomorix_teacher
            $_cmd_sophomorix_room
            $_cmd_sophomorix_print
            $_cmd_sophomorix_passwd
            $_cmd_sophomorix_project
            $_cmd_sophomorix_check
            $_cmd_sophomorix_add
            $_cmd_sophomorix_move
            $_cmd_sophomorix_kill
            $_cmd_sophomorix_teachin
            $_cmd_sophomorix_quota
            $_cmd_sophomorix_class
            $_cmd_sophomorix_mail
            $_cmd_sophomorix_repair
            $_cmd_import_workstations
            $_cmd_import_printers
            $_cmd_ovpn_client_cert
            $_cmd_wlan_on_off
            $_cmd_linuxmuster_wlan_reset
            $_cmd_horde_mail
            $_cmd_linbo_remote);


=head3 Other variables

=over

=item C<$true>

Value used for 'true' in Sophomorix configuration files

=item C<$false>

Value used for 'false' in Sophomorix configuration files

=item C<$on>

Value used for 'true' in preferences.conf

=item C<$off>

Value used for 'false' in preferences.conf

=back

=cut

use vars qw($true $false $on $off);

$true = 'yes';
$false= 'no';
$on = 'on';
$off = 'off';

$_version = '0.40.1';
$_sysconfdir = '/etc/linuxmuster/schulkonsole';
$_templatedir = '/usr/share/schulkonsole/tt';
$_runtimedir = '/var/lib/schulkonsole';
$_lockdir = '/var/lock';

$_preferences_conf_file = "$_sysconfdir/preferences.conf";
$SKPREFS = 'Schulkonsole Preferences';
$PATHPREFS = 'Program Paths';
$PROJECTPREFS = 'Project';
$CLASSPREFS = 'Class';

$_permissions_conf_file = "$_sysconfdir/permissions.conf";

$_db_conf_file = "$_sysconfdir/db.conf";
my $DBPREFS = 'Schulkonsole DB';

# read environment variables of linuxmuster scripts
my $lml_config_file = '/usr/share/linuxmuster/config/dist.conf';
my %lml_env;

tie %lml_env, 'Env::Bash', Source => $lml_config_file;
$_lml_majorversion = $lml_env{DISTMAJORVERSION};
$_lml_cache_dir = $lml_env{CACHEDIR};
$_blocked_hosts_internet_file = $lml_env{BLOCKEDHOSTSINTERNET};
$_blocked_hosts_intranet_file = $lml_env{BLOCKEDHOSTSINTRANET};
$_unfiltered_hosts_file = $lml_env{UNFILTEREDHOSTS};
$_workstations_file = $lml_env{WIMPORTDATA};
$_workstations_tmp_log_file = "/var/tmp/import_workstations.log";
$_workstations_log_file = "$lml_env{LOGDIR}/import_workstations.log";
$_room_defaults_file = $lml_env{ROOMDEFAULTS};
$_dhcpd_conf_file = $lml_env{DHCPDCONF};
$_printers_file = $lml_env{PRINTERS};
$_classrooms_file = $lml_env{CLASSROOMS};
$_network_settings_file = $lml_env{NETWORKSETTINGS};
$_linbo_dir = $lml_env{LINBODIR};
$_grub_templates_dir = '/usr/share/linuxmuster-linbo/templates';
$_grub_config_dir = $lml_env{LINBODIR} . '/boot/grub';
$_pxe_config_dir = $lml_env{PXECFGDIR};
$_linbo_examples_dir = $lml_env{LINBODIR} . '/examples';
$_linbo_templates_dir = '/usr/share/schulkonsole/linbo/templates';
$_linbo_log_dir = $lml_env{LINBOLOGDIR};
$_linbo_templates_os_dir = "$_linbo_templates_dir/os";
$_linbo_template_partition = "$_linbo_templates_dir/part/start.conf.partition";
$_wlan_defaults_file = '/etc/linuxmuster/wlan_defaults';

$_linbo_start_conf_prefix = $_linbo_dir . '/start.conf.';


# read environment variables of linuxmuster scripts
my $lml_default_config_file = '/etc/default/linuxmuster-base';
my %lml_default_env;

tie %lml_default_env, 'Env::Bash', Source => $lml_default_config_file;
$_lml_start = ($lml_default_env{START_LINUXMUSTER} eq 'yes');


$_cups_printers_conf_file = '/etc/cups/printers.conf';

$_workstation_file = "$_lml_cache_dir/logins/%s";

$_login_template = 'login.tt';


$_session_expire_time = '+1h';	# delete session after 1 hour idle time
$_login_expire_time = '+1h';	# invalidate session unless logged in within an
                             	# hour

$_tmp_valid_time = '+1m';	# invalidate temporarily stored data after 1 minute

$_http_root = '/schulkonsole';
$_htaccess_filename = '.htaccess';
$_imap_host = 'localhost';
$_wrapper_user = '/usr/lib/schulkonsole/bin/wrapper-user';
$_wrapper_firewall = '/usr/lib/schulkonsole/bin/wrapper-firewall';
$_wrapper_ovpn = '/usr/lib/schulkonsole/bin/wrapper-ovpn';
$_wrapper_printer = '/usr/lib/schulkonsole/bin/wrapper-printer';
$_wrapper_sophomorix = '/usr/lib/schulkonsole/bin/wrapper-sophomorix';
$_wrapper_cyrus = '/usr/lib/schulkonsole/bin/wrapper-cyrus';
$_wrapper_collab = '/usr/lib/schulkonsole/bin/wrapper-collab';
$_wrapper_files = '/usr/lib/schulkonsole/bin/wrapper-files';
$_wrapper_linbo = '/usr/lib/schulkonsole/bin/wrapper-linbo';
$_wrapper_radius = '/usr/lib/schulkonsole/bin/wrapper-radius';
$_wrapper_debconf = '/usr/lib/schulkonsole/bin/wrapper-debconf';
$_wrapper_repair = '/usr/lib/schulkonsole/bin/wrapper-repair';
$_wrapper_horde = '/usr/lib/schulkonsole/bin/wrapper-horde';



%_id_root_app_names = (
	INTERNETONOFFAPP() => 'internet_on_off',
	INTRANETONOFFAPP() => 'intranet_on_off',
	WLANALLOWEDAPP() => 'allowed_groups_users_wlan',
	WLANONOFFAPP() => 'wlan_on_off',
	WLANRESETATAPP() => 'wlan_reset_at',
	WLANRESETAPP() => 'wlan_reset',
	UPDATELOGINSAPP() => 'update_logins',
	UPDATELINBOFSAPP() => 'update_linbofs',
	URLFILTERCHECKAPP() => 'urlfilter_check',
	URLFILTERONOFFAPP() => 'urlfilter_on_off',
	ALLONAPP() => 'all_on',
	ALLONATAPP() => 'all_on_at',
	ROOMSRESETAPP() => 'rooms_reset',
	PRINTERINFOAPP() => 'printer_info',
	PRINTERONOFFAPP() => 'printer_on_off',
	PRINTERALLOWDENYAPP() => 'printer_allow_deny',
	SHARESTATESAPP() => 'share_states',
	SHARESONOFFAPP() => 'shares_on_off',
	FILEMANAPP() => 'fileman',
	STUDENTSFILEMANAPP() => 'studentsfileman',
	LSHANDEDOUTAPP() => 'ls_handedout',
	LSHANDOUTAPP() => 'ls_handout',
	LSCOLLECTAPP() => 'ls_collect',
	LSCOMMITSAPP() => 'ls_commits',
	LSCOMMITAPP() => 'ls_commit',
	HANDOUTAPP() => 'handout',
	COLLECTAPP() => 'collect',
	RESETROOMAPP() => 'room_reset',
	EDITOWNCLASSMEMBERSHIPAPP() => 'edit_own_class_membership',
	PRINTCLASSAPP() => 'print_class',
	PRINTALLUSERSAPP() => 'print_allusers',
	PRINTCOMMITAPP() => 'print_commit',
	PRINTTEACHERSAPP() => 'print_teachers',
	PRINTPROJECTAPP() => 'print_project',
	SETPASSWORDSAPP() => 'set_passwords',
	PROJECTMEMBERSAPP() => 'project_members',
	PROJECTCREATEDROPAPP() => 'project_create_drop',
	PROJECTJOINNOJOINAPP() => 'project_join_no_join',
	PROJECTWLANDEFAULTSAPP() => 'project_wlan_defaults',
	READSOPHOMORIXFILEAPP() => 'read_sophomorix_file',
	WRITESOPHOMORIXFILEAPP() => 'write_sophomorix_file',
	USERSCHECKAPP() => 'check_users',
	USERSADDAPP() => 'add_users',
	USERSMOVEAPP() => 'move_users',
	USERSKILLAPP() => 'kill_users',
	USERSADDMOVEKILLAPP() => 'addmovekill_users',
	TEACHINAPP() => 'teachin',
	CHMODAPP() => 'chmod',
	SETQUOTAAPP() => 'quota',
	HIDEUNHIDECLASSAPP() => 'hide_unhide_class',
	SETMYMAILAPP() => 'set_user_mymail',
	CHANGEMAILALIASCLASSAPP() => 'change_mailalias_classes',
	CHANGEMAILLISTCLASSAPP() => 'change_maillist_classes',
	CHANGEMAILALIASPROJECTAPP() => 'change_mailalias_projects',
	CHANGEMAILLISTPROJECTAPP() => 'change_maillist_projects',
	SETOWNPASSWORDAPP() => 'set_own_password',
	WRITEFILEAPP() => 'write_file',
	IMPORTWORKSTATIONSAPP() => 'import_workstations',
	IMPORTPRINTERSAPP() => 'import_printers',
	OVPNCHECKAPP() => 'ovpn_check',
	OVPNDOWNLOADAPP() => 'ovpn_download',
	OVPNCREATEAPP() => 'ovpn_create',
	LINBOWRITESTARTCONFAPP() => 'write_start_conf',
	LINBOCOPYSTARTCONFAPP() => 'copy_start_conf',
	LINBOCOPYREGPATCHAPP() => 'copy_regpatch',
	LINBODELETEAPP() => 'linbo_delete',
	LINBOWRITEAPP() => 'linbo_write',
	LINBOWRITEGRUBCFGAPP() => 'linbo_write_grub_cfg',
	LINBOWRITEPXEAPP() => 'linbo_write_pxe',
	LINBOIMAGEAPP() => 'linbo_manage_images',
	LINBOREMOTESTATUSAPP() => 'linbo_remote_status',
	LINBOREMOTEWINDOWAPP() => 'linbo_remote_window',
	LINBOREMOTEAPP() => 'linbo_remote',
	LINBOREMOTEPLANNEDAPP() => 'linbo_remote_planned',
	LINBOREMOTEREMOVEAPP() => 'linbo_remote_remove',
	DEBCONFREADAPP() => 'debconf_read',
	DEBCONFREADSMTPRELAYAPP() => 'read_smtprelay',
	CYRUSQUOTAAPP() => 'cyrus_quota',
	REPAIRPERMISSIONSAPP() => 'repair_permissions',
	REPAIRMYHOMEAPP() => 'repair_myhome',
	REPAIRCLASSHOMESAPP() => 'repair_classhomes',
	REPAIRPROJECTHOMESAPP() => 'repair_projecthomes',
	REPAIRHOMESAPP() => 'repair_homes',
	REPAIRGETINFOAPP() => 'repair_get_info',
	GETMAILFORWARDS() => 'get_mailforwards',
	SETMAILFORWARDS() => 'set_mailforwards',
	REMOVEMAILFORWARDS() => 'remove_mailforwards',
);



$_cmd_import_printers = '/usr/sbin/import_printers';
$_cmd_import_workstations = '/usr/sbin/import_workstations';
$_cmd_internet_on_off = '/usr/share/linuxmuster/scripts/internet_on_off.sh';
$_cmd_intranet_on_off = '/usr/share/linuxmuster/scripts/intranet_on_off.sh';
$_cmd_linuxmuster_reset = '/usr/sbin/linuxmuster-reset';
$_cmd_ovpn_client_cert = '/usr/share/linuxmuster/scripts/ovpn-client-cert.sh';
$_cmd_printer_accept = '/usr/sbin/accept';
$_cmd_printer_lpadmin = '/usr/sbin/lpadmin';
$_cmd_printer_reject = '/usr/sbin/reject';
$_cmd_printer_info = '/usr/bin/lpstat';
$_cmd_sophomorix_add = '/usr/sbin/sophomorix-add';
$_cmd_sophomorix_check = '/usr/sbin/sophomorix-check';
$_cmd_sophomorix_class = '/usr/sbin/sophomorix-class';
$_cmd_sophomorix_mail = '/usr/sbin/sophomorix-mail';
$_cmd_sophomorix_repair = '/usr/sbin/sophomorix-repair';
$_cmd_sophomorix_kill = '/usr/sbin/sophomorix-kill';
$_cmd_sophomorix_move = '/usr/sbin/sophomorix-move';
$_cmd_sophomorix_passwd = '/usr/sbin/sophomorix-passwd';
$_cmd_sophomorix_print = '/usr/sbin/sophomorix-print';
$_cmd_sophomorix_project = '/usr/sbin/sophomorix-project';
$_cmd_sophomorix_quota = '/usr/sbin/sophomorix-quota';
$_cmd_sophomorix_room = '/usr/sbin/sophomorix-room';
$_cmd_sophomorix_teacher = '/usr/bin/sophomorix-teacher';
$_cmd_sophomorix_teachin = '/usr/sbin/sophomorix-teach-in';
$_cmd_update_linbofs = '/usr/share/linuxmuster-linbo/update-linbofs.sh';
$_cmd_update_logins = '/usr/share/linuxmuster/scripts/update-logins.sh';
$_cmd_urlfilter_check = '/usr/share/linuxmuster/scripts/check_urlfilter.sh';
$_cmd_urlfilter_on_off = '/usr/share/linuxmuster/scripts/urlfilter_on_off.sh';
$_cmd_wlan_on_off = '/usr/sbin/wlan_on_off';
$_cmd_linuxmuster_wlan_reset = '/usr/sbin/linuxmuster-wlan-reset';
$_cmd_horde_mail = '/usr/share/schulkonsole/Schulkonsole/horde-mail.php';
$_cmd_linbo_remote = '/usr/sbin/linbo-remote';


=head2 Functions

=head3 C<db()>

=head4 Description

Returns the database configuration

=head4 Return value

A hash with the configuration parameter's name as key and the value as value

=cut

sub db {
	my %preferences = read_conf($_db_conf_file);
	return %{$preferences{$DBPREFS}};
}




=head2 Functions

=head3 C<ldap()>

=head4 Description

Returns the ldap configuration

=head4 Return value

A hash with the configuration parameter's name as key and the value as value

=cut

sub ldap {
        my $filename = '/etc/ldap/ldap.conf';
        my %conf;

        open CONF, '<', Schulkonsole::Encode::to_fs($filename)
                or die "$0: Cannot open $filename: $!\n";

        while (<CONF>) {
                next if /^#/ or /^\s*$/;

                my ($key, $value) = /^(.+?)\s+(.*)/;

                die "$0: Syntax error in $filename, line $.\n" unless $key;
                $key = lc $key;
                $conf{$key} = $value;
        }
        close CONF;

        return %conf;
}




my %permissions_pages;
my %permissions_apps;
sub permissions {
	return if (%permissions_pages or %permissions_apps);

	my $is_linbo_enabled = is_linbo_enabled();

	my $section = 0;

	open PERMISSIONS, '<', Schulkonsole::Encode::to_fs($_permissions_conf_file)
		or die "$0: Cannot open $_permissions_conf_file: $!\n";
	while (<PERMISSIONS>) {
		next if /^#/ or /^\s*$/;
		if (my ($section_name) = /^\[(.*)\]/) {
			SWITCH: {
			$section_name =~ /^p/i and do {
				$section = 1;
				last SWITCH;
			};
			$section_name =~ /^e/i and do {
				$section = 2;
				last SWITCH;
			};
			die "$0: Section must be one of [Pages] or [external Programs] "
				. "in $_permissions_conf_file, line $.\n";
			}
		} else {
			my ($group, $resources) = /^(.+?)=(.+)$/;
			if ($group and $resources) {
				my @resources = split /\s+/, $resources;
				SWITCH: {
				$section == 1 and do {
					foreach my $page (@resources) {
						# only allow linbo-pages if linbo is enabled
						if (   $is_linbo_enabled
						    or $page !~ /^linbo/) {
							$permissions_pages{$group}{$page} = 1;
						}
					}
					last SWITCH;
				};
				$section == 2 and do {
					foreach my $app (@resources) {
						$permissions_apps{$group}{$app} = 1;
					}
					last SWITCH;
				};
				}
			} else {
				die "$0: Syntax error in $_permissions_conf_file, line $.\n";
			}
		}
	}
	close PERMISSIONS;
	#FIXME: compatibility for linuxmuster-base 6.1
	# o project_passwords erst ab 2.4.50 (disable page project_passwords)
	# o sophomorix-print --back-in-time ab 2.4.51 (disable user_print)
	# o linbo-grub2 / uefi ab 2.3 (disable linbo_grubedit, enable linbo_pxeedit, linbo_menuedit)
	if($_lml_majorversion eq "6.1"){
		foreach my $group (keys %permissions_pages){
			delete $permissions_pages{$group}{"project_passwords"} if defined $permissions_pages{$group}{"project_passwords"};
			delete $permissions_pages{$group}{"user_print"} if defined $permissions_pages{$group}{"user_print"};
			delete $permissions_pages{$group}{"linbo_grubedit"} if defined $permissions_pages{$group}{"linbo_grubedit"};
		}
	}
	if($_lml_majorversion eq "6.2"){
		foreach my $group (keys %permissions_pages){
			delete $permissions_pages{$group}{"linbo_menuedit"} if defined $permissions_pages{$group}{"linbo_menuedit"};
			delete $permissions_pages{$group}{"linbo_pxeedit"} if defined $permissions_pages{$group}{"linbo_pxeedit"};
		}
	}
}



=head3 C<permissions_pages()>

=head4 Description

Returns the access permissions for the interface's web pages

=head4 Return value

A reference to a hash with the group name as key and a reference to a
hash with the pages as keys and true as value as value.

=cut

sub permissions_pages {
	permissions();


	return \%permissions_pages;
}



=head3 C<permissions_apps()>

=head4 Description

Returns the access permissions for the helper applications used by the
interface

=head4 Return value

A reference to a hash with the group name as key and a reference to a
hash with the applications as keys and true as value as value.

=cut

sub permissions_apps {
	permissions();


	return \%permissions_apps;
}




=head3 C<workstation_info($workstation, $ip)>

Returns the room and the configured name of a workstation

=head4 Parameters

=over 

=item C<$workstation>

DNS name of the workstation

=item C<$ip>

IP of the workstation

=back

=head4 Return value

An array with the room as the first element and the configured name as the
second element

=head4 Description

Returns the room and the configured name of the workstation C<$workstation>
or the ip C<$ip>, whatever comes first

=cut

sub workstation_info {
	my $workstation = shift;
	my $ip = shift;

	my $conf_workstation;
	my $room;


	if (open CONF, '<', Schulkonsole::Encode::to_fs($_workstations_file)) {
		while (<CONF>) {
			next if /^#/ || /^\s*$/;

			my $dummy;
			my $conf_ip;
			($room, $conf_workstation, $dummy, $dummy, $conf_ip) = split ';';

			last if (   $conf_workstation eq $workstation
			         or $conf_ip eq $ip);
			undef $conf_workstation;
		}

		close CONF;
	} else {
		warn "$0: Cannot open $_workstations_file: $!\n";
	}


	if (not $conf_workstation) {
		($conf_workstation) = $workstation =~ /^([^.]*)/;
		$room = '';
	}

	return ($room, $conf_workstation);
}




=head3 C<workstations_room($room)>

Return info about the workstations in a room

=head4 Parameters

=over

=item C<$room>

The name of the room

=back

=head4 Return value

A hash with the workstation names as values and a hash with the information
about the workstation as value. The information hash has the following
keys:

=over

=item C<room>

The name of the room of the workstation

=item C<name>

The name of the workstation

=item C<hw_class>

The hardware class of the workstation

=item C<mac>

The MAC address of the workstation

=item C<ip>

The IP of the workstation

=back

=cut

sub workstations_room {
	my $room = shift;

	my %workstations;

	if (open CONF, '<', Schulkonsole::Encode::to_fs($_workstations_file)) {
		while (<CONF>) {
			next if /^#/ || /^\s*$/;

			my ($conf_room, $workstation, $hw_class, $mac, $ip) = split ';';

			if ($conf_room eq $room) {
				$workstations{$workstation}{room} = $room;
				$workstations{$workstation}{name} = $workstation;
				$workstations{$workstation}{hw_class} = $hw_class;
				$workstations{$workstation}{mac} = $mac;
				$workstations{$workstation}{ip} = $ip;
			}
		}

		close CONF;
	} else {
		warn "$0: Cannot open $_workstations_file: $!\n";
	}



	return \%workstations;
}




=head3 C<count_unimported_unconfigured_workstations()>

Count unimported and unconfigured workstations

=head4 Return value

In list context, an array with the number of unimported workstations as
first, the number of unconfigured workstation as second, and the number of
comments as third element.
Otherwise true, if there are unimported or unconfigured workstations.

=head4 Description

Counts how many of the workstations configured in C<$_workstations_file>
are not actually present in the system and vice versa.

=cut

sub count_unimported_unconfigured_workstations {
	my %macs;
	my $comment_cnt = 0;

	my $unconfigured_cnt = 0;
	if (open CONF, '<', Schulkonsole::Encode::to_fs($_workstations_file)) {
		while (<CONF>) {
			if (/^#/) {
				$comment_cnt++;
				next;
			}
			next if /^\s*$/;

			my ($conf_room, $workstation, $hw_class, $mac, $ip) = split ';';

			$macs{"\L$mac"} = 1 if $mac;
		}

		close CONF;


		open CONF, '<', Schulkonsole::Encode::to_fs($_dhcpd_conf_file)
			or die "$0: Cannot open $_dhcpd_conf_file: $!\n";

		while (<CONF>) {
			s/#.*//;

			if (my ($mac) = /hardware\s+ethernet\s+([0-9A-Fa-f:]+)/) {
				$mac = lc $mac;
				if ($macs{$mac}) {
					delete $macs{$mac}
				} else {
					$unconfigured_cnt++;
				}
			}
		}

	} else {
		warn "$0: Cannot open $_workstations_file: $!\n";
	}


	my $unimported_cnt = keys %macs;

	return (wantarray ? ($unimported_cnt, $unconfigured_cnt, $comment_cnt) :
	                    $unimported_cnt || $unconfigured_cnt );
}




=head3 C<lockfile($task)>

Creates the filename for a lockfile for a task

=head4 Parameters

=over

=item C<$task>

The name of the task to be locked

=back

=head4 Return value

The filename

=cut

sub lockfile {
	my $task = shift;

	return Schulkonsole::Encode::to_fs(
	       	sprintf("%s/schulkonsole-%s", $_lockdir, $task));
}




=head3 C<workstation_file($workstation)>

Creates the filename of the file that stores login information about a
workstation

=head4 Parameters

=over

=item C<$workstation>

The name of the workstation

=back

=head4 Return value

The filename

=cut

sub workstation_file {
	my $workstation = shift;

	return Schulkonsole::Encode::to_fs(
	       	sprintf($_workstation_file, $workstation));
}





=head3 C<classrooms()>

Returns a list of all classrooms

=head4 Return value

A reference to an array of all classrooms

=cut

sub classrooms {
	my @re;

	open CLASSROOMS, '<', Schulkonsole::Encode::to_fs($_classrooms_file)
		or die "$0: Cannot open $_classrooms_file: $!\n";

	while (<CLASSROOMS>) {
		s/#.*//;
		chomp;
		next unless $_;

		push @re, $_;
	}

	close CLASSROOMS;


	return \@re;
}




=head3 C<rooms()>

Returns a list of all rooms with workstations

=head4 Return value

A reference to a hash with all rooms from the workstations file as keys

=cut

sub rooms {
	my %rooms;

	open ROOMS, '<', Schulkonsole::Encode::to_fs($_workstations_file)
		or die "$0: Cannot open $_workstations_file: $!\n";

	while (<ROOMS>) {
		next if /^#/ || /^\s*$/;

		my ($room, $workstation) = split ';';

		if ($workstation) {
			$rooms{$room} = 1 unless exists $rooms{$room};
		}
	}

	close ROOMS;


	return \%rooms;
}




=head3 C<hosts()>

Returns a list of all workstations

=head4 Return value

A reference to a hash of all hosts from the workstations file as keys and
the room of that workstation as value

=cut

sub hosts {
	my %hosts;

	open HOSTS, '<', Schulkonsole::Encode::to_fs($_workstations_file)
		or die "$0: Cannot open $_workstations_file: $!\n";

	while (<HOSTS>) {
		next if /^#/ || /^\s*$/;

		my ($room, $workstation) = split ';';

		if ($workstation) {
			$hosts{$workstation} = $room;
		}
	}

	close HOSTS;


	return \%hosts;
}




=head3 C<workstations()>

Returns a list of all workstations in scalar environment and
an array of all comments (unsorted) and a list of all workstations in a 
non scalar environment.

=head4 Return value

A reference to a hash of all workstations from the workstations file as keys and
the room of that workstation as value in a scalar environment and
a reference to an array of all comments (unsorted) and a hash of all workstations from
the workstations file as keys and the room of that workstation in a non scalar
environment.

=cut

sub workstations {
        my $comments;
	my %workstations;

	open WORKSTATIONS, '<', Schulkonsole::Encode::to_fs($_workstations_file)
		or die "$0: Cannot open $_workstations_file: $!\n";

	while (<WORKSTATIONS>) {
                if(/^#|^\s*$/) {
                    $comments .= $_;
                    next;
		}
		chomp;
                my @fields = split ';';

		my $base = $fields[1];
		if ($base) {
			my $cnt = 0;
			my $key;
			do {
				$cnt++;
				$key = "$base!$cnt";
			} while (exists $workstations{$key});

			$workstations{$key}{room} = $fields[0];
			$workstations{$key}{name} = $fields[1];
			$workstations{$key}{groups} = $fields[2];
			$workstations{$key}{mac} = $fields[3];
			$workstations{$key}{ip} = $fields[4];
			$workstations{$key}{pxe} = $fields[10];
			$workstations{$key}{opts} = $fields[11];
		}
	}

	close WORKSTATIONS;

	return (wantarray ? ($comments,\%workstations) : \%workstations);
}





=head3 linbogroups()

Get all groups that have a start.conf.*

=head4 Return value

A reference to a hash with the group names as keys

=head4 Description

Extracts the groupname from the filenames /var/linbo/start.conf.<GROUP>
and returns them in a hash.

=cut

sub linbogroups {
	my @files = glob($Schulkonsole::Config::_linbo_start_conf_prefix . '*');

	my %re;
	# this will take all files, that start with _linbo_start_conf_prefix
	# plus a valid group name and optionally an arbitrary suffix (except it
	# ends with '~')
	foreach my $file (@files) {
		next if $file =~ /~$/;	# skip editor backup files
		my ($group) = $file =~ /^\Q${Schulkonsole::Config::_linbo_start_conf_prefix}\E([a-z\d_]+.*)/;
		next unless $group;

		$re{ Schulkonsole::Encode::from_fs($group) } = 1;
	}

	return \%re;
}




=head3 C<printers_room($room)>

Returns a list of all printers in a room

=head4 Parameters

=over

=item C<$room>

The name of the room

=back

=head4 Return value

A reference to an array of the printers

=cut

sub printers_room {
	my $room = shift;
	my @re;

	open PRINTERS, '<', Schulkonsole::Encode::to_fs($_printers_file)
		or die "$0: Cannot open $_printers_file: $!\n";

	while (my $line = <PRINTERS>) {
		$line =~ s/#.*//;
		next unless $line;

		my ($printer, $rooms, $hosts) = split /\s+/, $line;
		next unless $rooms;

		my $is_in_room = 0;
		foreach my $conf_room (split ',', $rooms) {
			if ($conf_room eq $room) {
				$is_in_room = 1;
				last;
			}
		}
		next unless $is_in_room;

		push @re, $printer;
	}


	close PRINTERS;


	return \@re;
}




=head3 C<printers()>

Returns all printers

=head4 Return value

A reference to a hash with the printer's name as key and a reference to
a hash with the keys C<rooms> and C<hosts> with a reference to a hash
with the rooms or resp. the hosts as keys and 1 as a value.

=cut

sub printers {
	my %re;

	open PRINTERS, '<', Schulkonsole::Encode::to_fs($_printers_file)
		or die "$0: Cannot open $_printers_file: $!\n";

	while (my $line = <PRINTERS>) {
		$line =~ s/#.*//;
		next unless $line;

		my ($printer, $rooms, $hosts) = split /\s+/, $line;
		next unless $printer;

		my %rooms;
		if ($rooms ne '-') {
			foreach my $room (split ',', $rooms) {
				$rooms{$room} = 1;
			}
		}
		my %hosts;
		if ($hosts ne '-') {
			foreach my $host (split ',', $hosts) {
				$hosts{$host} = 1;
			}
		}

		$re{$printer} = {
			rooms => \%rooms,
			hosts => \%hosts,
		};
	}

	close PRINTERS;


	return \%re;
}




=head3 is_linbo_enabled()

Check if LINBO is enabled

=head4 Return value

True if LINBODIR exists, false otherwise

=head4 Description

Checks if LINBO is enabled.

=cut

my $is_linbo_enabled;
sub is_linbo_enabled {
	return $is_linbo_enabled if defined $is_linbo_enabled;

        if ( -d $_linbo_dir ) {
                $is_linbo_enabled = 1;
        } else {
                $is_linbo_enabled = 0;
        };
	
	return $is_linbo_enabled;
}



my %_preferences_conf_section = (
	$SKPREFS => 1,
	$PATHPREFS => 1,
	$DBPREFS => 1,
	$PROJECTPREFS => 1,
	$CLASSPREFS => 1,
);

sub read_conf {
	my $filename = shift;
	my %conf;

	open CONF, '<', Schulkonsole::Encode::to_fs($filename)
		or die "$0: Cannot open $filename: $!\n";

	my $section = '';
	while (<CONF>) {
		next if /^#/ or /^\s*$/;
		if (/^\[/){
			($section) = $_ =~ /^\[(.+)\]$/;
			$section = '' unless $_preferences_conf_section{$section};
			next;
		}
		my ($key, $value) = /^(.+?)=(.*)/;

		die "$0: Syntax error empty key in $filename, line $\n" unless $key;

		die "$0: Syntax error empty section in $filename, line $\n" unless $section;
		
		$conf{$section}{$key} = $value;
	}
	close CONF;

	return %conf;
}





=head3 C<expire_seconds($time_str)>

Returns the number of seconds described in a string

=head4 Parameters

=over

=item C<$time_str>

A string with a number and an optional suffix describing a unit.
Possible suffixes are: s (seconds), m (minutes), h (hours), d (days),
w (weeks), M (months), and y (years).

=back

=head4 Return value

The number of seconds

=head4 Description

Parses the string C<$time_str> and returns the number of seconds

=cut

sub expire_seconds {
	my $time_str = shift;

	if (my ($n, $unit) = $time_str =~ /^([+-]?\d+)([smhdwMy])$/) {
		my %mult = (
			s => 1,
			m => 60,
			h => 3600,
			d => 86400,
			w => 604800,
			M => 2592000,
			y => 31536000,
		);

		return $n * $mult{$unit};
	} else {
		return int($time_str);
	}
}




# read preferences from file into config variables

sub init_preferences {
	my %preferences = read_conf($_preferences_conf_file);
	# sk prefs
	$_max_idle_time = $preferences{$SKPREFS}{max_idle_time}
		if (exists $preferences{$SKPREFS}{max_idle_time});
	$_templatedir = $preferences{$SKPREFS}{templatedir}
		if (    exists $preferences{$SKPREFS}{templatedir}
		    and -d $preferences{$SKPREFS}{templatedir});
	$_min_password_len = $preferences{$SKPREFS}{min_password_len}
		if (exists $preferences{$SKPREFS}{min_password_len});
	$_wlan_ldap_group = $preferences{$SKPREFS}{wlan_ldap_group}
		if (exists $preferences{$SKPREFS}{wlan_ldap_group});
	if($preferences{$SKPREFS}{check_passwords}) {
		if($preferences{$SKPREFS}{check_passwords} eq 'yes'){
			$_check_passwords = 1;
		} else {
			$_check_passwords = 0;
		}
	}
	
	# repair paths
	%_repair_path = ();
	if (exists $preferences{$PATHPREFS}) {
		foreach my $program (keys $preferences{$PATHPREFS}) {
			@{$_repair_path{$program}} = split(',', $preferences{$PATHPREFS}{$program});
		}
	}
	#project prefs
	$_project_mailalias = $preferences{$PROJECTPREFS}{mailalias}
		if exists $preferences{$PROJECTPREFS}{mailalias};
	$_project_maillist = $preferences{$PROJECTPREFS}{maillist}
		if exists $preferences{$PROJECTPREFS}{maillist};
	$_project_wlan = $preferences{$PROJECTPREFS}{wlan}
		if exists $preferences{$PROJECTPREFS}{wlan};
	#project prefs
	$_class_mailalias = $preferences{$CLASSPREFS}{mailalias}
		if exists $preferences{$CLASSPREFS}{mailalias};
	$_class_maillist = $preferences{$CLASSPREFS}{maillist}
		if exists $preferences{$CLASSPREFS}{maillist};
	$_class_wlan = $preferences{$CLASSPREFS}{wlan}
		if exists $preferences{$CLASSPREFS}{wlan};
}

# compare new values to values from conf file and create new file lines to
# write to config file into section $section
sub new_preferences_lines {
	my $section = shift;
	my $new = shift;
	
	my @lines;

	my %key_map = (
		conf_max_idle_time => 'max_idle_time',
		conf_min_password_len => 'min_password_len',
		conf_wlan_ldap_group => 'wlan_ldap_group',
		conf_check_passwords => 'check_passwords',
	);
	my %key_map_rev = reverse %key_map;

	my $current = '';
	my $last_pref = 0;
	
	if (open CONF, '<',
	         Schulkonsole::Encode::to_fs(
	         	$Schulkonsole::Config::_preferences_conf_file)) {
		while (<CONF>) {
			if (/^\[.+\]/) {
				($current) = $_ =~ /^\[(.+)\]/; 
				push @lines, $_;
				$current = '' unless $section eq $current;
				$last_pref = @lines if $current;
			} elsif (/^#/ or /^\s*$/ or not $current) {
				push @lines, $_;
			} elsif (my ($conf_key, $value) = /^(.+?)=(.*)/) {
				my $key = $key_map_rev{$conf_key};
				if (defined $$new{$key}) {
					$value = $$new{$key};
					if ($key eq 'conf_max_idle_time') {
						$value = "+${value}m";
					} elsif ($key eq 'conf_check_passwords') {
						$value = (defined $value and $value ? $true : $false );
					}
					push @lines, "$conf_key=$value\n";

					delete $$new{$key};
				} elsif ($current eq $PATHPREFS || $current eq $PROJECTPREFS || $current eq $CLASSPREFS) {
					if (defined $$new{$conf_key}) {
						push @lines, "$conf_key=$$new{$conf_key}\n";
						
						delete $$new{$conf_key};
					} else {
						push @lines, $_;
					}
				} else {
					push @lines, $_;
				}
				$last_pref = @lines;
			}
		}
		close CONF;
	}
	if (not $last_pref) {
		push @lines, "[$section]\n";
		$last_pref = @lines;
	}

	foreach my $key (sort keys %$new) {
		my $value = $$new{$key};
		if ($key eq 'conf_max_idle_time') {
			$value = "+${value}m";
		} elsif  ($key eq 'conf_check_passwords') {
			$value = (defined $value and $value ? $true : $false);
		}
		if ($section eq $SKPREFS) {
			if ($last_pref) {
				splice @lines, $last_pref, 0, "$key_map{$key}=$value\n";
			} else {
				push @lines, "$key_map{$key}=$value\n";
			}
		} else {
			if ($last_pref) {
				splice @lines, $last_pref, 0, "$key=$value\n";
			} else {
				push @lines, "$key=$value\n";
			}
		}
	}

	return \@lines;
}

sub read_preferences_conf {

=item C<conf_check_passwords>

corresponds to check_passwords in F<preferences.conf>

=item C<conf_max_idle_time>

corresponds to max_idle_time in F<preferences.conf>

=item C<conf_min_password_len>

corresponds to min_password_len in F<preferences.conf>

=item C<conf_wlan_ldap_group>

corresponds to wlan_ldap_group in F<preferences.conf>

=cut

	return (
		conf_max_idle_time => int(expire_seconds($_max_idle_time) / 60),
		conf_min_password_len => int($_min_password_len),
		conf_wlan_ldap_group => $_wlan_ldap_group,
		conf_check_passwords => $_check_passwords,
	);
}

INIT {
	$_max_idle_time = '+30m';	# ask for password after 30 minutes idle time
	$_check_passwords = 1;        # enforce password quality
	$_min_password_len = 8;       # enforce password length requirement
	$_wlan_ldap_group = 'p_wifi';
	$_project_mailalias = 'off';
	$_project_maillist = 'off';
	$_project_wlan = 'off';
	$_class_mailalias = 'off';
	$_class_maillist = 'off';
	$_class_wlan = 'off';
	
	init_preferences();
}

1;

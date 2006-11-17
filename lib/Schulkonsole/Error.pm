use strict;

package Schulkonsole::Error;
require Exporter;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
$VERSION = 0.06;
@ISA = qw(Exporter);
@EXPORT_OK = qw(
	new
	what
	errstr

	OK
	USER_AUTHENTICATION_FAILED
	USER_PASSWORD_MISMATCH
	UNKNOWN_ROOM
	QUOTA_NOT_ALL_MOUNTPOINTS
	DB_PREPARE_FAILED
	DB_EXECUTE_FAILED
	DB_FETCH_FAILED
	UNKNOWN_PASSWORD_ENCRYPTION
	DB_USER_DOES_NOT_EXIST
	DB_NO_WORKSTATION_USERS
	CANNOT_OPEN_FILE
	FILE_FORMAT_ERROR
	WRAPPER_EXEC_FAILED
	WRAPPER_BROKEN_PIPE_OUT
	WRAPPER_BROKEN_PIPE_IN
	WRAPPER_USER_ERROR_BASE
	WRAPPER_USER_GENERAL_ERROR
	WRAPPER_USER_PROGRAM_ERROR
	WRAPPER_USER_UNAUTHORIZED_UID
	WRAPPER_USER_INVALID_UID
	WRAPPER_USER_INVALID_SCRIPT
	WRAPPER_USER_SCRIPT_EXEC_FAILED
	WRAPPER_USER_SETUID_FAILED
	WRAPPER_FIREWALL_ERROR_BASE
	WRAPPER_FIREWALL_GENERAL_ERROR
	WRAPPER_FIREWALL_UNAUTHORIZED_UID
	WRAPPER_FIREWALL_SCRIPT_EXEC_FAILED
	WRAPPER_FIREWALL_UNAUTHENTICATED_ID
	WRAPPER_FIREWALL_APP_ID_DOES_NOT_EXIST
	WRAPPER_FIREWALL_UNAUTHORIZED_ID
	WRAPPER_FIREWALL_INVALID_MAC
	WRAPPER_FIREWALL_NO_MACS
	WRAPPER_FIREWALL_INVALID_HOST
	WRAPPER_FIREWALL_NO_HOSTS
	WRAPPER_FIREWALL_INVALID_ROOM
	WRAPPER_FIREWALL_INVALID_LESSONMODE
	WRAPPER_FIREWALL_INVALID_LESSONTIME
	WRAPPER_FIREWALL_CANNOT_WRITE_ROOMFILE
	WRAPPER_FIREWALL_CANNOT_READ_ROOMFILE
	WRAPPER_FIREWALL_CANNOT_FORK
	WRAPPER_PRINTER_ERROR_BASE
	WRAPPER_PRINTER_GENERAL_ERROR
	WRAPPER_PRINTER_PROGRAM_ERROR
	WRAPPER_PRINTER_UNAUTHORIZED_UID
	WRAPPER_PRINTER_SCRIPT_EXEC_FAILED
	WRAPPER_PRINTER_UNAUTHENTICATED_ID
	WRAPPER_PRINTER_APP_ID_DOES_NOT_EXIST
	WRAPPER_PRINTER_UNAUTHORIZED_ID
	WRAPPER_PRINTER_CANNOT_OPEN_PRINTERSCONF
	WRAPPER_PRINTER_INVALID_PRINTER_NAME
	WRAPPER_PRINTER_NO_PRINTERS
	WRAPPER_PRINTER_INVALID_USER
	WRAPPER_SOPHOMORIX_ERROR_BASE
	WRAPPER_SOPHOMORIX_GENERAL_ERROR
	WRAPPER_SOPHOMORIX_PROGRAM_ERROR
	WRAPPER_SOPHOMORIX_UNAUTHORIZED_UID
	WRAPPER_SOPHOMORIX_CANNOT_FORK
	WRAPPER_SOPHOMORIX_SCRIPT_EXEC_FAILED
	WRAPPER_SOPHOMORIX_UNAUTHENTICATED_ID
	WRAPPER_SOPHOMORIX_APP_ID_DOES_NOT_EXIST
	WRAPPER_SOPHOMORIX_UNAUTHORIZED_ID
	WRAPPER_SOPHOMORIX_ON_UNDEFINED
	WRAPPER_SOPHOMORIX_INVALID_USER
	WRAPPER_SOPHOMORIX_NO_USERS
	WRAPPER_SOPHOMORIX_INVALID_USERID
	WRAPPER_SOPHOMORIX_NO_USERIDS
	WRAPPER_SOPHOMORIX_NO_SUCH_DIRECTORY
	WRAPPER_SOPHOMORIX_INVALID_DO_COPY
	WRAPPER_SOPHOMORIX_INVALID_FROM
	WRAPPER_SOPHOMORIX_INVALID_TYPE
	WRAPPER_SOPHOMORIX_INVALID_ROOM
	WRAPPER_SOPHOMORIX_INVALID_PROJECT
	WRAPPER_SOPHOMORIX_INVALID_CLASS
	WRAPPER_SOPHOMORIX_INVALID_SUBCLASS
	WRAPPER_SOPHOMORIX_INVALID_DO_ADD
	WRAPPER_SOPHOMORIX_CANNOT_OPEN_PDF_FILE
	WRAPPER_SOPHOMORIX_INVALID_SET_PASSWORD_TYPE
	WRAPPER_SOPHOMORIX_INVALID_PASSWORD
	WRAPPER_SOPHOMORIX_INVALID_IS_GROUPS
	WRAPPER_SOPHOMORIX_INVALID_IS_PUBLIC
	WRAPPER_SOPHOMORIX_INVALID_IS_UPLOAD
	WRAPPER_SOPHOMORIX_INVALID_PROJECTGID
	WRAPPER_SOPHOMORIX_INVALID_MEMBERSCOPE
	WRAPPER_SOPHOMORIX_INVALID_DO_CREATE
	WRAPPER_SOPHOMORIX_INVALID_LONGNAME
	WRAPPER_SOPHOMORIX_INVALID_FILENUMBER
	WRAPPER_SOPHOMORIX_CANNOT_OPEN_FILE
	WRAPPER_SOPHOMORIX_PROCESS_RUNNING
	WRAPPER_SOPHOMORIX_INVALID_MODE
	WRAPPER_SOPHOMORIX_CHMOD_FAILED
	WRAPPER_SOPHOMORIX_INVALID_FLAGS
	WRAPPER_SOPHOMORIX_INVALID_DISKQUOTA
	WRAPPER_SOPHOMORIX_INVALID_MAILQUOTA
	WRAPPER_CYRUS_ERROR_BASE
	WRAPPER_CYRUS_UNAUTHORIZED_UID
	WRAPPER_CYRUS_INVALID_SCRIPT
	WRAPPER_CYRUS_SCRIPT_EXEC_FAILED
	WRAPPER_CYRUS_NO_CYRUS_USER
	WRAPPER_CYRUS_INVALID_EUID
	WRAPPER_COLLAB_ERROR_BASE
	WRAPPER_COLLAB_GENERAL_ERROR
	WRAPPER_COLLAB_PROGRAM_ERROR
	WRAPPER_COLLAB_UNAUTHENTICATED_ID
	WRAPPER_COLLAB_APP_ID_DOES_NOT_EXIST
	WRAPPER_COLLAB_UNAUTHORIZED_ID
	WRAPPER_COLLAB_INVALID_IS_CREATE
	WRAPPER_COLLAB_INVALID_IS_GID
	WRAPPER_FILES_ERROR_BASE
	WRAPPER_FILES_GENERAL_ERROR
	WRAPPER_FILES_PROGRAM_ERROR
	WRAPPER_FILES_UNAUTHORIZED_UID
	WRAPPER_FILES_CANNOT_FORK
	WRAPPER_FILES_SCRIPT_EXEC_FAILED
	WRAPPER_FILES_UNAUTHENTICATED_ID
	WRAPPER_FILES_APP_ID_DOES_NOT_EXIST
	WRAPPER_FILES_UNAUTHORIZED_ID
	WRAPPER_FILES_INVALID_FILENUMBER
	WRAPPER_FILES_CANNOT_OPEN_FILE
	WRAPPER_FILES_CANNOT_CLOSE_FILE
);

# package constants
use constant {
	OK => 0,

	USER_AUTHENTICATION_FAILED  => 1,
	USER_PASSWORD_MISMATCH => 2,

	UNKNOWN_ROOM => 3,

	QUOTA_NOT_ALL_MOUNTPOINTS => 10,

	INTERNAL => 1000,
	DB_PREPARE_FAILED => 1001,
	DB_EXECUTE_FAILED => 1002,
	DB_FETCH_FAILED => 1003,

	UNKNOWN_PASSWORD_ENCRYPTION => 2001,
	DB_USER_DOES_NOT_EXIST => 2002,
	DB_NO_WORKSTATION_USERS => 2003,

	CANNOT_OPEN_FILE => 2501,
	FILE_FORMAT_ERROR => 2502,

	WRAPPER_EXEC_FAILED => 3001,
	WRAPPER_BROKEN_PIPE_OUT => 3002,
	WRAPPER_BROKEN_PIPE_IN => 3003,

	WRAPPER_USER_ERROR_BASE => 5000,
	WRAPPER_USER_GENERAL_ERROR => 5000 -1,
	WRAPPER_USER_PROGRAM_ERROR => 5000 -2,
	WRAPPER_USER_UNAUTHORIZED_UID => 5000 -3,
	WRAPPER_USER_INVALID_UID => 5000 -4,
	WRAPPER_USER_INVALID_SCRIPT => 5000 -5,
	WRAPPER_USER_SCRIPT_EXEC_FAILED => 5000 -6,
	WRAPPER_USER_SETUID_FAILED => 5000 -9,

	WRAPPER_FIREWALL_ERROR_BASE => 6000,
	WRAPPER_FIREWALL_GENERAL_ERROR => 6000 -1,
	WRAPPER_FIREWALL_PROGRAM_ERROR => 6000 -2,
	WRAPPER_FIREWALL_UNAUTHORIZED_UID => 6000 -3,
	WRAPPER_FIREWALL_SCRIPT_EXEC_FAILED => 6000 -6,
	WRAPPER_FIREWALL_UNAUTHENTICATED_ID => 6000 -32,
	WRAPPER_FIREWALL_APP_ID_DOES_NOT_EXIST => 6000 -33,
	WRAPPER_FIREWALL_UNAUTHORIZED_ID => 6000 -34,
	WRAPPER_FIREWALL_INVALID_MAC => 6000 -35,
	WRAPPER_FIREWALL_NO_MACS => 6000 -36,
	WRAPPER_FIREWALL_INVALID_HOST => 6000 -37,
	WRAPPER_FIREWALL_NO_HOSTS => 6000 -38,
	WRAPPER_FIREWALL_INVALID_ROOM => 6000 -39,
	WRAPPER_FIREWALL_INVALID_LESSONMODE => 6000 -40,
	WRAPPER_FIREWALL_INVALID_LESSONTIME => 6000 -41,
	WRAPPER_FIREWALL_CANNOT_WRITE_ROOMFILE => 6000 -42,
	WRAPPER_FIREWALL_CANNOT_READ_ROOMFILE => 6000 -43,
	WRAPPER_FIREWALL_CANNOT_FORK => 6000 -44,

	WRAPPER_PRINTER_ERROR_BASE => 7000,
	WRAPPER_PRINTER_GENERAL_ERROR => 7000 -1,
	WRAPPER_PRINTER_PROGRAM_ERROR => 7000 -2,
	WRAPPER_PRINTER_UNAUTHORIZED_UID => 7000 -3,
	WRAPPER_PRINTER_SCRIPT_EXEC_FAILED => 7000 -6,
	WRAPPER_PRINTER_UNAUTHENTICATED_ID => 7000 -32,
	WRAPPER_PRINTER_APP_ID_DOES_NOT_EXIST => 7000 -33,
	WRAPPER_PRINTER_UNAUTHORIZED_ID => 7000 -34,
	WRAPPER_PRINTER_CANNOT_OPEN_PRINTERSCONF => 7000 -64,
	WRAPPER_PRINTER_INVALID_PRINTER_NAME => 7000 -65,
	WRAPPER_PRINTER_NO_PRINTERS => 7000 -66,
	WRAPPER_PRINTER_INVALID_USER => 7000 -67,

	WRAPPER_SOPHOMORIX_ERROR_BASE => 8000,
	WRAPPER_SOPHOMORIX_GENERAL_ERROR => 8000 -1,
	WRAPPER_SOPHOMORIX_PROGRAM_ERROR => 8000 -2,
	WRAPPER_SOPHOMORIX_UNAUTHORIZED_UID => 8000 -3,
	WRAPPER_SOPHOMORIX_SCRIPT_EXEC_FAILED => 8000 -6,
	WRAPPER_SOPHOMORIX_UNAUTHENTICATED_ID => 8000 -32,
	WRAPPER_SOPHOMORIX_APP_ID_DOES_NOT_EXIST => 8000 -33,
	WRAPPER_SOPHOMORIX_UNAUTHORIZED_ID => 8000 -34,
	WRAPPER_SOPHOMORIX_CANNOT_FORK => 8000 -44,
	WRAPPER_SOPHOMORIX_ON_UNDEFINED => 8000 -96,
	WRAPPER_SOPHOMORIX_INVALID_USER => 8000 -97,
	WRAPPER_SOPHOMORIX_NO_USERS => 8000 -98,
	WRAPPER_SOPHOMORIX_INVALID_USERID => 8000 -99,
	WRAPPER_SOPHOMORIX_NO_USERIDS => 8000 -100,
	WRAPPER_SOPHOMORIX_NO_SUCH_DIRECTORY => 8000 -101,
	WRAPPER_SOPHOMORIX_INVALID_DO_COPY => 8000 -102,
	WRAPPER_SOPHOMORIX_INVALID_FROM => 8000 -103,
	WRAPPER_SOPHOMORIX_INVALID_TYPE => 8000 -104,
	WRAPPER_SOPHOMORIX_INVALID_ROOM => 8000 -105,
	WRAPPER_SOPHOMORIX_INVALID_PROJECT => 8000 -106,
	WRAPPER_SOPHOMORIX_INVALID_CLASS => 8000 -107,
	WRAPPER_SOPHOMORIX_INVALID_SUBCLASS => 8000 -108,
	WRAPPER_SOPHOMORIX_INVALID_DO_ADD => 8000 -109,
	WRAPPER_SOPHOMORIX_CANNOT_OPEN_PDF_FILE => 8000 -110,
	WRAPPER_SOPHOMORIX_INVALID_SET_PASSWORD_TYPE => 8000 -111,
	WRAPPER_SOPHOMORIX_INVALID_PASSWORD => 8000 -112,
	WRAPPER_SOPHOMORIX_INVALID_IS_GROUPS => 8000 -113,
	WRAPPER_SOPHOMORIX_INVALID_IS_PUBLIC => 8000 -114,
	WRAPPER_SOPHOMORIX_INVALID_IS_UPLOAD => 8000 -115,
	WRAPPER_SOPHOMORIX_INVALID_PROJECTGID => 8000 -116,
	WRAPPER_SOPHOMORIX_INVALID_MEMBERSCOPE => 8000 -117,
	WRAPPER_SOPHOMORIX_INVALID_DO_CREATE => 8000 -118,
	WRAPPER_SOPHOMORIX_INVALID_LONGNAME => 8000 -119,
	WRAPPER_SOPHOMORIX_INVALID_FILENUMBER => 8000 -120,
	WRAPPER_SOPHOMORIX_CANNOT_OPEN_FILE => 8000 -121,
	WRAPPER_SOPHOMORIX_PROCESS_RUNNING => 8000 -122,
	WRAPPER_SOPHOMORIX_INVALID_MODE => 8000 -123,
	WRAPPER_SOPHOMORIX_CHMOD_FAILED => 8000 -124,
	WRAPPER_SOPHOMORIX_INVALID_FLAGS => 8000 -125,
	WRAPPER_SOPHOMORIX_INVALID_DISKQUOTA => 8000 -126,
	WRAPPER_SOPHOMORIX_INVALID_MAILQUOTA => 8000 -127,

	WRAPPER_CYRUS_ERROR_BASE => 9000,
	WRAPPER_CYRUS_UNAUTHORIZED_UID => 9000 -3,
	WRAPPER_CYRUS_INVALID_SCRIPT => 9000 -5,
	WRAPPER_CYRUS_SCRIPT_EXEC_FAILED => 9000 -6,
	WRAPPER_CYRUS_NO_CYRUS_USER => 9000 -7,
	WRAPPER_CYRUS_INVALID_EUID => 9000 -8,

	WRAPPER_COLLAB_ERROR_BASE => 10000,
	WRAPPER_COLLAB_GENERAL_ERROR => 10000 -1,
	WRAPPER_COLLAB_PROGRAM_ERROR => 10000 -2,
	WRAPPER_COLLAB_UNAUTHORIZED_UID => 10000 -3,
	WRAPPER_COLLAB_SCRIPT_EXEC_FAILED => 10000 -6,
	WRAPPER_COLLAB_UNAUTHENTICATED_ID => 10000 -32,
	WRAPPER_COLLAB_APP_ID_DOES_NOT_EXIST => 10000 -33,
	WRAPPER_COLLAB_UNAUTHORIZED_ID => 10000 -34,
	WRAPPER_COLLAB_INVALID_IS_CREATE => 10000 -48,
	WRAPPER_COLLAB_INVALID_IS_GID => 10000 -49,

	WRAPPER_FILES_ERROR_BASE => 11000,
	WRAPPER_FILES_GENERAL_ERROR => 11000 -1,
	WRAPPER_FILES_PROGRAM_ERROR => 11000 -2,
	WRAPPER_FILES_UNAUTHORIZED_UID => 11000 -3,
	WRAPPER_FILES_SCRIPT_EXEC_FAILED => 11000 -6,
	WRAPPER_FILES_UNAUTHENTICATED_ID => 11000 -32,
	WRAPPER_FILES_APP_ID_DOES_NOT_EXIST => 11000 -33,
	WRAPPER_FILES_UNAUTHORIZED_ID => 11000 -34,
	WRAPPER_FILES_CANNOT_FORK => 11000 -44,
	WRAPPER_FILES_INVALID_FILENUMBER => 11000 -120,
	WRAPPER_FILES_CANNOT_OPEN_FILE => 11000 -121,
	WRAPPER_FILES_CANNOT_CLOSE_FILE => 11000 -123,
};

use overload
	'""' => \&errstr;





sub new {
	my $class = shift;
	my $code = shift;
	my $info = @_ ? \@_ : undef;

	my $this = {
		code => $code,
		internal => $code >= INTERNAL,
		info => $info,
	};

	bless $this, $class;

	return $this;
}




sub what {
	my $this = shift;

	SWITCH: {
	$this->{code} == OK and return 'kein Fehler';
	$this->{code} == USER_AUTHENTICATION_FAILED
		and return 'Authentifizierung fehlgeschlagen';
	$this->{code} == USER_PASSWORD_MISMATCH
		and return 'Neues Passwort nicht richtig wiederholt';
	$this->{code} == UNKNOWN_ROOM
		and return 'Raum ist unbekannt';
	$this->{code} == QUOTA_NOT_ALL_MOUNTPOINTS
		and return 'F&uuml;r Diskquota m&uuml;ssen alle oder keine Felder ausgef&uuml;llt sein';
	$this->{code} == DB_PREPARE_FAILED
		and return 'Prepare fehlgeschlagen';
	$this->{code} == DB_EXECUTE_FAILED
		and return 'Execute fehlgeschlagen';
	$this->{code} == DB_FETCH_FAILED
		and return 'Fetch fehlgeschlagen';
	$this->{code} == UNKNOWN_PASSWORD_ENCRYPTION
		and return 'Unbekannte Passwortverschluesselung';
	$this->{code} == DB_USER_DOES_NOT_EXIST
		and return 'Benutzer existiert nicht';
	$this->{code} == DB_NO_WORKSTATION_USERS
		and return 'Keine Workstationbenutzer';
	(   $this->{code} == CANNOT_OPEN_FILE
	 or $this->{code} == WRAPPER_SOPHOMORIX_CANNOT_OPEN_FILE
	 or $this->{code} == WRAPPER_FILES_CANNOT_OPEN_FILE)
		and return 'Kann Datei nicht oeffnen';
	$this->{code} == FILE_FORMAT_ERROR
		and return 'Datei hat falsches Format';
	$this->{code} == WRAPPER_EXEC_FAILED
		and return 'Wrapperaufruf fehlgeschlagen';
	$this->{code} == WRAPPER_BROKEN_PIPE_OUT
		and return 'Datenuebertragung (schreiben) unterbrochen';
	$this->{code} == WRAPPER_BROKEN_PIPE_IN
		and return 'Datenuebertragung (lesen) unterbrochen';
	(   $this->{code} == WRAPPER_USER_PROGRAM_ERROR
	 or $this->{code} == WRAPPER_FIREWALL_PROGRAM_ERROR
	 or $this->{code} == WRAPPER_PRINTER_PROGRAM_ERROR
	 or $this->{code} == WRAPPER_SOPHOMORIX_PROGRAM_ERROR
	 or $this->{code} == WRAPPER_COLLAB_PROGRAM_ERROR
	 or $this->{code} == WRAPPER_FILES_PROGRAM_ERROR)
		and return 'Programmaufruf fehlgeschlagen';
	(   $this->{code} == WRAPPER_USER_UNAUTHORIZED_UID
	 or $this->{code} == WRAPPER_FIREWALL_UNAUTHORIZED_UID
	 or $this->{code} == WRAPPER_PRINTER_UNAUTHORIZED_UID
	 or $this->{code} == WRAPPER_SOPHOMORIX_UNAUTHORIZED_UID
	 or $this->{code} == WRAPPER_CYRUS_UNAUTHORIZED_UID
	 or $this->{code} == WRAPPER_COLLAB_UNAUTHORIZED_UID
	 or $this->{code} == WRAPPER_FILES_UNAUTHORIZED_UID)
		and return 'Nicht autorisierter Aufrufer';
	$this->{code} == WRAPPER_USER_INVALID_UID
		and return 'Wechsel zu diesem Benutzer nicht erlaubt';
	$this->{code} == WRAPPER_USER_SETUID_FAILED
		and return 'Wechsel zu diesem Benutzer nicht moeglich';
	(   $this->{code} == WRAPPER_USER_INVALID_SCRIPT
	 or $this->{code} == WRAPPER_CYRUS_INVALID_SCRIPT)
		and return 'Skript nicht vorhanden';
	(   $this->{code} == WRAPPER_USER_SCRIPT_EXEC_FAILED
	 or $this->{code} == WRAPPER_FIREWALL_SCRIPT_EXEC_FAILED
	 or $this->{code} == WRAPPER_PRINTER_SCRIPT_EXEC_FAILED
	 or $this->{code} == WRAPPER_SOPHOMORIX_SCRIPT_EXEC_FAILED
	 or $this->{code} == WRAPPER_CYRUS_SCRIPT_EXEC_FAILED
	 or $this->{code} == WRAPPER_COLLAB_SCRIPT_EXEC_FAILED
	 or $this->{code} == WRAPPER_FILES_SCRIPT_EXEC_FAILED)
		and return 'Skriptaufruf fehlgeschlagen';
	(   $this->{code} == WRAPPER_FIREWALL_UNAUTHENTICATED_ID
	 or $this->{code} == WRAPPER_PRINTER_UNAUTHENTICATED_ID
	 or $this->{code} == WRAPPER_SOPHOMORIX_UNAUTHENTICATED_ID
	 or $this->{code} == WRAPPER_COLLAB_UNAUTHENTICATED_ID
	 or $this->{code} == WRAPPER_FILES_UNAUTHENTICATED_ID)
		and return 'Authentifizierung fehlgeschlagen nach ID';
	(   $this->{code} == WRAPPER_FIREWALL_APP_ID_DOES_NOT_EXIST
	 or $this->{code} == WRAPPER_PRINTER_APP_ID_DOES_NOT_EXIST
	 or $this->{code} == WRAPPER_SOPHOMORIX_APP_ID_DOES_NOT_EXIST
	 or $this->{code} == WRAPPER_COLLAB_APP_ID_DOES_NOT_EXIST
	 or $this->{code} == WRAPPER_FILES_APP_ID_DOES_NOT_EXIST)
		and return 'Programm-ID unbekannt';
	(   $this->{code} == WRAPPER_FIREWALL_UNAUTHORIZED_ID
	 or $this->{code} == WRAPPER_PRINTER_UNAUTHORIZED_ID
	 or $this->{code} == WRAPPER_SOPHOMORIX_UNAUTHORIZED_ID
	 or $this->{code} == WRAPPER_COLLAB_UNAUTHORIZED_ID
	 or $this->{code} == WRAPPER_FILES_UNAUTHORIZED_ID)
		and return 'Nicht autorisierter Aufrufer nach ID';
	$this->{code} == WRAPPER_FIREWALL_INVALID_MAC
		and return 'Ungueltige MAC-Adresse';
	$this->{code} == WRAPPER_FIREWALL_NO_MACS
		and return 'Keine MAC-Adressen';
	$this->{code} == WRAPPER_FIREWALL_INVALID_HOST
		and return 'Ungueltiger Host';
	$this->{code} == WRAPPER_FIREWALL_NO_HOSTS
		and return 'Keine Hosts';
	$this->{code} == WRAPPER_FIREWALL_INVALID_ROOM
		and return 'Ungueltige Raumbezeichnung';
	$this->{code} == WRAPPER_FIREWALL_INVALID_LESSONMODE
		and return 'Ungueltiger Modus fuer Unterricht';
	$this->{code} == WRAPPER_FIREWALL_INVALID_LESSONTIME
		and return 'Ungueltige Zeitangabe fuer Unterrichtsende';
	$this->{code} == WRAPPER_FIREWALL_CANNOT_WRITE_ROOMFILE
		and return 'Raumdatei kann nicht geschrieben werden';
	$this->{code} == WRAPPER_FIREWALL_CANNOT_READ_ROOMFILE
		and return 'Raumdatei kann nicht gelesen werden';
	(   $this->{code} == WRAPPER_FIREWALL_CANNOT_FORK
	 or $this->{code} == WRAPPER_SOPHOMORIX_CANNOT_FORK
	 or $this->{code} == WRAPPER_FILES_CANNOT_FORK)
		and return 'Fork nicht moeglich';
	$this->{code} == WRAPPER_PRINTER_CANNOT_OPEN_PRINTERSCONF
		and return 'Kann printers.conf nicht oeffnen';
	$this->{code} == WRAPPER_PRINTER_INVALID_PRINTER_NAME
		and return 'Ungueltiger Druckername';
	$this->{code} == WRAPPER_PRINTER_NO_PRINTERS
		and return 'Keine Drucker';
	$this->{code} == WRAPPER_PRINTER_INVALID_USER
		and return 'Ungueltiger Druckernutzer';
	$this->{code} == WRAPPER_SOPHOMORIX_ON_UNDEFINED
		and return 'on muss 1 oder 0 sein';
	$this->{code} == WRAPPER_SOPHOMORIX_INVALID_USER
		and return 'Ungueltiger Benutzer';
	$this->{code} == WRAPPER_SOPHOMORIX_NO_USERS
		and return 'Keine Benutzer';
	$this->{code} == WRAPPER_SOPHOMORIX_INVALID_USERID
		and return 'Ungueltige Benutzer-ID';
	$this->{code} == WRAPPER_SOPHOMORIX_NO_USERIDS
		and return 'Keine Benutzer-IDs';
	$this->{code} == WRAPPER_SOPHOMORIX_NO_SUCH_DIRECTORY
		and return 'Verzeichnis nicht gefunden';
	$this->{code} == WRAPPER_SOPHOMORIX_INVALID_ROOM
		and return 'Ungueltiger Raumbezeichner';
	$this->{code} == WRAPPER_SOPHOMORIX_INVALID_DO_COPY
		and return 'Erwarte 1 oder 0 fuer do_copy';
	$this->{code} == WRAPPER_SOPHOMORIX_INVALID_FROM
		and return 'Erwarte numerische Angabe fuer "from"';
	$this->{code} == WRAPPER_SOPHOMORIX_INVALID_TYPE
		and return 'Erwarte numerische Angabe fuer "type"';
	$this->{code} == WRAPPER_SOPHOMORIX_INVALID_ROOM
		and return 'Ungueltiger Raum';
	$this->{code} == WRAPPER_SOPHOMORIX_INVALID_PROJECT
		and return 'Ungueltiges Projekt';
	$this->{code} == WRAPPER_SOPHOMORIX_INVALID_CLASS
		and return 'Ungueltige Klassen-GID';
	$this->{code} == WRAPPER_SOPHOMORIX_INVALID_SUBCLASS
		and return 'Ungueltige Subklasse';
	$this->{code} == WRAPPER_SOPHOMORIX_INVALID_DO_ADD
		and return 'Erwarte 1 oder 0 fuer do_add';
	$this->{code} == WRAPPER_SOPHOMORIX_CANNOT_OPEN_PDF_FILE
		and return 'Kann PDF-Datei nicht oeffnen';
	$this->{code} == WRAPPER_SOPHOMORIX_INVALID_SET_PASSWORD_TYPE
		and return 'Erwarte 0 (reset), 1 (passwd) oder 3 (random) fuer type';
	$this->{code} == WRAPPER_SOPHOMORIX_INVALID_PASSWORD
		and return 'Ungueltiger Wert fuer password';
	$this->{code} == WRAPPER_SOPHOMORIX_INVALID_IS_GROUPS
		and return 'Erwarte 1 oder 0 fuer is_groups';
	$this->{code} == WRAPPER_SOPHOMORIX_INVALID_IS_PUBLIC
		and return 'Erwarte 1 oder 0 fuer is_public';
	$this->{code} == WRAPPER_SOPHOMORIX_INVALID_IS_UPLOAD
		and return 'Erwarte 1 oder 0 fuer is_upload';
	$this->{code} == WRAPPER_SOPHOMORIX_INVALID_PROJECTGID
		and return 'Ungueltiger Wert fuer projectgid';
	$this->{code} == WRAPPER_SOPHOMORIX_INVALID_MEMBERSCOPE
		and return 'Erwarte 0, 1, 2 oder 3 fuer scope';
	$this->{code} == WRAPPER_SOPHOMORIX_INVALID_DO_CREATE
		and return 'Erwarte 1 oder 0 fuer do_create';
	$this->{code} == WRAPPER_SOPHOMORIX_INVALID_LONGNAME
		and return 'Ungueltiger Wert fuer longname';
	$this->{code} == WRAPPER_CYRUS_NO_CYRUS_USER
		and return 'Benutzer "cyrus" gibt es nicht';
	$this->{code} == WRAPPER_CYRUS_INVALID_EUID
		and return 'wrapper-cyrus gehoert nicht Benutzer "cyrus" oder SUID nicht gesetzt';
	$this->{code} == WRAPPER_COLLAB_INVALID_IS_CREATE
		and return 'Erwarte 1 oder 0 fuer is_create';
	$this->{code} == WRAPPER_COLLAB_INVALID_IS_GID
		and return 'Erwarte 1 oder 0 fuer is_gid';
	(   $this->{code} == WRAPPER_SOPHOMORIX_INVALID_FILENUMBER
	 or $this->{code} == WRAPPER_FILES_INVALID_FILENUMBER)
		and return 'Erwarte 0 bis 6 fuer number';
	$this->{code} == WRAPPER_SOPHOMORIX_PROCESS_RUNNING
		and return 'Prozess laeuft schon';
	$this->{code} == WRAPPER_SOPHOMORIX_INVALID_MODE
		and return 'Erwarte 0, 1 oder 2 fuer mode';
	$this->{code} == WRAPPER_SOPHOMORIX_CHMOD_FAILED
		and return 'Konnte Berechtigung nicht aendern';
	$this->{code} == WRAPPER_SOPHOMORIX_INVALID_FLAGS
		and return 'Erwarte 1 bis 7 fuer flags';
	$this->{code} == WRAPPER_SOPHOMORIX_INVALID_DISKQUOTA
		and return 'Ungueltiger Wert fuer diskquota';
	$this->{code} == WRAPPER_SOPHOMORIX_INVALID_MAILQUOTA
		and return 'Ungueltiger Wert fuer mailquota';
	$this->{code} == WRAPPER_FILES_CANNOT_CLOSE_FILE
		and return 'Fehler beim Schliessen der Datei';

	return 'Unbekannter Fehler ' . $this->{code}
		. ' [' . join(', ', (caller(2))[1..3]) . ']'; 
	}
}



sub errstr {
	my $this = shift;

	return $0
		. ': '
		. $this->what()
		. ($this->{info} ? ' (' . join(', ', @{ $this->{info} }) . ')' : '')
		. "\n";
}





1;

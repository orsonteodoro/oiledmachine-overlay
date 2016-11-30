#!/usr/bin/perl

# ~/.config/lastfm looks like this:
# $login = 'vpupkin';
# $password = 'mycoolpassword';


#$hs_url = "https://post.audioscrobbler.com/";
$hs_url = "https://ws.audioscrobbler.com/2.0/";
$client_id = "lsd";
$client_version = "1.0.4";
$debug = 0;

$app_name="APP_NAME";
$api_key="APP_API_KEY";
$shared_secret="APP_SHARED_SECRET";

use LWP::UserAgent;
use Digest::MD5 qw(md5_hex);
use URI::Escape;
use XML::XPath;
use XML::XPath::XMLParser;

die "Usage: lastfm.pl <artist> <title> <album> <length> <nowplaying>" unless $#ARGV==4;
$ua = LWP::UserAgent->new;

do "$ENV{HOME}/.config/lastfm";

foreach ("login", "password") {
	die "No $_ in ~/.config/lastfm" unless ${$_};
}

@t = gmtime();
$time = time;
$hash = md5_hex(md5_hex($password).$time);

$session_key=getSessionKey();
print "Current session key: ".$session_key."\n" if $debug;
if (length $session_key > 0) {
	print "Resuming session\n" if $debug;
} else {
	print "New session\n" if $debug;
	$session_key=auth_getMobileSession();
	storeSessionKey($session_key);
}

#get token (step 2)
sub auth_getMobileSession {
	$api_method="auth.getMobileSession";

	$api_sig="";
	$api_sig=$api_sig."api_key".$api_key;
	$api_sig=$api_sig."method".$api_method;
	$api_sig=$api_sig."password".$password;
	$api_sig=$api_sig."username".$login;
	$api_sig=$api_sig.$shared_secret;
	print $api_sig."\n" if $debug;
	$api_sig2=md5_hex($api_sig);
	print $api_sig2."\n" if $debug;

	$params="";
	$params=$params."method=".$api_method;
	$params=$params."&api_key=".$api_key;
	$params=$params."&password=".$password;
	$params=$params."&username=".$login;
	$params=$params."&api_sig=".$api_sig2;

	$url=$hs_url;
	my $req = HTTP::Request->new(POST=>$url);
	$req->content_type('application/x-www-form-urlencoded');
	$req_str=$params;

	$req->content($req_str);
	$resp = $ua->request($req);
	($status, $int) = split(/\n/, $resp->content, 2);
	print "Server returned:".$resp->content."\n" if $debug;

	my $xp = XML::XPath->new( xml => $resp->content );
	$session_key = $xp->getNodeText('/lfm/session/key');
	return $session_key;
}

sub storeSessionKey {
	my ($key) = @_;
	$filename=$ENV{"HOME"}.'/.config/lastfm.sessionkey';
	if (-e $filename) {
		print("Not storing session key.\n") if $debug;
	} else {
		print("Storing session key.\n") if $debug;
		open(my $fh, '>', $filename) or die "Cannot store session key at $filename\n";
		print $fh $key;
		close $fh ;
        }
}

sub getSessionKey {
	$filename=$ENV{"HOME"}.'/.config/lastfm.sessionkey';
	my $key="";
	if (-e $filename) {
		print("Getting session key.\n") if $debug;
		open(my $fh, '<', $filename) or die "Cannot get session key at $filename\n";
		$key = <$fh>;
		close $fh;
	} else {
		print("Failed to get session key.\n") if $debug;
        }
	return $key;
}


sub track_updateNowPlaying {
	my ($artist, $track, $album, $trackNumber, $context, $mbid, $duration, $albumArtist) = @_;
	$api_method="track.updateNowPlaying";

	$api_sig="";
	if (length $album > 0) {
		$api_sig=$api_sig."album".$album;
	}
	if (length $albumArtist > 0) {
		$api_sig=$api_sig."albumArtist".$albumArtist;
	}
	$api_sig=$api_sig."api_key".$api_key;
	$api_sig=$api_sig."artist".$artist; #required
	if (length $context > 0) {
		$api_sig=$api_sig."context".$context;
	}
	if (length $duration > 0) {
		$api_sig=$api_sig."duration".$duration;
	}
	if (length $mbid > 0) {
		$api_sig=$api_sig."mbid".$mbid;
	}
	$api_sig=$api_sig."method".$api_method;
	$api_sig=$api_sig."sk".$session_key; #required
	$api_sig=$api_sig."track".$track; #required
	if (length $trackNumber > 0) {
		$api_sig=$api_sig."trackNumber".$trackNumber;
	}
	$api_sig=$api_sig.$shared_secret;
	print $api_sig."\n" if $debug;
	$api_sig2=md5_hex($api_sig);
	print $api_sig2."\n" if $debug;

	$params="";
	$params=$params."method=".$api_method;
	$params=$params."&api_key=".$api_key;

	if (length $album > 0) {
		$params=$params."&album=".$album;
	}
	if (length $albumArtist > 0) {
		$params=$params."&albumArtist=".$albumArtist;
	}
	$params=$params."&artist=".$artist; #required
	if (length $context > 0) {
		$params=$params."&context=".$context;
	}
	if (length $duration > 0) {
		$params=$params."&duration=".$duration;
	}
	if (length $mbid > 0) {
		$params=$params."&mbid=".$mbid;
	}
	$params=$params."&sk=".$session_key; #required
	$params=$params."&track=".$track; #required
	if (length $trackNumber > 0) {
		$params=$params."&trackNumber=".$trackNumber;
	}
	$params=$params."&api_sig=".$api_sig2;
	print $params if $debug;

	$url=$hs_url;
	my $req = HTTP::Request->new(POST=>$url);
	$req->content_type('application/x-www-form-urlencoded');
	$req_str=$params;

	$req->content($req_str);
	$resp = $ua->request($req);
	($status, $int) = split(/\n/, $resp->content, 2);
	print "Server returned:".$resp->content."\n" if $debug;
	#die "Scrobble failed, server returned: $status\n" unless $status == "OK";
}

sub track_scrobble {
	my ($artist, $track, $timestamp, $album, $context, $streamId, $chosenByUser, $trackNumber, $mbid, $albumArtist, $duration ) = @_;

	$api_method="track.scrobble";

	$api_sig="";
	if (length $album > 0) {
		$api_sig=$api_sig."album".$album;
	}
	if (length $albumArtist > 0) {
		$api_sig=$api_sig."albumArtist".$albumArtist;
	}
	$api_sig=$api_sig."api_key".$api_key;
	$api_sig=$api_sig."artist".$artist; #required
	if (length $chosenByUser > 0) {
		$api_sig=$api_sig."chosenByUser".$chosenByUser;
	}
	if (length $context > 0) {
		$api_sig=$api_sig."context".$context;
	}
	if (length $duration > 0) {
		$api_sig=$api_sig."duration".$duration;
	}
	if (length $mbid > 0) {
		$api_sig=$api_sig."mbid".$mbid;
	}
	$api_sig=$api_sig."method".$api_method;
	$api_sig=$api_sig."sk".$session_key; #required
	if (length $streamId > 0) {
		$api_sig=$api_sig."streamId".$streamId;
	}
	$api_sig=$api_sig."timestamp".$timestamp; #required
	$api_sig=$api_sig."track".$track; #required
	if (length $trackNumber > 0) {
		$api_sig=$api_sig."trackNumber".$trackNumber;
	}
	$api_sig=$api_sig.$shared_secret;
	print $api_sig."\n" if $debug;
	$api_sig2=md5_hex($api_sig);
	print $api_sig2."\n" if $debug;

	$params="";
	$params=$params."method=".$api_method;
	$params=$params."&api_key=".$api_key;

	if (length $album > 0) {
		$params=$params."&album=".$album;
	}
	if (length $albumArtist > 0) {
		$params=$params."&albumArtist=".$albumArtist;
	}
	$params=$params."&artist=".$artist; #required
	if (length $chosenByUser > 0) {
		$params=$params."&chosenByUser=".$chosenByUser;
	}
	if (length $context > 0) {
		$params=$params."&context=".$context;
	}
	if (length $duration > 0) {
		$params=$params."&duration=".$duration;
	}
	if (length $mbid > 0) {
		$params=$params."&mbid=".$mbid;
	}
	$params=$params."&sk=".$session_key; #required
	$params=$params."&timestamp=".$timestamp; #required
	$params=$params."&track=".$track; #required
	if (length $trackNumber > 0) {
		$params=$params."&trackNumber=".$trackNumber;
	}
	if (length $streamId > 0) {
		$params=$params."&streamId=".$streamId;
	}
	$params=$params."&api_sig=".$api_sig2;
	print $params if $debug;

	$url=$hs_url;
	my $req = HTTP::Request->new(POST=>$url);
	$req->content_type('application/x-www-form-urlencoded');
	$req_str=$params;

	$req->content($req_str);
	$resp = $ua->request($req);
	($status, $int) = split(/\n/, $resp->content, 2);
	print "Server returned:".$resp->content."\n" if $debug;
	die "Scrobble failed, server returned: $status\n" unless $status == "OK";

}

$artist=$ARGV[0];
print $artist."\n" if $debug;
$track=$ARGV[1];
print $track."\n" if $debug;
$album=$ARGV[2];
print $album."\n" if $debug;
$trackNumber='';
$context='';
$mbid='';
$duration=$ARGV[3];
print $duration if $debug;
$albumArtist='';
if ($ARGV[4] eq "1") {
	print "Setting Now Playing.\n";
	track_updateNowPlaying($artist, $track, $album, $trackNumber, $context, $mbid, $duration, $albumArtist);
}

$timestamp=time;
$streamId='';
$chosenByUser='false';
if ($ARGV[4] eq "0") {
	print "Scrobbling track.\n";
	track_scrobble($artist, $track, $timestamp, $album, $context, $streamId, $chosenByUser, $trackNumber, $mbid, $albumArtist, $duration);
}

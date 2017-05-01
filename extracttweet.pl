# pull out a few key fields from json formatted tweets

while (<>) {

##	if (/"text": "(.*?)".*"favorite_count": (\d+).*"created_at": "(\w+) (\w+) (\d+) (\S+) (\S+) (\d+)"/) {
	if (/"text": "(.*?)".*"created_at": "(\w+) (\w+) (\d+) (\S+) (\S+) (\d+)"/) {
		print "$7$3$4 $1\n";
	}
}

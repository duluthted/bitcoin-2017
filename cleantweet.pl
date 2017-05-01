
while (<>) {

	chomp;

	$_ = lc($_);

	#remove
	s/&amp;/ /g;
	s/\\[nu](\S+)?/ /g;

	#normalize 

	s/http\S+/ WEBSITE_URL /g;
	s/(\d+)?[.,](\d+)/ REAL_VALUE /g;
	s/\$(\d+)(\.(\d+))?/ DOLLAR_AMOUNT /g;
	s/\b\d+\b/ INTEGER /g; # remove standalone ints, leave dates alone!

	#convert for the sake of readability
	#and because punctuation will be removed later

	s/@(\w+)/ USERID_$1 /g;
	s/#(\S+)/ HTAG_$1 /g;
	s/=/ EQUALS /g;

	# final pass to remove anything that isn't alphanumeric

	s/\W+/ /g;
##	s/[)(\[\],.!\/\\\-*|~^'":?`]/ /g;

	@line = split;
	if (@line > 2) {

		for ($x=0; $x<@line-1;$x++) {
			print "@line[$x] ";	
		}
		print "@line[$x]\n";
	}
}

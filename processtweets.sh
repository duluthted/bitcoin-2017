# start with a json file, clean it, remove duplicates, output date and text fields

##rm -fr $1.tmp
##rm -fr $1.uniq
##rm -fr $1.clean
rm -fr $1.before
rm -fr $1.after
rm -fr $1.*cnt
rm -fr $1.*ll
rm -fr $1.*sval2

# get unduplicated json count

echo "get unduplicate json count"
 sort $1 | uniq > $1.uniq

echo "running extracttweet" 

# get duplicate count before normalization

#perl extracttweet.pl $1.uniq | sort | uniq -c | sort -nr > $1.before 

perl extracttweet.pl $1.uniq | sort | uniq > $1.tmp

# echo "running cleantweet"

perl cleantweet.pl $1.tmp |sort |uniq -f 1 > $1.clean

# get duplicated count after normalization

#perl cleantweet.pl $1.tmp |sort |uniq -c | sort -nr > $1.after 

# count ngrams in entire corpus

for gram in 1 2 3
do
	echo "whole corpus gram $gram"
	count.pl --remove 5 --ngram $gram --stop stoplist-nsp.regex --newline $1.$gram.cnt $1.clean 
done

for month in 2016nov 2016dec 2017jan 2017feb 2017mar 2017apr
do 
	echo "grep $month" 
	grep $month $1.clean > $1.$month.clean

	# remove first column with date 
	awk '{$1=""; print}' $1.$month.clean > $1.$month.clean.tmp
	text2sval.pl $1.$month.clean.tmp > $1.$month.sval2
done

for month in 2016nov 2016dec 2017jan 2017feb 2017mar 2017apr
do
	echo "$month $gram"
	for gram in 1 2 3
	do
		echo "gram $gram"
		count.pl --remove 5 --ngram $gram --stop stoplist-nsp.regex --newline $1.$month.$gram.cnt $1.$month.clean.tmp
	done

	for gram in 2 3
	do
		for window in 4 10 
		do
			echo "gram $gram window $window"
			count.pl --remove 5 --ngram $gram --window $window --stop stoplist-nsp.regex --newline $1.$month.$window.$gram.cnt $1.$month.clean.tmp 
		done
	done

	for gram in 2 3
	do
		for window in 4 10 
		do
			echo "gram $gram window $window"
			statistic.pl ll --ngram $gram $1.$month.$window.$gram.ll $1.$month.clean.tmp 
		done
	done
done

echo "get word counts"

wc $1* > $1.wc

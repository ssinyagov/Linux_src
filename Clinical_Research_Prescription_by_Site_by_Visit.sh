#"Site",-  8
#"Patient",-13 
#"CPE Name",- 15 
#"2.What will be  dose of Gaviscon in ml?",- 29
#"3.Frequency of Gaviscon intake in a day?",- 31
#"4.Duration of Gaviscon prescription?"- 33


cat QS2.csv| 
tail -n +2|
#					    Site  CPE_Name  Frequence	
#					      Patient  Dose    Duration
awk -F ',' 'OFS="," { if( $31 != ""){ print $8,$13,$15,$29, $31,$33;} }' |tee ttt|
#					     1   2   3  4   5   6
sed 's\VISIT \VISIT_\'|
awk -F ',' ' {
	Site[$1]=$1;
	Patient[$2]=$2;
	Visit_site[$1,$3]=$3;
	Visit[$3]=$3;
	Dose[$4]=$4;
	Freq[$5]=$5;
	Duration[$6]=$6;
	Duration_Summary[$1,$3]+=$6;
	Patient_Summary[$1,$3]+=1;
}
END {
	for (i in Site){
		for (j in Visit ){ 
			if( Patient_Summary[i,j] != 0 ){
				printf("%s\t%s\t%d\t%d\t%4.2f\n",
				i,
				j,
				Duration_Summary[i,j], 
				Patient_Summary[i,j],
				Duration_Summary[i,j]/Patient_Summary[i,j]);
			}	
			else {
				printf("%s\t%s\t%d\t%d\t%4.2f\n",
                                i,
                                j,
                                Duration_Summary[i,j],
                                0,
                                0 );
			}
		}

	}
}'

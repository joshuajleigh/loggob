#setting ansible playbooks path
apath=~/Repos/hubot-playbooks/inventory/ops
rm /tmp/table* 

#---------------------------------------------------------------------------------------------

# gathers list of servers for given enviroment
for i in $( ls $apath ); do
	cat $apath/$i |
	grep '[a-z]\{2,3\}-.\{2,12\}' | grep -v "#" |sort | uniq -u | tr "\n" " " >> /tmp/table$i
done

for i in $( ls $apath ); do
	cat /tmp/table$i | sed "s/^/$i /g" >> /tmp/tableA
done
# debug
#echo "the list of servers closer to raw"
#cat /tmp/tableA
#---------------------------------------------------------------------------------------------
# adding checkboxes
cat /tmp/tableA | tr " " "\t" | sed 's|	| [x]|g'  >> /tmp/tableB
# cat /tmp/tableB
# removing unwanted trailing boxes
cat /tmp/tableB | sed -e s/'.\{3\}$'// > /tmp/tableA

#echo "table with checkboxes"
#cat /tmp/tableA
#----------------------------------------------------------------------------------------------
#gathering the number of rows needed
rowlen=$(awk '{if (NF > max) {max = NF; line=$0}} END{print line}' /tmp/tableA)
rows=0
for i in $rowlen; do
	((rows++))
done
##debug
#echo "the longest set of rows are $rowlen"
#echo "for a total of $rows rows"

#-------------------------------------------------------------------

# gathering longest word and the cell length
longest=0
for i in $(</tmp/tableA); do
	cellen=${#i}
	if [ $cellen -gt ${#longest} ]
	then
		longest=$cellen

	fi
done

#debug
#echo "the longest word is $cellen long."
maxcell=$(($cellen+6))

#debug
#echo "the cell length will be $maxcell"

#----------------------------------------------------------------------------------------------

# gathering the number of columns
col=0
collumn=$(cut -d" " -f1 /tmp/tableA)
for i in $collumn; do
	((col++))
done

#debug
#echo "the columns are $collumn"
#echo "for a total of $col columns"

#-----------------------------------------------------------------------------------------------

# changing rows to columns and vice versa
rm /tmp/tableB

x=0
for i in $rowlen; do
	((x++))
	echo "$(cat /tmp/tableA | cut -d" " -f$x | tr '\n' '\t')"  | expand -t$maxcell >> /tmp/tableB
done

#debug
#echo "the table corrected"
#cat /tmp/tableB

#------------------------------------------------------------------------------------------------

# adding cell borders
delimiter=0
for i in $rowlen; do
	delimiter=$((delimiter + $maxcell))
	cat /tmp/tableB | sed "s/./|/$delimiter" > /tmp/tableA
	cat /tmp/tableA > /tmp/tableB
done

sed 's/^/|/' /tmp/tableB > /tmp/tableA

#debug
#echo "table with borders:"
#cat /tmp/tableA

#--------------------------------------------------------------------------------------------------

#adding header, tail and left border

s=$(printf "%-$((($maxcell * $col)+1))s" "=")

echo "${s// /-}" >> /tmp/table
echo "Full list of servers in environment" >> /tmp/table
echo "${s// /=}" >> /tmp/table
head -1 /tmp/tableA|expand >> /tmp/table
echo "${s// /=}" >> /tmp/table
tail -$(($rows -1)) /tmp/tableA >> /tmp/table
echo "${s// /=}" >> /tmp/table

#echo table with header, etc
logname=$(date +"%m-%d-%y")
cat /tmp/table >> list-$logname

echo "table entry has been created, see list-$logname"

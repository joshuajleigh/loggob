logs=( "/var/log/messages" "/var/log/secure" )
playpath=~/Repos/hubot-playbooks/inventory/ops/

for x in $( ls $playpath ); do
	for p in ${logs[@]}; do 
		ansible -b -v -i $playpath$x -m fetch -a "src=$p dest=." $1
	done
done

logs=( "/var/log/messages" "/var/log/secure" )
playpath=~/Repos/hubot-playbooks/inventory/ops/

#gathering logs for servers based on role or name
for p in ${logs[@]}; do
	ansible -b -v -i $playpath -m fetch -a "src=$p dest=." $1
done

apath=~/Repos/hubot-playbooks/inventory/ops/
LOG=$1
ENVS=$(ls $apath)
IP='[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'

# checks for cached coopy of file, if it doesn't exsist removes unwanted logs and DLs new
if [ ! -f /tmp/$LOG.fetchedlog ]
then
	rm /tmp/*.fetchedlog
	echo "caching local copy and removing other logs"
	for i in $ENVS; do
		ansible -i $apath$i -m shell -a "cat /var/log/messages|\
			grep -v 'Finished catalog\|deprecat\|freshclam\|imuxsock lost [0-9]\{2,3\} messages from pid'|\
			cut -d' ' -f5-|\
			sed 's/\[[0-9]\{3,7\}\]\|[0-9]\{6\}-\{1\}\|[a-z]\{2,3\}-[a-z]\{2,8\}[0-9]\{0,2\}\|\[[0-9]\{5,7\}\.[0-9]\{5,7\}\]\|ID=[0-9]\{1,5\}\|WINDOW=[0-9]\{3,7\}\|TTL=[0-9]\{2,4\}\|LEN=[0-9]\{2\}//g' |\
			more" $1 -b |\
			sed 's/SPT=[0-9]\{2,6\}//g'|\
			sed "s/SRC=$IP//g"|\
			sed "s/DST=$IP//g"|\
			sort|uniq -c|sort -rn|\
			sed 's/ \{2,\}/ /g'|\
			sed -e "1d" >> /tmp/$LOG.fetchedlog
	done
fi

less /tmp/$LOG.fetchedlog

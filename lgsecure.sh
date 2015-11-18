apath=~/Repos/hubot-playbooks/inventory/ops/
LOG=$1
ENVS=$(ls $apath)
# checks for cached coopy of file, if it doesn't exsist removes unwanted logs and DLs new
if [ ! -f /tmp/$LOG.fetchedseclog ]
then
	rm /tmp/*.fetchedseclog
	echo "caching local copy and removing other logs"
	for i in $ENVS; do
		ansible -i $apath$i -m shell -a "cat /var/log/secure|grep -v 'Finished catalog\|freshclam\|deprecat\|COMMAND'|cut -d' ' -f5-|sed 's/\[[0-9]\{3,7\}\]\|[0-9]\{0,6\}-\?[a-z]\{2,3\}-[a-z]\{2,8\}[0-9]\{0,2\}\|port [0-9]\{3,7\} ssh2//g' |\
			more" $1 -b |\
			sed -e "1d" |\
			sed -e 's/^[[:space:]]*//g'|\
			sort|uniq -c|sort -rn|more >> /tmp/$LOG.fetchedseclog
	done
fi

less /tmp/$LOG.fetchedseclog

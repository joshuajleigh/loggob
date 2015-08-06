#tool for gathering size of log files

logs=/var/log/messages-*

for i in ${servers[@]}; do
	ansible -b -v -i ~/Repos/hubot-playbooks/inventory/ops/rackspace -m shell -a "gzip -l /var/log/messages-*" all \
		| grep totals \
		| awk '{ SUM+= $2; print "total for messages on one server= " (($2/1048576))" M" } END { print "total for all servers= "((SUM/1073741824))" G" } END { print "average for log size= "(((SUM/21)/1048576))" M"}' \
		| more

done

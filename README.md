# loggob

log gathering tool built off of ansible

lfetch.sh - pulls /var/logs/messages and /ver/logs/secure from all servers in ansible group in all ansible enviroments

lclean.sh - clears out the locally DLed log files

ltable.sh - makes a nice table of the servers for a type and status for quicker reporting
  ex.
    sh ltable.sh webs
      or
    sh ltable.sh apps

lglist.sh - prints out a nice table of all the servers by environment

lgmessage - for a specific host pulls messages from /var/log/messages, sorts them and displays them in a more quickly understood manner. This command caches the result locally making subsequent uses much faster
  ex.
    sh lgmessage.sh rva-web01
      or
    sh lgmessage.sh rva-app01
      or further manipulated
    sh lgmessage.sh rva-app01 | grep -v "iptables" | less

lgsecure - same as lgmessage except with /var/log/secure
  ex.
    sh lgsecure.sh rva-web01
      or
    sh lgsecure.sh rva-app01
      or further manipulated
    sh lgsecure.sh rva-app01 | grep -v "sudo" | less

To Do:
  - create a config file to enable different ansible path

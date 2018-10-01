#!/usr/bin/fish

#########################
#                       #
# Backup Database Daily #
#                       #
#########################

set date_time (date +"%Y_%m_%d")
set file_name db_backup_"$date_time"
set store_path /{{ path_to_dest }}/"$file_name"
echo backup "$date_time" datatbase

set slack_webhook "{{ slack_webhook }}"

if mysqldump --defaults-extra-file=/{{ path_mysql_conf }}/mysqldump.cnf {{ db_name }} > $store_path
	chmod 600 $store_path
	echo finish backup to local

	if scp -q -o LogLevel=QUIET $store_path {{ backup-server }}:/{{ backup-server_path }}
		echo finish backup to backup server
		curl -X POST $slack_webhook -H "Content-Type: application/json" -d '{"attachments":[{"fallback":"Backup database success","pretext":"Backup database","color":"good","fields":[{"title":"Local","value":"success","short":false}, {"title":"Backup server","value":"success","short":false}]}]}'
	else
		echo fail backup to backup server
		curl -X POST $slack_webhook -H "Content-Type: application/json" -d '{"attachments":[{"fallback":"Backup database failure","pretext":"Backup database","color":"danger","fields":[{"title":"Local","value":"success","short":false},{"title":"Backup server","value":"failure","short":false}]}]}]}'
	end
else
	echo failed
	curl -X POST $slack_webhook -H "Content-Type: application/json" -d '{"attachments":[{"fallback":"Backup database failure","pretext":"Backup database","color":"danger","fields":[{"title":"Local","value":"failure","short":false}]}]}'
	exit 1
end

#########################
#                       #
# Remove Old Backup     #
#                       #
#########################

set now (date)
set old_date (date -d "$now - 7 day" +"%Y_%m_%d")
set old_file_name db_backup_"$old_date"
set old_store_path /{{ path_to_dest }}/"$old_file_name"
echo remove "$old_date" old backup datatbase
if rm $old_store_path 2> /dev/null
	echo finish
else
	echo failed
end

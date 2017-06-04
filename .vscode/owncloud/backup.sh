#!/bin/bash
#
# docker based owncloud backup script for database + triogger for maintenance mode
# Owncloud credentials read from instance directly, no local config necessary

oc_db_host="owncloud_db_1"
oc_instance_host="owncloud_owncloud_1"
oc_backup_dir="/var/lib/mysql/backup"

# set oc maintenance mode
setMaintenance () {

  switch=$1

  case $switch in
  off)
    docker exec -it $oc_instance_host occ maintenance:mode --off
    ;;
  on)
    docker exec -it $oc_instance_host occ maintenance:mode --on
    ;;
  esac
}

# backup MySQL DB
ocDbBackup () {
  oc_db_name=$(docker exec -it $oc_instance_host occ config:system:get dbname | tr -d '\r')
  oc_db_user=$(docker exec -it $oc_instance_host occ config:system:get dbuser | tr -d '\r')
  oc_db_pass=$(docker exec -it $oc_instance_host occ config:system:get dbpassword | tr -d '\r')

  setMaintenance on

  docker exec -ti $oc_db_host sh -c "mysqldump --single-transaction -u $oc_db_user -p$oc_db_pass $oc_db_name | gzip -9 > $oc_backup_dir/$oc_db_host-$oc_db_name-`date +"%Y%m%d"`.sql.gz" \
  && echo -n "MySQL backup in progress ..." && echo "...done." || echo ".error occured!"

  setMaintenance off
}

ocDbBackup
#!/usr/bin/env bash

set -x

project_name=iris-classification
project_dir=$(dirname $(readlink -f $0))
project_parent_dir=$(dirname $project_dir)
working_dir="$project_parent_dir/$project_name-working"
backup_dir="$project_parent_dir/$project_name-backup"
default_commit_msg="Still working..."

# push
function my_push() {
	rsync -avh --progress --delete-after $working_dir/ $backup_dir/ --exclude=/.git &&\
		cd $backup_dir &&\
		git add --all &&\
		git commit -a --allow-empty-message -m "$default_commit_msg" &&\
		git push
}

# pull
function my_pull() {
	cd $backup_dir &&\
		git pull origin master --rebase &&\
		rsync -avh --progress --delete-after $backup_dir/ $working_dir/ --exclude=/.git
}

# gst
function my_gst() {
	cd $backup_dir &&\
		git status
}

# continue-work
function my_continue_work() {
	if [[ ! -d $working_dir ]]; then
		mkdir -p -v $working_dir
	fi
	if [[ ! -d $backup_dir ]]; then
		mv -v $project_dir $backup_dir
	fi
	rsync -avh --progress --delete-after $backup_dir/ $working_dir/ --exclude=/.git
}

case "$1" in
	"push")
		my_push
		;;
	"pull")
		my_pull
		;;
	"gst")
		my_gst
		;;
	"continue-work")
		my_continue_work
		;;
	*)
		echo "Unknown argument: $1"
		;;
esac


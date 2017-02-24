#!/bin/bash
# Make sure we are up to date with the remotes
echo "deleteRemoteBranches [remote_name] [base_commit]"
echo "Fetch all remote branches."
git fetch --all

# Which remote? (default: origin)
REMOTE_REPO=${1:-'origin'}
# Which base commit? (default: HEAD)
BASE_COMMIT=${2:-'HEAD'}

echo "Base: $BASE_COMMIT, Remote: $REMOTE_REPO"

echo "Find the remote/$REMOTE_REPO branches already merged into $BASE_COMMIT."

# Get the list of merged remotes branches
MERGED_LIST=`git branch --remotes --merged $BASE_COMMIT | grep $REMOTE_REPO | cut -c $(expr 4 + ${#REMOTE_REPO})- | grep "^\(feature\|fix\)"`

echo "#########################################"
echo "${MERGED_LIST}"  | awk -v REMOTE_REPO="$REMOTE_REPO" '{print REMOTE_REPO"/"$1}'
echo "#########################################"

echo "Do you wish to delete these branches?"
select yn in "Yes" "No"; do
    case $yn in
        # Delete given branches name on remotes
        Yes ) break;;
        No ) exit;;
    esac
done

# Delete remote branches
git push -d "$REMOTE_REPO" `echo "${MERGED_LIST}" | awk '{print $1}'`

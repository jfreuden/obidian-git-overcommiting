#!/bin/bash
# For routine commits on `master`, cherry-pick all the changes by day as their own commits into default branch `develop`

# Get unique dates for commits on A not in main
for day in $(git log --reverse --date=short --pretty='%ad' main..master | sort -u); do
  echo "Processing $day"
  # cherry-pick all commits for that day without committing
  hashes=$(git log --reverse --pretty='%H' --since="$day 00:00" --until="$day 23:59" main..master)
  if [ -n "$hashes" ]; then
    echo "Cherry Pick"
    git cherry-pick -n $hashes --strategy ort -X theirs -m 1 || exit 1
    echo "Commit"
    GIT_AUTHOR_DATE="$day 23:59:00" GIT_COMMITTER_DATE="$day 23:59:00" git commit -m "Changes from branch master on $day" --date="$day 23:59:00" || exit 1
  fi
done


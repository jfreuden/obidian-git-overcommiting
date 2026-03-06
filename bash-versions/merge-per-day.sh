#!/bin/bash
# For routine commits on `master`, merge-commit them bulk by day into `develop`,
# then cherry-pick the merge commit into default branch `main`

old_branch=$(git branch --show-current)

for day in $(git log --reverse --date=short --pretty='%ad' develop..master | sort -u); do
  echo "Processing $day"
  # cherry-pick all commits for that day without committing
  hash=$(git log --pretty='%H' --since="$day 00:00" --until="$day 23:59" develop..master | head -n 1)
  if [ -n "$hash" ]; then
    echo "Checking out develop"
    git checkout develop

    echo "Merging from $hash"
    GIT_AUTHOR_DATE="$day 23:59:00" GIT_COMMITTER_DATE="$day 23:59:00" git merge --no-ff $hash -m "Changes from branch master on $day" || break

    echo "Checking out main, squashing from develop"
    git checkout main || break
    GIT_AUTHOR_DATE="$day 23:59:00" GIT_COMMITTER_DATE="$day 23:59:00" git cherry-pick develop --strategy ort -X theirs -m 1 || break
  fi
done

echo "Returning to $old_branch"
git checkout $old_branch

# Obsidian-git Overcommit Compress-o-matic

## Purpose

The `obsidian-git` plugin for Obsidian isn't just an excellent way to sync your vaults for free, it's also a way to visually represent the activity in your Second Brain via the commit history. However, an extremely active user will generate hundreds of commits per month, and that activity will overwhelm other activity in your GitHub (or CodeBerg) contribution graph.

The aim of this project is to find a middle ground between hiding your activity and losing the ability to track your progress and overrepresenting the contributions of your Obsidian notetaking.

## Approach

The approach is to compress the commit history by grouping commits into larger intervals, such as day-long, 4-hour-long, or hour-long intervals. This will allow users to see the overall activity trend without being overwhelmed by the sheer number of commits.

## How-To

To use this tool as-is, your obsidian-git repository will need to be configured a particular way. Either use that form or modify the code to suit your needs.

Particularly: the "default" branch of your repository will end up being the one that is compressed, but not the one where all of your devices will commit their changes to. This is critical not to get wrong, as you will end up destroying your vault and overwriting work if you do.

In my case (and what are the defaults are configured to), all devices are configured to commit to the `master` branch with their noisy commits. The script will then merge-commit without fast-forward into the `develop` branch according to the settings chosen for the tool. Finally, exclusively these merge commits will be cherry-picked into the official default `main` branch. Essentially:
- `master` is the "effective" but not "official" default branch
- `develop` is the intermediate branch between `master` and `main` **and will be deleted when changing parameters**
- `main` is the "official" default branch **and will be deleted when changing parameters**

All three branches must be present locally.

As noted above `master` will be the source where all your noisy commits come from. `develop` and `main` will be the target branches, and will be totally cleared and re-built when the parameters are changed. On the other hand, as long as the parameters are not changed, the script will merely update with changes from the last run forward.

Note: In certain edge-cases, a full reset and rerun may be desired, or even required. This can occur for a lot of reasons, usually a mistake in synchronization between devices/repos, or edge-cases in how the windows are determined.

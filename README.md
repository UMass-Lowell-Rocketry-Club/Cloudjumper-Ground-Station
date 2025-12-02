# Cloudjumper Ground Station

## Submodule Configuration

Before executing any commands, know that **a Git submodule is a specific commit from another repository**. This means that if a submodule has been updated, even cloning a new copy of the repository will not fetch changes to the submodule.

```bash
# Add Cloudjumper-Sensors as a submodule
git submodule add git@github.com:UMass-Lowell-Rocketry-Club/Cloudjumper-Sensors
# Commit submodule addition
git add -A
git commit -m "added Cloudjumper-Sensors submodule"
git push
```

After cloning a repository with a submodule, you must run `git submodule init` to initialize the local configuration file and then `git submodule update` to fetch all the data from the submodule's repository and check out the appropriate commit.

Alternatively, you can run add the `--recurse-submodules` flag to the `git clone` command to automatically run both the above commands.

You can update all submodules using `git submodule update --remote`, which updates the submodule to the `HEAD` commit of its repository. **Note that this does not update the main repository—this is considered a change that must be committed like all other changes.**

You can set the submodule to track a specific branch with `git config -f .gitmodules submodule.[submodule name].branch [branch name]`. This just adds `branch = [branch name]` to the module in `.gitmodules`.

Now, when you're working on the Ground Station normally, you'll probably want to edit the sensor code and push your changes. Because a Git submodule is just a specific commit by default, you can't do this normally. To fix this, you must go into the submodule with `cd [submodule name]` and switch to a specific branch with `git switch [branch name]`. The submodule is now checking out a specific branch, and you can commit and push any changes you make.

Pulling changes to a submodule is a problem though, since by default this will reset the submodule to the HEAD commit of the branch it's tracking. Supplying the `--merge` or `--rebase` flag to the `git submodule update --remote` call will force incoming commits to be merged or rebased, keeping the submodule on the branch it's checking out. This can be automatically applied for every submodule update with `git config -f .gitmodules submodule.Cloudjumper-Sensors.branch main`.

Also, by default pushing changes to the main repository will **not** push changes to submodules. You can always push your changes directly from the submodule directories, but if you want this to happen automatically you can update the configuration with `git config -f .gitmodules push.recurseSubmodules on-demand`, which automatically pushes any changes from all submodules before pushing changes to the main repository.

Finally, you can run `git config -f .gitmodules submodule.recurse true` to make any commands that can recurse submodules do it automatically. This is most useful for `git pull`, which will now update all submodules automatically.

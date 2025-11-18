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



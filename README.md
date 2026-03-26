# Cloudjumper Ground Station

## Downloading

If you just want to run the code, download this repository by navigating to wherever you want to store it and running the following command:

```bash
git clone --recurse-submodules https://github.com/UMass-Lowell-Rocketry-Club/Cloudjumper-Ground-Station.git
```

If you want to edit the repository, use this command instead:

```bash
git clone --recurse-submodules git@github.com:UMass-Lowell-Rocketry-Club/Cloudjumper-Ground-Station.git
```

If you want to edit the repository you should also read the [setup instructions](https://github.com/UMass-Lowell-Rocketry-Club/Cloudjumper-Sensors/blob/main/SUBMODULE%20MAINTENANCE.md#editing-submodules).

## Setting Up The Service

We use a `systemd` service to run the radio receiving program after boot. After pulling changes to this service, there are a few commands that need to be run:

```bash
# copy the config file to the correct location
sudo cp config_files/radio-receiver.service /etc/systemd/system
# tell systemd that the config file changed
sudo systemctl daemon-reload
# enable the radio-receiver service at startup
sudo systemctl enable radio-receiver
# start the radio-receiver service right now (optional)
sudo systemctl start radio-receiver
```

You can check the status of the service with `systemctl status radio-receiver`. If you need to, you can stop it with `systemctl stop radio-receiver`

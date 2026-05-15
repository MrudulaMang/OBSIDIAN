## include this 
	Restart=always
	RestartSec=5

journalctl -u runner -f -> for logs
--------------------------	
This is a systemd service file for running a self-hosted GitHub Actions runner as a background Linux service.
File is typically something like:
/etc/systemd/system/runner.service
It ensures the GitHub runner starts automatically after reboot and keeps running.

[Unit]Description=GitHub Actions RunnerAfter=network.target
[Unit]
Basic metadata about the service.


Description → human-readable name of the service
After=network.target → start this service only after network is available
Why?
Because the GitHub runner must connect to GitHub servers, so network must exist first.

[Service]Type=simpleUser=ec2-userWorkingDirectory=/home/ec2-user/actions-runnerExecStart=/home/ec2-user/actions-runner/run.shRestart=always
[Service]
This defines how the process runs.

Type=simple
Means systemd assumes the process starts immediately and keeps running in foreground.
No fork, no daemon mode.
Good for GitHub runner.

User=ec2-user
The runner runs as:
ec2-user
—not root.
This is correct because GitHub runners should usually not run as root unless necessary.

WorkingDirectory
/home/ec2-user/actions-runner
Before starting, systemd moves into this directory.
This is where the GitHub runner files exist.
Usually contains:
config.shrun.shsvc.sh.env

ExecStart
/home/ec2-user/actions-runner/run.sh
This is the actual command systemd executes.
It starts the GitHub runner process and waits for jobs.
This is the heart of the service.

Restart=always
Very important.
If runner crashes:


network issue


process failure


accidental kill


systemd automatically restarts it.
Without this, your runner silently dies.
Bad for production.

[Install]WantedBy=multi-user.target
[Install]
This controls boot startup.
multi-user.target means:
Start this service automatically during normal server boot.
Equivalent to “enable at startup.”
When you run:
sudo systemctl enable runner
systemd uses this section.

Real operational commands
After creating this file:
sudo systemctl daemon-reloadsudo systemctl enable runnersudo systemctl start runnersudo systemctl status runner

What your mentor is doing here
They are making the GitHub self-hosted runner production-safe.
Not just:
./run.sh
because that dies when terminal closes.
Instead:
systemd manages it permanently.
That is the correct professional setup.
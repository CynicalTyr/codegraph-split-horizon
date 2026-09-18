# Foreign mounts are not local graphs

We watched someone index a CIFS/NFS share of another machine and call it "the other box's CodeGraph." It was a slow, locked copy of someone else's disk. The graph belongs **on the host that edits the files**.

`findmnt -T ROOT` tells you the filesystem type. cifs, nfs, fuse.sshfs — refuse (exit 2). Local ext4/xfs/btrfs/tmpfs — proceed.

What this will not do: enumerate your LAN. The script has no hostnames.

Ten-minute outcome: `bin/refuse-mount.sh`. Point it at a local scratch dir (exit 0) and at a mount you know is foreign (exit 2) if you have one.

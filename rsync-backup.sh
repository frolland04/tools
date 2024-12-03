#!/bin/bash
set -aeux -o pipefail
sudo rsync -av --exclude={".cache",".config",".local",".mozilla",".vscode","Logiciels","VirtualBox VMs"} /home/frrol/ /media/frrol/ExterneLinux/Sauvegarde/home/frrol/

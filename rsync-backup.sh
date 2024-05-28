#!/bin/bash
set -aeux -o pipefail
sudo rsync -av --exclude={".cache",".local",".mozilla",".vscode","Logiciels"} /home/frrol/ /media/frrol/ExterneLinux/Sauvegarde/home/frrol/

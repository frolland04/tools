#!/bin/bash
set -aeux -o pipefail

OUTPUT_SYNC_DIR='/media/frrol/ExterneLinux/Sauvegarde/home/frrol/'
mkdir -p ${OUTPUT_SYNC_DIR}
sudo rsync -av --exclude={".cache",".config",".local",".mozilla",".vscode","Logiciels","VirtualBox VMs","","Téléchargements",".vagrant.d","snap"} /home/frrol/ ${OUTPUT_SYNC_DIR}

OUTPUT_SYNC_DIR='/media/frrol/ExterneLinux/Sauvegarde/data/git/'
mkdir -p ${OUTPUT_SYNC_DIR}
sudo rsync -av --exclude={"misc"} /data/git/ ${OUTPUT_SYNC_DIR}

OUTPUT_SYNC_DIR='/media/frrol/ExterneLinux/Sauvegarde/opt/apt-cacher-ng/'
mkdir -p ${OUTPUT_SYNC_DIR}
sudo rsync -av /opt/apt-cacher-ng/ ${OUTPUT_SYNC_DIR}

OUTPUT_SYNC_DIR='/media/frrol/ExterneLinux/Sauvegarde/opt/nagios/'
mkdir -p ${OUTPUT_SYNC_DIR}
sudo rsync -av /opt/nagios/ ${OUTPUT_SYNC_DIR}

OUTPUT_SYNC_DIR='/media/frrol/ExterneLinux/Sauvegarde/opt/harbor/'
mkdir -p ${OUTPUT_SYNC_DIR}
sudo rsync -av /opt/harbor/ ${OUTPUT_SYNC_DIR}

OUTPUT_SYNC_DIR='/media/frrol/ExterneLinux/Sauvegarde/opt/portainer/'
mkdir -p ${OUTPUT_SYNC_DIR}
sudo rsync -av /opt/portainer/ ${OUTPUT_SYNC_DIR}

set +x
echo ""
echo "Sync'ing OK."
echo ""
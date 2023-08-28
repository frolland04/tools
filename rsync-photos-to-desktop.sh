#!/bin/bash
rsync -av --dry-run /media/frrol/freebox/Photos/ /home/frrol/Bureau/Photos

# Note: there is a trailing slash on source dir to specify NOT to create similar dir onto destination


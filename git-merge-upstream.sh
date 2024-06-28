#!/bin/bash

# source branch is 'master'
git_project='test'
git_url_source='git@test:test.git'
git_branch_source='master'

# target branch is 'integration'
git_remote='sandbox'
git_url_target='git@test:sandbox.git'
git_branch_target='integration'

mkdir sync-git && \
cd sync-git && \
git clone ${git_url_source} --single-branch --branch=${git_url_source} --bare ${git_project} && \
cd ${git_project} && \
git remote add ${git_remote} ${git_url_target} && \
git branch --move ${git_branch_target} && \
git push ${git_remote} && \
git push ${git_remote} --tags

echo "Finished."

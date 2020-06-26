#!/bin/bash -e

touch /etc/bacula/mbsync.conf

if [ -d "${DOCKER_MBSYNC_DIR}" ]; then
    pushd "${DOCKER_MBSYNC_DIR}"
    for filename in *.conf; do
        account=${filename%.*}
        mkdir -p /var/backups/maildirs/$account

        echo "IMAPAccount $account" >> /etc/bacula/mbsync.conf
        cat "${DOCKER_MBSYNC_DIR}/$filename" >> /etc/bacula/mbsync.conf
        chmod 600 /etc/bacula/mbsync.conf

        echo "
IMAPStore master-$account-imap
Account $account

MaildirStore slave-$account-maildir
Path /var/backups/maildirs/$account/
Inbox /var/backups/maildirs/$account/INBOX
Flatten .

Channel backup-$account
Master :master-$account-imap:
Slave :slave-$account-maildir:
Patterns *
Create Slave
CopyArrivalDate yes
Sync Pull
SyncState *
" >> /etc/bacula/mbsync.conf
    done
    popd
fi

chmod 600 /etc/bacula/mbsync.conf

exit 0

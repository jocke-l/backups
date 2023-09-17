# A robust backup procedure

The overall goal is be able to backup your information safely and restore it
completely with minimal amount of information that you can remember without
writing it down. This will significantly increase your chances of restoring
your information in case of theft, robbery, accidents or catastrophies.

##  Redundant backups off-site

Information should be backed-up regularly to several off-site storage systems
using encrypted [borg](https://borgbackup.readthedocs.io/) repositories. Make
sure that you can restore all your information using the information you
already know or is readily available to you. For example you might have
separate repository that contains your password manager's database, using a
strong passphrase that you can remember, which can be used to further retreive
information from other repositories.

## Key keepers

In event that you completely lose all your information (including local
backups), you need to restore it from off-site, which you cannot do directly
since the keys you need to access it are lost too.

To mitigate the use of passphrase authentication to remote backups, you issue
special security-hardened emergency keys to individuals that you trust. Note
that these keys could also be placed at secure off-site locations that you have
physical access to. You may also choose to carry one with you at all times on
an encrypted device of your choosing.

The passphrase should be known only to you, and be somthing that you can
remember. This ensures that only you can access your backups, without any
additional information that you don't already know.

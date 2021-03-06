#!/bin/bash

touch _xfs_commands
>_xfs_commands

nespl boot.spl
echo load --os=primary $(readlink -f boot.xsm) >>_xfs_commands

nespl boot2.spl
echo load --os=secondary $(readlink -f boot2.xsm) >>_xfs_commands

expl program_idle.expl
echo load --idle $(readlink -f program_idle.xsm) >>_xfs_commands

expl program_login.expl
echo load --init $(readlink -f program_login.xsm) >>_xfs_commands

expl program_shell.expl
echo load --shell $(readlink -f program_shell.xsm) >>_xfs_commands

echo load --library $HOME/mynexpos/expl/library.lib >>_xfs_commands

nespl handler_exception.spl
echo load --exhandler $(readlink -f handler_exception.xsm) >>_xfs_commands

nespl handler_timer.spl
echo load --int=timer $(readlink -f handler_timer.xsm) >>_xfs_commands

nespl handler_console.spl
echo load --int=console $(readlink -f handler_console.xsm) >>_xfs_commands

nespl handler_disk.spl
echo load --int=disk $(readlink -f handler_disk.xsm) >>_xfs_commands

nespl handler_4.spl
echo load --int=4 $(readlink -f handler_4.xsm) >>_xfs_commands

nespl handler_5.spl
echo load --int=5 $(readlink -f handler_5.xsm) >>_xfs_commands

nespl handler_6.spl
echo load --int=6 $(readlink -f handler_6.xsm) >>_xfs_commands

nespl handler_7.spl
echo load --int=7 $(readlink -f handler_7.xsm) >>_xfs_commands

nespl handler_8.spl
echo load --int=8 $(readlink -f handler_8.xsm) >>_xfs_commands

nespl handler_9.spl
echo load --int=9 $(readlink -f handler_9.xsm) >>_xfs_commands

nespl handler_10.spl
echo load --int=10 $(readlink -f handler_10.xsm) >>_xfs_commands

nespl handler_11.spl
echo load --int=11 $(readlink -f handler_11.xsm) >>_xfs_commands

nespl handler_12.spl
echo load --int=12 $(readlink -f handler_12.xsm) >>_xfs_commands

nespl handler_13.spl
echo load --int=13 $(readlink -f handler_13.xsm) >>_xfs_commands

nespl handler_14.spl
echo load --int=14 $(readlink -f handler_14.xsm) >>_xfs_commands

nespl handler_15.spl
echo load --int=15 $(readlink -f handler_15.xsm) >>_xfs_commands

nespl handler_16.spl
echo load --int=16 $(readlink -f handler_16.xsm) >>_xfs_commands

nespl handler_17.spl
echo load --int=17 $(readlink -f handler_17.xsm) >>_xfs_commands

nespl module_resourcemgr.spl
echo load --module 0 $(readlink -f module_resourcemgr.xsm) >>_xfs_commands

nespl module_processmgr.spl
echo load --module 1 $(readlink -f module_processmgr.xsm) >>_xfs_commands

nespl module_memorymgr.spl
echo load --module 2 $(readlink -f module_memorymgr.xsm) >>_xfs_commands

nespl module_filemgr.spl
echo load --module 3 $(readlink -f module_filemgr.xsm) >>_xfs_commands

nespl module_devicemgr.spl
echo load --module 4 $(readlink -f module_devicemgr.xsm) >>_xfs_commands

nespl module_contextswitch.spl
echo load --module 5 $(readlink -f module_contextswitch.xsm) >>_xfs_commands

nespl module_pager.spl
echo load --module 6 $(readlink -f module_pager.xsm) >>_xfs_commands

nespl module_boot.spl
echo load --module 7 $(readlink -f module_boot.xsm) >>_xfs_commands

nespl module_accessctrl.spl
echo load --module 8 $(readlink -f module_accessctrl.xsm) >>_xfs_commands

# nespl assg_peterson/module_boot.spl
# echo load --module 7 $(readlink -f assg_peterson/module_boot.xsm) >>_xfs_commands

# nespl assg_peterson/module_accessctrl.spl
# echo load --module 8 $(readlink -f assg_peterson/module_accessctrl.xsm) >>_xfs_commands

nexfsif run _xfs_commands

rm *.xsm

#! /bin/sh

# Remove all php3~ files, produced by gvim
find .  -name "*php3~" -exec rm {} ';'

# Remove all html files, produced by gvim
# DO NOT use, because doc php ...
#find .  -name "*html" -exec rm {} ';'


---
title: Syncthing
lang: fr
tags: []
categories: []
---

```
    <folder id="rpeyronencfs" label="RPeyron-encfs" path="/mnt/synchro_rpeyron_encfs_st" type="sendonly" rescanIntervalS="3600" fsWatcherEnabled="false" fsWatcherDelayS="10" ignorePerms="false" autoNormalize="true">
        <filesystemType>basic</filesystemType>
        ...
        <markerName>uP-77qTZcu8WhCZGC8R2P1WI</markerName>
        ...
```
Discussion about input/output error not the same as readonly :
- syncthing point of view :  https://forum.syncthing.net/t/dir-on-read-only-filesystem-folder-stopped-because-of-missing-stignore/18237  and  https://github.com/syncthing/syncthing/issues/6171#issuecomment-557257895
- corresponding encfs open issue : https://github.com/vgough/encfs/issues/570
- where to patch to change input/output error to not exists: https://github.com/syncthing/syncthing/blob/634a3d0e3be4a706dfb58253da534e396cac714e/lib/fs/filesystem.go#L204

Workaround with mergerfs to add .stignore file and markerName changes to replace .stfolder

EDS List android app : https://f-droid.org/fr/packages/com.sovworks.edslite/

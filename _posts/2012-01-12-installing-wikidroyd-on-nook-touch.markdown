---
layout: post
date: 2012-01-12T17:45:00+00:00
title: Installing WikiDroid on Nook Touch
---

Offline wikipedia for Nook Touch was supposed to be my personal project
for Embedded Systems 3 course. However, one evening I started
investigation, and installed WikiDroyd successfully. How:

* Upgrade Nook Touch to 1.1
* TouchNooter 1.11.20 [nooter]
* Replace boot loader with wifi one, so you can access ADB 
* AppMarket does not seem to work. So download and install [wikidroyd] manually . Version 1.4.10 worked for me.
* Create the following file structure in /sdcard:

<pre>
/ # find /sdcard/WikiDroyd
/sdcard/WikiDroyd
/sdcard/WikiDroyd/en
/sdcard/WikiDroyd/en/file_infos.txt
/sdcard/WikiDroyd/en/lt.whole.wikidroyd
/sdcard/WikiDroyd/file_infos.txt
/sdcard/WikiDroyd/tmp
</pre>

file_infos.txt:

<pre>
filename,timestamp,size,md5sum,shorturl
ar.whole.wikidroyd,1288738800,170949632,65f0c107c03050c1e0c1c38324752316,http://books2.wikidroyd.com/bdkit8
ca.whole.wikidroyd,1288476000,385560576,e3305a0e704924f2efd5b639b5bf51c3,http://books3.wikidroyd.com/eb6xah
cs.whole.wikidroyd,1289257200,294767616,93f65728c69f518c74f74a6bf6a15020,http://books2.wikidroyd.com/a74qi6
da.whole.wikidroyd,1288652400,156098560,bfbff181de7260699fff2fe08e6ffe35,http://books2.wikidroyd.com/xib5zh
de.10%_most_read.wikidroyd,1286920800,501722112,25eac3a809e521734b4ea125aeabaf8b,http://books2.wikidroyd.com/d7i4uh
de.whole.wikidroyd,1286920800,2127689728,3871f4ad08f4c9a0b17ac4cc4323de37,http://books2.wikidroyd.com/e9zpz6
en.10%_most_read.wikidroyd,1286748000,1848722432,0798642b8ea8491512eb4e5cb550b63b,http://books2.wikidroyd.com/spixs5
en.whole-1-3.wikidroyd,1276418676,2118196224,8f5525cd0eb8fc1ae4a60991ac717160,http://books3.wikidroyd.com/r8ifkm
en.whole-2-3.wikidroyd,1276418741,2118159360,b9a74d5efdfdacbdcf2953783e3c5a6e,http://books3.wikidroyd.com/nkg3ki
en.whole-3-3.wikidroyd,1276418809,2109579264,59b6da9872cb0c6a2b207b9112544d29,http://books3.wikidroyd.com/udt7g7
eo.whole.wikidroyd,1289257200,118763520,4af3a711ff90cd5c6a7383cf7d446c79,http://books2.wikidroyd.com/td5s5z
es.whole.wikidroyd,1288911600,1197604864,e126d0d0bc4b60443fb4b0a934669333,http://books3.wikidroyd.com/84dmgq
fi.whole.wikidroyd,1288738800,321738752,6128fac490213d212962446dd3e5303d,http://books2.wikidroyd.com/9sa2me
fr.whole.wikidroyd,1288738800,1871736832,50842968eb50fc9422ab55c542b15ea1,http://books3.wikidroyd.com/ywyxcb
he.whole.wikidroyd,1289084400,225228800,1027eef844c9e37b12029463dcb1849f,http://books2.wikidroyd.com/kn5mby
hu.whole.wikidroyd,1289084400,374478848,076efcf2477d2a8514f6ad597f815e5c,http://books2.wikidroyd.com/4qcznp
id.whole.wikidroyd,1289084400,152918016,093c3fc61c31ca31d4f076c75ca7c7b5,http://books2.wikidroyd.com/g5r5h6
it.whole.wikidroyd,1288738800,1369921536,4641b751bd26c40b814687f3d2f437af,http://books3.wikidroyd.com/zcdr45
ja.whole.wikidroyd,1288652400,1751064576,733f48516651c8caca727deb7520e7a0,http://books3.wikidroyd.com/w89ep2
ko.whole.wikidroyd,1288825200,217603072,9a87c862ce963b7aa7e7d019d5427848,http://books2.wikidroyd.com/enrykj
lt.whole.wikidroyd,1289084400,113582080,b3d93b49196c2ad0f3eb2667a4ce9de3,http://books2.wikidroyd.com/heu5zc
ms.whole.wikidroyd,1289084400,72553472,addd870fec4837b8abff8d2edd625eea,http://books2.wikidroyd.com/8gx6ye
nl.whole.wikidroyd,1288566000,693029888,d45cf37d8186ae7fc43bd48ce98aca6f,http://books2.wikidroyd.com/pf4mg5
no.whole.wikidroyd,1288476000,295270400,be2f93d7916fe56853a4cfa3f2659631,http://books2.wikidroyd.com/84idwf
pl.whole.wikidroyd,1288566000,948410368,d50c749fa1bd464f4850556b4b59bb96,http://books3.wikidroyd.com/a2yqn4
pt.whole.wikidroyd,1288476000,748855296,68f785fca79118c45e8676be7302ed83,http://books3.wikidroyd.com/vun93z
ro.whole.wikidroyd,1289170800,168313856,23327504ee66f0adadc6da7483da727e,http://books2.wikidroyd.com/apqjyx
ru.whole.wikidroyd,1287784800,1308120064,0d4e57e6c4c294f5abe418b389a61bc3,http://books3.wikidroyd.com/kkhzkf
simple.whole.wikidroyd,1288825200,57327616,6b4c923e8b74e2303983589887859667,http://books2.wikidroyd.com/piw9yi
sk.whole.wikidroyd,1288566000,121936896,1bc3046508f2e04d2f47fd0647b9be5b,http://books2.wikidroyd.com/vun37s
sr.whole.wikidroyd,1288652400,168373248,a4f46190031f3b744de3c52b74d3fb6d,http://books2.wikidroyd.com/iu6n7r
sv.whole.wikidroyd,1288476000,395089920,2db36eeef2b3497589a6ca98bb66593c,http://books3.wikidroyd.com/ymkpxs
tr.whole.wikidroyd,1289084400,216014848,696a81e096f4b65e1d0782a9bd317ed3,http://books2.wikidroyd.com/7a3u6a
uk.whole.wikidroyd,1288825200,358979584,4b8dcaf7eb52f0488218f01816c8a9fe,http://books2.wikidroyd.com/qtcxa7
vi.whole.wikidroyd,1288476000,168049664,9dd572392fd001e9bfbb30e16a17cd9f,http://books2.wikidroyd.com/z464d4
zh.whole.wikidroyd,1289257200,510788608,3209de683ed79bb15aca6d7ab4f3b19a,http://books2.wikidroyd.com/nz9zrw
</pre>

I would suggest to install WikiDroyd on a phone, do the initialization there,
and copy the files to the sdcard.

Changing any setting seems to crash WikiDroyd for the future. Reinstalling the
application makes it work:

`adb uninstall com.osa.android.wikidroyd`

How to change font size without crashing the app for ever is left as an easy
exercise for the reader. Hint: you might want
[busybox]. :)

[busybox]: http://nookdevs.com/Busybox
[wikidroyd]: http://slideme.org/application/wikidroyd "Offline wikipedia reader for Android"
[rooting]: http://nookdevs.com/NookTouch_Rooting "NookTouch rooting"
[nooter]: http://forum.xda-developers.com/showthread.php?t=1343143 "TouchNooter"

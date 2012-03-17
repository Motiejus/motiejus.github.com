---
layout: post
date: 2012-03-17T14:35:00+00:00
title: Converting UK NPTDR data to GTFS
---

Took sime time to convert Glasgow Bus TXC to GTFS. I will show the problem and wat to tackle it:

     % ./tXCh2GT.sh ../GLA/ATCO_609_BUS.txc UTC 1 /tmp ../GLA/Stops.csv 
     transxchange2GTFS 1.7.4
     Please refer to LICENSE file for licensing information
     Exception in thread "main" java.lang.IndexOutOfBoundsException: Index: 44, Size: 1
     ...

Here is a work-around:

     diff --git a/TransxchangeTrips.java b/TransxchangeTrips.java
     index e104bb4..eafadaa 100755
     --- a/java/Transxchange2GoogleTransit/src/transxchange2GoogleTransitHandler/TransxchangeTrips.java
     +++ b/java/Transxchange2GoogleTransit/src/transxchange2GoogleTransitHandler/TransxchangeTrips.java
     @@ -225,7 +225,8 @@ public class TransxchangeTrips extends TransxchangeDataAspect {
        if (found) {
            // matching service found
            // generate service key specifically for current VehicleJourney
     -      handler.getCalendar().calendarDuplicateService(_serviceCode, _serviceCode + "_" + _vehicleJourneyCode + "@" + _departureTime);
     +      //handler.getCalendar().calendarDuplicateService(_serviceCode, _serviceCode + "_" + _vehicleJourneyCode + "@" + _departureTime);^M
            _serviceCode = _serviceCode + "_" + _vehicleJourneyCode + "@" + _departureTime;
            handler.getCalendarDates().calendarDatesRolloutOOLDates(_serviceCode);
        }

Then you will need a lot of RAM (for Glasgow busses 208 GB is not enough). To
tackle this, change all dates that are more than 5 years after now to whatever
is now + 2. The problem is that some bus timetables are valid until 2099-12-31,
which explains why it takes so much memory.

Lots of stops will not be there if you will use only Glasgow (region 609)... So
download full [UK stop data][1].

Then you will get some kind of `google_transit.zip`. And some tunings to the folder with txts':

{% highlight sh %}
#!/bin/sh

set -ex

# Fill agency.txt
awk -F, '{print $2","$2",http://example.org/"$2",UTC,en,1234"}' routes.txt | sort -u >> agency.txt

# Some station names have commas, remove them
perl -i -lne '@a = split (",", $_); print $. == 1? $_ : join(",", @a[0..2], join("_", @a[3..($#a-1)]), @a[$#a..$#a+2])' trips.txt

# No calendar dates for any service.. Force it
sed -i 's/,0/,1/g' calendar.txt

# Some routes have too early ending date
sed -i 's/20091231/20131231/' calendar.txt

# Remove routing exceptions which disables routes
sed -i '/2$/d' calendar_dates.txt

# Regenerate stops.txt with proper lat/lng
awk -F, '{print $1","$7",,"$5","$6",,"}' Stops.csv | sed 's/"//g' > stops.txt
sed -i '1s/.*/stop_id,stop_name,stop_desc,stop_lon,stop_lat,zone_id,stop_url/' stops.txt

# Remove 0000SPT stop_times, since these stops are not in Stops.csv
sed -i '/0000SPT[0-9]/d' stop_times.txt
{% endhighlight %}

And now you have a google_transit.zip which can be fed to Open Trip Planner! Enjoy!

[1]: http://nptdr.dft.gov.uk/October-2011/Single%20Zips/NaPTANcsv.zip

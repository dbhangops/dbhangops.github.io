---
layout: post
title: '#DBHangOps 10/16/14 -- MySQL SYS, Graphs, and more!'
categories:
- computing
- database
- debugging
- linux
- mysql
tags:
- '#DBHangOps'
- computing
- database
- HangOps
- linux
- mysql
- mysql_planet
status: publish
type: post
published: true
---
\#DBHangOps 10/16/14 -- MySQL SYS, Graphs, and more!
=========================================================

Hello everybody!

Join in \#DBHangOps this Thursday, **October, 16, 2014 at 11:00am pacific (18:00 GMT)**, to participate in the discussion about:

* ~~New in TokuDB 7.5~~ (rescheduled for next time!)
* MySQL SYS features and discussion -- what do you want to see in MySQL SYS?
* What graphs make a good dashboard?

You can check out the event page at https://plus.google.com/events/cml4a2uo9q77jr1pejste9pua1c on Thursday to participate.

As always, you can still watch the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Thursday as well.

See all of you on Thursday!


<iframe width="560" height="315" src="//www.youtube.com/embed/u_0VdVKxlbY" frameborder="0" allowfullscreen></iframe>


<a href="#show-notes">Show Notes</a>
==========

## What graphs make a good dashboard?
* Etsy uses ganglia to collect metrics and graphite to visualize their data and aggregates
	* 300-400 dashboards of graphs for various systems
	* Etsy deploys new code 20+ times a day, so deployment graphs help for this
* What type of graphs do you watch?
	* CPU utilization
	* Disk IO Wait
	* Command counters (SELECTs, UPDATEs, DELETES, INSERTs)
	* Innodb\_history\_list\_length -- this will help you find if there's large or long-running transactions in your system
	* temp tables on disk -- this is a big user of disk IO and CPU. You want to try and keep this down
	* table\_open\_cache
	* binlog\_cache\_disk\_usage
	* sort\_merge\_passes
	* rows\_read or rows\_changed in InnoDB
	* Handler counters -- The various handler counters can help indicate changes on the storage engine level
	* Long query counters
	* Idle transaction counters
* MySQL Enterprise Monitor (MEM) collects most of the above metrics automatically and provides feedback based on their values
	* MEM can also provide some trend monitoring and projections around future capacity based on usage (e.g. current disk usage rate and how long until you saturate your disk)
* What collects your metrics?
	* Etsy uses https://github.com/ganglia/gmond_python_modules/blob/master/mysqld/python_modules/mysql.py
	* Box's collectors can be seen in http://www.slideshare.net/geoffanderson/monitoring-mysql-with-opentsdb-19982758
* System-level metrics
	* CPU usage and idle
	* IO statistics
	* If you use FusionIO or other heavy SSD solutions, gather their metrics (e.g. heat sensors, block usage)
	* If you use spinning disks, collect metrics from SMART
* What granularity do you measure?
	* Average can cause some events to be lost.  Percentiles tends to give you better visibility into your system's overall performance (e.g. 95th percentile)
* What do you use to collect and view all your data?
	* Zabbix
	* Cacti
	* Ganglia
	* OpenTSDB
	* collectd
	* poor man monitoring

## MySQL SYS
* MySQL SYS is similar to Common Schema, but there's not a complete overlap
	* Common Schema is more focused around administering things and viewing system data
	* MySQL SYS is more focused on PERFORMANCE\_SCHEMA data and rolling it up for easy consumability
* What features do DBAs want to see?
	* Finding long transactions and killing them off
	* easily bubbling up the "worst queries" to evaluate (query time sum, execution sum, etc.)
		* tying CPU usage and IO information to bad queries so you can easily discover bad queries based on resource usage
	* Method to identify "badness" at a high-level (or across multiple nodes in a replication topology) and then be able to drill down quickly
	* CLI tools or views in MySQL SYS could help show high-level health of a node and then make it easy to find memory/IO/CPU problems happening


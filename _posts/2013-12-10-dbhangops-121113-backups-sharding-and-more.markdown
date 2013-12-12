---
layout: post
title: '#DBHangOps 12/11/13 -- Backups, Sharding, and more!'
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
\#DBHangOps 12/11/13 -- Backups, Sharding, and more!
=========================================================

Check out the recording below!

<iframe width="560" height="315" src="//www.youtube.com/embed/skksuiUODKk" frameborder="0" allowfullscreen></iframe>

Happy Holidays!

Participate in \#DBHangOps this Wednesday, **December, 11, 2013 at 12:00pm pacific (19:00 GMT)**, to discuss:

* Backups
	* How do you do them? How often?
	* How do you test your backups?
	* What backup tools would you suggest?
* Sharding
	* How do you deal with sharded database architectures?
	* What tools do you use for managing a sharded environment?
* How do you configure your application to talk to MySQL?
	* Do you use VIPs, DNS CNAMEs, hard-coded strings in a config file, or something else?
* ~~Load Balancers and MySQL~~
	* ~~What load balancers have you use with MySQL? Why?~~

Be sure to check out the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Wednesday!

See all of you on Wednesday!


---

<a name="show-notes">Show notes</a>
==========

## Backups ##

### How do you do them? ###
* LVM Snapshots
	* You should typically target doing this on slaves
	* Where do you put your snapshots once they're complete?
		* Have a dedicated backup slave that maintains more than 1 open snapshot so you can quickly rollback
		* Simply mounting the snapshots is costly, but easy for rollback.
	* Before taking the snapshots, you need to "FLUSH TABLES"
		* If you need to rebuild replicas, you'll need to do "FLUSH TABLE WITH READ LOCK" and collect master information
		* [Blog post by Peter on doing this](http://www.mysqlperformanceblog.com/2006/08/21/using-lvm-for-mysql-backup-and-replication-setup/)
* [Percona Xtrabackup](http://www.percona.com/software/percona-xtrabackup)
	* requires innobackupex to collect all MyISAM tables cleanly
	* Performing incrementals is pretty painless compared to other methods
	* Cool features:
		* throttling option to reduce IOPS on server
		* Streaming backups on the fly
* Recovering individual tables?
	* Doing off a physical backup gets interesting. You need to ensure the data dictionary of InnoDB syncs up with what's in the .ibd file
	* [Chris' blog](http://www.chriscalender.com/?tag=innodb-recovery) has good innodb recovery information.
* It's very important to have alerting on your backups!
	* Alert if a backup fails
	* Alert if a backup is not complete, restorable, etc.
* Long term storage
	* Amazon S3
	* Internal filer machines
* Tools
	* Zmanda Recovery Manager
	* good ol' shell scripts and cron!


## Sharding ##

### How do you deal with sharded architectures ###
* Horizontally or vertically?
	* Vertically is breaking up logical parts of the application into different databases
	* Horizontally is split the same functional data across multiple hosts

#### Horizontal Sharding considerations ####
* Need some way to map shards to physical servers
	* Hash-based 
		* simpler sharding method
		* less flexibility for moving shards around
		* Rehashing requires a full recopy of your dataset (expensive at scale)
	* Dynamic
		* Have a more dynamic system that simply stores a shard ID for a given sharded item
		* Slightly more complex and a little increased latency due to additional lookup
		* greater flexibilty for easily moving sharded data around since you can copy the data and update your mapping data store

## Application configuration ##

### What do you use? ###
* Hard-coded in a file that you push to all machines
	* YAML
	* INI-style
* DNS CNAMEs
	* Setup DNS CNAMEs to reference certain servers, cluters, and roles
		* e.g. have a CNAME for "mysql-master" local to each datacenter, but they all reference the master in a single DC
		* DNS can be responsible for providing local slave or closest slave to the application
	* Changing masters is as easy as pushing a DNS change
* Service discovery-based systems
	* [SkyDNS](https://github.com/skynetservices/skydns) can be used for an auto-discovery based DNS system.
	* [SmartStack](http://nerds.airbnb.com/smartstack-service-discovery-cloud/) allows for auto service discovery and registration

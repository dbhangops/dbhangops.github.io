---
layout: post
title: '#DBHangOps 04/16/14 -- PLMCE Learnings and Defending your DBs!'
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
\#DBHangOps 04/16/14 -- PLMCE Learnings and Defending your DBs!
=========================================================

Check out the recording below:

<iframe width="420" height="315" src="http://www.youtube.com/embed/Q0VsrYm6q9I" frameborder="0" allowfullscreen></iframe>

Hello everybody!

Join in \#DBHangOps this Wednesday, **April, 16, 2014 at 12:00pm pacific (19:00 GMT)**, to participate in the discussion about:

* Learnings from Percona Live MySQL Conference and Expo
* Defending your databases!

Be sure to check out the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Wednesday!

See all of you on Wednesday!


<a name="show-notes">Show notes</a>
===========

# Learnings from Percona Live MySQL Conference and Expo
* Particularly exciting/enjoyable talks
	* ChatOps by Sam Lambert -- https://speakerdeck.com/samlambert/chatops-how-github-manages-mysql
	* Devops @ Outbrain by Shlomi Noach -- http://www.slideshare.net/shlominoach/mysql-devops-at-outbrain
	* Asynchronous client by Facebook
	* GTID by facebook
* Announcements
	* Webscalesql -- http://webscalesql.org/
		* Pretty exciting to have a common upstream branch that major organizations are pushing changes and fixes into
* Take aways
	* Enabling GTIDs in an online cluster
		* Booking.com blogged about a small patch to mysql that allowed them to do it -- http://blog.booking.com/mysql-5.6-gtids-evaluation-and-online-migration.html


# Defending your Database
* How do you defend your database from your *own* services?
	* Killing connections based on thresholds
		* Long running queries
		* Long/large transactions
			* You can look at INFORMATION_SCHEMA.INNODB_LOCKS and INFORMATION_SCHEMA.INNODB_LOCK_WAITS to get information about locks by transaction.
		* Can use common_schema to get at information about transactions blocking each other -- http://common-schema.googlecode.com/svn/trunk/common_schema/doc/html/innodb_locked_transactions.html
* What are critical metrics to measure?
	* Slave availability for serving reads -- e.g. "7/10 slaves are available, we're okay"
		* Have slaves publish information to a service about their health (e.g. Zookeeper)
		* If a slave deems itself unhealthy, start throttling itself


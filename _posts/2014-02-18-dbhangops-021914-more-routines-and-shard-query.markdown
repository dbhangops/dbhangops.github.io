---
layout: post
title: '#DBHangOps 02/19/14 -- More Routines. More shard-query. More, more, more!'
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
\#DBHangOps 02/19/14 -- More Routines. More shard-query. More, more, more!
=========================================================


<iframe width="420" height="315" src="http://www.youtube.com/embed/ZJKtdKlOJd8" frameborder="0" allowfullscreen></iframe>

Hello everybody!

Join in \#DBHangOps this Wednesday, **February, 19, 2014 at 12:00pm pacific (20:00 GMT)**, to participate in the discussion about:

* Follow-up discussion on routines, functions, and trigger
* Justin Swanhart to demo more of shard-query and flexviews!

Be sure to check out the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Wednesday!

See all of you on Wednesday!


<a name="show-notes">Show notes</a>
==========

## Follow-up discussion on routines, functions, and trigger
* Testing
	* [STK/Unit](http://freecode.com/projects/stkunit) can help you debug and test stored routines
* Routines
	* Dynamic SQL can only be executed using the "PREPARE" clause
	* Downsides
		* stored routines can't create events
		* can't use load file, load data infile, can't create stored routines/triggers
* Events
	* Event scheduler in MySQL -- similar to crontab in Linux
	* Events can execute statements or stored routines automatically
	* can setup events that are "self-destructing" (delete the event when it's done)
	* each invocation of an event runs within its own thread
		* a dummy thread is created for each event that is executed
	* Uses
		* Dump status counters into a table whenever threads_running goes above a threshold (e.g. Emulating Oracle Stats pack)
			* have an event that collects I_S.global_status into a table on an interval
		* Auto-kill queries over a certain threshold -- http://www.markleith.co.uk/2011/05/31/finding-and-killing-long-running-innodb-transactions-with-events/
		* Re-balance partitions
		* Track "Replication Load Average" -- http://www.markleith.co.uk/2012/07/24/a-mysql-replication-load-average-with-performance-schema/
		* Rotate the slow query log -- http://swanhart.livejournal.com/135348.html
	* WARNING: Events replicate to slaves but are disabled by default -- http://datacharmer.blogspot.co.il/2009/03/something-to-know-about-event-scheduler.html

## Justin Swanhart's shard-query demo part 2


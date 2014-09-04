---
layout: post
title: '#DBHangOps 09/04/14 -- R-Tree Indexes, DBAs and Networking, and more!'
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
\#DBHangOps 09/04/14 -- R-Tree Indexes, DBAs and Networking, and more!
=========================================================

All set for this week. Check out the recording below:

<iframe width="420" height="315" src="http://www.youtube.com/embed/95QYLncWZI0" frameborder="0" allowfullscreen></iframe>

Hello everybody!

Join in \#DBHangOps this Thursday, **September, 04, 2014 at 11:00am pacific (18:00 GMT)**, to participate in the discussion about:

* ~~R-Tree index overview from Matt Lord~~
* Index Fragmentation (requested by Shlomi)
* What should a DBA know about networking?

Be sure to check out the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Thursday!

See all of you on Thursday!

<a name="show-notes">Show notes</a>
===========
## Index Fragmentation
* How do you handle index fragmentation? Should it handled at all?
	* Normally if you insert in PK order, the index won't fragment too much and page splits inside of innodb is pretty well spread (leaving the 1/16th empty space in a page)
* What about  inserting on secondary key order?  This can sometimes cause "weird" growth in innodb pages
* Percona (and MySQL 5.6) has the innodb_index_stats and fast index creation abilities which helps keeping this under control
* InnoDB has some interesting semantics around its page management.  It will make decisions to split and/or merge pages 
	* Facebook has dedicated some engineering resources into the page merging work
	* In InnoDB, pages are typically split into 2 even halves when a page fills up.  Merges are done typically when 2 adjacent pages are less then half full and can be merged to a more full page
* How does the performance of MySQL change when a page size is 4k vs. 16k?
	* The 15/16 fill rule is obviously very different base on page size
* Fragmentation can also happen inside of secondary indexes.  With "fast index creation", keys may not be inserted in order and could consume more disk space
	* Insert data in batch and then applying indexes afterwards will give you better index
* http://www.markleith.co.uk/2009/01/19/innodb-table-and-tablespace-monitors/
	* Native InnoDB Data Dictionary will hopefully replace the need for using tablespace monitors
* Facebook did a good talk on this too: https://www.percona.com/live/mysql-conference-2014/sites/default/files/slides/defragmentation.pdf 
* Jeremy Cole's innodb ruby tools have been supremely helpful in viewing usage of space 
	* You can see images of some outputs from these tools at https://github.com/jeremycole/innodb_diagrams/tree/master/images!
* Future thinking:
	* InnoDB File per table isn't necessary the panacea for all problems ( 
	* MySQL 5.7 brings in the ability to break up the ibdata file some more so you can have an UNDO tablespace, a TEMPORARY tablespace, etc.

# What should a DBA know about networking?
* tcpdump is the ultimate tool that a DBA should learn
	* understanding the basics of TCP flags and handshakes is very important for troubleshooting work that goes in and out of a server
	* In a world of flash and SSDs, it's possible you might start seeing your network IO getting backed up
		* This could manifest as query pile up and high %IOWait utilization on your server (but not high disk IO)
* ngrep -- amazing tool for watching mysql traffic and snipping traffic on the fly
	* You can use this to observe client-side database timeouts that don't necessarily make it into any mysql server logs
* iftop -- gives you 'top'-like view for network interfaces
* atop -- gives you a 'top'-like view and shows network utilization per ethernet device in addition
* "sar -n" allows you to see network and dropped packets on a server
* How can a DBA start to learn more of this stuff?
	* Take a look at Wireshark -- it'll give you a nice GUI and teach you basics of interacting with captured network traffic
	* Checkout out various blog posts online for using tcpdump with MySQL
		* http://jeremytinley.wordpress.com/2014/03/21/capturing-mysql-data-with-tcpdump/
* Anything to change in mysql?
	* backlog (and TCP backlog on your linux server) -- this is something you may want to tune if you have a high volume of connections coming into the server
		* failing to increase the backlog will cause clients to hit timeout errors or see slow connections
	* net_buffer_length -- If you're normally doing large queries or result sets (e.g. multi insert queries) this can help mysql pre-allocate more memory to send down the network pipe
		* Most web shops typically won't need to tune this, but it may help based on your workload (e.g. a data warehous)!


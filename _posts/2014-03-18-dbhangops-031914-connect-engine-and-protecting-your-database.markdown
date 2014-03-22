---
layout: post
title: '#DBHangOps 03/19/14 -- CONNECT Engine in MariaDB, Protecting your database, and more!'
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
\#DBHangOps 03/19/14 -- CONNECT Engine in MariaDB, Protecting your database, and more!
=========================================================

You can join the Google Hangout at http://bit.ly/1lPyLlv or watch the livestream below:

<iframe width="420" height="315" src="http://www.youtube.com/embed/HtzVU4L09LI" frameborder="0" allowfullscreen></iframe>

Hello everybody!

Join in \#DBHangOps this Wednesday, **March, 19, 2014 at 12:00pm pacific (20:00 GMT)**, to participate in the discussion about:

* CONNECT engine in MariaDB (from Gerry/Sheeri)
* How to protect your database
	* What tools do you employ?
	* What tips/tricks do you have?
* "Worst schema of the week"

Be sure to check out the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Wednesday!

See all of you on Wednesday!


<a name="show-notes">Show notes</a>
===========
## CONNECT Engine in MariaDB
* More information can be found at https://mariadb.com/blog/mariadb-10-connect-engine-better-way-access-external-data
* Can be used to setup tables that correlate to files on your file system. e.g.:
	* CSV -- you can specify different separators and index fields, too!
	* INI-style
	* XML files
* Some of its real strength comes with being able to do PIVOT table operations with data files on your system.
	* Caveat: you need networking enabled in MySQL in order to create a PIVOT table
* You can also do an "unpivot" table type
* Can be used to merge tables with different field counts.  E.g.:
	* You have a table with "who, what, amount" and another table with "who, what, week, amount". You can merge these into a new table with "who,what,amount"
	* When merging tables, there's a special field "SPECIAL='TABID'" which makes the CONNECT engine auto-populate the source table name into the new table
		* This can be valuable if you partition data across multiple tables (e.g. table_week1, table_week2, etc.)
* Allows for doing chopping of data in fields using XCOL -- https://mariadb.com/kb/en/connect-table-types-xcol-table-type/
	* E.g. a comma-separated list as a value of a given field can be broken up into individual records
	* This is extremely valuable for making GROUP BY and COUNT() operations in SQL possible
* There's another table_type for "DIR" that allows you to point a table at a directory on your filesystem -- https://mariadb.com/kb/en/connect-table-types-special-virtual-tables/#dir-type


## "Worst Schema of the Week"
* Check the video and discussion to hear more about it!

---
layout: post
title: '#DBHangOps 03/05/14 -- CONNECT storage engine, Indexing tips, and more!'
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
\#DBHangOps 03/05/14 -- Indexing tips and more!
=========================================================

Check out the recording below:

<iframe width="420" height="315" src="http://www.youtube.com/embed/1JV8bECorCE" frameborder="0" allowfullscreen></iframe>

Hello everybody!

Join in \#DBHangOps this Wednesday, **March, 05, 2014 at 12:00pm pacific (20:00 GMT)**, to participate in the discussion about:

* Indexing Tips, tricks, and best practices
	* Given a set of known queries, how do you best index for them?

Be sure to check out the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Wednesday!

See all of you on Wednesday!


<a name="show-notes">Show notes</a>
===========

## Indexing Tips, tricks, and best practices
* Great talk from Zardosht @ Tokutek about indexing -- https://www.youtube.com/watch?v=AVNjqgf7zNw
* http://use-the-index-luke.com/3-minute-test
* http://sqlfiddle.com/
* Compound indexes
	* Good example is your local phone book -- entries are sorted by surname, first name, and street address
	* In MySQL, an example compound index would be (surname, firstname, address)
* Index hinting
* Index merges/intersections -- if these are problematic, you can index hint these
* Optimizer switches: https://dev.mysql.com/doc/refman/5.6/en/switchable-optimizations.html
* In percona server 5.6.14, there's a query-level settings 
* ANALYZE table is important to ensure table statistics are up to date (but can be costly)
* Can also tune the number of "innodb page dives" to help make better query decisions
* MySQL 5.6 has persistent statistics which makes it more durable

* Query cost tells you how
	* MySQL 5.6 has optimizer trace
		* You can gauge the cost of different operations that the optimizer sees
		* Understand the cost of different operations in the query and why the optizmier makes a decision

* What about compiled explain plans? MySQL Doesn't have these (yet) but here's some things to look at:
	* http://www.percona.com/doc/percona-server/5.6/flexibility/per_query_variable_statement.html
	* http://dev.mysql.com/doc/refman/5.5/en/index-hints.html
	* https://www.google.com/search?q=mysql+5.6+optimizer+trace


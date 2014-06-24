---
layout: post
title: '#DBHangOps 06/12/14 -- MySQL Credential management and Gaps'
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
\#DBHangOps 06/12/14 -- MySQL Credential management and Gaps
============================================================

Check out the recording below!

<iframe width="420" height="315" src="http://www.youtube.com/embed/DBxV34V8uLU" frameborder="0" allowfullscreen></iframe>

Hello everybody!

Join in \#DBHangOps this Thursday, **June, 12, 2014 at 11:00am pacific (18:00 GMT)**, to participate in the discussion about:

* MySQL Credentials
	* How do you set them up?
	* How do you store them?
	* Who has access to them?
* Gaps -- When do you stop working on a specific task
	* How do you know when you've hit the "80/20" threshold?
	* What's a "sub-optimization"?
	* When are you "over-optimizing"?
	* When do you stop automating and accept manual process
		* What is important to automate in your environment?
* Recap of MySQL 5.7 features
* Overview of MySQL Central

Be sure to check out the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Thursday!

See all of you on Thursday!


<a name="show-notes">Show notes</a>
===========

## Credentials
* Credential management
	* You can use Common_schema to help disable and manage SQL accounts -- http://common-schema.googlecode.com/svn/trunk/common_schema/doc/html/sql_accounts.html
	* Good practice to effectively disable the root account except where it's need by events, triggers, etc.
	* Split your application's access to mysql across read/write accounts and read-only accounts (e.g. app_rw, app_ro).
		* This gives you finer grain control over monitoring and controling user accounts
	* MySQL doesn't have roles built-in the same way other DBMSs do (e.g. Oracle, SQL Server)
		* MariaDB added stored routines to do basic role-type management
		* A lot of people tend to build role-based logic/management in puppet/chef or other external systems
	* If you have  lots of explicilty defined privileges, you may need to be conscientious of the grant cache in MySQL
		* Any time you see a query in the "Checking permissions" state, it's going to the grant cache to check if it has access to do the work.
	* PROXY users might be a way to get at role-based type logic where you define an account and then defined PROXY accounts to this account
* Rotation
	* Password expiration comes in MySQL 5.6 so you can start having them automatically deactivate
		* This has been a requested feature since 2004! http://bugs.mysql.com/bug.php?id=6108
	* Good practice for rotating passwords is creating a new account and moving services over to it.
		* Using the user statistics plugin allows you to see if there's still connections on the server on the old account
		* MySQL 5.6 allows you to check for connections on a user account through PERFORMANCE_SCHEMA
* Security around credentials
	* At the end of the day, communication between mysql clients and servers is in plain text *unless* you enable SSL

## Gaps
* how do you know when you’ve hit the 80/20 threshold?
* when do you stop fixing every last checksum problem?
* what’s a “sub-optimization” (is it a problem and is it relevant?)
* when do you stop automating and accept the manual
* Good reads:
	* http://blog.hut8labs.com/speeding-up-your-eng-org-part-i.html!


## Semi Sync Replication in MySQL
Check out Morgan Tocker's blog post about semi-sync replication and its performacnce at http://www.tocker.ca/2014/06/05/semi-sync-replication-is-not-slow.html

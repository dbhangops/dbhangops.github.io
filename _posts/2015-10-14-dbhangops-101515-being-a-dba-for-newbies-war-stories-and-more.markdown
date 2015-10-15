---
layout: post
title: '#DBHangOps 10/15/15 -- Being a newbie DBA, War stories, and more!'
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
\#DBHangOps 10/15/15 -- Being a newbie DBA, War stories, and more!
=========================================================

Hello everybody!

Join in \#DBHangOps this Thursday, **October, 15, 2015 at 11:00am pacific (18:00 GMT)**, to participate in the discussion about:

* What advice and resources would you give a newbie DBA
* What's on your monitoring dashboard?
* War stories

You can check out the event page at https://plus.google.com/events/cm0vnu6enkekcf4e163d09tsm6o on Thursday to participate.

As always, you can still watch the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Thursday!

See all of you on Thursday!

You can catch a livestream at:

<iframe width="560" height="315" src="//www.youtube.com/embed/16MttbhxOrE" frameborder="0" allowfullscreen></iframe>


<a href="#show-notes" id="show-notes">Show Notes</a>
==========

## New DBA Advice and Resources
* Find some sort of training training course to go to for at least a day!
  * Great opportunity to ask a lot of questions and get shared experiences with other students/attendees
  * Oracle prepares and offers various training curriculums
    * Performance and Tuning training
* Read the High Performance MySQL book!
* A few high level approaches:
  * supply reading for the person
  * put them into a staging environment to start to learn
  * throw them into production with easier tasks and get started
    * E.g. moving some replication around for the first time
* Start messing around with MySQL Sandbox
* Find a nearby MySQL Meetup!
* A good way to learn things is to answer question on MySQL discussion forums
  * Also StackOverflow
  * #mysql on freenode
  * This is also a good medium to learn to be specific about things at certain times
    * E.g. 5 years ago, Full text indexes only worked in MyISAM.  People may be correcting posts that say that these days... :)
* A good order to learn things
  * Understanding backups
    * If the data isn't there...you won't have a job
    * Understand the reasons for backups and why
    * Figure out how the data is backed up and if it's backed up properly
    * Understand how to restore them
    * Backups are important because hardware fails *and* people and applications make "mistakes"
      * The wrong records may be changed in yoru dataset and you'll need the old version of that data
  * Replication
    * Understand how to bootstrap a read replica
    * Understand how to move replication
  * Performance and Tuning
    * Understanding how queries work and how data is fetched
    * Understanding how JOINS and subqueries work
    * Getting familiar with the queries working in your schema (use pt-query-digest, PERFORMANCE_SCHEMA, etc.)
* How important is normalization?
  * Having a good foundational knowledge of this informs decisions on reducing data size and making performant access to data
  * Understanding where referential integrity needs to be managed
  * A DBA should be familiar with 1NF, 2NF, and 3NF.  Beyond that it starts to get academic and not as performant.
* Open planet.mysql.com and check out some of the blog posts there
  * This might be a little noisy, but always worth a look
* MySQL 101 track at Percona Live was started last year
  * Very good set of sessions for beginners to participate in


## War Stories
* Accidentally dropped a column instead of an Index....woops!
* Accidentally changed the Linux user ID of the MySQL data directory while mysql was running....woops!
* Trying to hot swap an active master in a Master<->Master setup
  * Added another master to make a circular replication ring
  * Pulled out the old server and wrapped up for the night
  * Next morning it appeared that a server_id from a server not in the replication topology was looping between the 2 active masters
    * These statements replicated for a few hours over and over
    * The statement was incrementing in-game currency for a player infinitely... :)
* A field was an unsigned int and some code kept decrementing until the data went from 0 to a max int
  * Suffice to say...the leaderboard this field populated looked very weird the next day
* Cloned a read replica with the same server_id


<a href="#links" id="links">Links of supreme interest!</a>
==========================
* Awesome slide deck on query optimization - https://github.com/jynus/query-optimization
* [MySQL Community Reception at Oracle OpenWorld](http://www.tocker.ca/2015/10/06/mysql-community-reception-at-oracle-openworld.html)
* Find auto increment columns -- https://github.com/MarkLeith/mysql-sys/blob/master/views/i_s/schema_auto_increment_columns.sql


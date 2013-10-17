---
layout: post
title: '#DBHangOps 10/16/13 -- Resource Management, Compliance, and more!'
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
\#DBHangOps 10/16/13 -- Resource Management, Compliance, and more
=================================================================

This weeks \#DBHangOps is a wrap. Check out the recording below:

<iframe width="560" height="315" src="//www.youtube.com/embed/SjsHsnghNCk" frameborder="0" allowfullscreen="allowfullscreen"> </iframe>

Hello everyone!

This Wednesday, **October 16th, 2013 at 12:00pm pacific (19:00 GMT)**, \#DBHangOps is coming up with discussion on:

* How do you constrain over-consumption of resources by competing applications?
* Network vs. Local storage for MySQL
    * How do you use this for HA? Do you use DRBD or floating VIPs?
* Secure connections to MySQL (using SSL) (requested by Daniel)
    * Do you have experience with this? What's the performance impact?
* PCI Certification with MySQL -- what changed for you?
* ~~MySQL-isms!~~
	* ~~(From Gerry) Sub SELECTs -- Why aren't these as mature as other databases?~~
	* ~~(From Daniel) GROUP_CONCAT and other OLAP Style query functions -- Why doesn't MySQL have them?~~
	* ~~(From Gerry) MySQL DBAs are used to building covering indexes to avoid PK lookups -- Is there a plan for this to change?~~

Be sure to check out the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Wednesday!

See all of you on Wednesday!


---

<a name="show-notes">Show notes</a>
==========

### How do you constrain over-consumption of resources by competing applications? ###
* For starters, you'll need to know if over-consumption by a single user is happening!
	* user_statistics will be you best friend when trying to gauge resource consumption -- [https://mariadb.com/kb/en/user-statistics/](https://mariadb.com/kb/en/user-statistics/)
		* Allows you to see information on a per-user basis for CPU time, connection counts, bytes read/written, command counters, etc.
* If you're running MyISAM, you might be able to get away with overcommitting on memory and allowing filesystem caches to take care of things for you
	* Can dynamically tune MyISAM key buffers (InnoDB buffer pool changes require a restart)
* You can functionally partition databases onto new machines to free up resources on a particularly busy machine

### Network vs. Local storage for MySQL ###
* TL;DR -- DBAs prefer local storage for simplifying debugging, reducing failure scenarios, and because databases are typically bottlenecked on I/O
* Shared storage - issues with accessing any of the data files can leave mysql in weird states
	* **NFS is a baaaaad idea because of file locking and periodic issues.** 
		* If MySQL can't see, lock, or perform other common file operations on it's datafiles (which can be spotty at times over NFS), it'll get very upset.
	* "One of the main challenges in dealing with shared storage is that concurrency and tenant management is incredibly difficult" -- John Cesario
* Amazon Web Services
	* All IO on AWS is shared
	* You can pay for "Provisioned IOPS" to get a dedicated amount of IO ("It's kind of like 'Express Pass' at Disney..")
* Percona put together a whitepaper about commonly encountered MySQL issues for their customers.  SAN issues were the second highest storage issue.
	* [http://www.percona.com/about-us/mysql-white-paper/causes-of-downtime-in-production-mysql-servers](http://www.percona.com/about-us/mysql-white-paper/causes-of-downtime-in-production-mysql-servers)

### Secure connections to MySQL (using SSL) (requested by Daniel) ###
* Percona posted a blog to illustrate some performance numbers with SSL enabled at [http://www.mysqlperformanceblog.com/2013/10/10/mysql-ssl-performance-overhead/](http://www.mysqlperformanceblog.com/2013/10/10/mysql-ssl-performance-overhead/)
	* The SSL handshake per-connection can really impacts the total QPS you can get
* Checkout Sheeri's presentation on setting up SSL for MySQL replication at [http://technocation.org/files/doc/2009_04_secure_rep.pdf](http://technocation.org/files/doc/2009_04_secure_rep.pdf)
	* You may want to avoid using certificates for your 'root' user (just to be safe! :))

### PCI Certification with MySQL -- what changed for you? ###
* User Auditing was required -- Need to know what a user changes
	* You'll need to have an audit plugin (the MySQL Security module isn't 100% solid for PCI)
	* You may need to write your own plugin to address compliance concerns. Performance hits may come with this.
* Encrypting data at the application level is a must
* PCI compliance adds an extreme amount of overhead to the development lifecycle


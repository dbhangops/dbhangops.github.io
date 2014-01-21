---
layout: post
title: '#DBHangOps 01/08/14 -- Sharding (part 2), Load balancing, and more!'
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
\#DBHangOps 01/08/14 -- Sharding (part 2), Load balancing, and more!
=========================================================

Thanks for watching. You can catch the recording below!

<iframe width="560" height="315" src="//www.youtube.com/embed/tbHYcNBlofk" frameborder="0" allowfullscreen></iframe>



Hello everybody!

Join in \#DBHangOps this Wednesday, **January, 08, 2014 at 12:00pm pacific (19:00 GMT)**, to participate in the discussion about:

* Sharding (part 2)
	* Horizontal vs. Vertical -- When do you choose to do one? How do you plan for this?
* Load balancing and MySQL -- What do you use for load balancing (hardware or software)?
	* How does this influence your application configuration?
	* Best practices for load balancers and MySQL


Be sure to check out the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Wednesday!

See all of you on Wednesday!


<a name="show-notes">Show notes</a>
==========
* Sharding
	* Vertical sharding is a logical way to separate data for different applications
	* Some example vendor products to solve the "sharding" problem
		* http://dbshards.com/ -- Product's been around for awhile
		* http://www.scalebase.com/
		* http://spiderformysql.com/
* Load balancing
	* HAProxy (software) can be used to load balance -- http://haproxy.1wt.eu/
		* You specify a group of servers to be used (e.g. here's my MySQL slaves)
			* or multiple groups (pools) of servers
		* Will periodically poll servers it's told to balance to.
			* Expcects an HTTP 200 from the servers to indicate that it's "healthy"
			* You'd need a simple HTTP daemon to healthcheck your databases.
		* By default, HAProxy does round-robin connecting
		* Will try to maintain stickiness
		* Can specify "weights" for hosts so that more requests are directed to certain machines
		* downside is that MySQL will only see connections coming from HAProxy, not the original client
	* Riverbed Stingray (hardware) load balancer -- http://www.riverbed.com/products-solutions/products/application-delivery-stingray/Stingray-Traffic-Manager.html
		* specify different handlers for reads or writes
		* Does healthchecking to identify if a service is up or down
	* Maxscale (software) mysql proxy from SkySQL -- https://github.com/skysql/maxscale
	* Connector/J (Java MySQL connector for Java) supports round-robin connection pooling -- http://dev.mysql.com/downloads/connector/j/



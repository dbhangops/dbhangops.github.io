---
layout: post
title: '#DBHangOps 08/07/14 -- Spatial Indexes, GTID, and more!'
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
\#DBHangOps 08/07/14 -- Spatial Indexes, GTID, and more!
=========================================================

If you missed the hangout, check out the recording below:

<iframe width="420" height="315" src="http://www.youtube.com/embed/g8BJt9b5idA" frameborder="0" allowfullscreen></iframe>

Hello everybody!

Join us at \#DBHangOps this Thursday, **August, 07, 2014 at 11:00am pacific (18:00 GMT)**, to participate in the discussion about:

* Spatial Indexes with Matt Lord
	* What they are
	* How they work
	* When to use them
* GTIDs in MariaDB
* Upcoming InnoDB Data Dictionary changes

Be sure to check out the [\#DBHangOps twitter search](https://twitter.com/search/realtime?q=%23DBHangOps), the [@DBHangOps](https://twitter.com/dbhangops) twitter feed, or this blog post to get a link for the google hangout on Thursday!

See all of you on Thursday!

<a name="show-notes">Show notes</a>
===========

## Spatial Indexes
* http://en.wikipedia.org/wiki/R-tree covers a good example of R-Trees which are used to store SPATIAL index data
* Spatial data is typically thought of in GIS contexts for dealing with Map data of the earth, but it can be used for all types of data
	* See http://en.wikipedia.org/wiki/Spatial_reference_system for some more information and examples!
* You would use this to store "spatial attributes" of points (e.g. a park on a map, a building, etc.)
* Effectively running range queries that finds geometries that fit in a bounding box
* MySQL 5.7 will be bringing in spatial index support for InnoDB!
	* Prior to MySQL 5.7 you either had to use MyISAM or accept no indexing in InnoDB

### Additional Spatial Querying/Indexing Resources:
* Matt will be giving a more in-depth Webinar on this stuff on August 20th, 2014! -- http://www.mysql.com/news-and-events/web-seminars/geographic-information-systems-gis-in-mysql-5-7-for-web-mobile-applications/
* Be sure to check out Matt Lord's blog post on using GIS functions at http://mysqlserverteam.com/mysql-5-7-and-gis-an-example/
* Also a great OurSQL podcast about spatial indexes and querying -- http://www.technocation.org/content/oursql-episode-183-map-our-way-around
* Also check out https://mariadb.com/blog/nodejs-mariadb-and-gis which gives some real life examples of writing an application using spatial data!
* Importing Raster data into MySQL 5.7 -- http://mysqlserverteam.com/importing-raster-based-spatial-data-into-mysql-5-7/
* Another example of using geo-spatial data with python -- https://mariadb.com/blog/greenelk-representing-geodata-and-around-python


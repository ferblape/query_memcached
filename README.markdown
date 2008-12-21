# QueryMemcached

<http://github.com/ferblape/query_memcached>

## Install

In the root directory of your project:

    script/plugin install git://github.com/ferblape/query_memcached.git

If you want to install it like a git module you can follow this post, adapting the URLs to this plugin:

<http://woss.name/2008/04/09/using-git-submodules-to-track-vendorrails/>

## Requirements

  - Ruby >= 1.8.4
  
  - Rails >= 2.1
  
  - memcache-client gem (maybe it will work also in memcached gem by fauna, but I haven't tested it yet)
  
  - MySQL or PostgreSQL

## Description

This plugin tries to replace ActiveRecord query_cache, adding a Memcache layer for persistence of the query's cache between requests. 

It is, instead of saving all the SQL query's results in memory each request you save them into Memcached, so you have them all the time.

For expiring this cache, each Memcached key contains a sum of all the version numbers of the tables involved in the query. If one of that tables is modified, then the version number for that table is increased.

For example, the query below involves the table _items_ and the table _places_:

    SELECT * from items INNER JOIN places ON places.item_id = item.id WHERE (item.created_at >= '2008-02-02 00:00:00')
    
So, the version for the cache of that query will be the sum of the cache version of the table _items_ and the cache version of the table _places_.

The idea behind this is way of create and expire cache was inspired by the post [The Secret to Memcached](http://blog.leetsoft.com/2007/5/22/the-secret-to-memcached) by Tobias Lütke.

For this plugin to work it's supposed that your ActionController cache store configured is `mem_cache_store`.

I changed the behavior in one major way.  I made the memcaching of the QueryCache optional.  

You need to add `_enable_memache_querycache_` to your AcitveRecord model, like so:

<code>
  class User < ActiveRecord::Base
    enable_memcache_querycache
  end
</code>

The reason for this (drastic) change is two fold:

  - For starters, there are many tables where trying to cache the contents but expiring all caching on any insert/update/delete/drop/alter on the table causes unnecessary overhead.  A sessions table is a perfect example.  I also have a metrics table and a few other tables where the contents are changed _often_.  By not enabling memcache on tables that I know will constantly be changing I can save quite a number of needless memcache calls (not caching the session queries saves two reads and two writes per request).
  
  - The other reason is I don't quite trust the implications of having a persisted query cache.  I want to carefully roll it out, starting with just the few models that rarely change, and go from there.  I'm not worried about users seeing information they shouldn't be, as the key is the query; it is more about making sure things expire correctly.  I didn't want to push such a large caching change into my app without a careful (and long) rollout.

## Known issues

  - You can get race conditions in the version keys of tables stored in Memcached
  
## Running plugin tests

The tests of this plugin are not so standard so I decided to wrote a very explicative instructions in a file apart named RUNNING_TESTS

## TODO

There is a list of pending features, bugs, and so on in a file named TODO.

Any comments and suggestions are welcome.

## Another comments

It's so easy to adapt the plugin for Rails version 2.0.2 if you change the cache variable for another instantiated with the memcache-client.

Also, it is possible to run in Rails >= 1.2.4 if you change the plugin [query_cache](http://agilewebdevelopment.com/plugins/query_cache) with the changes of query_memcached.

## Special Thanks

  - Raul Murciano <http://raul.murciano.net/> for helping to adapt the plugin to Rails 2.1
  
  - methodmissing <http://blog.methodmissing.com/> for some fresh ideas, lock library and correct some mistakes
  
  - skippy <http://github.com/skippy> for a lot of work deleting and cleaning methods, and also doing this plugin optional to each model

Copyright (c) 2008 [Fernando Blat](http://www.inwebwetrust.net), released under the MIT license

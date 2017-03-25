#!/bin/bash

# Finding all httpdocs
test -e /tmp/httpdocs_vhosts || find /var/www/vhosts/ -type d -name "httpdocs" > /tmp/httpdocs_vhosts 


time while read -r httpdocs; do
	#Define username used for chowning
	user=$(ls -l $(echo "$httpdocs" | sed -e 's/\/httpdocs//') | grep httpdocs | awk '{print $3}')
	#Define location for the robots.txt to append
	location=$(echo $httpdocs | sed -e 's/\/httpdocs/\/httpdocs\/robots.txt/')
	#Append the robots.txt file
	cat <<- ROBOTS > "$location"
		#
		# robots.txt
		#
		# This file is to prevent the crawling and indexing of certain parts
		# of your site by web crawlers and spiders run by sites like Yahoo!
		# and Google. By telling these "robots" where not to go on your site,
		# you save bandwidth and server resources.
		#
		# This file will be ignored unless it is at the root of your host:
		# Used:    http://example.com/robots.txt
		# Ignored: http://example.com/site/robots.txt
		#
		# For more information about the robots.txt standard, see:
		# http://www.robotstxt.org/wc/robots.html
		#
		# For syntax checking, see:
		# http://www.sxw.org.uk/computing/robots/check.html
		
		# disallow all 
		User-agent: *
		Disallow: /
		Crawl-delay: 600
		
		# but allow only important bots
		User-agent: Googlebot
		User-agent: Googlebot-Image
		User-agent: Mediapartners-Google
		User-agent: msnbot
		User-agent: msnbot-media
		User-agent: Slurp
		User-agent: Yahoo-Blogs
		User-agent: Yahoo-MMCrawler
		# Directories
		Disallow: /includes/
		Disallow: /misc/
		Disallow: /modules/
		Disallow: /profiles/
		Disallow: /scripts/
		Disallow: /sites/
		Disallow: /themes/
		# Files
		Disallow: /CHANGELOG.txt
		Disallow: /cron.php
		Disallow: /INSTALL.mysql.txt
		Disallow: /INSTALL.pgsql.txt
		Disallow: /install.php
		Disallow: /INSTALL.txt
		Disallow: /LICENSE.txt
		Disallow: /MAINTAINERS.txt
		Disallow: /update.php
		Disallow: /UPGRADE.txt
		Disallow: /xmlrpc.php
		# Paths (clean URLs)
		Disallow: /admin/
		Disallow: /comment/reply/
		Disallow: /contact/
		Disallow: /logout/
		Disallow: /node/add/
		Disallow: /search/
		Disallow: /opensearch/
		Disallow: /user/register/
		Disallow: /user/password/
		Disallow: /user/login/
		# Paths (no clean URLs)
		Disallow: /?q=admin/
		Disallow: /?q=comment/reply/
		Disallow: /?q=contact/
		Disallow: /?q=logout/
		Disallow: /?q=node/add/
		Disallow: /?q=search/
		Disallow: /?q=user/password/
		Disallow: /?q=user/register/
		Disallow: /?q=user/login/
		Crawl-delay: 600
	ROBOTS
 	
	chown "$user":psaserv "$location"
	echo -e "\e[92m[Succesfully appeneded robots.txt for $user"
	
done < /tmp/httpdocs_vhosts



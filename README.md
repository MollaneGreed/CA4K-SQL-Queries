# Overview
This is a collection of SQL queries designed to be used with CA4K to collect information to better support the application via direct queries to the SQL database.

# How to Use
Each query has been configured to have a set of variables at the top that must be set before the query can be run.

# Notes
Our company has altered the way the SQL databases are created and managed by CA4K. Specifically, instead of having an ever increasing number of databases with archive events, they are all consolodated into an 'Archive' and 'Archive_2' database which makes both managing them and running queries much simplier than normal.

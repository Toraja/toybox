---
syntax: markdown
---

# CLI

`psql` is the PostgreSQL terminal interface. The following commands were tested on version 9.5.
Connection options:
`-U` username (if not specified current OS user is used).
`-p` port.
`-h` server hostname/address.

## Connect to a specific database:
```sh
psql -U <username> -h <host> -d <database>
```

## Get databases on a server:
```sh
psql -U <username> -h <host> --list
```

## Execute sql query and save output to file:
```sh
psql -U <username> -d <database> -c 'select * from tableName;' -o <outfile>
```

## Execute query and get tabular html output:
```sh
psql -U <username> -d <database> -H -c 'select * from tableName;'
```

## Execute query and save resulting rows to csv file:
(if column names in the first row are not needed, remove the word 'header')
```sh
psql -U <username> -d <database> -c 'copy (select * from tableName) to stdout with csv header;' -o <outfile>
```

## Read commands from file:
```sh
psql -f <outfile>
```

## Restore databases from file:
```sh
psql -f <outfile> <username>
```

# Posgtres Command Prompt

## List databases
```
\l
```

## Change database
```
\c
```

## Show tables
```
\dt
```

## Describe table (`+` for extra info)
```
\d[+] <table>
```

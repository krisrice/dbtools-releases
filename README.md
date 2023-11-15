# Oracle DB Tools Utilities

## SQLcl

`sql` is a helper bash function for launching versions of sqlcl or always the latest version. This can be sourced into the current shell to load the helper.

To source into your shell directly from the repo.
```
. <(curl -s https://raw.githubusercontent.com/krisrice/dbtools-releases/main/sql)
```

`sql` run with no extra arguments will always load the most current released version.

`🤷 Available Versions:` will list versions at the start of the tool.

The optional argument of `-r [version]` will automatically download and stage that version if not already downloaded. Then launch that specific version.

### Example: SQLcl version 21.4.1 

``` 
sql -r 21.4.1  klrice/klrice@//localhost:1521/klr
Trying Version: 21.4.1
🤷 Available Versions:
"latest"
"23.3.0"
"23.2.0"
"23.1.0"
"22.4.0"
"22.2.0"
"22.1.1"
"22.1.0"
"21.4.1"
"21.4.0"
"21.3.3"
"21.3.2"
"21.3.0"
"21.2.0"
🔄 Checking SQLcl version...21.4.1 https://download.oracle.com/otn_software/java/sqldeveloper/sqlcl-21.4.1.17.1458.zip
⬇️  Downloading 21.4.1 SQLcl...
🧹 Removing old SQLcl
🗜️  Unzipping latest SQLcl to /tmp/sqlcl/21.4.1/
STAGED AT : /tmp/sqlcl/21.4.1/
🚀 Launching SQLcl...


SQLcl: Release 21.4 Production on Wed Nov 15 10:03:36 2023

Copyright (c) 1982, 2023, Oracle.  All rights reserved.

Last Successful login time: Wed Nov 15 2023 10:03:36 -05:00

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.19.0.0.0

SQL> 
```


### Files 

| File               | Description                  |
|--------------------|------------------------------|
| [sql](./sql)       | Bash script alias that can be sourced to always download and use the latest SQLcl. |
| [sql.sh](./sql.sh) | Bash script for always downloading and using the latest SQLcl. |


## ORDS

[[ coming soon...... ]]
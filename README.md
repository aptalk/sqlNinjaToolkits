
# sqlNinjaToolkits - A Tiny Treasure Trove of SQL Sorcery
![Static Badge](https://img.shields.io/badge/sql-geek-blue)


Just a small—but mighty—selection of queries and scripts that’ll make your SQL Server bow to your every admin whim. Whether you're taming rogue indexes, interrogating your database like it's on trial, or just trying to remember that one command you always Google—this stash has your back. Use wisely, laugh occasionally, and may your SELECTs always be fast and your WHEREs never too vague.

### Checkout these amazing resources!

|#| **CodeBase** | **Created By** | **Location _(Ctrl + click to open in a new tab)_** |
|-| ------------- |:-------------:| :-------------|
|1| Create Handy DBA Database | Andy Mallon (ᴀᴍ²) | [dba-database](https://github.com/amtwo/dba-database) - this is handy for installing repos 2 to 5 below using powershell into a **DBA** database |
|||||
|2| SQL Server Maintenance Solution | Ola Hallengren | [Backups and maintenance...](https://github.com/olahallengren/sql-server-maintenance-solution) |
|3| SQL Server First Responder Kit | Brent Ozar | [Health checks and more...](https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit) |
|4| WhoIsActive | Adam Machanic | [WhoIsActive?](https://github.com/amachanic/sp_whoisactive) |
|5| Darling Data Scripts | Erik Darling | [Super-cool troubleshooting...](https://github.com/erikdarlingdata/DarlingData) |
|||||
|6| SQL Query Stress | Erik Ejlskov Jensen | [Stress that server!](https://github.com/ErikEJ/SqlQueryStress) |
|7| Statistics Parser | Richie Rump | [Online Statistics Parser ](https://statisticsparser.com/) |
|8| sp_block (script) | Chris Howarth-536003 | [Return blocked process hierarchy](sp_block.sql) |

Notes:
If using the _**Andy Mallon**_ powershell setup scripts clone the repo then run the following in powershell (if you want to install to a new database named _**DBA**_):

```
> Set-Location path_to_repo
> .\Get-OpenSourceScripts.ps1 -Verbose
> .\Install-LatestDbaDatabase.ps1 -InstanceName "DellPro" -Verbose
```

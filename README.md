# Execute SQL queries using different R libraries, benchmark them and plot the results

The aim of this project is to create and compare the performance of code that returns the exact same dataframes as SQL queries given below, using the following R libraries:
- sqldf
- base R
- dplyr
- data.table

*It was made as part of structured data processing course at my university and all credits for inventing these excercises go to my professor, Anna Cena, Ph. D.*

**Additionaly, I challanged myself to write dplyr and data.table functions with only one command.**

**Furthermore, I decided to play around with ggplot2 plotting library to visualize the benchmark results, definitely check it out!**

## How to use
If you want to run the script, you need to unzip the data from and into the data directory

## Folder structure
- main.R loads and executes all the tasks, checks if the results are equal, benchmarks the functions and saves results
- data: the data we are working with
- tasks: each R file contains functions written with mentioned libraries for one SQL query
- queries_results: tables resulting from given queries in csv format
- benchmark_results: tables comparing performance of the libraries
- plots: plots showing benchmark results 

## Dataset
We are working with a travel forum data from anonymized dump of all user-contributed content on the Stack Exchange network.
- data: https://archive.org/details/stackexchange
- data description: https://ia600107.us.archive.org/27/items/stackexchange/readme.txt

## Queries
### Query 1
```SQL
SELECT Location, SUM(UpVotes) as TotalUpVotes
FROM Users
WHERE Location != ''
GROUP BY Location
ORDER BY TotalUpVotes DESC
LIMIT 10 
```
### Query 2
```SQL
SELECT STRFTIME('%Y', CreationDate) AS Year, STRFTIME('%m', CreationDate) AS Month,
COUNT(*) AS PostsNumber, MAX(Score) AS MaxScore
FROM Posts
WHERE PostTypeId IN (1, 2)
GROUP BY Year, Month
HAVING PostsNumber > 1000 
```
### Query 3
```SQL
SELECT Id, DisplayName, TotalViews
FROM (
    SELECT OwnerUserId, SUM(ViewCount) as TotalViews
    FROM Posts
    WHERE PostTypeId = 1
    GROUP BY OwnerUserId
) AS Questions
JOIN Users
ON Users.Id = Questions.OwnerUserId
ORDER BY TotalViews DESC
LIMIT 10
```
### Query 4
```SQL
SELECT DisplayName, QuestionsNumber, AnswersNumber, Location, Reputation, UpVotes, DownVotes
FROM (
    SELECT *
    FROM (
        SELECT COUNT(*) as AnswersNumber, OwnerUserId
        FROM Posts
        WHERE PostTypeId = 2
        GROUP BY OwnerUserId
    ) AS Answers
    JOIN
    (
        SELECT COUNT(*) as QuestionsNumber, OwnerUserId
        FROM Posts
        WHERE PostTypeId = 1
        GROUP BY OwnerUserId
    ) AS Questions
    ON Answers.OwnerUserId = Questions.OwnerUserId
    WHERE AnswersNumber > QuestionsNumber
    ORDER BY AnswersNumber DESC
    LIMIT 5
) AS PostsCounts
JOIN Users
ON PostsCounts.OwnerUserId = Users.Id
```
### Query 5
```SQL
SELECT Title, CommentCount, ViewCount, CommentsTotalScore, DisplayName, Reputation, Location
FROM (
    SELECT Posts.OwnerUserId, Posts.Title, Posts.CommentCount, Posts.ViewCount,
    CmtTotScr.CommentsTotalScore
        FROM (
            SELECT PostId, SUM(Score) AS CommentsTotalScore
            FROM Comments
            GROUP BY PostId
        ) AS CmtTotScr
    JOIN Posts ON Posts.Id = CmtTotScr.PostId
    WHERE Posts.PostTypeId=1
) AS PostsBestComments
JOIN Users ON PostsBestComments.OwnerUserId = Users.Id
ORDER BY CommentsTotalScore DESC
LIMIT 10
```

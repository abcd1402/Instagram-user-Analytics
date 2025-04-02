==== Insights: Marketing ====
        
-----# 1.Rewarding Most Loyal Users: People who have been using the platform for the longest time.
SELECT id,
       username,
       created_at
FROM   users
ORDER  BY created_at
LIMIT  5;

----# 2.Remind Inactive Users to Start Posting: By sending them promotional emails to post their 1st photo.

SELECT u.id,
       u.username,
       Count(p.user_id) AS 'no._of_posts'
FROM   users u
       LEFT JOIN photos p
              ON u.id = p.user_id
GROUP  BY u.id
HAVING Count(p.user_id) = 0;
The users who have never posted a single photo on Instagram


----# 3.Declaring Contest Winner: The team started a contest and the user who gets the most likes on a single photo will win the contest now they wish to declare the winner.

SELECT id,
       username
FROM   users
WHERE  id = (SELECT user_id
             FROM   photos
             WHERE  id = (SELECT photo_id
                          FROM   likes
                          GROUP  BY photo_id
                          ORDER  BY Count(photo_id) DESC
                          LIMIT  1)); 


-----# 4.Hashtag Researching: A partner brand wants to know, which hashtags to use in the post to reach the most people on the platform.

SELECT t.tag_name,
       Count(t.tag_name) AS "tags count"
FROM   tags t
       INNER JOIN photo_tags ph
               ON t.id = ph.tag_id
GROUP  BY t.tag_name
ORDER  BY Count(t.tag_name) DESC
LIMIT  5; 

-----# 5.Launch AD Campaign: The team wants to know, which day would be the best day to launch ADs.

SELECT Dayname(created_at) "day of week",
Count(Dayname(created_at)) "count of users registered"
FROM users
GROUP BY Dayname(created_at)
ORDER BY Count(Dayname(created_at)) DESC
LIMIT 2;

==== Insights: investor metrics ====
----# 1. User Engagement: Are users still as active and post on Instagram or they are making fewer posts.

SELECT (SELECT Count(id)
        FROM   photos) / (SELECT Count(DISTINCT user_id)
                          FROM   photos) AS Average_posts_per_User,
       (SELECT Count(id)
        FROM   photos) / (SELECT Count(id)
                          FROM   users)  AS Ratio_of_Total_Posts_to_Total_Users; 

------ # 2.Bots & Fake Accounts: The investors want to know if the platform is crowded with fake and dummy accounts

SELECT id,
       username
FROM   users
WHERE  id IN (SELECT user_id
              FROM   likes
              GROUP  BY user_id
              HAVING Count(user_id) = (SELECT Count(id)
                                       FROM   photos)); 

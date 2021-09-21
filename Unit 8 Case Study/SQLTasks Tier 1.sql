/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 1 of the case study, which means that there'll be more guidance for you about how to 
setup your local SQLite connection in PART 2 of the case study. 

The questions in the case study are exactly the same as with Tier 2. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */
SELECT name
FROM Facilities
WHERE membercost > 0

Answer:
Tennis Court 1
Tennis Court 2
Massage Room 1
Massage Room 2
Squash Court

/* Q2: How many facilities do not charge a fee to members? */
SELECT COUNT(facid)
FROM Facilities
WHERE membercost = 0

Answer:
4


/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance
FROM Facilities
WHERE membercost > 0
AND membercost < (monthlymaintenance * 0.2)

Answer: 
facid	name		membercost	monthlymaintenance	
0	Tennis Court 1	5.0	        200
1	Tennis Court 2	5.0	        200
4	Massage Room 1	9.9	        3000
5	Massage Room 2	9.9	        3000
6	Squash Court	3.5	        80


/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

SELECT *
FROM Facilities
WHERE facid IN (1,5)

Answer:

facid	name	    	 membercost	guestcost	initialoutlay	monthlymaintenance	
1	Tennis Court 2	 5.0	        25.0	        8000	        200
5	Massage Room 2	 9.9	        80.0	        4000	        3000

/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

SELECT name, monthlymaintenance, CASE
WHEN monthlymaintenance > 100 THEN 'Expensive'
WHEN monthlymaintenance < 100 THEN 'Cheap'
ELSE 'other'
END AS price_cat
FROM Facilities

ANSWER:
name			monthlymaintenance	price_cat	
Tennis Court 1		200			Expensive
Tennis Court 2		200			Expensive
Badminton Court		50			Cheap
Table Tennis		10			Cheap
Massage Room 1		3000			Expensive
Massage Room 2		3000			Expensive
Squash Court		80			Cheap
Snooker Table		15			Cheap
Pool Table		15			Cheap


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

SELECT firstname, surname
FROM Members
WHERE joindate = (SELECT MAX(joindate) FROM Members)

Answer:
firstname	surname
Darren		Smith


/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT CONCAT_WS(' ', firstname, surname) AS fullname, CASE
WHEN facid = 0 THEN 'Tennis Court 1'
WHEN facid = 1 THEN 'Tennis Court 2'
ELSE 'other'
END AS 'courtname'
FROM Members AS m
INNER JOIN Bookings AS b
ON m.memid = b.memid
WHERE facid IN (0,1)
GROUP BY b.memid
ORDER BY fullname

Answer:

fullname		courtname	
Anne Baker		Tennis Court 1
Burton Tracy		Tennis Court 2
Charles Owen		Tennis Court 1
Darren Smith		Tennis Court 2
David Farrell		Tennis Court 1
David Jones		Tennis Court 2
David Pinker		Tennis Court 1
Douglas Jones		Tennis Court 1
Erica Crumpet		Tennis Court 1
Florence Bader		Tennis Court 2
Gerald Butters		Tennis Court 1
GUEST GUEST		Tennis Court 2
Henrietta Rumney	Tennis Court 2
Jack Smith		Tennis Court 1
Janice Joplette		Tennis Court 1
Jemima Farrell		Tennis Court 2
Joan Coplin		Tennis Court 1
John Hunt		Tennis Court 1
Matthew Genting		Tennis Court 1
Millicent Purview	Tennis Court 2
Nancy Dare		Tennis Court 2
Ponder Stibbons		Tennis Court 2
Ramnaresh Sarwin	Tennis Court 2
Tim Boothe		Tennis Court 2
Tim Rownam		Tennis Court 2
Timothy Baker		Tennis Court 2
Tracy Smith		Tennis Court 1



/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT CONCAT_WS( ' ', firstname, surname ) AS fullname, f.name AS facilityname, 
	   IF(b.memid = 0, (f.guestcost * b.slots), (f.membercost * b.slots)) AS cost
FROM Members AS m
INNER JOIN Bookings AS b ON m.memid = b.memid
INNER JOIN Facilities AS f ON b.facid = f.facid
WHERE starttime
BETWEEN '2012-09-14 00:00:00'
AND '2012-09-14 23:59:00'
HAVING cost > 30
ORDER BY cost DESC

Answer:
fullname	facilityname	cost	
GUEST GUEST	Massage Room 2	320.0
GUEST GUEST	Massage Room 1	160.0
GUEST GUEST	Massage Room 1	160.0
GUEST GUEST	Massage Room 1	160.0
GUEST GUEST	Tennis Court 2	150.0
GUEST GUEST	Tennis Court 1	75.0
GUEST GUEST	Tennis Court 1	75.0
GUEST GUEST	Tennis Court 2	75.0
GUEST GUEST	Squash Court	70.0
Jemima Farrell	Massage Room 1	39.6
GUEST GUEST	Squash Court	35.0
GUEST GUEST	Squash Court	35.0


/* Q9: This time, produce the same result as in Q8, but using a subquery. */



/* PART 2: SQLite
/* We now want you to jump over to a local instance of the database on your machine. 

Copy and paste the LocalSQLConnection.py script into an empty Jupyter notebook, and run it. 

Make sure that the SQLFiles folder containing thes files is in your working directory, and
that you haven't changed the name of the .db file from 'sqlite\db\pythonsqlite'.

You should see the output from the initial query 'SELECT * FROM FACILITIES'.

Complete the remaining tasks in the Jupyter interface. If you struggle, feel free to go back
to the PHPMyAdmin interface as and when you need to. 

You'll need to paste your query into value of the 'query1' variable and run the code block again to get an output.
 
QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */
SELECT f.name AS facilityname, (SUM(IF(b.memid = 0, (f.guestcost * b.slots), (f.membercost * b.slots))) - (f.monthlymaintenance * 3)) AS totalrevenue 
FROM Facilities AS f
INNER JOIN Bookings AS b
ON f.facid = b.facid
GROUP BY f.facid
HAVING totalrevenue < 1000

Answer: 

facilityname 	totalrevenue
Table Tennis 	150.0
Snooker Table	195.0
Pool Table	225.0

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */
SELECT m.surname || ', ' || m.firstname AS member, m.memid, r.surname || ', ' || r.firstname AS recommendingmember,
       r.memid
FROM Members AS m
JOIN Members AS r
ON m.recommendedby = r.memid
WHERE r.memid != 0 
ORDER BY member

Answer:
('Bader, Florence', 15, 'Stibbons, Ponder', 9)
('Baker, Anne', 12, 'Stibbons, Ponder', 9)
('Baker, Timothy', 16, 'Farrell, Jemima', 13)
('Boothe, Tim', 8, 'Rownam, Tim', 3)
('Butters, Gerald', 5, 'Smith, Darren', 1)
('Coplin, Joan', 22, 'Baker, Timothy', 16)
('Crumpet, Erica', 36, 'Smith, Tracy', 2)
('Dare, Nancy', 7, 'Joplette, Janice', 4)
('Genting, Matthew', 20, 'Butters, Gerald', 5)
('Hunt, John', 35, 'Purview, Millicent', 30)
('Jones, David', 11, 'Joplette, Janice', 4)
('Jones, Douglas', 26, 'Jones, David', 11)
('Joplette, Janice', 4, 'Smith, Darren', 1)
('Mackenzie, Anna', 21, 'Smith, Darren', 1)
('Owen, Charles', 10, 'Smith, Darren', 1)
('Pinker, David', 17, 'Farrell, Jemima', 13)
('Purview, Millicent', 30, 'Smith, Tracy', 2)
('Rumney, Henrietta', 27, 'Genting, Matthew', 20)
('Sarwin, Ramnaresh', 24, 'Bader, Florence', 15)
('Smith, Jack', 14, 'Smith, Darren', 1)
('Stibbons, Ponder', 9, 'Tracy, Burton', 6)
('Worthington-Smyth, Henry', 29, 'Smith, Tracy', 2)

/* Q12: Find the facilities with their usage by member, but not guests */
SELECT f.name, b.facid, COUNT(memid) AS uses
FROM Bookings AS b
INNER JOIN Facilities AS f
ON b.facid = f.facid
WHERE memid != 0
GROUP BY b.facid

Answer:
('Tennis Court 1', 0, 308)
('Tennis Court 2', 1, 276)
('Badminton Court', 2, 344)
('Table Tennis', 3, 385)
('Massage Room 1', 4, 421)
('Massage Room 2', 5, 27)
('Squash Court', 6, 195)
('Snooker Table', 7, 421)
('Pool Table', 8, 783)

/* Q13: Find the facilities usage by month, but not guests */
SELECT f.name, COUNT(memid) AS uses, strftime('%m', starttime) as month
FROM Bookings AS b
INNER JOIN Facilities AS f
ON b.facid = f.facid
WHERE memid != 0
GROUP BY b.facid, month

Answer:
('Tennis Court 1', 65, '07')
('Tennis Court 1', 111, '08')
('Tennis Court 1', 132, '09')
('Tennis Court 2', 41, '07')
('Tennis Court 2', 109, '08')
('Tennis Court 2', 126, '09')
('Badminton Court', 51, '07')
('Badminton Court', 132, '08')
('Badminton Court', 161, '09')
('Table Tennis', 48, '07')
('Table Tennis', 143, '08')
('Table Tennis', 194, '09')
('Massage Room 1', 77, '07')
('Massage Room 1', 153, '08')
('Massage Room 1', 191, '09')
('Massage Room 2', 4, '07')
('Massage Room 2', 9, '08')
('Massage Room 2', 14, '09')
('Squash Court', 23, '07')
('Squash Court', 85, '08')
('Squash Court', 87, '09')
('Snooker Table', 68, '07')
('Snooker Table', 154, '08')
('Snooker Table', 199, '09')
('Pool Table', 103, '07')
('Pool Table', 272, '08')
('Pool Table', 408, '09')

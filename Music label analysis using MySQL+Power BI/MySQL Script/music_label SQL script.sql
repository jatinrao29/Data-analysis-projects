create database music;
use music;
show tables;
select * from album2;
rename table album2 to album;



/* Q1: Which countries have the most Invoices? */

select * from invoice;
select billing_city,count(invoice_id) as frequency from invoice group by billing_city order by count(invoice_id) desc;


/* Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest number of purchases. Write a query that returns each country along with the top Genre. */


select * from genre;
select * from customer;
select * from invoice;
select * from invoice_line;

with Popular_genres as(
select c.country as country,g.name as genre_name,count(il.quantity) as quantity_sold,
row_number() over(partition by country order by count(il.quantity) desc) as _index 
from genre as g inner join track as t on g.genre_id=t.genre_id
inner join invoice_line as il on il.track_id =t.track_id
inner join invoice as i on i.invoice_id=il.invoice_id
inner join customer as c on c.customer_id=i.customer_id group by country,genre_name)

select country,genre_name from Popular_genres where _index=1;

/* Q3: Who are the top 5 customer ? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the amount spent by each customer and the best customer.*/

select * from customer;
select * from invoice;

with  Customer_Invoice as(
select i.customer_id as ic_id,c.customer_id as cc_id,c.first_name,c.last_name,
sum(i.total ) over(partition by i.customer_id order by i.total desc ) as _total 
from invoice as i inner join customer as c on i.customer_id=c.customer_id)
select concat(first_name," ",last_name) as Full_name,max(_total) as expenditure from Customer_Invoice group by concat(first_name," ",last_name) order by max(_total) desc limit 5;


/* Q4: Let's invite the bands who have played the most rock music in our dataset. 
Write a query that returns the band name and total track count of the all rock bands. */

select * from album;
select * from genre;
select * from track;
select * from artist;

with guest as(
select g.name as Band_type,t.track_id as Track_id,art.name as Band_name from genre as g inner join track as t on g.genre_id=t.genre_id
inner join album as a on a.album_id=t.album_id 
inner join artist as art on a.artist_id=art.artist_id where g.genre_id=1)
select Band_name,count(Track_id) as Track_count from guest  group by Band_name order by count(Track_id) desc;

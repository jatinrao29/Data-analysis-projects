show databases;
use music;
show tables;


select * from employee;
with senior1 as(
select first_name,last_name,title,max(levels) over(partition by title order by levels desc) as Level_,
row_number() over(partition by title order by levels desc) as _Index from employee)
select concat(first_name,"",last_name) as Full_name,title,Level_ from senior1 where _Index=1 order by Level_ desc;



select * from invoice;


select billing_country,count(invoice_id) as Total_invoice from invoice group by billing_country order by count(invoice_id) desc;

select billing_city,sum(total) as revenue from invoice group by billing_city order by sum(total) desc;

with top_customers as(
select i.customer_id as ID,concat(c.first_name,"",c.last_name) as Full_name,i.total as Total from invoice as i inner join
customer as c on i.customer_id=c.customer_id )
select ID,Full_name,sum(Total) as Revenue from top_customers group by ID,Full_name order by sum(Total) desc;


with Rock_lovers as(
select c.first_name,c.last_name,c.email,g.name as Genre from customer as c 
inner join invoice as i on c.customer_id=i.customer_id
inner join invoice_line as il on i.invoice_id=il.invoice_id
inner join track as t on il.track_id=t.track_id
inner join genre as g on t.genre_id=g.genre_id)
select distinct(concat(first_name,"",last_name)),email,Genre from Rock_lovers where Genre="Rock" order by email;



with Band as(
select art.name as Band_name,g.genre_id as Genre_id,count(a.artist_id) over(partition by art.name) as Track_count from genre as g
inner join track as t on g.genre_id=t.genre_id
inner join album as a on t.album_id=a.album_id
inner join artist as art on a.artist_id=art.artist_id where g.genre_id=1 )
select distinct(Band_name),Track_count from Band order by Track_count desc;


with Best_seller as(
select c.first_name,c.last_name,art.name as Artist,sum(il.unit_price*il.quantity) as Expenditure from customer as c
inner join invoice as i on c.customer_id=i.customer_id
inner join invoice_line as il on i.invoice_id=il.invoice_id
inner join track as t on il.track_id=t.track_id
inner join album as a on t.album_id=a.album_id
inner join artist as art on a.artist_id=art.artist_id group by c.first_name,c.last_name,art.name)
select concat(first_name,"",last_name) as Full_name,Artist,Expenditure from Best_seller order by Full_name;



With Country_genre as(
select i.billing_country as Country,g.name as Genre,sum(il.quantity) as Total_purchase,
row_number() over(partition by i.billing_country order by sum(il.quantity) desc) as Index_ from customer as c
inner join invoice as i on c.customer_id=i.customer_id
inner join invoice_line as il on i.invoice_id=il.invoice_id
inner join track as t on il.track_id=t.track_id
inner join genre as g on t.genre_id=g.genre_id group by i.billing_country,g.name order by i.billing_country)
select Country,Genre from Country_genre where Index_=1 ;






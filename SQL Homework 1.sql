use Sakila;
-- Question 1a ----- 
Select first_name, last_name
From sakila.actor;

-- Question 1b -----
Select concat(Upper(first_name),' ',Upper(last_name)) as Actor
From sakila.actor;

-- Question 2a-------
Select Actor_Id, First_Name, Last_Name
From  sakila.actor
Where First_Name ='Joe';

-- Question 2b-------
Select Actor_Id, First_Name, Last_Name
From  sakila.actor
Where Last_Name like '%GEN%';

-- Question 2c-------
Select Actor_Id, First_Name, Last_Name
From  sakila.actor
Where Last_Name like '%LI%'
ORder by Last_Name, First_Name;

-- Question 2d-------
Select country_id, Country
From sakila.country
Where country in ('Afghanistan', 'Bangladesh', 'China');

-- Question 3a	-----
Alter Table sakila.actor 
Add Column `description` BLOB after `last_update`;
 -- Question 3a display --
Select * from sakila.actor limit 1;
-- Question 3b	-----
Alter Table sakila.actor 
drop Column `description`;
 
  -- Question 3b display --
Select * from sakila.actor limit 1;

-- Question 4a	-----
Select last_name, count(last_name) as 'Count of Last Name'
From sakila.actor
group by last_Name;

-- Question 4b	-----
Select last_name, count(last_name) as 'Count of Last Name'
From sakila.actor
group by last_Name
Having count(last_name)>1;

-- Question 4c	-----
UPDATE sakila.actor 
SET first_name = 'HARPO'
Where first_name = 'GROUCHO';
-- VIEW 4C --
Select * From sakila.actor Where Last_Name = 'Williams';

-- Question 4d	-----                                         
UPDATE sakila.actor 
SET first_name = 'GROUCHO'
Where first_name = 'HARPO';

-- VIEW 4D --
Select * From sakila.actor Where Last_Name = 'Williams'  ;                                 
-- Question 5a	-----

SHOW CREATE TABLE sakila.address;

-- Question 6a	----- Used left join to see if all employees had addresses
SELECT 
    s.first_name,
    s.last_name,
    a.address,
    a.postal_code
FROM sakila.staff s
left join sakila.address a on  s.address_id = a.address_id 
;
-- Question 6b	-----
SELECT 
    s.first_name,
    s.last_name,
    sum(p.amount) as Total_Rung
FROM sakila.staff s
left join sakila.payment p on  s.staff_ID = p.staff_ID
Where Payment_Date>= '2005-08-01 00:00:00' 
and Payment_Date<'2005-09-01 00:00:00'
Group by  s.first_name, s.last_name;
 
-- Question 6c	----- Assumption made that there are no duplicate movie titles
SELECT  f.title
    , count(fa.Actor_ID) as 'Number of Actors'

FROM sakila.film f
join  sakila.film_actor fa on fa.film_id = f.film_ID
group by  f.title;

-- Question 6d	-----
SELECT  f.title
    , count(i.inventory_id) as 'Number of Copies'
FROM sakila.film f
join sakila.inventory i on f.film_id = i.film_id
where f.title ='Hunchback Impossible'
Group by  f.title;

-- Question 6e	-----
Select 
	c.First_Name
    , c.Last_Name
    , sum(p.amount) as 'Total Amount Paid';

From sakila.customer c
join sakila.payment p on c.customer_ID = p.Customer_ID
Group by c.First_Name, c.Last_Name;

-- Question 7a	-----
Select title as 'Movie Title'
from sakila.language l
join (	SELECT 
		title,language_id
		FROM sakila.film
		Where title like 'K%' or title like 'Q%') f on f.language_id = l.language_id
where name='English';

-- Question 7b	-----
SELECT 
    a.first_name,
    a.last_name
FROM sakila.actor a
join (Select  Actor_ID from sakila.film_actor 
					Where film_ID in (Select Film_ID from sakila.film where title='Alone Trip') 
                    order by actor_id) fa on fa.actor_id =a.actor_id;

-- Question 7c	-----
Select first_name, last_name,email from sakila.customer
Where (address_id in (Select address_Id from sakila.address
Where city_id in (Select city_id from sakila.city
Where country_ID =(Select Country_ID from sakila.country where Country='Canada'))));

-- Question 7d	-----
select Title from sakila.film 
where film_id in(
select film_id from sakila.film_category 
where category_id =(Select Category_id From sakila.category where name ='family'));

-- Question 7e	-----
Select title, total_rentals
from sakila.film f
join(Select film_id, sum(r.count) as "Total_Rentals"
		From sakila.inventory i
			join(SELECT inventory_id, count(rental_date) as count 
		FROM sakila.rental group by inventory_ID) r on r.inventory_id = i.inventory_id 
        group by film_id) ri 
        on ri.film_id =f.film_id
Order by total_rentals desc ;

-- Question 7f	-----
Select a.store_id, sum(b.amount) as "Store Total"
from Sakila.customer a
join (Select Amount, customer_id From sakila.payment) b on a.customer_id=b.Customer_Id
Group by a.store_id;

-- Question 7g	-----
Select 
a.Store_id
, c.City, d.Country
From sakila.Store a
join Sakila.address b on a.address_id = b.Address_Id
join sakila.city c on b.city_id=c.city_id
join sakila.country d on c.country_id= d.country_id;

-- Question 7h	-----

Select 
cat.Name, sum(amount) as 'Total'
From sakila.category cat
join sakila.film_category fc on cat.category_id = fc.category_id
join sakila.inventory i on fc.film_id =i.film_id
join sakila.rental r on i.inventory_id = r.inventory_id
join sakila.payment p on r.rental_id=p.rental_id
group by cat.name
order by sum(amount) desc
Limit 5 offset 0;

-- Question 8a	-----
Create view sakila.Category_Revenue as
Select 
cat.Name as 'Category', sum(amount) as 'Total'
From sakila.category cat
join sakila.film_category fc on cat.category_id = fc.category_id
join sakila.inventory i on fc.film_id =i.film_id
join sakila.rental r on i.inventory_id = r.inventory_id
join sakila.payment p on r.rental_id=p.rental_id
group by cat.name
order by sum(amount) desc
Limit 5 offset 0;

-- Question 8b	-----
Select * From sakila.Category_Revenue;
-- Question 8ac	-----
Drop view if exists sakila.Category_Revenue;
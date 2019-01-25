
use sakila;
describe actor;
-- 1a. Display the first and last names of all actors from the table actor.

select first_name,last_name from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.

select upper(concat(first_name," ", last_name)) as "Actor Name" from actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

select actor_id,first_name,last_name from actor where first_name="Joe";

-- 2b. Find all actors whose last name contain the letters GEN:

select * from actor where last_name like '%GEN%' ;

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:

select * from actor where last_name like '%LI%' order by last_name,first_name;

describe country;
-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id,country from country where country in ('Afghanistan','Bangladesh','China');

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE actor ADD description blob;
describe actor;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.

ALTER TABLE actor DROP COLUMN description;

-- 4a. List the last names of actors, as well as how many actors have that last name.

select last_name,count(*) from actor group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.

select last_name,count(*) from actor group by last_name having count(*)>1;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.

update actor set first_name="HARPO" where actor_id = 172;
select * from actor where first_name='HARPO';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
update actor set first_name="GROUCHO" where actor_id=172;

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
create table if not exists address (
addres_id  int auto_increament ,
address varchar(50) not null,
address2 varchar(50),
district varchar(20),
city_id int not null ,
postal_code varchar(20),
phone int ,
location varchar(50),
last_update varchar(100)
primary key(address_id));

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select * from staff;
select * from address;

SELECT first_name, last_name,address.address
FROM staff
INNER JOIN address ON staff.address_id = address.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

select * from payment;
select staff.staff_id,sum(payment.amount)
from staff inner join payment on staff.staff_id=payment.staff_id group by (staff.staff_id);

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select * from film_actor;
select * from film;

select title,count(actor_id) from film
inner join film_actor on film.film_id=film_actor.film_id group by title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select * from inventory;
select * from rental;
select * from payment;

select count(film_id) from inventory 
where film_id = (select film_id from film where title='Hunchback Impossible' group by title) group by film_id;

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select * from payment;
select * from customer;

select payment.customer_id,sum(amount) from payment 
inner join customer on payment.customer_id=customer.customer_id group by payment.customer_id;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select * from film;
select * from language;

select title from film 
where language_id = (select language_id from language where name='English') 
and (title like 'Q%' or title like 'K%');

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select * from film;
select * from film_actor;
select * from actor;

select first_name,last_name 
from actor where actor_id in 
(select actor_id from film_actor where film_id = 
(select film_id from film where title='Alone Trip'));

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

select * from country;
select * from address;
select * from customer;
select * from city;

select first_name,last_name,email,a.address_id,country.country_id,city.city_id,city.city from address a
 join customer c on a.address_id=c.address_id
 join city on city.city_id=a.city_id
 join country on country.country_id=city.country_id where country='canada';
  



-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select * from category;
select * from film;
select * from film_category;

select title from film where film_id 
in (select film_id from film_category where category_id=
(select category_id from category where name='Family'));

-- 7e. Display the most frequently rented movies in descending order.

select * from rental;
select * from inventory;
select * from film;


select film.film_id,count(rental_id) rented from rental join inventory on rental.inventory_id=inventory.inventory_id
join film on inventory.film_id=film.film_id group by film.film_id order by rented desc;


-- 7f. Write a query to display how much business, in dollars, each store brought in.
select * from store;
select * from payment;
select * from rental;
select * from film;
select * from staff;

select staff.store_id,sum(amount) from payment 
inner join staff on payment.staff_id=staff.staff_id group by staff.staff_id;


-- 7g. Write a query to display for each store its store ID, city, and country.
select * from country;
select * from city;
select * from store;
select * from address;

select store_id,city,country from 
store inner join address 
on address.address_id=store.address_id
inner join city on address.city_id=city.city_id
inner join country on city.country_id=country.country_id ; 


-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select * from category;
select * from film_category;
select * from payment;
select * from rental;
select * from inventory;

select film_id,sum(amount) from payment inner join rental on rental.rental_id=payment.rental_id 
inner join inventory on rental.inventory_id=inventory.inventory_id group by inventory.inventory_id ;


-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
select * from category;

select name,sum(amount) Amount from payment join rental on payment.rental_id=rental.rental_id
join inventory on rental.inventory_id=inventory.inventory_id join film_category on inventory.film_id=film_category.film_id
join category on film_category.category_id=category.category_id group by name order by Amount desc limit 5;

-- 8b. How would you display the view that you created in 8a?

create view topfive as select name,sum(amount) Amount from payment join rental on payment.rental_id=rental.rental_id
join inventory on rental.inventory_id=inventory.inventory_id join film_category on inventory.film_id=film_category.film_id
join category on film_category.category_id=category.category_id group by name order by Amount desc limit 5;

select * from topfive;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.*/
drop view topfive;
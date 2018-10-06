use sakila;
select * from actor;
select * from country;
select * from staff;
select * from address;
select * from payment;
select * from film_actor;
select * from film;
select * from inventory;
select * from customer;
select * from language;
select * from city;
select * from category;
select * from film_category;
select * from rental;
select * from store;

-- 1a
select first_name, last_name from actor;

-- 1b
select concat(first_name," ",last_name) as "Actor Name" from actor;

-- 2a
select actor_id, first_name, last_name
from actor
where first_name = "Joe";

-- 2b
select actor_id, first_name, last_name
from actor
where last_name like "%GEN%";

-- 2c
select actor_id, first_name, last_name
from actor
where last_name like "%LI%"
order by last_name, first_name;

-- 2d
select country_id, country
from country
where country in ("Afghanistan", "Bangladesh", "China");

-- 3a
alter table actor
add column description BLOB;

-- 3b 
alter table actor
drop column description;

-- 4a
select last_name, count(last_name) as counts
from actor
group by last_name;

-- 4b
select last_name, count(last_name) as counts
from actor
group by last_name
having count(last_name)>=2
order by count(last_name);

-- 4c
update actor
set first_name = "HARPO"
where first_name = "GROUCHO" and last_name = "WILLIAMS";

-- 4d
update actor
set first_name = "GROUCHO"
where first_name = "HARPO" and last_name = "WILLIAMS";

-- 5a
show create table address;

-- 6a
select staff.first_name, staff.last_name, address.address
from staff
inner join address
on address.address_id = staff.address_id;

-- 6b
select staff.first_name, staff.last_name, sum(payment.amount) as "Total amount"
from payment
inner join staff
on staff.staff_id = payment.staff_id
group by payment.staff_id;

-- 6c
select film.title, count(film_actor.film_id) as "Number of Actors"
from film_actor
inner join film
on film.film_id = film_actor.film_id
group by film_actor.film_id;

-- 6d
select film.title, count(inventory.film_id) as copies
from inventory
inner join film
on film.film_id = inventory.film_id
where film.title = "Hunchback Impossible";

-- 6e
select customer.first_name, customer.last_name, sum(payment.amount) as "Total Payment"
from payment
inner join customer
on customer.customer_id = payment.customer_id
group by payment.customer_id
order by customer.last_name;

-- 7a
select title
from film
where title like "K%" or title like "Q%"
and language_id in 
	(
	select language_id
    from language
    where name = "English"
    )
;

-- 7b
select first_name, last_name
from actor
where actor_id in
	(
    select actor_id
    from film_actor
    where film_id in
		(
        select film_id
        from film
        where title = "Alone Trip"
        )
	)
;

-- 7c
select customer.first_name, customer.last_name, customer.email
from customer
left join (address cross join city cross join country)
on 
(
customer.address_id = address.address_id and
address.city_id = city.city_id and 
city.country_id = country.country_id
)
where country.country = "Canada"
;

-- 7d
select film.title, category.name
from film
inner join (film_category cross join category)
on (film.film_id = film_category.film_id and film_category.category_id = category.category_id)
where category.name = "Family"
;

-- 7e
select film.title, count(rental.inventory_id) as "rental times"
from film 
inner join (rental cross join inventory)
on film.film_id = inventory.film_id and inventory.inventory_id = rental.inventory_id
group by rental.inventory_id
order by count(rental.inventory_id) desc
;

-- 7f
select store.store_id as "store", sum(payment.amount) as "Total Business"
from payment 
left join (store cross join customer)
on (
    payment.customer_id = customer.customer_id
	and 
    customer.store_id = store.store_id
    )
group by store.store_id
;

-- 7g
select store.store_id, city.city, country.country
from store 
inner join (city cross join country cross join address)
on 
(
store.address_id = address.address_id
and
address.city_id = city.city_id
and
city.country_id = country.country_id
)
;

-- 7h
select c.name as genres, sum(p.amount) as "total revenue"
from payment p
inner join (category c cross join film_category f cross join inventory i cross join rental r)
on
(c.category_id = f.category_id
and
f.film_id = i.film_id
and
i.inventory_id = r.inventory_id
and
r.rental_id = p.rental_id
)
group by f.category_id
order by sum(p.amount) desc
limit 5
;

-- 8a
create view `Top_five_genres` as 
select c.name as genres, sum(p.amount) as "total revenue"
from payment p
inner join (category c cross join film_category f cross join inventory i cross join rental r)
on
(c.category_id = f.category_id
and
f.film_id = i.film_id
and
i.inventory_id = r.inventory_id
and
r.rental_id = p.rental_id
)
group by f.category_id
order by sum(p.amount) desc
limit 5
;

-- 8b
select * from `Top_five_genres`;

-- 8c
drop view `Top_five_genres`;
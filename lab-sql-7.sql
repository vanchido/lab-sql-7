use sakila;

#1.In the table actor, which are the actors whose last names are not repeated?
select *, count(last_name) from actor
group by last_name
having count(last_name) = 1; 

#2.Which last names appear more than once?
select *, count(last_name) from actor
group by last_name
having count(last_name) > 1; 

#3.Using the rental table, find out how many rentals were processed by each employee.
select *, count(rental_id) from rental
group by staff_id;

#4.Using the film table, find out how many films were released each year.
select *, count(film_id) from film
group by release_year;

#5.Using the film table, find out for each rating how many films were there.
select *, count(film_id) from film
group by rating;

#6.What is the mean length of the film for each rating type.
select rating, count(film_id), round(avg(length),2) as mean_length from film
group by rating;

#7.Which kind of movies (rating) have a mean duration of more than two hours?
select rating, count(film_id), round(avg(length),2) as mean_length from film
group by rating
having mean_length > 120;
-- 1a--
USE sakila;
SELECT * FROM actor;
SELECT first_name, last_name FROM actor;
-- 1b-- 
-- ALTER TABLE actor DROP COLUMN Actor_Name;
ALTER TABLE actor ADD COLUMN Actor_Name VARCHAR(50);
UPDATE actor SET Actor_Name = CONCAT(first_name, ' ', last_name);
SELECT * FROM actor;
-- 2a -- 
SELECT * FROM actor WHERE first_name = "Joe";
-- 2b -- 
SELECT Actor_Name FROM actor WHERE last_name LIKE '%GEN%';
-- 2c --
SELECT last_name, first_name FROM actor where last_name LIKE '%LI%'
ORDER BY last_name, first_name;
-- 2d -- 
SELECT country_id, country FROM Country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
-- 3a -- 
ALTER TABLE actor ADD COLUMN description BLOB NOT NULL;
-- 3b --
ALTER TABLE actor DROP COLUMN description;
-- 4a -- 
SELECT last_name FROM actor;
SELECT COUNT( DISTINCT last_name) FROM actor;
-- 4b -- 
SELECT last_name, COUNT(*) AS 'Count' FROM actor
GROUP BY last_name
HAVING Count > 2;
-- 4c -- 
UPDATE actor 
SET first_name= 'HARPO' WHERE first_name='GROUCHO' AND last_name='WILLIAMS';
-- 4d --
UPDATE actor 
SET first_name= 'GROUCHO'
WHERE first_name='HARPO' AND last_name='WILLIAMS';
-- 5a --
SHOW CREATE TABLE address;
-- 6a --
SELECT staff.first_name, staff.last_name, address.address FROM staff
LEFT JOIN address ON staff.address_id = address.address_id;
-- 6b --
SELECT staff.first_name, staff.last_name, SUM(payment.amount)
FROM staff JOIN payment ON staff.staff_id = payment.staff_id
GROUP BY staff.first_name, staff.last_name;
-- 6c --
SELECT film.title, COUNT(film_actor.actor_id) AS 'Num_Actors'
FROM film LEFT JOIN film_actor  ON film.film_id = film_actor.film_id
GROUP BY film.title;
-- 6d --
-- 2 actors -- 
-- 6e --
SELECT customer.first_name, customer.last_name, SUM(payment.amount)
AS 'Total Amount Paid' FROM customer LEFT JOIN payment 
ON customer.customer_id = payment.customer_id
GROUP BY customer.first_name, customer.last_name
ORDER BY customer.last_name;

-- 7a -- 
SELECT title FROM film
WHERE (
title LIKE 'K%' OR title LIKE 'Q%'
) 
AND language_id = (SELECT language_id FROM language WHERE name='English');

-- 7b -- 
SELECT first_name, last_name FROM actor
WHERE actor_id 
IN(SELECT actor_id FROM film_actor WHERE film_id 
	IN (SELECT film_id from film where title='ALONE TRIP'));
-- 7c -- 
SELECT first_name, last_name, email FROM customer
JOIN address ON (customer.address_id = address.address_id)
JOIN city ON (city.city_id = address.city_id)
JOIN country ON (country.country_id = city.country_id) AND city.country_id = 20;
-- 7d --
SELECT f.title FROM film f
JOIN film_category fc ON (f.film_id = fc.film_id)
JOIN category cat ON (cat.category_id=fc.category_id) AND cat.category_id = 7;
-- 7e -- 
SELECT title, COUNT(f.film_id) AS 'Count_Rented_Movies' FROM  film f
JOIN inventory i ON (f.film_id= i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
GROUP BY title ORDER BY Count_Rented_Movies DESC;
-- 7f -- 
SELECT s.store_id, SUM(p.amount) FROM payment p
JOIN staff s ON (p.staff_id=s.staff_id)
GROUP BY store_id;
-- 7g -- 
SELECT store_id, city, country FROM store s
JOIN address a ON (s.address_id=a.address_id)
JOIN city c ON (a.city_id=c.city_id)
JOIN country cntry ON (c.country_id=cntry.country_id);
-- 7f --
SELECT c.name AS "Top Five", SUM(p.amount) AS "Gross" 
FROM category c
JOIN film_category fc ON (c.category_id=fc.category_id)
JOIN inventory i ON (fc.film_id=i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
JOIN payment p ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;
-- 8a--  
CREATE VIEW Top_five_ AS
SELECT c.name AS "Top Five", SUM(p.amount) AS "Gross" 
FROM category c
JOIN film_category fc ON (c.category_id=fc.category_id)
JOIN inventory i ON (fc.film_id=i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
JOIN payment p ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5; 
 -- 8b -- 
 SELECT * FROM Top_five_;
-- 8c --
 DROP VIEW Top_five_;
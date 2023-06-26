-- Challenge
-- Write SQL queries to perform the following tasks using the Sakila database:

-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.

SELECT f.title, COUNT(i.inventory_id) AS number_of_copies FROM inventory AS i
JOIN film as f
ON i.film_id = f.film_id
WHERE f.title = "Hunchback Impossible"
GROUP BY f.title;

-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.

SELECT * FROM film
WHERE length > ( SELECT AVG(length) FROM film);

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".

SELECT sq_films_actors.first_name, sq_films_actors.last_name FROM 
(SELECT  f.title, a.first_name, a.last_name FROM film AS f
JOIN film_actor AS fa
ON f.film_id = fa.film_id
JOIN actor AS a
ON fa.actor_id = a.actor_id) AS sq_film_actor
WHERE sq_films_actors.title = "Alone Trip";

-- 4. Sales have been lagging among young families, and you want to target family movies for a promotion. 
-- Identify all movies categorized as family films.

SELECT f.film_id, f.title FROM film as f
JOIN film_category as fc
ON f.film_id = fc.film_id
JOIN category as c
ON fc.category_id = c.category_id
WHERE c.name = 'Family';

-- 5. Retrieve the name and email of customers from Canada using both subqueries and joins. 
-- To use joins, you will need to identify the relevant tables and their primary and foreign keys.

-- Using JOINs:

SELECT cu.first_name, cu.last_name, cu.email FROM customer AS cu
JOIN address AS a
ON cu.address_id = a.address_id
JOIN city AS ci
ON a.city_id = ci.city_id
JOIN country as co
ON ci.country_id = co.country_id
WHERE co.country = 'Canada';

-- Using subqueries:

SELECT * FROM 
(SELECT cu.first_name, cu.last_name, cu.email, co.country FROM customer AS cu
JOIN address AS a
ON cu.address_id = a.address_id
JOIN city AS ci
ON a.city_id = ci.city_id
JOIN country as co
ON ci.country_id = co.country_id) as sq_customer_country
WHERE country = 'Canada';

-- 6. Determine which films were starred by the most prolific actor in the Sakila database.
-- A prolific actor is defined as the actor who has acted in the most number of films. 
-- First, you will need to find the most prolific actor and then use that actor_id to find the 
-- different films that he or she starred in.

SELECT * FROM film AS f
JOIN film_actor AS fa
ON f.film_id = fa.film_id
WHERE fa.actor_id =
(SELECT a.actor_id FROM actor AS a
JOIN film_actor AS fa
ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
ORDER BY COUNT(fa.film_id) DESC
LIMIT 1);

-- 7. Find the films rented by the most profitable customer in the Sakila database.
-- You can use the customer and payment tables to find the most 
-- profitable customer, i.e., the customer who has made the largest sum of payments.

SELECT DISTINCT(f.title) FROM rental as r
JOIN inventory AS i
ON r.inventory_id = i.inventory_id
JOIN film AS f
ON i.film_id = f.film_id
WHERE customer_id = 
(SELECT customer_id FROM payment as p
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 1);

-- 8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the 
-- average of the total_amount spent by each client. You can use subqueries to accomplish this.

SELECT customer_id, SUM(amount) AS total_amount_spent 
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > 
(SELECT AVG(cta.total_amount_spent) FROM
(SELECT customer_id, SUM(amount) AS total_amount_spent FROM payment
GROUP BY customer_id) AS cta);

USE sakila;
#1a. Display the first and last names of all actors from the table `actor`.
SELECT * FROM actor LIMIT 5;
SELECT first_name, last_name FROM actor;
#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
SELECT CONCAT(first_name, last_name) AS ActorName FROM actor;
UPDATE actor SET ActorName = UPPER(ActorName);
#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name FROM actor WHERE first_name="Joe";
#2b. Find all actors whose last name contain the letters `GEN`
SELECT * FROM actor WHERE last_name LIKE "%GEN%";
#2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
SELECT * FROM actor WHERE last_name LIKE "%LI%" ORDER BY last_name ASC, first_name ASC;
#2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT * FROM country LIMIT 5;
SELECT country_id, country FROM country WHERE country IN("Afghanistan", "Bangladesh", "China");
#3a. Create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
ALTER TABLE actor ADD description BLOB;
#3b. Delete the `description` column.
ALTER TABLE actor DROP description;
#4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, count(*) FROM actor GROUP BY last_name;
#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, count(last_name) FROM actor GROUP BY last_name HAVING COUNT(last_name) > 1;
#4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
UPDATE actor SET first_name="HARPO" WHERE first_name="GROUCHO" AND last_name="WILLIAMS";
#4d. In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
UPDATE actor SET first_name="GROUCHO" WHERE first_name="HARPO";
#5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE address;
#6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
SELECT staff.first_name, staff.last_name, address.address FROM staff INNER JOIN address ON address.address_id=staff.address_id;
#6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
SELECT staff.first_name, staff.last_name, SUM(payment.amount) FROM staff LEFT JOIN payment ON staff.staff_id=payment.staff_id AND MONTH(payment_date)=8 GROUP BY first_name;
#6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT film.title, COUNT(film_actor.actor_id) FROM film INNER JOIN film_actor ON film.film_id=film_actor.film_id GROUP BY title;
#6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT * FROM film WHERE title="Hunchback Impossible";
SELECT film.title, COUNT(inventory.film_id) FROM film INNER JOIN inventory ON film.film_id=inventory.film_id AND inventory.film_id=439;
#6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT customer.first_name, customer.last_name, SUM(payment.amount) FROM customer INNER JOIN payment ON payment.customer_id=customer.customer_id GROUP BY first_name ORDER BY last_name ASC;
#7a. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
SELECT title FROM film WHERE title LIKE "K%" OR title LIKE "Q%" AND language_id = (SELECT language_id FROM language WHERE name="English");
#7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT first_name, last_name FROM actor WHERE actor_id IN (SELECT actor_id from film_actor WHERE film_id IN (SELECT film_id FROM film WHERE title="Alone Trip"));
#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT first_name, last_name, email FROM customer INNER JOIN address ON customer.address_id=address.address_id INNER JOIN city ON address.city_id=city.city_id INNER JOIN country ON city.country_id=country.country_id AND country.country="Canada";
#7d. Identify all movies categorized as _family_ films.
SELECT title, description FROM film WHERE film_id IN(SELECT film_id FROM film_category WHERE category_id IN(SELECT category_id FROM category WHERE name="Family"));
#7e. Display the most frequently rented movies in descending order.
SELECT title FROM film INNER JOIN inventory ON film.film_id=inventory.inventory_id INNER JOIN rental ON rental.inventory_id=inventory.inventory_id GROUP BY rental.inventory_id ORDER BY COUNT(rental.inventory_id);
#7f. Write a query to display how much business, in dollars, each store brought in.
SELECT store.store_id, SUM(payment.amount) FROM store INNER JOIN inventory ON store.store_id=inventory.store_id INNER JOIN rental ON rental.inventory_id=inventory.inventory_id INNER JOIN payment ON rental.rental_id=payment.rental_id GROUP BY store.store_id;
#7g. Write a query to display for each store its store ID, city, and country.
SELECT store.store_id, city.city, country.country FROM store INNER JOIN address ON store.address_id=address.address_id INNER JOIN city ON city.city_id=address.city_id INNER JOIN country ON city.country_id=country.country_id;
#7h. List the top five genres in gross revenue in descending order.
SELECT category.name, SUM(payment.amount) FROM category INNER JOIN film_category ON category.category_id=film_category.category_id INNER JOIN inventory ON inventory.film_id=film_category.film_id INNER JOIN rental ON rental.inventory_id=inventory.inventory_id INNER JOIN payment ON payment.rental_id=rental.rental_id GROUP BY category.name ORDER BY SUM(payment.amount) DESC LIMIT 5;
#8a. Use the solution from the problem above to create a view.
CREATE VIEW TopFiveRevenueGenres AS SELECT category.name, SUM(payment.amount) FROM category INNER JOIN film_category ON category.category_id=film_category.category_id INNER JOIN inventory ON inventory.film_id=film_category.film_id INNER JOIN rental ON rental.inventory_id=inventory.inventory_id INNER JOIN payment ON payment.rental_id=rental.rental_id GROUP BY category.name ORDER BY SUM(payment.amount) DESC LIMIT 5;
#8b. How would you display the view that you created in 8a?
SELECT * FROM TopFiveRevenueGenres;
#8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW TopFiveRevenueGenres;
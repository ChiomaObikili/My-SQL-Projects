WITH TopCities AS (
    SELECT Cty.city_id
    FROM customer AS Cust
    INNER JOIN address AS Addr ON Cust.address_id = Addr.address_id
    INNER JOIN city AS Cty ON Addr.address_id = Cty.city_id  -- your original join
    GROUP BY Cty.city_id
    ORDER BY COUNT(Cust.customer_id) DESC
    LIMIT 10
),

total_amount_paid_top_5_customers AS (
    SELECT 
        Cust.customer_id,
        Cust.first_name,
        Cust.last_name,
        Cty.city,
        Crty.country,
        SUM(Pay.amount) AS total_amount_paid
    FROM payment AS Pay
    INNER JOIN customer AS Cust ON Pay.customer_id = Cust.customer_id
    INNER JOIN address AS Addr ON Cust.address_id = Addr.address_id
    INNER JOIN city AS Cty ON Addr.city_id = Cty.city_id
    INNER JOIN country AS Crty ON Cty.country_id = Crty.country_id
    WHERE Cty.city_id IN (SELECT city_id FROM TopCities)
    GROUP BY 
        Cust.customer_id,
        Cust.first_name,
        Cust.last_name,
        Cty.city,
        Crty.country
    ORDER BY total_amount_paid DESC
    LIMIT 5
)

SELECT 
    AVG(total_amount_paid) AS average_amount_paid
FROM total_amount_paid_top_5_customers;

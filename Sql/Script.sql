-- Ecommerce

--DROP TABLE IF EXISTS customers, orders, products, order_items, categories;

create table customers (
  customer_id serial primary key,
  name varchar(50),
  email varchar(70)
);

create table orders (
  order_id serial primary key,
  customer_id int, --fk
  order_date date,
  total_amount numeric(10, 2),
  foreign key(customer_id) references customers(customer_id)
);

create table products (
  product_id serial primary key,
  price numeric(10,2),
  product_name varchar(100)
);



create table order_items (
  order_item_id serial primary key,
  order_id int, --fk
  product_id int, --fk
  quantity int,
  foreign key(order_id) references orders(order_id),
  foreign key(product_id) references products(product_id)
);



create table categories (
  category_id serial primary key,
  category_name varchar(100)
);




alter table products add category_id int;

alter table products add foreign key(category_id) references categories(category_id);



-- Insertion

INSERT INTO customers (customer_id, name, email) VALUES
(1, 'John Doe', 'john.doe@example.com'),
(2, 'Jane Smith', 'jane.smith@example.com'),
(3, 'Alice Johnson', 'alice.johnson@example.com'),
(4, 'Bob Brown', 'bob.brown@example.com'),
(5, 'Carol Davis', 'carol.davis@example.com'),
(6, 'David Wilson', 'david.wilson@example.com'),
(7, 'Emily Clark', 'emily.clark@example.com'),
(8, 'Frank Harris', 'frank.harris@example.com'),
(9, 'Grace Lewis', 'grace.lewis@example.com'),
(10, 'Hannah Walker', 'hannah.walker@example.com');



INSERT INTO orders (order_id, customer_id, order_date, total_amount)
VALUES
(1, 1, '2024-08-01', 250.00),
(2, 2, '2024-08-02', 150.50),
(3, 3, '2024-08-03', 99.99),
(4, 4, '2024-08-04', 299.90),
(5, 5, '2024-08-05', 189.75),
(6, 6, '2024-08-06', 349.20),
(7, 7, '2024-08-07', 129.45),
(8, 8, '2024-08-08', 89.99),
(9, 9, '2024-08-09', 499.99),
(10, 10, '2024-08-10', 75.00),
(11, 1, '2024-08-11', 400.50),
(12, 2, '2024-08-12', 220.00),
(13, 3, '2024-08-13', 105.25),
(14, 4, '2024-08-14', 215.30),
(15, 5, '2024-08-15', 310.00);


INSERT INTO categories (category_id, category_name) VALUES
(1, 'Electronics'),
(2, 'Accessories'),
(3, 'Computers'),
(4, 'Office Supplies'),
(5, 'Mobile Devices');


INSERT INTO products (product_id, category_id, product_name, price) VALUES
(1, 1, 'Laptop', 999.99),
(2, 1, 'Smartphone', 499.99),
(3, 1, 'Headphones', 89.99),
(4, 2, 'Keyboard', 45.99),
(5, 2, 'Mouse', 25.99),
(6, 3, 'Monitor', 199.99),
(7, 3, 'Printer', 129.99),
(8, 4, 'Tablet', 349.99),
(9, 2, 'Webcam', 59.99),
(10,2, 'External Hard Drive', 129.99);


INSERT INTO order_items (order_item_id, order_id, product_id,
quantity) VALUES
(1, 1, 1, 1), -- 1 Laptop
(2, 1, 3, 2), -- 2 Headphones
(3, 2, 2, 1), -- 1 Smartphone
(4, 2, 5, 1), -- 1 Mouse
(5, 3, 4, 1), -- 1 Keyboard
(6, 4, 6, 2), -- 2 Monitors
(7, 5, 7, 1), -- 1 Printer
(8, 6, 8, 1), -- 1 Tablet
(9, 7, 9, 1), -- 1 Webcam
(10, 8, 3, 1), -- 1 Headphones
(11, 9, 10, 1), -- 1 External Hard Drive
(12, 10, 2, 1), -- 1 Smartphone
(13, 11, 1, 1), -- 1 Laptop
(14, 12, 6, 1), -- 1 Monitor
(15, 13, 4, 1), -- 1 Keyboard
(16, 14, 8, 1), -- 1 Tablet
(17, 15, 5, 2); -- 2 Mice


-- Query



select c."name", o.total_amount, o.order_date from orders o 
inner join customers c on o.customer_id = c.customer_id;


select p.product_name, c.category_name, p.price from products p inner join categories c on c.category_id = p.category_id;


select p.product_name, p.price, o.total_amount from orders o
inner join order_items oi ON oi.order_id = o.order_id 
inner join products p on p.product_id = oi.product_id where o.order_id = 1;



select c."name", o.total_amount, o.order_date from orders o 
inner join customers c on o.customer_id = c.customer_id where o.total_amount < 100;


-- Get the Total Number of Orders and Total Amount Spent by Each Customer
select count(o.order_id), SUM(o.total_amount) from orders o where customer_id=10;

-- List Products and Their Total Sales Amount
select p.product_name, sum(oi.quantity) as "sale quantity", sum(oi.quantity * p.price) as "Total Sale" from order_items oi 
inner join products p on oi.product_id = p.product_id group by p.product_name;


--Find the Most Expensive Product in Each Category
select c.category_name, Max(p.price) from categories c 
inner join products p on p.category_id = c.category_id group by c.category_id;


-- Create an Index on customer_id in the orders Table

create index idx_customer_id on orders(customer_id);

drop index idx_customer_id;


--Update Product Prices Based on a Percentage Increase
update products set price = price * 1.10;



-- Delete Orders Older Than a Certain Date
insert into orders (order_id, customer_id, order_date, total_amount) values (99,2, '2023-08-01', 1234),(98, 1,'2024-06-02', 908);

delete from orders where order_date < '2024-06-03';


--Create a View to Show Top Selling Products
create View product_sale as 
select p.product_name, sum(p.price * oi.quantity)  from order_items oi
inner join products p on oi.product_id = p.product_id group by p.product_name;
--

--select * from product_sale ps;

--DROP VIEW product_sales;



--Add a New Column to Track Product Stock Quantity
alter table products add column stock_quantity int default 5;


--
select * from order_items oi 
full outer join products p on p.product_id = oi.product_id;



select * from orders o
inner join order_items oi on o.order_id =oi.order_item_id
where o.order_date < CURRENT_DATE - INTERVAL '10 days';



--Find the Top 5 Products by Total Sales Amount
select p.product_name, sum(oi.quantity * p.price) from order_items oi 
inner join products p on oi.product_id = p.product_id group by p.product_name order by sum(oi.quantity * p.price) desc limit 5;


select c.category_name from categories c
left outer join products p  on p.category_id = c.category_id where p.product_id is null ;

select c.customer_id, avg(o.total_amount) from customers c
inner join orders o on o.customer_id = c.customer_id group by c.customer_id;


insert into customers(customer_id, "name", email) values (13, 'demo', 'demo@customer.in');

select c.name, o.order_id from customers c
left join orders o on o.customer_id = c.customer_id where o.order_id is null;




select c.category_name, MAX(p.price) from categories c 
inner join products p on c.category_id = p.category_id group by c.category_name ;


update products set price = price * 0.90;



-- need to delete
select p.product_name from products p
left join order_items oi on p.product_id = oi.product_id
where 
oi.order_item_id is null;



alter table products add column discount_price numeric(10,2);

update products set discount_price = price * 0.90; 

select c."name", c.customer_id from customers c 
inner join orders o on o.customer_id = c.customer_id group by c."name", c.customer_id having count(c.customer_id) > 1;





select c.category_name, sum(p.price * oi.quantity) from order_items oi 
inner join products p on oi.product_id = p.product_id
inner join categories c on p.category_id = c.category_id group by c.category_name;


select p.product_name, p.price from order_items oi 
inner join products p on oi.product_id = p.product_id where p.category_id = 4;


select c."name", max(o.order_date) from order_items oi 
inner join orders o on o.order_id = oi.order_item_id
inner join customers c on c.customer_id = o.customer_id group by c."name";



select c."name", p.product_name, p.price from customers c 
inner join orders o on o.customer_id = c.customer_id
inner join order_items oi on oi.order_id = o.order_id
inner join products p on p.product_id = oi.product_id;









 
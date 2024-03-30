CREATE SCHEMA inventory DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE inventory.user (
  id INT NOT NULL AUTO_INCREMENT,
  roleId SMALLINT NOT NULL,
  firstName VARCHAR(50) NULL DEFAULT NULL,
  middleName VARCHAR(50) NULL DEFAULT NULL,
  lastName VARCHAR(50) NULL DEFAULT NULL,
  username VARCHAR(50) NULL DEFAULT NULL,
  mobile VARCHAR(15) NULL,
  email VARCHAR(50) NULL,
  passwordHash VARCHAR(32) NOT NULL,
  registeredAt DATETIME NOT NULL,
  lastLogin DATETIME NULL DEFAULT NULL,
  intro TINYTEXT NULL DEFAULT NULL,
  profile TEXT NULL DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE INDEX uq_username (username ASC),
  UNIQUE INDEX uq_mobile (mobile ASC),
  UNIQUE INDEX uq_email (email ASC)
);

CREATE TABLE inventory.product (
  id INT NOT NULL AUTO_INCREMENT,
  title VARCHAR(75) NOT NULL,
  summary TINYTEXT NULL,
  type SMALLINT(6) NOT NULL DEFAULT 0,
  createdAt DATETIME NOT NULL,
  updatedAt DATETIME NULL DEFAULT NULL,
  content TEXT NULL DEFAULT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE inventory.product_meta (
  id INT NOT NULL AUTO_INCREMENT,
  productId INT NOT NULL,
  meta_key VARCHAR(50) NOT NULL,
  content TEXT NULL DEFAULT NULL,
  PRIMARY KEY (id),
  INDEX idx_meta_product (productId ASC),
  UNIQUE INDEX uq_product_meta (productId ASC, meta_key ASC),
  CONSTRAINT fk_meta_product
    FOREIGN KEY (productId)
    REFERENCES inventory.product (id)
);

CREATE TABLE inventory.category (
  id INT NOT NULL AUTO_INCREMENT,
  parentId INT NULL DEFAULT NULL,
  title VARCHAR(75) NOT NULL,
  metaTitle VARCHAR(100) NULL DEFAULT NULL,
  slug VARCHAR(100) NOT NULL,
  content TEXT NULL DEFAULT NULL,
  PRIMARY KEY (id),
  INDEX idx_category_parent (parentId ASC),
  CONSTRAINT fk_category_parent
    FOREIGN KEY (parentId)
    REFERENCES inventory.category (id)
);

CREATE TABLE inventory.product_category (
  productId INT NOT NULL,
  categoryId INT NOT NULL,
  PRIMARY KEY (productId, categoryId),
  INDEX idx_pc_category (categoryId ASC),
  INDEX idx_pc_product (productId ASC),
  CONSTRAINT fk_pc_product
    FOREIGN KEY (productId)
    REFERENCES inventory.product (id),
  CONSTRAINT fk_pc_category
    FOREIGN KEY (categoryId)
    REFERENCES inventory.category (id)
);

CREATE TABLE inventory.brand (
  id INT NOT NULL AUTO_INCREMENT,
  title VARCHAR(75) NOT NULL,
  summary TINYTEXT NULL,
  createdAt DATETIME NOT NULL,
  updatedAt DATETIME NULL DEFAULT NULL,
  content TEXT NULL DEFAULT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE inventory.order (
  id INT NOT NULL AUTO_INCREMENT,
  userId INT NOT NULL,
  type SMALLINT(6) NOT NULL DEFAULT 0,
  status SMALLINT(6) NOT NULL DEFAULT 0,
  subTotal FLOAT NOT NULL DEFAULT 0,
  itemDiscount FLOAT NOT NULL DEFAULT 0,
  tax FLOAT NOT NULL DEFAULT 0,
  shipping FLOAT NOT NULL DEFAULT 0,
  total FLOAT NOT NULL DEFAULT 0,
  promo VARCHAR(50) NULL DEFAULT NULL,
  discount FLOAT NOT NULL DEFAULT 0,
  grandTotal FLOAT NOT NULL DEFAULT 0,
  createdAt DATETIME NOT NULL,
  updatedAt DATETIME NULL DEFAULT NULL,
  content TEXT NULL DEFAULT NULL,
  PRIMARY KEY (id),
  INDEX idx_order_user (userId ASC),
  CONSTRAINT fk_order_user
    FOREIGN KEY (userId)
    REFERENCES inventory.user (id)
);

CREATE TABLE inventory.address (
  id INT NOT NULL AUTO_INCREMENT,
  userId INT NULL DEFAULT NULL,
  orderId INT NULL DEFAULT NULL,
  firstName VARCHAR(50) NULL DEFAULT NULL,
  middleName VARCHAR(50) NULL DEFAULT NULL,
  lastName VARCHAR(50) NULL DEFAULT NULL,
  mobile VARCHAR(15) NULL,
  email VARCHAR(50) NULL,
  line1 VARCHAR(50) NULL DEFAULT NULL,
  line2 VARCHAR(50) NULL DEFAULT NULL,
  city VARCHAR(50) NULL DEFAULT NULL,
  province VARCHAR(50) NULL DEFAULT NULL,
  country VARCHAR(50) NULL DEFAULT NULL,
  createdAt DATETIME NOT NULL,
  updatedAt DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (id),
  INDEX idx_address_user (userId ASC),
  CONSTRAINT fk_address_user
    FOREIGN KEY (userId)
    REFERENCES inventory.user (id)
);

CREATE TABLE inventory.item (
  id INT NOT NULL AUTO_INCREMENT,
  productId INT NOT NULL,
  brandId INT NOT NULL,
  supplierId INT NOT NULL,
  orderId INT NOT NULL,
  sku VARCHAR(100) NOT NULL,
  mrp FLOAT NOT NULL DEFAULT 0,
  discount FLOAT NOT NULL DEFAULT 0,
  price FLOAT NOT NULL DEFAULT 0,
  quantity SMALLINT(6) NOT NULL DEFAULT 0,
  sold SMALLINT(6) NOT NULL DEFAULT 0,
  available SMALLINT(6) NOT NULL DEFAULT 0,
  defective SMALLINT(6) NOT NULL DEFAULT 0,
  createdBy INT NOT NULL,
  updatedBy INT DEFAULT NULL,
  createdAt DATETIME NOT NULL,
  updatedAt DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (id),
  INDEX idx_item_product (productId ASC),
  CONSTRAINT fk_item_product
    FOREIGN KEY (productId)
    REFERENCES inventory.product (id)
);

CREATE TABLE inventory.order_item (
  id INT NOT NULL AUTO_INCREMENT,
  productId INT NOT NULL,
  itemId INT NOT NULL,
  orderId INT NOT NULL,
  sku VARCHAR(100) NOT NULL,
  price FLOAT NOT NULL DEFAULT 0,
  discount FLOAT NOT NULL DEFAULT 0,
  quantity SMALLINT(6) NOT NULL DEFAULT 0,
  createdAt DATETIME NOT NULL,
  updatedAt DATETIME NULL DEFAULT NULL,
  content TEXT NULL DEFAULT NULL,
  PRIMARY KEY (id),
  INDEX idx_order_item_product (productId ASC),
  CONSTRAINT fk_order_item_product
    FOREIGN KEY (productId)
    REFERENCES inventory.product (id),
  INDEX idx_order_item_item (itemId ASC),
  CONSTRAINT fk_order_item_item
    FOREIGN KEY (itemId)
    REFERENCES inventory.item (id),
  INDEX idx_order_item_order (orderId ASC),
  CONSTRAINT fk_order_item_order
    FOREIGN KEY (orderId)
    REFERENCES inventory.order (id)
);

CREATE TABLE inventory.transaction (
  id INT NOT NULL AUTO_INCREMENT,
  userId INT NOT NULL,
  orderId INT NOT NULL,
  code VARCHAR(100) NOT NULL,
  type SMALLINT(6) NOT NULL DEFAULT 0,
  mode SMALLINT(6) NOT NULL DEFAULT 0,
  status SMALLINT(6) NOT NULL DEFAULT 0,
  createdAt DATETIME NOT NULL,
  updatedAt DATETIME NULL DEFAULT NULL,
  content TEXT NULL DEFAULT NULL,
  PRIMARY KEY (id),
  INDEX idx_transaction_user (userId ASC),
  CONSTRAINT fk_transaction_user
    FOREIGN KEY (userId)
    REFERENCES inventory.user (id),
INDEX idx_transaction_order (orderId ASC),
CONSTRAINT fk_transaction_order
  FOREIGN KEY (orderId)
  REFERENCES inventory.order (id)
);
INSERT INTO inventory.user (roleId, firstName, middleName, lastName, username, mobile, email, passwordHash, registeredAt)
VALUES
(1, 'John', 'A.', 'Doe', 'johndoe1', '1234567890', 'john.doe1@example.com', MD5('password123'), NOW()),
(2, 'Jane', 'B.', 'Smith', 'janesmith2', '1234567891', 'jane.smith2@example.com', MD5('password123'), NOW()),
(3, 'Alice', 'C.', 'Johnson', 'alicejohnson3', '1234567892', 'alice.johnson3@example.com', MD5('password123'), NOW()),
(4, 'Bob', 'D.', 'Jones', 'bobjones4', '1234567893', 'bob.jones4@example.com', MD5('password123'), NOW()),
(5, 'Charlie', 'E.', 'Brown', 'charliebrown5', '1234567894', 'charlie.brown5@example.com', MD5('password123'), NOW()),
(6, 'Daisy', 'F.', 'Miller', 'daisymiller6', '1234567895', 'daisy.miller6@example.com', MD5('password123'), NOW()),
(7, 'Ethan', 'G.', 'Wilson', 'ethanwilson7', '1234567896', 'ethan.wilson7@example.com', MD5('password123'), NOW()),
(8, 'Fiona', 'H.', 'Davis', 'fionadavis8', '1234567897', 'fiona.davis8@example.com', MD5('password123'), NOW()),
(9, 'George', 'I.', 'Anderson', 'georgeanderson9', '1234567898', 'george.anderson9@example.com', MD5('password123'), NOW()),
(10, 'Hannah', 'J.', 'Thomas', 'hannahthomas10', '1234567899', 'hannah.thomas10@example.com', MD5('password123'), NOW());
INSERT INTO inventory.category (parentId, title, metaTitle, slug, content)
VALUES
(NULL, 'Electronics', 'Electronics Meta', 'electronics', 'All electronic items'),
(NULL, 'Books', 'Books Meta', 'books', 'All kinds of books'),
(NULL, 'Home Appliances', 'Home Appliances Meta', 'home-appliances', 'Essential home appliances'),
(NULL, 'Fashion', 'Fashion Meta', 'fashion', 'Latest fashion trends'),
(NULL, 'Toys', 'Toys Meta', 'toys', 'Toys for children of all ages'),
(NULL, 'Sports', 'Sports Meta', 'sports', 'Sports equipment and accessories'),
(NULL, 'Gardening', 'Gardening Meta', 'gardening', 'Gardening tools and plants'),
(NULL, 'Music', 'Music Meta', 'music', 'Musical instruments and music albums'),
(NULL, 'Groceries', 'Groceries Meta', 'groceries', 'Daily groceries'),
(NULL, 'Automotive', 'Automotive Meta', 'automotive', 'Automotive parts and accessories');
INSERT INTO inventory.product (title, summary, type, createdAt)
VALUES
('Laptop X200', 'A powerful laptop for professionals', 1, NOW()),
('The Great Gatsby', 'Classic novel by F. Scott Fitzgerald', 1, NOW()),
('Microwave Oven', 'Compact microwave oven for quick meals', 1, NOW()),
('Leather Jacket', 'Fashionable leather jacket in black', 1, NOW()),
('Action Figure', 'Superhero action figure with movable joints', 1, NOW()),
('Tennis Racket', 'Professional grade tennis racket', 1, NOW()),
('Gardening Shovel', 'Sturdy shovel for all gardening needs', 1, NOW()),
('Electric Guitar', 'Six-string electric guitar for beginners and pros', 1, NOW()),
('Organic Honey', '100% pure organic honey', 1, NOW()),
('Car Tire', 'All-weather car tire for enhanced grip', 1, NOW());
INSERT INTO inventory.product_meta (productId, meta_key, content) VALUES
(1, 'spec', '16GB RAM, 512GB SSD'),
(1, 'author', 'F. Scott Fitzgerald'),
(1, 'power', '700W'),
(1, 'material', 'Genuine leather'),
(1, 'height', '12 inches'),
(1, 'weight', '250 grams'),
(2, 'author', 'F. Scott Fitzgerald'),
(3, 'power', '700W'),
(4, 'material', 'Genuine leather'),
(5, 'height', '12 inches'),
(6, 'weight', '250 grams'),
(7, 'material', 'Stainless steel'),
(8, 'strings', '6'),
(9, 'origin', 'Himalayas'),
(10, 'size', '17 inches');


INSERT INTO inventory.product_category (productId, categoryId)
VALUES
(1, 1), -- Laptop to Electronics
(2, 2), -- The Great Gatsby to Books
(3, 3), -- Microwave Oven to Home Appliances
(4, 4), -- Leather Jacket to Fashion
(5, 5), -- Action Figure to Toys
(6, 6), -- Tennis Racket to Sports
(7, 7), -- Gardening Shovel to Gardening
(8, 8), -- Electric Guitar to Music
(9, 9), -- Organic Honey to Groceries
(10, 10); -- Car Tire to Automotive
INSERT INTO inventory.brand (title, summary, createdAt)
VALUES
('Tech Innovators', 'Leading technology products', NOW()),
('Classic Reads', 'Timeless books and novels', NOW()),
('HomeEssentials', 'Reliable home appliances', NOW()),
('FashionForward', 'Trendsetting fashion apparel', NOW()),
('Toy Universe', 'Fun and educational toys for kids', NOW()),
('SportsMaster', 'High-quality sports equipment', NOW()),
('GreenThumb', 'Everything for your gardening needs', NOW()),
('MusicMakers', 'Instruments and gear for musicians', NOW()),
('HealthyFoods', 'Organic and healthy food options', NOW()),
('AutoParts', 'Quality automotive parts and accessories', NOW());
INSERT INTO inventory.order (userId, type, status, subTotal, itemDiscount, tax, shipping, total, discount, grandTotal, createdAt)
VALUES
(1, 1, 1, 1000, 50, 100, 20, 1070, 0, 1070, NOW()),
(2, 1, 1, 500, 0, 50, 15, 565, 0, 565, NOW()),
(3, 1, 2, 800, 0, 80, 25, 905, 0, 905, NOW()),
(4, 1, 2, 1500, 100, 150, 30, 1580, 0, 1580, NOW()),
(5, 1, 1, 200, 10, 20, 10, 220, 0, 220, NOW()),
(6, 1, 1, 950, 0, 95, 20, 1065, 0, 1065, NOW()),
(7, 1, 2, 700, 70, 70, 15, 720, 0, 720, NOW()),
(8, 1, 1, 400, 0, 40, 10, 450, 0, 450, NOW()),
(9, 1, 2, 300, 0, 30, 12, 342, 0, 342, NOW()),
(10, 1, 1, 1200, 0, 120, 50, 1370, 0, 1370, NOW());
INSERT INTO inventory.address (userId, firstName, lastName, mobile, email, line1, city, country, createdAt) VALUES
(1, 'John', 'Doe', '1234567890', 'john.doe@example.com', '123 Baker Street', 'New York', 'USA', NOW()),
(2, 'Jane', 'Smith', '2345678901', 'jane.smith@example.com', '234 Oak Street', 'Los Angeles', 'USA', NOW()),
(3, 'Emily', 'Jones', '3456789012', 'emily.jones@example.com', '345 Pine Street', 'Chicago', 'USA', NOW()),
(4, 'Michael', 'Brown', '4567890123', 'michael.brown@example.com', '456 Maple Street', 'Houston', 'USA', NOW()),
(5, 'Jessica', 'Davis', '5678901234', 'jessica.davis@example.com', '567 Cedar Street', 'Phoenix', 'USA', NOW()),
(6, 'William', 'Martinez', '6789012345', 'william.martinez@example.com', '678 Birch Street', 'Philadelphia', 'USA', NOW()),
(7, 'Elizabeth', 'Garcia', '7890123456', 'elizabeth.garcia@example.com', '789 Elm Street', 'San Antonio', 'USA', NOW()),
(8, 'David', 'Wilson', '8901234567', 'david.wilson@example.com', '890 Oak Street', 'San Diego', 'USA', NOW()),
(9, 'Sophia', 'Anderson', '9012345678', 'sophia.anderson@example.com', '901 Pine Street', 'Dallas', 'USA', NOW()),
(10, 'James', 'Thomas', '0123456789', 'james.thomas@example.com', '101 Maple Street', 'San Jose', 'USA', NOW());
INSERT INTO inventory.item (productId, brandId, supplierId, sku, mrp, discount, price, quantity, available, defective, createdBy, createdAt) VALUES
(1, 1, 1, 'SKU-001', 100, 10, 90, 100, 90, 0, 1, NOW()),
(1, 1, 1, 'SKU-002', 200, 20, 180, 100, 80, 0, 1, NOW()),
(1, 1, 1, 'SKU-003', 300, 30, 270, 100, 70, 0, 1, NOW()),
(1, 1, 1, 'SKU-004', 400, 40, 360, 100, 60, 0, 1, NOW()),
(1, 1, 1, 'SKU-005', 500, 50, 450, 100, 50, 0, 1, NOW()),
(1, 1, 1, 'SKU-006', 600, 60, 540, 100, 40, 0, 1, NOW()),
(1, 1, 1, 'SKU-007', 700, 70, 630, 100, 30, 0, 1, NOW()),
(1, 1, 1, 'SKU-008', 800, 80, 720, 100, 20, 0, 1, NOW()),
(1, 1, 1, 'SKU-009', 900, 90, 810, 100, 10, 0, 1, NOW()),
(1, 1, 1, 'SKU-010', 1000, 100, 900, 100, 0, 0, 1, NOW());

INSERT INTO inventory.transaction (userId, orderId, amount, status, createdAt) VALUES
(1, 1, 180, 'completed', NOW()),
(2, 2, 180, 'completed', NOW()),
(3, 3, 270, 'completed', NOW()),
(4, 4, 720, 'completed', NOW()),
(5, 5, 450, 'completed', NOW()),
(6, 6, 1080, 'completed', NOW()),
(7, 7, 630, 'completed', NOW()),
(8, 8, 1440, 'completed', NOW()),
(9, 9, 810, 'completed', NOW()),
(10, 10, 1800, 'completed', NOW());
INSERT INTO inventory.transaction (userId, orderId, code, status, createdAt) VALUES
(1, 1, 'DEFAULT_CODE_1', 0, NOW()), 
(2, 2, 'DEFAULT_CODE_2', 0, NOW()),
(3, 3, 'DEFAULT_CODE_3', 0, NOW()),
(4, 4, 'DEFAULT_CODE_4', 0, NOW()),
(5, 5, 'DEFAULT_CODE_5', 0, NOW()),
(6, 6, 'DEFAULT_CODE_6', 0, NOW()),
(7, 7, 'DEFAULT_CODE_7', 0, NOW()),
(8, 8, 'DEFAULT_CODE_8', 0, NOW()),
(9, 9, 'DEFAULT_CODE_9', 0, NOW()),
(10, 10, 'DEFAULT_CODE_10', 0, NOW());
INSERT INTO inventory.order_item (productId, itemId, orderId, sku, price, quantity, createdAt) VALUES
(1, 1, 1, 'SKU-001', 90, 2, NOW()),
(2, 2, 2, 'SKU-002', 180, 1, NOW()),
(3, 3, 3, 'SKU-003', 270, 1, NOW()),
(4, 4, 4, 'SKU-004', 360, 2, NOW()),
(5, 5, 5, 'SKU-005', 450, 1, NOW()),
(6, 6, 6, 'SKU-006', 540, 2, NOW()),
(7, 7, 7, 'SKU-007', 630, 1, NOW()),
(8, 8, 8, 'SKU-008', 720, 2, NOW()),
(9, 9, 9, 'SKU-009', 810, 1, NOW()),
(10, 10, 10, 'SKU-010', 900, 2, NOW());

INSERT INTO inventory.product_meta (productId, meta_key, content) VALUES
(1, 'color', 'Red'),
(1, 'size', 'M'),
(2, 'color', 'Blue'),
(2, 'material', 'Cotton'),
(3, 'color', 'Green'),
(3, 'warranty', '1 year'),
(4, 'color', 'Black'),
(4, 'size', 'L'),
(5, 'color', 'White'),
(5, 'style', 'Modern');

INSERT INTO inventory.product_meta (productId, meta_key, content) VALUES
(6, 'color', 'Yellow'),
(6, 'fabric', 'Polyester'),
(7, 'color', 'Pink'),
(7, 'weight', '200g'),
(8, 'color', 'Violet'),
(8, 'dimension', '10x5 inches'),
(9, 'color', 'Gray'),
(9, 'usage', 'Outdoor'),
(10, 'color', 'Navy Blue'),
(10, 'pattern', 'Striped');

SELECT userId, COUNT(*) AS total_orders
FROM inventory.order
GROUP BY userId;

SELECT userId, AVG(total) AS average_order_value
FROM inventory.order
GROUP BY userId;

SELECT userId, SUM(total) AS total_spent
FROM inventory.order
GROUP BY userId
HAVING total_spent > 1000;

SELECT MONTH(createdAt) AS month, COUNT(*) AS total_orders
FROM inventory.order
GROUP BY month
ORDER BY total_orders DESC
LIMIT 1;

SELECT p.*
FROM inventory.product p
LEFT JOIN inventory.order_item oi ON p.id = oi.productId
WHERE oi.id IS NULL;

SELECT o.*
FROM inventory.order o
JOIN inventory.user u ON o.userId = u.id
WHERE u.registeredAt < DATE_SUB(NOW(), INTERVAL 6 MONTH);

SELECT u.id, u.firstName, o.total_orders
FROM inventory.user u
JOIN (SELECT userId, COUNT(*) AS total_orders FROM inventory.order GROUP BY userId) o
ON u.id = o.userId;

SELECT p.id, p.title, GROUP_CONCAT(c.title) AS categories
FROM inventory.product p
JOIN inventory.product_category pc ON p.id = pc.productId
JOIN inventory.category c ON pc.categoryId = c.id
GROUP BY p.id;

SELECT c.id, c.title, COUNT(pc.productId) AS total_products
FROM inventory.category c
JOIN inventory.product_category pc ON c.id = pc.categoryId
GROUP BY c.id
ORDER BY total_products DESC
LIMIT 5;

SELECT o.id AS order_id, u.id AS user_id, u.firstName, u.lastName, o.createdAt AS order_date, t.code AS transaction_code
FROM inventory.order o
INNER JOIN inventory.user u ON o.userId = u.id
LEFT JOIN inventory.transaction t ON o.id = t.orderId;

SELECT u.id AS user_id, u.firstName, COUNT(o.id) AS total_orders
FROM inventory.user u
LEFT JOIN inventory.order o ON u.id = o.userId
GROUP BY u.id
HAVING COUNT(o.id) > 3;

SELECT o.id AS order_id, u.id AS user_id, u.firstName, u.lastName, a.line1, a.city, a.country
FROM inventory.order o
INNER JOIN inventory.user u ON o.userId = u.id
LEFT JOIN inventory.address a ON u.id = a.userId;

SELECT p.id AS product_id, p.title AS product_title, SUM(oi.quantity) AS total_items_sold, SUM(oi.price * oi.quantity) AS total_revenue
FROM inventory.product p
LEFT JOIN inventory.order_item oi ON p.id = oi.productId
GROUP BY p.id;

SELECT u.id, u.firstName, u.lastName
FROM inventory.user u
JOIN inventory.order o ON u.id = o.userId
JOIN (
    SELECT orderId, SUM(quantity) AS total_quantity
    FROM inventory.order_item
    GROUP BY orderId
) AS oi ON o.id = oi.orderId
WHERE oi.total_quantity > 10;

SELECT t.userId, COUNT(t.id) AS transaction_count
FROM inventory.transaction t
JOIN (
    SELECT userId
    FROM inventory.transaction
    WHERE status = 'completed'
) AS completed_transactions ON t.userId = completed_transactions.userId
JOIN (
    SELECT userId
    FROM inventory.transaction
    WHERE status = 'failed'
) AS failed_transactions ON t.userId = failed_transactions.userId
GROUP BY t.userId
HAVING transaction_count > 1;
















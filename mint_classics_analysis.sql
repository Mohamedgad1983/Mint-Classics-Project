-- Step 1: Inventory Overview
-- List all products and their current inventory levels
SELECT productCode, productName, quantityInStock
FROM products
ORDER BY quantityInStock DESC;

-- Step 2: Identify Where Items Are Stored
-- Identify where items are stored
SELECT p.productCode, p.productName, w.warehouseCode, w.warehouseName, w.warehouseCap, p.quantityInStock
FROM products p
JOIN warehouses w ON p.warehouseCode = w.warehouseCode
ORDER BY w.warehouseCode;

-- Step 3: Compare Inventory Levels with Sales Figures
-- Compare inventory levels with sales figures to identify overstocked items
SELECT p.productCode, p.productName, p.quantityInStock, SUM(od.quantityOrdered) AS totalSold
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productCode, p.productName, p.quantityInStock
ORDER BY p.quantityInStock DESC;

-- Step 4: Identify Low-Turnover Items
-- Identify items with low sales figures
SELECT p.productCode, p.productName, SUM(od.quantityOrdered) AS totalSold
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productCode, p.productName
HAVING totalSold < 50  -- Adjust threshold as needed
ORDER BY totalSold ASC;

-- Step 5: Identify Items with Minimal or No Sales
-- Identify items with minimal or no sales
SELECT p.productCode, p.productName, SUM(od.quantityOrdered) AS totalSold
FROM products p
LEFT JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productCode, p.productName
HAVING totalSold = 0
ORDER BY totalSold ASC;

-- Step 6: Recommendations for Consolidation and Reduction
-- Script for Inventory Consolidation (Example)
-- Move inventory from one warehouse to another (hypothetical example)
UPDATE products
SET warehouseCode = 'WH2'  -- Target warehouse
WHERE warehouseCode = 'WH1' AND quantityInStock < 100;  -- Source warehouse and condition

-- Script for Inventory Reduction (Example)
-- Discontinue items with low sales (hypothetical example)
DELETE FROM products
WHERE productCode IN (
    SELECT p.productCode
    FROM products p
    JOIN orderdetails od ON p.productCode = od.productCode
    GROUP BY p.productCode
    HAVING SUM(od.quantityOrdered) < 50  -- Adjust threshold as needed
);

-- Additional queries for analysis can be added as needed

-- ============================================================
-- Proyecto: Supply Chain Dashboard – DataCo Global
-- Descripción: Script for transforming raw dates into a SQL schema
-- Autor: Oscar Davila
-- Fecha: 2026
-- ============================================================

-- ============================================================
-- 1. DIMENSIÓN: CLIENTES (dim_customers)
-- ============================================================
DROP TABLE IF EXISTS dim_customers;

CREATE TABLE dim_customers AS
SELECT DISTINCT
    "Customer Id" AS customer_id,
    "Customer Fname" AS first_name,
    "Customer Lname" AS last_name,
    "Customer Segment" AS customer_segment,
    "Customer City" AS customer_city,
    "Customer State" AS customer_state,
    "Customer Country" AS customer_country
FROM raw_supply_chain;

ALTER TABLE dim_customers ADD PRIMARY KEY (customer_id);

-- ============================================================
-- 2. DIMENSIÓN: PRODUCTOS (dim_products)
-- ============================================================
DROP TABLE IF EXISTS dim_products;

CREATE TABLE dim_products AS
SELECT DISTINCT
    "Product Card Id" AS product_id,
    "Category Id" AS category_id,
    "Category Name" AS category_name,
    "Product Name" AS product_name,
    "Product Price" AS product_price
FROM raw_supply_chain;

ALTER TABLE dim_products ADD PRIMARY KEY (product_id);

-- ============================================================
-- 3. DIMENSIÓN: ENVÍOS (dim_shipments)
-- ============================================================
DROP TABLE IF EXISTS dim_shipments;

CREATE TABLE dim_shipments AS
SELECT DISTINCT
    "Order Item Id" AS order_item_id,
    "Shipping Mode" AS shipping_mode,
    "Days for shipping (real)" AS real_shipping_days,
    "Days for shipment (scheduled)" AS scheduled_shipping_days,
    "Delivery Status" AS delivery_status,
    "Late_delivery_risk" AS late_risk
FROM raw_supply_chain;

ALTER TABLE dim_shipments ADD PRIMARY KEY (order_item_id);

-- ============================================================
-- 4. TABLA DE HECHOS: ÓRDENES (fact_orders)
-- ============================================================
DROP TABLE IF EXISTS fact_orders;

CREATE TABLE fact_orders AS
SELECT 
    "Order Item Id" AS order_item_id,
    "Order Id" AS order_id,
    "Customer Id" AS customer_id,
    "Product Card Id" AS product_id,
    "Order Item Quantity" AS quantity,
    "Product Price" AS product_price,
    "Sales" AS gross_sales,
    "Order Item Total" AS net_sales,
    "Order Item Profit Ratio" AS profit_margin,
    "Order Profit Per Order" AS profit,
    "Order Item Discount" AS discount_amount,
    "Order City" AS order_city,
    "Order State" AS order_state,
    "Order Country" AS order_country,
    "Order Region" AS order_region,
    "Market" AS market
FROM raw_supply_chain;

ALTER TABLE fact_orders ADD PRIMARY KEY (order_item_id);

-- ============================================================
-- 5. TRANSFORMACIÓN: FECHAS
-- Convierte las fechas de texto a timestamp
-- ============================================================
UPDATE fact_orders f
SET 
    order_date = TO_TIMESTAMP(r."order date (DateOrders)", 'MM/DD/YYYY HH24:MI'),
    shipping_date = TO_TIMESTAMP(r."shipping date (DateOrders)", 'MM/DD/YYYY HH24:MI')
FROM raw_supply_chain r
WHERE f.order_item_id = r."Order Item Id";

-- ============================================================
-- 6. VALIDACIÓN: VERIFICAR FECHAS
-- ============================================================
SELECT order_id, order_date, shipping_date 
FROM fact_orders 
ORDER BY order_date ASC 
LIMIT 10;

-- ============================================================
-- 7. VALIDACIÓN: VERIFICAR ÓRDENES CON MÚLTIPLES ITEMS
-- ============================================================
SELECT 
    f.order_id,
    COUNT(DISTINCT f.order_item_id) AS total_items,
    COUNT(DISTINCT s.shipping_mode) AS distinct_shipping_modes,
    COUNT(DISTINCT s.delivery_status) AS distinct_delivery_statuses,
    COUNT(DISTINCT s.real_shipping_days) AS distinct_real_days
FROM fact_orders AS f
INNER JOIN dim_shipments AS s 
    ON f.order_item_id = s.order_item_id
GROUP BY f.order_id
HAVING COUNT(DISTINCT f.order_item_id) > 1
LIMIT 20;

-- ============================================================
-- FIN DEL SCRIPT
-- ============================================================

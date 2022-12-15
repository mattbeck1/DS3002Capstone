# ===================================================================================
# How to Integrate a Dimension table. In other words, how to look-up Foreign Key
# values FROM a dimension table and add them to new Fact table columns.
#
# First, go to Edit -> Preferences -> SQL Editor and disable 'Safe Edits'.
# Close SQL Workbench and Reconnect to the Server Instance.
# ===================================================================================

USE classicmodel_dw;

# ==============================================================
# Step 1: Add New Column(s)
# ==============================================================
ALTER TABLE classicmodel_dw.fact_table
ADD COLUMN order_date_key int NOT NULL AFTER orderDate,
ADD COLUMN shipped_date_key int NOT NULL AFTER shippedDate,
ADD COLUMN required_date_key int NOT NULL AFTER requiredDate;

# ==============================================================
# Step 2: Update New Column(s) with value from Dimension table
#         WHERE Business Keys in both tables match.
# ==============================================================
UPDATE classicmodel_dw.fact_table AS fo
JOIN classicmodel_dw.dim_date AS dd
ON DATE(fo.orderDate) = dd.full_date
SET fo.order_date_key = dd.date_key;

UPDATE classicmodel_dw.fact_table AS fo
JOIN classicmodel_dw.dim_date AS dd
ON DATE(fo.shippedDate) = dd.full_date
SET fo.shipped_date_key = dd.date_key;

UPDATE classicmodel_dw.fact_table AS fo
JOIN classicmodel_dw.dim_date AS dd
ON DATE(fo.requiredDate) = dd.full_date
SET fo.required_date_key = dd.date_key;

# ==============================================================
# Step 3: Validate that newly updated columns contain valid data
# ==============================================================
SELECT orderDate
	, order_date_key
    , shippedDate
	, shipped_date_key
    , requiredDate
    , required_date_key
FROM classicmodel_dw.fact_table
LIMIT 10;

# =============================================================
# Step 4: If values are correct then drop old column(s)
# =============================================================
ALTER TABLE classicmodel_dw.fact_table
DROP COLUMN orderDate,
DROP COLUMN shippedDate,
DROP COLUMN requiredDate;

# =============================================================
# Step 5: Validate Finished Fact Table.
# =============================================================
SELECT * FROM classicmodel_dw.fact_table
LIMIT 10;




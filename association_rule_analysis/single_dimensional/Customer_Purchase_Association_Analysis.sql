-- Define the Customer base data
WITH Customer AS (
    SELECT *
    FROM UNNEST([
      STRUCT (1 AS Customer_ID, 25 AS Age, 'Male' AS Gender, 'Student' AS Occupation, TRUE AS Laptop_Purchased, TRUE AS Webcam_Purchased, 15000 AS Income),
      STRUCT (2, 35, 'Female', 'Engineer', TRUE, FALSE, 60000),
      STRUCT (3, 45, 'Male', 'Doctor', TRUE, TRUE, 120000),
      STRUCT (4, 30, 'Female', 'Teacher', FALSE, FALSE, 50000),
      STRUCT (5, 28, 'Male', 'Artist', TRUE, TRUE, 40000),
      STRUCT (6, 50, 'Female', 'Lawyer', TRUE, FALSE, 80000),
      STRUCT (7, 23, 'Male', 'Student', TRUE, FALSE, 10000),
      STRUCT (8, 40, 'Female', 'Engineer', FALSE, FALSE, 70000),
      STRUCT (9, 32, 'Male', 'Doctor', TRUE, TRUE, 110000),
      STRUCT (10, 27, 'Female', 'Teacher', FALSE, TRUE, 45000),
      STRUCT (11, 38, 'Male', 'Artist', TRUE, FALSE, 35000),
      STRUCT (12, 42, 'Female', 'Lawyer', TRUE, TRUE, 95000),
      STRUCT (13, 26, 'Male', 'Student', FALSE, TRUE, 8000),
      STRUCT (14, 33, 'Female', 'Engineer', TRUE, FALSE, 65000),
      STRUCT (15, 47, 'Male', 'Doctor', TRUE, TRUE, 130000),
      STRUCT (16, 29, 'Female', 'Teacher', FALSE, FALSE, 48000),
      STRUCT (17, 36, 'Male', 'Artist', TRUE, TRUE, 37000),
      STRUCT (18, 43, 'Female', 'Lawyer', FALSE, TRUE, 90000),
      STRUCT (19, 31, 'Male', 'Student', TRUE, FALSE, 12000),
      STRUCT (20, 39, 'Female', 'Engineer', TRUE, TRUE, 72000)
      ]) AS Customer
),
-- Calculate total customers, those who purchased laptop and those who purchased both laptop and webcam
Measures AS (

    SELECT
        COUNT(*) AS total_customers,
        COUNT(
            CASE
                WHEN Laptop_Purchased = TRUE THEN 1
            END
        ) AS purchased_laptop,
        COUNT(
            CASE
                WHEN Laptop_Purchased = TRUE AND Webcam_Purchased = TRUE THEN 1
            END
        ) AS purchased_laptop_and_webcam
    FROM Customer
),
-- Single-dimensional association rule analysis
-- Rule: If a customer buys a laptop, then they buy a webcam
-- Support: How frequently the rule occurs in the dataset
-- Confidence: Probability that a customer buying a laptop also buys a webcam
single_dimensional_analysis AS (

    SELECT
        'buys(X "laptop") => buys(X, "webcam")' AS rule,
        FORMAT(
            "%.2f%%",
            purchased_laptop_and_webcam * 100/ total_customers
        )  AS support,
        FORMAT(
            "%.2f%%",
            purchased_laptop_and_webcam * 100 / purchased_laptop
        ) AS confidence
    FROM Measures

)

SELECT * FROM single_dimensional_analysis
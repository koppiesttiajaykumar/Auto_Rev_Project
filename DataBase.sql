-- ------------ Create New Database ------------
CREATE DATABASE IF NOT EXISTS automation_rev;
USE automation_rev;


-- ------------ Create TestResults Table ------------
CREATE TABLE IF NOT EXISTS TestResults (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    ClassName VARCHAR(255),
    TestCaseName VARCHAR(500),
    Status VARCHAR(50),
    TestCase VARCHAR(255),
    ModuleName VARCHAR(255),
    SuiteName VARCHAR(255),
    OperatingBrowser VARCHAR(100),
    BuildNo VARCHAR(100),
    TimeInSeconds DECIMAL(10,2),
    Environment VARCHAR(100),
    TestDate DATETIME,
    ToolName VARCHAR(50)
);

ALTER TABLE TestResults
ADD COLUMN AutomationOwner VARCHAR(255);

-- Step 1: Add the missing column to the existing table structure
ALTER TABLE TestResults 
ADD COLUMN AutomationOwner VARCHAR(100) AFTER ToolName;


-- ------------ Insert Data IN Table ------------
INSERT INTO TestResults
(ClassName, TestCaseName, Status, TestCase, ModuleName, SuiteName,
 OperatingBrowser, BuildNo, TimeInSeconds, Environment, TestDate, ToolName)
VALUES
('LoginClass','TC_Login_001','PASS','Verify Login','Login','Smoke','Chrome','1.0.0',12.50,'QA',NOW(),'Tosca'),
('LoginClass','TC_Login_002','FAIL','Invalid Login','Login','Smoke','Chrome','1.0.0',10.20,'QA',NOW(),'Tosca'),
('UserClass','TC_User_001','PASS','Create User','User','Regression','Edge','1.0.0',18.40,'QA',NOW(),'Tosca'),
('UserClass','TC_User_002','PASS','Delete User','User','Regression','Chrome','1.0.0',15.70,'QA',NOW(),'Tosca'),
('OrderClass','TC_Order_001','FAIL','Create Order','Order','Regression','Firefox','1.0.0',20.60,'QA',NOW(),'Tosca'),
('LoginClass','TC_Login_003','PASS','Login Validation','Login','Smoke','Chrome','2.0.0','11.30','QA',NOW(),'Selenium'),
('ProductClass','TC_Product_001','PASS','Add Product','Product','Regression','Edge','2.0.0',16.80,'QA',NOW(),'Selenium'),
('ProductClass','TC_Product_002','FAIL','Delete Product','Product','Regression','Chrome','2.0.0',19.10,'QA',NOW(),'Selenium'),
('CartClass','TC_Cart_001','PASS','Add To Cart','Cart','Smoke','Firefox','2.0.0',13.50,'QA',NOW(),'Selenium'),
('PaymentClass','TC_Payment_001','PASS','Payment Success','Payment','Regression','Chrome','2.0.0',22.90,'QA',NOW(),'Selenium');


-- ------------ Insert Data IN Table if pass and Fail ------------
INSERT INTO TestResults
(ClassName, TestCaseName, Status, TestCase, ModuleName, SuiteName,
OperatingBrowser, BuildNo, TimeInSeconds, Environment, TestDate, ToolName)
VALUES
('Authentication','TC_AUTH_001','FAIL','Verify User Login','Authentication','Smoke','Chrome','1.0.2',12.10,'QA',NOW(),'Tosca'),
('Customer','TC_CUST_001','FAIL','Create Customer','Customer','Regression','Edge','1.1.2',16.80,'QA',NOW(),'Tosca'),
('Inventory','TC_INV_001','FAIL','Validate Inventory','Inventory','Regression','Firefox','1.2.0',18.40,'QA',NOW(),'Tosca'),
('Order','TC_ORDER_001','PASS','Place Order','Order','Smoke','Chrome','1.3.1',14.20,'QA',NOW(),'Tosca'),
('Payment','TC_PAY_001','FAIL','Payment Validation','Payment','Regression','Edge','1.4.0',20.50,'QA',NOW(),'Tosca');

INSERT INTO TestResults
(ClassName, TestCaseName, Status, TestCase, ModuleName, SuiteName,
OperatingBrowser, BuildNo, TimeInSeconds, Environment, TestDate, ToolName)
VALUES
('Authentication','TC_AUTH_001','FAIL','Verify User Login','Authentication','Smoke','Chrome','1.0.2',12.10,'QA','2026-07-06 09:00:00','Tosca'),
('Customer','TC_CUST_001','FAIL','Create Customer','Customer','Regression','Edge','1.1.2',16.80,'QA','2026-07-06 09:15:00','Tosca'),
('Inventory','TC_INV_001','PASS','Validate Inventory','Inventory','Regression','Firefox','1.2.0',18.40,'QA','2026-07-06 09:30:00','Tosca'),
('Order','TC_ORDER_001','PASS','Place Order','Order','Smoke','Chrome','1.3.1',14.20,'QA','2026-07-06 09:45:00','Tosca'),
('Payment','TC_PAY_001','FAIL','Payment Validation','Payment','Regression','Edge','1.4.0',20.50,'QA','2026-07-06 10:00:00','Tosca');

INSERT INTO TestResults
(ClassName, TestCaseName, Status, TestCase, ModuleName, SuiteName,
OperatingBrowser, BuildNo, TimeInSeconds, Environment, TestDate, ToolName)
VALUES
('Authentication','TC_AUTH_001','FAIL','Verify User Login','Authentication','Smoke','Chrome','1.0.2',12.10,'QA','2026-07-08 09:00:00','Tosca'),
('Customer','TC_CUST_001','FAIL','Create Customer','Customer','Regression','Edge','1.1.2',16.80,'QA','2026-07-08 09:15:00','Tosca'),
('Inventory','TC_INV_001','FAIL','Validate Inventory','Inventory','Regression','Firefox','1.2.0',18.40,'QA','2026-07-08 09:30:00','Tosca'),
('Order','TC_ORDER_001','PASS','Place Order','Order','Smoke','Chrome','1.3.1',14.20,'QA','2026-07-08 09:45:00','Tosca'),
('Payment','TC_PAY_001','FAIL','Payment Validation','Payment','Regression','Edge','1.4.0',20.50,'QA','2026-07-08 10:00:00','Tosca');


-- ------------ Print Table Database ------------
SELECT * FROM TestResults;


-- ------------ Procedure For BulkCSV Upload ------------
DELIMITER $$

DROP PROCEDURE IF EXISTS InsertTestResult $$

CREATE PROCEDURE InsertTestResult(
    IN pClassName VARCHAR(255),
    IN pTestCaseName VARCHAR(255),
    IN pStatus VARCHAR(50),
    IN pTestCase TEXT,
    IN pModuleName VARCHAR(255),
    IN pSuiteName VARCHAR(255),
    IN pOperatingBrowser VARCHAR(100),
    IN pBuildNo VARCHAR(50),
    IN pTimeInSeconds DECIMAL(10,2),
    IN pEnvironment VARCHAR(100),
    IN pTestDate TIMESTAMP,
    IN pToolName VARCHAR(255)
)
BEGIN
    INSERT INTO TestResults (
        ClassName, TestCaseName, Status, TestCase, ModuleName, 
        SuiteName, OperatingBrowser, BuildNo, TimeInSeconds, Environment, TestDate, ToolName
    ) 
    VALUES (
        pClassName, pTestCaseName, pStatus, pTestCase, pModuleName, 
        pSuiteName, pOperatingBrowser, pBuildNo, pTimeInSeconds, pEnvironment, pTestDate, pToolName
    );
END $$

DELIMITER ;


-- ------------ Procedure1 For TestResultServlet ------------
DELIMITER $$

DROP PROCEDURE IF EXISTS GetToolResults$$

CREATE PROCEDURE GetToolResults(
    IN p_toolName VARCHAR(100),
    IN p_startDate VARCHAR(50),          
    IN p_endDate VARCHAR(50),            
    IN p_statusFilter VARCHAR(10),       
    IN p_searchTestCaseName VARCHAR(255),
    IN p_automationOwnerFilter VARCHAR(100) -- [NEW] 6th Parameter for real-time searchable dropdown
)
BEGIN
    SELECT 
        Id,
        TestCaseName,
        Status,
        TestCase,
        ModuleName,
        SuiteName,
        TimeInSeconds,
        Environment,
        TestDate,
        ToolName,
        AutomationOwner -- [NEW] Projection matrix column listed safely for dynamic view parsing
    FROM testresults
    WHERE UPPER(TRIM(ToolName)) = UPPER(TRIM(p_toolName))
      
      -- ✅ DATE BYPASS LOGIC: Agar dono dates 'DEFAULT' hain, toh filter bypass hoga (pehli baar blank load validation smoothly chalega).
      -- Agar user dates fill karega, tabhi BETWEEN check execute hoga.
      AND (
            (p_startDate = 'DEFAULT' AND p_endDate = 'DEFAULT')
            OR 
            (DATE(TestDate) BETWEEN STR_TO_DATE(p_startDate, '%Y-%m-%d') AND STR_TO_DATE(p_endDate, '%Y-%m-%d'))
          )
      
      -- ✅ STATUS STRICTOR LOGIC: Handles 'N' or 'PASS' for passes, 'Y' or 'FAIL' for execution drops
      AND (
            p_statusFilter = 'ALL'
            OR (p_statusFilter = 'PASS' AND UPPER(TRIM(Status)) IN ('N', 'PASS', 'P'))
            OR (p_statusFilter = 'FAIL' AND UPPER(TRIM(Status)) IN ('Y', 'FAIL', 'F'))
          )
          
      -- ✅ DYNAMIC SEARCH KEYWORD LOGIC: Match row substrings dynamically
      AND (
            p_searchTestCaseName = '' 
            OR TestCaseName LIKE CONCAT('%', p_searchTestCaseName, '%')
          )
          
      -- ✅ [NEW] AUTOMATION OWNER DROPDOWN FILTER LOGIC
      -- Agar value 'ALL' ya blank hai toh ye rule complete bypass hoga, warna exact team member ka criteria filter karega
      AND (
            p_automationOwnerFilter = 'ALL'
            OR p_automationOwnerFilter = ''
            OR UPPER(TRIM(AutomationOwner)) = UPPER(TRIM(p_automationOwnerFilter))
          );
END$$

DELIMITER ;


-- ------------ Procedure For Automation DashBoard ------------
-- ------------ Updated Strict 'N'=PASS / 'Y'=FAIL Global Tool Logic ------------
DELIMITER $$

DROP PROCEDURE IF EXISTS GetAutomationSummaryMetrics$$

CREATE PROCEDURE GetAutomationSummaryMetrics
(
    IN pToolName VARCHAR(100),
    IN pStartDate DATETIME,
    IN pEndDate DATETIME
)
BEGIN

    /*
      Step 1
      Jo TestCase kabhi bhi PASS (Status='N') hua hai,
      usko Global PASS list me rakho.
    */

    WITH EverPassed AS
    (
        SELECT DISTINCT
            UPPER(TRIM(ToolName)) AS ToolName,
            UPPER(TRIM(TestCaseName)) AS TestCaseName
        FROM TestResults
        WHERE UPPER(TRIM(Status))='N'
          AND UPPER(TRIM(ToolName))=UPPER(TRIM(pToolName))
    ),

    /*
      Step 2
      Date range ke andar unique TestCase nikalo.
      Same din 100 run hue to bhi 1 record.
    */

    DailyUnique AS
    (
        SELECT DISTINCT
            DATE(TestDate) AS ExecutionDate,
            UPPER(TRIM(ToolName)) AS ToolName,
            UPPER(TRIM(TestCaseName)) AS TestCaseName
        FROM TestResults
        WHERE UPPER(TRIM(ToolName))=UPPER(TRIM(pToolName))
          AND TestDate BETWEEN pStartDate AND pEndDate
    ),

    /*
      Step 3
      Global PASS / FAIL decide karo.
    */

    FinalStatus AS
    (
        SELECT
            D.ExecutionDate,
            D.ToolName,
            D.TestCaseName,

            CASE
                WHEN EXISTS
                (
                    SELECT 1
                    FROM EverPassed E
                    WHERE E.ToolName=D.ToolName
                      AND E.TestCaseName=D.TestCaseName
                )
                THEN 'PASS'
                ELSE 'FAIL'
            END AS Result
        FROM DailyUnique D
    )

    /*
      Final Summary
    */

    SELECT

        ExecutionDate AS TestDate,

        COUNT(*) AS TotalCases,

        SUM(
            CASE
                WHEN Result='PASS'
                THEN 1
                ELSE 0
            END
        ) AS TotalPass,

        SUM(
            CASE
                WHEN Result='FAIL'
                THEN 1
                ELSE 0
            END
        ) AS TotalFail,

        ROUND(
            (
                SUM(
                    CASE
                        WHEN Result='PASS'
                        THEN 1
                        ELSE 0
                    END
                )*100
            )/COUNT(*)
        ,2) AS PassPercentage,

        ROUND(
            (
                SUM(
                    CASE
                        WHEN Result='FAIL'
                        THEN 1
                        ELSE 0
                    END
                )*100
            )/COUNT(*)
        ,2) AS FailPercentage

    FROM FinalStatus

    GROUP BY ExecutionDate

    ORDER BY ExecutionDate;

END$$

DELIMITER ;


-- ------------ Delete All Data In Table And Reset Auto INCREMENT ------------
-- Note: Agar aap data safe rakhna chahte hain toh niche wali line ko execute na karein.
TRUNCATE TABLE TestResults;




------ new ------------
DELIMITER $$

DROP PROCEDURE IF EXISTS GetAutomationSummaryMetrics$$

CREATE PROCEDURE GetAutomationSummaryMetrics
(
    IN pToolName VARCHAR(100),
    IN pStartDate VARCHAR(50),          
    IN pEndDate VARCHAR(50)             
)
BEGIN

    /*
      Step 1:
      Jo TestCase kabhi bhi PASS (Status='N') hua hai,
      usko Global PASS list me rakho (Aapka core logic unchanged).
    */
    WITH EverPassed AS
    (
        SELECT DISTINCT
            UPPER(TRIM(ToolName)) AS ToolName,
            UPPER(TRIM(TestCaseName)) AS TestCaseName
        FROM TestResults
        WHERE UPPER(TRIM(Status))='N'
          AND UPPER(TRIM(ToolName))=UPPER(TRIM(pToolName))
    ),

    /*
      Step 2:
      Bina date select kiye 'DEFAULT' aane par condition bypass hogi,
      aur agar date select ki hai toh range filter lagega.
    */
    DailyUnique AS
    (
        SELECT DISTINCT
            DATE(TestDate) AS ExecutionDate,
            UPPER(TRIM(ToolName)) AS ToolName,
            UPPER(TRIM(TestCaseName)) AS TestCaseName
        FROM TestResults
        WHERE UPPER(TRIM(ToolName))=UPPER(TRIM(pToolName))
          
          -- ✅ FIXED BYPASS LOGIC: 'DEFAULT' par filter bypass, date select karne par filter on.
          AND (
                (pStartDate = 'DEFAULT' AND pEndDate = 'DEFAULT')
                OR 
                (DATE(TestDate) BETWEEN STR_TO_DATE(pStartDate, '%Y-%m-%d') AND STR_TO_DATE(pEndDate, '%Y-%m-%d'))
              )
    ),

    /*
      Step 3:
      Global PASS / FAIL mapping.
    */
    FinalStatus AS
    (
        SELECT
            D.ExecutionDate,
            D.ToolName,
            D.TestCaseName,
            CASE
                WHEN EXISTS
                (
                    SELECT 1
                    FROM EverPassed E
                    WHERE E.ToolName=D.ToolName
                      AND E.TestCaseName=D.TestCaseName
                )
                THEN 'PASS'
                ELSE 'FAIL'
            END AS Result
        FROM DailyUnique D
    )

    /*
      Final Summary Grouped By Day
    */
    SELECT
        ExecutionDate AS TestDate,
        COUNT(*) AS TotalCases,
        SUM(CASE WHEN Result='PASS' THEN 1 ELSE 0 END) AS TotalPass,
        SUM(CASE WHEN Result='FAIL' THEN 1 ELSE 0 END) AS TotalFail,
        ROUND((SUM(CASE WHEN Result='PASS' THEN 1 ELSE 0 END)*100)/COUNT(*), 2) AS PassPercentage,
        ROUND((SUM(CASE WHEN Result='FAIL' THEN 1 ELSE 0 END)*100)/COUNT(*), 2) AS FailPercentage
    FROM FinalStatus
    GROUP BY ExecutionDate
    ORDER BY ExecutionDate;

END$$

DELIMITER ;

TRUNCATE TABLE TestResults;
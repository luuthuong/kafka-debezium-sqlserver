USE master
GO
IF NOT EXISTS ( SELECT 1 FROM sys.databases WHERE [name] = N'MyDb')
    CREATE DATABASE MyDb
GO

USE MyDb
GO 

IF NOT EXISTS ( SELECT 1 FROM sys.databases WHERE [name] = 'MyDb' AND is_cdc_enabled = 1)
    EXEC sys.sp_cdc_enable_db
GO

IF NOT EXISTS ( 
    SELECT 1 
    FROM 
        INFORMATION_SCHEMA.TABLES 
    WHERE 
        TABLE_NAME = 'Employees'
        AND TABLE_SCHEMA = 'dbo'
)
BEGIN
    CREATE TABLE [dbo].[Employees]
    (
        EmployeeID INT PRIMARY KEY,
        FirstName NVARCHAR(50),
        LastName NVARCHAR(50),
        HireDate DATETIME
    );
    PRINT 'Table dbo.Employees has been created.';
END

IF EXISTS (
    SELECT 1
    FROM cdc.change_tables
    WHERE source_object_id = OBJECT_ID('dbo.Employees')
)
BEGIN
    EXEC sys.sp_cdc_disable_table 
    @source_schema = N'dbo', 
    @source_name = N'Employees', 
    @capture_instance = N'dbo_Employees';
END
GO

EXEC sys.sp_cdc_enable_table 
    @source_schema = N'dbo',       
    @source_name = N'Employees',  
    @role_name = NULL,
    @filegroup_name = NULL,
    @supports_net_changes = 0;
PRINT 'CDC  has been enabled for the table dbo.Employees'
GO

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
        TABLE_NAME = 'EventOutbox'
        AND TABLE_SCHEMA = 'dbo'
)
BEGIN
    CREATE TABLE EventOutbox (
        [Id] UNIQUEIDENTIFIER PRIMARY KEY,
        [AggregateType] VARCHAR(255) NOT NULL,
        [AggregateId] VARCHAR(255) NOT NULL,
        [EventType] VARCHAR(255) NOT NULL,
        [Data] NVARCHAR(MAX),
        [CreatedAt] DATETIME
    );
    PRINT 'Table dbo.EventOutbox has been created.';
END

IF EXISTS (
    SELECT 1
    FROM cdc.change_tables
    WHERE source_object_id = OBJECT_ID('dbo.EventOutbox')
)
BEGIN
    EXEC sys.sp_cdc_disable_table 
    @source_schema = N'dbo', 
    @source_name = N'EventOutbox', 
    @capture_instance = N'dbo_EventOutbox';
END
GO

EXEC sys.sp_cdc_enable_table 
    @source_schema = N'dbo',       
    @source_name = N'EventOutbox',  
    @role_name = NULL,
    @filegroup_name = NULL,
    @supports_net_changes = 0;
PRINT 'CDC  has been enabled for the table dbo.EventOutbox'
GO

USE MyDb
INSERT INTO [dbo].[EventOutbox] (
    [Id],
    [AggregateType],
    [AggregateId],
    [EventType],
    [Data],
    [CreatedAt]
) VALUES (
    NEWID(), -- Generates a new uniqueidentifier
    'Order', -- Example AggregateType
    '12345', -- Example AggregateId
    'Order Cancelled', -- Example EventType
    N'{"OrderId": "1", "OrderDate": "2024-09-01T00:00:00"}', -- Example JSON data
    GETDATE() -- Current date and time
);

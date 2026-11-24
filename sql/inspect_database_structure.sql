USE EcommerceBI;
GO

-- Check all tables
SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO

-- Check column definitions
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
ORDER BY TABLE_NAME, ORDINAL_POSITION;
GO

SELECT
    t.name AS TableName,
    c.name AS ColumnName,
    kc.name AS ConstraintName
FROM sys.key_constraints kc
JOIN sys.tables t
    ON kc.parent_object_id = t.object_id
JOIN sys.index_columns ic
    ON ic.object_id = t.object_id
    AND ic.index_id = kc.unique_index_id
JOIN sys.columns c
    ON c.object_id = t.object_id
    AND c.column_id = ic.column_id
WHERE kc.type = 'PK'
ORDER BY t.name;

SELECT
    fk.name AS ForeignKeyName,
    OBJECT_NAME(fk.parent_object_id) AS ChildTable,
    OBJECT_NAME(fk.referenced_object_id) AS ParentTable
FROM sys.foreign_keys fk
ORDER BY ChildTable;


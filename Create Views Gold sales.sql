------------------------
-- CREATE VIEW Sales
------------------------
CREATE VIEW gold.sales
AS
SELECT 
    * 
FROM 
    OPENROWSET
        (
            BULK 'https://nhstoragedatalake.blob.core.windows.net/silver/AventureWorks_Sales/',
            FORMAT = 'PARQUET'
        ) as QUER1
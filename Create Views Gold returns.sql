------------------------
-- CREATE VIEW RETURNS
------------------------
CREATE VIEW gold.returns
AS
SELECT 
    * 
FROM 
    OPENROWSET
        (
            BULK 'https://nhstoragedatalake.blob.core.windows.net/silver/AventureWorks_Returns/',
            FORMAT = 'PARQUET'
        ) as QUER1


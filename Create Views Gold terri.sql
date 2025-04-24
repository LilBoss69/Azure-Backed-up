------------------------
-- CREATE VIEW TERRITORIES
------------------------
CREATE VIEW gold.territories
AS
SELECT 
    * 
FROM 
    OPENROWSET
        (
            BULK 'https://nhstoragedatalake.blob.core.windows.net/silver/AventureWorks_Territories/',
            FORMAT = 'PARQUET'
        ) as QUER1
------------------------
-- CREATE VIEW SUBCAT
------------------------
CREATE VIEW gold.subcat
AS
SELECT 
    * 
FROM 
    OPENROWSET
        (
            BULK 'https://nhstoragedatalake.blob.core.windows.net/silver/AventureWorks_Subcategories/',
            FORMAT = 'PARQUET'
        ) as QUER1


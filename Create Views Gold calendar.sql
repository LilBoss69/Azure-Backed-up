------------------------
-- CREATE VIEW CALENDAR
------------------------
CREATE VIEW gold.calendar
AS
SELECT 
    * 
FROM 
    OPENROWSET
        (
            BULK 'https://nhstoragedatalake.blob.core.windows.net/silver/AventureWorks_Calendar/',
            FORMAT = 'PARQUET'
        ) as QUER1






        








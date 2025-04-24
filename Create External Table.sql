CREATE DATABASE SCOPED CREDENTIAL cred_nh
WITH
    IDENTITY = 'Managed Identity'


CREATE EXTERNAL DATA SOURCE source_silver
WITH
(
    LOCATION = 'https://nhstoragedatalake.blob.core.windows.net/silver',
    CREDENTIAL = cred_nh
)

CREATE EXTERNAL DATA SOURCE sources_gold
WITH
(
    LOCATION = 'https://nhstoragedatalake.blob.core.windows.net/gold',
    CREDENTIAL = cred_nh
)

CREATE EXTERNAL FILE FORMAT format_parquet
WITH
(
    FORMAT_TYPE = PARQUET,
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
)

------------------------------
--Create external table--
------------------------------
CREATE EXTERNAL TABLE gold.extsales
WITH
(
    LOCATION = 'extsales',
    DATA_SOURCE = sources_gold,
    FILE_FORMAT = format_parquet
)
AS
SELECT * FROM gold.sales

SELECT* FROM gold.extsales
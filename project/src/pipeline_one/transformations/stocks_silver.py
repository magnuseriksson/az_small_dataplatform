from pyspark import pipelines as dp
from pyspark.sql import functions as f
from pyspark.sql.types import StructType, StructField, StringType, DoubleType, IntegerType, ArrayType


# Define schema for stock data
stock_schema = StructType([
        StructField("symbol", StringType(), True),
        StructField("price", StructType([
            StructField("currency", StringType(), True),
            StructField("value", DoubleType(), True)
        ]), True),
        StructField("volume", IntegerType(), True),
        StructField("market_Cap", StructType([
            StructField("currency", StringType(), True),
            StructField("value", DoubleType(), True)
        ]), True),
        StructField("open", DoubleType(), True),
        StructField("high", DoubleType(), True),
        StructField("low", DoubleType(), True),
        StructField("close", DoubleType(), True)
    ])


@dp.table(
        name='stocks',
        comment="Parsing stocks data from bronze table",
        table_properties={
        "quality": "silver"
    })
def stocks_from_eventhub():
    return (dlt
            .readStream('raw_eventhub_data')
            .withColumn('stocks', f.from_json(f.col('body'), stock_schema))
            .select('stocks.*')
    )

from pyspark import pipelines as dp
from pyspark.sql import functions as f
import dlt

@dp.materialized_view(
        name='most_traded_stocks_two',
        comment="The most traded stocks by sorting on volume",
        table_properties={
        "quality": "gold"
    })
def stocks_by_volume():
    return (dlt
            .read('stocks_two')
            .groupby('symbol')
            .agg(f.sum('volume').alias('volume'))
            .orderBy(f.col('volume').desc())
    )


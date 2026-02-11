from pyspark import pipelines as dp
from pyspark.sql import functions as f

EH_NAMESPACE = spark.conf.get('eventhub_namespace','mypr-evhns-5guq6r2gsrqmy-dev')
TOPIC = spark.conf.get('eventhub_name','ingest-hub')
BOOTSTRAP_SERVERS = f"{EH_NAMESPACE}.servicebus.windows.net:9093"

# For Serverless with Unity Catalog service credential
# Configure "eventhub.serviceCredential" in pipeline settings with your UC service credential name
SERVICE_CREDENTIAL_NAME = 'eventhub_credential_name'
# or can be set in config.
#spark.conf.get("eventhub_credential_name", "eventhub_credential_name")

kafka_options = {
    "kafka.bootstrap.servers": BOOTSTRAP_SERVERS,
    "subscribe": TOPIC,
    "databricks.serviceCredential": SERVICE_CREDENTIAL_NAME,
}

@dp.table(
    name="raw_eventhub_data",
    comment="Streaming data from Azure Event Hubs using Kafka",
    table_properties={
        "quality": "bronze"
    }
)
def raw_eventhub_data():
    return (
        spark.readStream
        .format("kafka")
        .options(**kafka_options)
        .load()
        .withColumn("body", f.col("value").cast("string"))
        .withColumn("enqueuedTime", f.col("timestamp"))
        .withColumn("ingestion_time", f.current_timestamp())
        .drop('value')
        )

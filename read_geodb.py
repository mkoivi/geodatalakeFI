# Databricks notebook source
driver = "org.postgresql.Driver"
url = "jdbc:postgresql://20.71.96.165:5432/gis"
table = "tieviiva"
user = "postgres"
password = "postgres"

# COMMAND ----------

tieviiva = spark.read.format("jdbc").option("driver", driver).option("url", url).option("dbtable", table).option("user", user).option("password", password).load()

# COMMAND ----------

tieviiva.createOrReplaceTempView("tieviiva")

# COMMAND ----------

# MAGIC %sql
# MAGIC select * from tieviiva limit 100;

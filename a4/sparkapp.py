from pyspark.sql import SparkSession
from pyspark.ml import Pipeline
from pyspark.ml.feature import VectorAssembler
from pyspark.ml.regression import DecisionTreeRegressor
from pyspark.ml.evaluation import RegressionEvaluator

spark = SparkSession.builder.appName("MYAPP_A4").getOrCreate()

# the logging is a bit verbose
spark.sparkContext.setLogLevel("ERROR")

# load taxi csv data and create a dataset with the four specified columns
# when I first ran the script there were predictions for 0 passengers, 
# which doesn't really make sense, so I filtered them out.
csvFile = "2019-04.csv"
taxiDF = spark.read.csv(
    csvFile,
    header=True,
    inferSchema=True
).select(
    "passenger_count",
    "pulocationid",
    "dolocationid",
    "total_amount"
).filter(
    "passenger_count > 0"
)

print("\n#1. first 10 entries of dataset")
taxiDF.show(10)

# split into 80% training and 20% testing data
trainDF, testDF = taxiDF.randomSplit([.8, .2], seed=42)

# vector assembler transforms input columns into a feature vector
# so we can use decision tree regression
vecAssembler = VectorAssembler(
    inputCols=["passenger_count", "pulocationid", "dolocationid"],
    outputCol="features"
)

# decision tree regressor takes feature vector and builds a model for predicting total amount
dtRegressor = DecisionTreeRegressor(
    featuresCol="features",
    labelCol="total_amount"
)

# pipeline applies vector assembler and trains decision tree regressor
# with the assembled feature vector
pipeline = Pipeline(stages=[vecAssembler, dtRegressor])

# train model with training data
model = pipeline.fit(trainDF)

# apply trained model to test data to generate total amount predictions
predictionDF = model.transform(testDF)

print("\n#6. first 10 predictions:")
predictionDF.select(
    "passenger_count",
    "pulocationid",
    "dolocationid",
    "total_amount",
    "prediction"
).show(10)

# evaluate model's prediction accuracy using root mean squared error metric
rmse = RegressionEvaluator(
    predictionCol="prediction",
    labelCol="total_amount",
    metricName="rmse"
).evaluate(predictionDF)

print("\n#7. rmse evaluation of model:")
print(f"{rmse}")

spark.stop()

import joblib
import pandas as pd

# Load saved model
model = joblib.load("ml/saved_model/model.joblib")

print("Model loaded successfully!")

# Load original dataset
df = pd.read_csv("data/WA_Fn-UseC_-Telco-Customer-Churn.csv")

# Take one customer for prediction
sample = df.drop("customerID", axis=1).iloc[[0]]

# Remove target column if present
sample = sample.drop("Churn", axis=1)

# Clean TotalCharges
sample["TotalCharges"] = pd.to_numeric(
    sample["TotalCharges"],
    errors="coerce"
).fillna(0)

# Make prediction
prediction = model.predict(sample)

print("Prediction:", prediction)
import pandas as pd
import mysql.connector
import streamlit as st
from faker import Faker
import random

# Initialize Faker
fake = Faker()

# Expense categories and payment modes
categories = ["Groceries", "Travel", "Transportation", "Entertainment", "Gifts", "Income Tax", "Gas Bill", "Subscriptions"]
payment_modes = ["Cash", "Credit Card", "Debit Card", "UPI"]

# MySQL connection details
mysql_config = {
    "host": "localhost",
    "user": "root",
    "password": "Ashok@mysql123"
}

def ensure_database():
    conn = mysql.connector.connect(host=mysql_config["host"], user=mysql_config["user"], password=mysql_config["password"])
    cursor = conn.cursor()
    cursor.execute("CREATE DATABASE IF NOT EXISTS expense_db")
    cursor.close()
    conn.close()

def ensure_table():
    conn = mysql.connector.connect(host=mysql_config["host"], user=mysql_config["user"], password=mysql_config["password"], database="expense_db")
    cursor = conn.cursor()
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS expenses (
            id INT AUTO_INCREMENT PRIMARY KEY,
            date DATE,
            category VARCHAR(50),
            payment_mode VARCHAR(20),
            description TEXT,
            amount_paid DECIMAL(10,2),
            cashback DECIMAL(5,2)
        )
    """)
    cursor.close()
    conn.close()

# Ensure database and table exist
ensure_database()
ensure_table()

def fetch_data_from_mysql(query):
    conn = mysql.connector.connect(host=mysql_config["host"], user=mysql_config["user"], password=mysql_config["password"], database="expense_db")
    cursor = conn.cursor()
    cursor.execute(query)
    data = cursor.fetchall()
    columns = [desc[0] for desc in cursor.description]
    cursor.close()
    conn.close()
    return pd.DataFrame(data, columns=columns)

# Streamlit UI
st.title("Expense Tracker Dashboard")

# Query selection
default_query = "copy paste your query from mysql workbench or sql query script"
query = st.text_area("Enter your SQL query:", default_query)

if st.button("Run Query"):
    try:
        df = fetch_data_from_mysql(query)
        st.write(df)
    except Exception as e:
        st.error(f"Error executing query: {e}")

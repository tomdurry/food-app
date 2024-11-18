import boto3
import psycopg2
import os

ssm = boto3.client('ssm')

def lambda_handler(event, context):
    rds_endpoint = ssm.get_parameter(Name='/prod/rds_endpoint', WithDecryption=True)['Parameter']['Value']
    
    db_name = "postgres"
    db_user = "yukihiro"
    db_password = "Yuki3769"
    db_port = 5432
    
    try:
        conn = psycopg2.connect(
            host=rds_endpoint,
            database=db_name,
            user=db_user,
            password=db_password,
            port=db_port
        )
        conn.autocommit = True
        
        cursor = conn.cursor()
        cursor.execute("CREATE DATABASE yukihiro;")
        cursor.close()
        conn.close()
        
        return {
            'statusCode': 200,
            'body': 'Database created successfully'
        }
        
    except Exception as e:
        print(f"Error creating database: {e}")
        return {
            'statusCode': 500,
            'body': f"Error creating database: {e}"
        }

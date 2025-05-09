#!/bin/bash
set -e

# Wait for MongoDB to be ready
until mongosh --host mongodb --port 27017 -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" --authenticationDatabase admin --eval "print('MongoDB connection successful')"
do
  echo "Waiting for MongoDB to start..."
  sleep 2
done

# Import category data
if [ -f "/docker-entrypoint-initdb.d/category/categories.json" ]; then
  mongoimport --host mongodb --port 27017 \
    -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" --authenticationDatabase admin \
    --db "$MONGODB_DATABASE" --collection categories \
    --file /docker-entrypoint-initdb.d/category/categories.json --jsonArray
  echo "Categories imported successfully"
fi

# Import product data
if [ -f "/docker-entrypoint-initdb.d/product/products.json" ]; then
  mongoimport --host mongodb --port 27017 \
    -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" --authenticationDatabase admin \
    --db "$MONGODB_DATABASE" --collection products \
    --file /docker-entrypoint-initdb.d/product/products.json --jsonArray
  echo "Products imported successfully"
fi
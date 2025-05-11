// Import required modules
const fs = require('fs');

// Switch to the purely_product_service database and create the 'products' collection
db = db.getSiblingDB('purely_product_service');

// Load products data from the JSON file
const productsData = fs.readFileSync('/docker-entrypoint-initdb.d/products.json');
let products = JSON.parse(productsData);

// Convert $oid fields to ObjectId
products = products.map(product => {
    if (product._id && product._id.$oid) {
        product._id = ObjectId(product._id.$oid);
    }
    return product;
});
db.products.insertMany(products);


// Switch to the purely_category_service database and create the 'categories' collection
db = db.getSiblingDB('purely_category_service');
// Load categories data from the JSON file
const categoriesData = fs.readFileSync('/docker-entrypoint-initdb.d/categories.json');
let categories = JSON.parse(categoriesData);

// Convert $oid fields to ObjectId
categories = categories.map(category => {
    if (category._id && category._id.$oid) {
        category._id = ObjectId(category._id.$oid);
    }
    return category;
});
db.categories.insertMany(categories);

print("Database initialization complete!");

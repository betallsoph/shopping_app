const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const connectDB = require('./config/db.config');

dotenv.config();
const app = express();
connectDB();

app.use(cors());
app.use(express.json());

// ROUTES
app.use('/api/v1/products', require('./routes/product.routes'));
//app.use('/api/v1/orders', require('./routes/order.routes'));
//app.use('/api/v1/users', require('./routes/user.routes'));

const PORT = process.env.PORT || 5999;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
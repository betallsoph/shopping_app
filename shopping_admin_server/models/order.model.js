const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema({
    userId: String,
    items: [
        {
            productId: String,
            quantity: Number,
            price: Number
        }
    ],
    total: Number,
    shippingAddress: String,
    status: {
        type: String,
        enum: ['pending', 'confirmed', 'shipping', 'completed'],
        default: 'pending'
    },
    createdAt: {
        type: Date,
        default: Date.now
    }
});

module.exports = mongoose.model('Order', orderSchema);
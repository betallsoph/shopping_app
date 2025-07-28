const Product = require('../models/product.model');

exports.getAll = async (req, res) => {
    const products = await Product.find();
    res.json(products);
};

exports.create = async (req, res) => {
    const product = new Product(req.body);
    await product.save();
    res.status(201).json(product);
};

exports.update = async (req, res) => {
    const { id } = req.params;
    await Product.findByIdAndUpdate(id, req.body);
    res.sendStatus(200);
};

exports.delete = async (req, res) => {
    const { id } = req.params;
    await Product.findByIdAndDelete(id);
    res.sendStatus(200);
};
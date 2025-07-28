const Product = require('../models/product.model');
const FCMService = require('../services/fcm.service');

exports.getAll = async (req, res) => {
    try {
        const products = await Product.find();
        res.json(products);
    } catch (error) {
        console.error('Get products error:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Lỗi lấy danh sách sản phẩm', 
            error: error.message 
        });
    }
};

exports.create = async (req, res) => {
    try {
        const product = new Product(req.body);
        await product.save();
        
        // Gửi FCM notification
        await FCMService.sendProductNotification('created', product);
        
        res.status(201).json(product);
    } catch (error) {
        console.error('Create product error:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Lỗi tạo sản phẩm', 
            error: error.message 
        });
    }
};

exports.update = async (req, res) => {
    try {
        const { id } = req.params;
        const product = await Product.findByIdAndUpdate(id, req.body, { new: true });
        
        if (!product) {
            return res.status(404).json({ 
                success: false, 
                message: 'Không tìm thấy sản phẩm' 
            });
        }
        
        // Gửi FCM notification
        await FCMService.sendProductNotification('updated', product);
        
        res.json(product);
    } catch (error) {
        console.error('Update product error:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Lỗi cập nhật sản phẩm', 
            error: error.message 
        });
    }
};

exports.delete = async (req, res) => {
    try {
        const { id } = req.params;
        const product = await Product.findById(id);
        
        if (!product) {
            return res.status(404).json({ 
                success: false, 
                message: 'Không tìm thấy sản phẩm' 
            });
        }
        
        await Product.findByIdAndDelete(id);
        
        // Gửi FCM notification
        await FCMService.sendProductNotification('deleted', product);
        
        res.json({ 
            success: true, 
            message: 'Xóa sản phẩm thành công' 
        });
    } catch (error) {
        console.error('Delete product error:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Lỗi xóa sản phẩm', 
            error: error.message 
        });
    }
};
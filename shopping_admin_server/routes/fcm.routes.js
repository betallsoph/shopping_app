const express = require('express');
const router = express.Router();
const FCMService = require('../services/fcm.service');

// Test endpoint để gửi notification đến topic
router.post('/test/topic', async (req, res) => {
    try {
        const { topic, title, body, data } = req.body;
        
        if (!topic || !title || !body) {
            return res.status(400).json({
                success: false,
                message: 'Topic, title và body là bắt buộc'
            });
        }
        
        const result = await FCMService.sendToTopic(topic, {
            title,
            body,
            data: data || {}
        });
        
        res.json({
            success: true,
            message: 'Gửi notification thành công',
            result
        });
    } catch (error) {
        console.error('FCM topic test error:', error);
        res.status(500).json({
            success: false,
            message: 'Lỗi gửi notification',
            error: error.message
        });
    }
});

// Test endpoint để gửi notification đến token cụ thể
router.post('/test/token', async (req, res) => {
    try {
        const { token, title, body, data } = req.body;
        
        if (!token || !title || !body) {
            return res.status(400).json({
                success: false,
                message: 'Token, title và body là bắt buộc'
            });
        }
        
        const result = await FCMService.sendToToken(token, {
            title,
            body,
            data: data || {}
        });
        
        res.json({
            success: true,
            message: 'Gửi notification thành công',
            result
        });
    } catch (error) {
        console.error('FCM token test error:', error);
        res.status(500).json({
            success: false,
            message: 'Lỗi gửi notification',
            error: error.message
        });
    }
});

// Test endpoint để gửi product notification
router.post('/test/product', async (req, res) => {
    try {
        const { action, product } = req.body;
        
        if (!action || !product) {
            return res.status(400).json({
                success: false,
                message: 'Action và product là bắt buộc'
            });
        }
        
        const result = await FCMService.sendProductNotification(action, product);
        
        res.json({
            success: true,
            message: 'Gửi product notification thành công',
            result
        });
    } catch (error) {
        console.error('FCM product test error:', error);
        res.status(500).json({
            success: false,
            message: 'Lỗi gửi product notification',
            error: error.message
        });
    }
});

// Health check cho FCM service
router.get('/health', (req, res) => {
    res.json({
        success: true,
        message: 'FCM service is running',
        timestamp: new Date().toISOString()
    });
});

module.exports = router;

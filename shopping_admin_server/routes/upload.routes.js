const express = require('express');
const router = express.Router();
const uploadController = require('../controllers/upload.controller');
const uploadMiddleware = require('../middleware/upload.middleware');

// Upload single image
router.post('/image', 
  uploadMiddleware.cleanupTempFiles,
  uploadMiddleware.uploadSingle,
  uploadController.uploadImage,
  uploadMiddleware.handleUploadError
);

// Upload multiple images
router.post('/images',
  uploadMiddleware.cleanupTempFiles,
  uploadMiddleware.uploadMultiple,
  uploadController.uploadMultipleImages,
  uploadMiddleware.handleUploadError
);

// Delete image by public_id
router.delete('/image/:public_id',
  uploadController.deleteImage
);

// Get image info by public_id
router.get('/image/:public_id',
  uploadController.getImageInfo
);

module.exports = router;

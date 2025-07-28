const cloudinary = require('../config/cloudinary.config');

// Upload single image
const uploadImage = async (req, res) => {
  try {
    console.log('Upload request received');
    console.log('Body:', req.body);
    console.log('File:', req.file);

    if (!req.file) {
      console.log('No file in request');
      return res.status(400).json({
        success: false,
        message: 'Không có file nào được upload'
      });
    }

    console.log('File details:', {
      filename: req.file.filename,
      originalname: req.file.originalname,
      mimetype: req.file.mimetype,
      size: req.file.size,
      path: req.file.path
    });

    // Upload to Cloudinary
    const result = await cloudinary.uploader.upload(req.file.path, {
      folder: req.body.folder || 'uploads', // Folder trên Cloudinary
      resource_type: 'image',
      transformation: [
        { width: 1000, height: 1000, crop: 'limit' }, // Giới hạn kích thước
        { quality: 'auto' }, // Tự động tối ưu quality
        { format: 'auto' } // Tự động chọn format tốt nhất
      ]
    });

    // Trả về thông tin ảnh
    res.json({
      success: true,
      message: 'Upload ảnh thành công',
      data: {
        url: result.secure_url,
        public_id: result.public_id,
        width: result.width,
        height: result.height,
        format: result.format,
        bytes: result.bytes
      }
    });

  } catch (error) {
    console.error('Lỗi upload ảnh:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server khi upload ảnh',
      error: error.message
    });
  }
};

// Upload multiple images
const uploadMultipleImages = async (req, res) => {
  try {
    if (!req.files || req.files.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Không có file nào được upload'
      });
    }

    const uploadPromises = req.files.map(file => 
      cloudinary.uploader.upload(file.path, {
        folder: req.body.folder || 'uploads',
        resource_type: 'image',
        transformation: [
          { width: 1000, height: 1000, crop: 'limit' },
          { quality: 'auto' },
          { format: 'auto' }
        ]
      })
    );

    const results = await Promise.all(uploadPromises);

    const uploadedImages = results.map(result => ({
      url: result.secure_url,
      public_id: result.public_id,
      width: result.width,
      height: result.height,
      format: result.format,
      bytes: result.bytes
    }));

    res.json({
      success: true,
      message: `Upload ${results.length} ảnh thành công`,
      data: uploadedImages
    });

  } catch (error) {
    console.error('Lỗi upload nhiều ảnh:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server khi upload ảnh',
      error: error.message
    });
  }
};

// Delete image
const deleteImage = async (req, res) => {
  try {
    const { public_id } = req.params;

    if (!public_id) {
      return res.status(400).json({
        success: false,
        message: 'Thiếu public_id'
      });
    }

    const result = await cloudinary.uploader.destroy(public_id);

    if (result.result === 'ok') {
      res.json({
        success: true,
        message: 'Xóa ảnh thành công',
        data: result
      });
    } else {
      res.status(404).json({
        success: false,
        message: 'Không tìm thấy ảnh để xóa',
        data: result
      });
    }

  } catch (error) {
    console.error('Lỗi xóa ảnh:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server khi xóa ảnh',
      error: error.message
    });
  }
};

// Get image info
const getImageInfo = async (req, res) => {
  try {
    const { public_id } = req.params;

    const result = await cloudinary.api.resource(public_id);

    res.json({
      success: true,
      data: {
        url: result.secure_url,
        public_id: result.public_id,
        width: result.width,
        height: result.height,
        format: result.format,
        bytes: result.bytes,
        created_at: result.created_at
      }
    });

  } catch (error) {
    console.error('Lỗi lấy thông tin ảnh:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server khi lấy thông tin ảnh',
      error: error.message
    });
  }
};

module.exports = {
  uploadImage,
  uploadMultipleImages,
  deleteImage,
  getImageInfo
};

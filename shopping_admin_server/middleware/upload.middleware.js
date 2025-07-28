const multer = require('multer');
const path = require('path');
const fs = require('fs');

// Tạo thư mục uploads nếu chưa có
const uploadDir = 'uploads/';
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir, { recursive: true });
}

// Cấu hình storage
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, uploadDir);
  },
  filename: function (req, file, cb) {
    // Tạo tên file unique
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname));
  }
});

// File filter - chỉ cho phép ảnh
const fileFilter = (req, file, cb) => {
  console.log('File info:', {
    fieldname: file.fieldname,
    originalname: file.originalname,
    mimetype: file.mimetype,
    size: file.size
  });

  // Kiểm tra MIME type
  const allowedMimeTypes = [
    'image/jpeg',
    'image/jpg', 
    'image/png',
    'image/gif',
    'image/webp',
    'image/bmp',
    'image/svg+xml'
  ];

  // Kiểm tra extension
  const allowedExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp', '.svg'];
  const fileExtension = path.extname(file.originalname).toLowerCase();

  if (allowedMimeTypes.includes(file.mimetype) || allowedExtensions.includes(fileExtension)) {
    console.log('File được chấp nhận:', file.originalname);
    cb(null, true);
  } else {
    console.log('File bị từ chối:', file.originalname, 'MIME type:', file.mimetype);
    cb(new Error('Chỉ cho phép upload file ảnh! Các định dạng được hỗ trợ: JPG, PNG, GIF, WebP, BMP, SVG'), false);
  }
};

// Cấu hình multer
const upload = multer({
  storage: storage,
  fileFilter: fileFilter,
  limits: {
    fileSize: 10 * 1024 * 1024, // 10MB
    files: 5 // Tối đa 5 files
  }
});

// Middleware xử lý lỗi upload
const handleUploadError = (error, req, res, next) => {
  if (error instanceof multer.MulterError) {
    if (error.code === 'LIMIT_FILE_SIZE') {
      return res.status(400).json({
        success: false,
        message: 'File quá lớn. Kích thước tối đa là 10MB'
      });
    }
    if (error.code === 'LIMIT_FILE_COUNT') {
      return res.status(400).json({
        success: false,
        message: 'Quá nhiều file. Tối đa là 5 files'
      });
    }
    if (error.code === 'LIMIT_UNEXPECTED_FILE') {
      return res.status(400).json({
        success: false,
        message: 'Trường file không hợp lệ'
      });
    }
  }
  
  if (error.message === 'Chỉ cho phép upload file ảnh!') {
    return res.status(400).json({
      success: false,
      message: error.message
    });
  }

  // Lỗi khác
  return res.status(500).json({
    success: false,
    message: 'Lỗi upload file',
    error: error.message
  });
};

// Middleware cleanup - xóa file tạm sau khi upload
const cleanupTempFiles = (req, res, next) => {
  // Hook vào response để cleanup sau khi response được gửi
  const originalSend = res.send;
  res.send = function(data) {
    // Xóa file tạm
    if (req.file) {
      fs.unlink(req.file.path, (err) => {
        if (err) console.error('Lỗi xóa file tạm:', err);
      });
    }
    if (req.files) {
      req.files.forEach(file => {
        fs.unlink(file.path, (err) => {
          if (err) console.error('Lỗi xóa file tạm:', err);
        });
      });
    }
    originalSend.call(this, data);
  };
  next();
};

module.exports = {
  uploadSingle: upload.single('image'),
  uploadMultiple: upload.array('images', 5),
  handleUploadError,
  cleanupTempFiles
};

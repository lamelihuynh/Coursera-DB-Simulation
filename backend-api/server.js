const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
app.use(cors());
app.use(bodyParser.json());

const db = mysql.createPool({
    host: 'localhost', 
    user: 'root', 
    password: 'nhatlinhnehehe', 
    database: 'mydb', 
    port: 3306,
    socketPath: '/tmp/mysql.sock', 
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});


db.getConnection((err, connection) => {
    if (err) {
        console.error('[ERROR BACKEND] Failed connect to Database:', err.message);
    } else {
        console.log('[SUCCESS BACKEND] Connect succesfull to MySQL Database');
        connection.release();
    }
});





app.get('/api/courses/search', (req, res) => {
    
    // ?keyword=Python&minPrice=0&maxPrice=100
    const { 
        authenticate_teacher_ID,
        keyword, 
        minPrice, 
        maxPrice, 
        level, 
        language, 
        teacherId, 
        specialization 
    } = req.query;

    const params = [
        authenticate_teacher_ID || null,
        keyword || null,
        minPrice || null,
        maxPrice || null,
        level || null,
        language || null,
        teacherId || null,
        specialization || null
    ];

    //  SQL command call Stored Procedure : SeachCourse
    const sql = `CALL sp_SearchCourses(?, ?, ?, ?, ?, ?, ?, ?)`;

    console.log("[FINDING BACKEND] Finding with params:", params);

    // Execute
    db.query(sql, params, (err, results) => {
        if (err) {
            console.error("[ERROR BACKEND] ERROR SQL:", err);
            return res.status(500).json({ 
                success: false, 
                message: err.message || "Internal Error" 
            });
        }

        // results[0] chứa danh sách kết quả trả về từ SP
        const courses = results[0];

        // Logic UI: Nếu không có kết quả
        if (courses.length === 0) {
            return res.status(200).json({
                success: true,
                count: 0,
                message: "Cannot find the course matching with your criteria.",
                data: []
            });
        }

        // Logic UI: Có kết quả
        return res.status(200).json({
            success: true,
            count: courses.length,
            message: "Get data successfully.",
            data: courses
        });
    });
});


// ============================================================
// 1. API Insert Course (CREATE)
// Call procedure SQL: sp_InsertCourse
// Method: POST
// URL: /api/courses
// ============================================================
app.post('/api/courses', (req, res) => {
    const { 
        title, language, description, price, 
        level, duration, teacherId, specialization 
    } = req.body;

    const params = [
        specialization || null,
        title, 
        language || 'English', 
        description || '', 
        price || 'Free', 
        level || 'Beginner', 
        duration || '4 Weeks', 
        teacherId
    ];

    const sql = `CALL sp_InsertCourse(?, ?, ?, ?, ?, ?, ?, ?)`;

    db.query(sql, params, (err, results) => {
        if (err) {
            console.error("[ERROR BACKEND] Error Insert:", err.message);
            return res.status(500).json({ success: false, message: err.message });
        }

        // sp_InsertCourse trả về ID của khóa học vừa tạo ở results[0][0]
        const newCourseId = results[0][0]?.NewCourseID || 'Unknown';

        res.json({
            success: true,
            message: "Insert course successfully!",
            newCourseId: newCourseId
        });
    });
});

// ============================================================
// 2. API Update Course (UPDATE)
// Call procedure SQL: sp_UpdateCourse
// Method: PUT
// URL: /api/courses/:id
// ============================================================
app.put('/api/courses/:id', (req, res) => {
    const courseId = req.params.id;
    const { 
        title, language, description, price, 
        level, duration, teacherId, specialization, status 
    } = req.body;

    //  Nếu Frontend không gửi field nào, gán mặc định là '__KEEP__'
    // để Stored Procedure giữ nguyên giá trị cũ trong Database.
    const params = [
        courseId,
        title || '__KEEP__',
        language || '__KEEP__',
        description || '__KEEP__',
        price || '__KEEP__',
        level || '__KEEP__',
        duration || '__KEEP__',
        specialization || '__KEEP__',
        teacherId, // TeacherID bắt buộc phải có để kiểm tra quyền sở hữu
        status || '__KEEP__',
    ];

    const sql = `CALL sp_UpdateCourse(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;

    db.query(sql, params, (err, results) => {
        if (err) {
            console.error("[ERROR BACKEND] Error Update:", err.message);
            return res.status(500).json({ success: false, message: err.message });
        }

        res.json({
            success: true,
            message: "Update course successfully!"
        });
    });
});

// ============================================================
// 3. API SOFT DELETE (SOFT DELETE)
// Call procedure SQL: sp_SoftDeleteCourse
// Method: DELETE
// URL: /api/courses/:id/soft
// ============================================================
app.delete('/api/courses/:id/soft', (req, res) => {
    const courseId = req.params.id;
    const { teacherId } = req.body; // Cần TeacherID để biết ai xóa

    const sql = `CALL sp_SoftDeleteCourse(?, ?)`;

    db.query(sql, [courseId, teacherId], (err, results) => {
        if (err) {
            console.error("[ERROR BACKEND] Error Soft Delete:", err.message);
            return res.status(500).json({ success: false, message: err.message });
        }

        res.json({
            success: true,
            message: "Soft Delete course successfully!."
        });
    });
});

// ============================================================
// 4. API HARD DELETE (HARD DELETE)
// Gọi thủ tục: sp_HardDeleteCourse
// Method: DELETE
// URL: /api/courses/:id/hard
// ============================================================
app.delete('/api/courses/:id/hard', (req, res) => {
    const courseId = req.params.id;
    const { teacherId } = req.body;

    
    const sql = `CALL sp_HardDeleteCourse(?, ?)`;

   
    db.query(sql, [courseId, teacherId], (err, results) => {
        if (err) {
            console.error("[ERROR BACKEND] Error Hard Delete:", err.message);
            return res.status(500).json({ success: false, message: err.message });
        }

        res.json({
            success: true,
            message: "Hard Delete course and learning resource relevant successfully!."
        });
    });
});



// ============================================================
// 5. API Calculate Revenue Course (CREATE)
// Call procedure SQL: Calc_Course_Revenue
// Method: GET
// URL: http://localhost:3000/api/courses/40001/revenue 
// ============================================================
app.get('/api/courses/:id/revenue', (req, res) => {
  const courseId = parseInt(req.params.id, 10);

  if (isNaN(courseId) || courseId <= 0) {
    return res.status(400).json({ error: 'course_id không hợp lệ' });
  }

  db.getConnection((err, connection) => {
    if (err) {
      console.error("[ERROR BACKEND] Error Get Connection:", err.message);
      return res.status(500).json({
        error: 'Lỗi server khi tính doanh thu khoá học',
        detail: err.message
      });
    }

    // Gọi Stored Procedure
    connection.query('CALL Calc_Course_Revenue(?, @total)', [courseId], (err) => {
      if (err) {
        connection.release();
        console.error("[ERROR BACKEND] Error Calculate Revenue:", err.message);
        return res.status(500).json({
          error: 'Lỗi server khi tính doanh thu khoá học',
          detail: err.message
        });
      }

      // Lấy giá trị của @total
      connection.query('SELECT @total as total_revenue', (err, results) => {
        connection.release();

        if (err) {
          console.error("[ERROR BACKEND] Error Get Revenue:", err.message);
          return res.status(500).json({
            error: 'Lỗi server khi lấy doanh thu khoá học',
            detail: err.message
          });
        }

        const total = results?.[0]?.total_revenue || 0;

        return res.json({
          success: true,
          course_id: courseId,
          total_revenue: total
        });
      });
    });
  });
});

// ============================================================
// API Get Course Details (READ)
// Call VIEW: ViewCourse
// Method: GET
// URL: /api/courses/:id?authenticate_teacher_ID=123

// ============================================================
app.get('/api/courses/:id', (req, res) => {
  const courseId = parseInt(req.params.id, 10);
  const authenticateTeacherId = parseInt(req.query.authenticate_teacher_ID, 10) || null;
  if (isNaN(courseId) || courseId <= 0) {
    return res.status(400).json({ 
      success: false,
      error: 'Course ID not valid' 
    });
  }
  
  const sql = 'CALL mydb.sp_ViewCourse(?,?);'

  db.query(sql, [authenticateTeacherId, courseId], (err, results) => {
    if (err) {
      console.error("[ERROR BACKEND] Error Get Course Details:", err.message);
      return res.status(500).json({ 
        success: false, 
        message: err.message 
      });
    }

    if (results[0].length === 0) {
      return res.status(404).json({
        success: false,
        message: "Course not found."
      });
    }

    const course = results[0][0];

    return res.status(200).json({
      success: true,
      message: "Get course details successfully.",
      data: course
    });
  });
});




// 3. KHỞI CHẠY SERVER
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`🚀 Server running at: http://localhost:${PORT}`);
});
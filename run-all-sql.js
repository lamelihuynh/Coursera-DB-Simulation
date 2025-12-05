const { exec } = require('child_process');
const fs = require('fs');
const path = require('path');

const SQL_FOLDER = path.join(__dirname, 'SQL-QUERY');
const DB_USER = 'root';
const DB_PASSWORD = 'nhatlinhnehehe';
const DB_NAME = 'mydb';
const DB_HOST = 'localhost';

async function runSqlFiles() {
    try {
        let files = fs.readdirSync(SQL_FOLDER)
            .filter(file => file.endsWith('.sql'))
            .sort();

        // Đảm bảo DDL.sql chạy đầu tiên
        files = files.filter(f => f !== 'DDL.sql');
        files.unshift('DDL.sql');

        console.log(`Found ${files.length} SQL files to execute:\n`);

        for (const file of files) {
            const filePath = path.join(SQL_FOLDER, file);
            
            console.log(`⏳ Executing: ${file}`);

            // DDL.sql chạy mà không cần -D (chưa có database)
            // Các file khác chạy với -D mydb
            const dbFlag = file === 'DDL.sql' ? '' : `-D ${DB_NAME}`;
            const command = `mysql -h ${DB_HOST} -u ${DB_USER} -p'${DB_PASSWORD}' ${dbFlag} < "${filePath}"`;

            await new Promise((resolve, reject) => {
                exec(command, (error, stdout, stderr) => {
                    if (error) {
                        console.error(`❌ Error in ${file}:`, stderr || error.message, '\n');
                    } else {
                        console.log(`✅ Success: ${file}\n`);
                    }
                    resolve(); 
                });
            });
        }

        console.log('\n🎉 All SQL files executed!');

    } catch (error) {
        console.error('[ERROR]', error.message);
        process.exit(1);
    }
}

runSqlFiles();
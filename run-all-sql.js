const { spawn } = require('child_process');
const fs = require('fs');
const path = require('path');
const os = require('os');

const SQL_FOLDER = path.join(__dirname, 'SQL-QUERY');
const DB_USER = process.env.DB_USER || 'root';
const DB_PASSWORD = process.env.DB_PASSWORD || '1234';
const DB_NAME = process.env.DB_NAME || 'mydb';
const DB_HOST = process.env.DB_HOST || 'localhost';

function makeTempCredFile(user, password, host) {
    const tmp = os.tmpdir();
    const name = `mysql-cred-${Date.now()}-${Math.random().toString(36).slice(2)}.cnf`;
    const filePath = path.join(tmp, name);
    const content = `[client]\nuser=${user}\npassword=${password}\nhost=${host}\n`;
    try {
        fs.writeFileSync(filePath, content, { mode: 0o600 });
    } catch (err) {
        // On Windows mode may be ignored; still write the file
        fs.writeFileSync(filePath, content);
    }
    return filePath;
}

async function runSqlFiles() {
    try {
        let files = fs.readdirSync(SQL_FOLDER)
            .filter(file => file.endsWith('.sql'))
            .sort();

        // Ensure DDL.sql runs first
        files = files.filter(f => f !== 'DDL.sql');
        files.unshift('DDL.sql');

        console.log(`Found ${files.length} SQL files to execute:\n`);

        for (const file of files) {
            const filePath = path.join(SQL_FOLDER, file);
            console.log(`⏳ Executing: ${file}`);

            // Create temp credential file per run to avoid passing password on command line
            const credFile = makeTempCredFile(DB_USER, DB_PASSWORD, DB_HOST);

            // For DDL.sql we don't specify database (it might create the database)
            const args = [`--defaults-extra-file=${credFile}`, '--default-character-set=utf8mb4'];
            if (file !== 'DDL.sql') {
                args.push('-D', DB_NAME);
            }

            await new Promise((resolve) => {
                const child = spawn('mysql', args, { stdio: ['pipe', 'pipe', 'pipe'] });

                // Read file, sanitize lines that contain only dashes (separators)
                // and pipe sanitized content to mysql stdin.
                fs.readFile(filePath, 'utf8', (err, data) => {
                    if (err) {
                        console.error(`❌ Failed to read ${file}:`, err.message);
                        // ensure cleanup
                        try { fs.unlinkSync(credFile); } catch (e) {}
                        resolve();
                        return;
                    }

                    // Replace lines that are only dashes (and optional spaces) with a SQL comment
                    const sanitized = data.replace(/^[ \t-]{3,}$/gm, '-- ----------');

                    child.stdin.end(sanitized);
                });

                let stderr = '';
                child.stderr.on('data', (chunk) => { stderr += chunk.toString(); });
                child.stdout.on('data', (chunk) => { process.stdout.write(chunk.toString()); });

                child.on('close', (code) => {
                    // Clean up temp file
                    try { fs.unlinkSync(credFile); } catch (e) {}

                    if (code !== 0) {
                        console.error(`❌ Error in ${file}:`, stderr || `exit code ${code}`, '\n');
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
import { is_teacher , teacherId} from "./utils.js";

class Course{
    static id='';
    static title='';
    static specialization='';
    static language='';
    static price='';
    static description='';
    static level='';
    static duration='';
    static teacher_id='';
    static disable_date='';
    static disable_by='';
    static status='';
    static teacher_name='';
    static partner_name='';
    static revenue=0;

    static display(){
        const mainInfo=document.getElementById('main-info');
        // Render actions conditional on status
        let actionButtons = '';
        // Always show Edit and Enter
        actionButtons += `<button class="action-button" id="edit-button">Edit</button>`;
        actionButtons += `<button class="action-button" id="enter-button">Enter</button>`;
        if (this.status === 'Discarded') {
            actionButtons += `<button class="action-button" id="enable-button">Enable</button>`;
            actionButtons += `<button class="action-button" id="delete-button">Delete</button>`;
        } else {
            actionButtons += `<button class="action-button" id="disable-button">Disable</button>`;
        }

        mainInfo.innerHTML=`
        <p class="course-name">${this.title}</p>
        <p class="teacher-name">${this.teacher_name}</p>
        <p class="partner-name">${this.partner_name}</p>
        <div id="action-section">
            <p class="action-title">Action:</p>
            ${actionButtons}
        </div>
        <p class="description">${this.description || 'N/A'}</p>
        `;

        const otherInfo=document.getElementById('other-info');
        otherInfo.innerHTML=`
        <div>
            <p class="title">Id:</p>
            <p class="value">${this.id}</p>
        </div>
        <div>
            <p class="title">Teacher ID:</p>
            <p class="value">${this.teacher_id}</p>
        </div>
        <div>
            <p class="title">Price:</p> 
            <p class="value">${this.price}</p>
        </div>
        <div>
            <p class="title">Specialization:</p>
            <p class="value">${this.specialization}</p>
        </div>
        <div>
            <p class="title">Level:</p>
            <p class="value">${this.level}</p>
        </div>
        <div>
            <p class="title">Language:</p>
            <p class="value">${this.language}</p>
        </div>
        <div>
            <p class="title">Duration:</p>
            <p class="value">${this.duration}</p>
        </div>
        <div>
            <p class="title">Disable date:</p>
            <p class="value" style="text-align: justify;">${this.disable_date || 'N/A'}</p>
        </div>
        <div>
            <p class="title">Disable by:</p>
            <p class="value">${this.disable_by || 'N/A'}</p>
        </div>
        <div>
            <p class="title">Status:</p>
            <p class="value">${this.status}</p>
        </div>
        <div>
            <p class="title">Revenue:</p>
            <p class="value">${this.revenue} USD</p>
        </div>
        `;
    }
    
    static async get(id){
        try {
            const response = await fetch(`http://localhost:3000/api/courses/${encodeURIComponent(id)}?authenticate_teacher_ID=${encodeURIComponent(teacherId)}`);
            if (!response.ok) throw new Error(`Server responded ${response.status}`);
            const data = await response.json();
            const item = data.data;
            console.log(item);
            this.id = item.ID;
            this.title = item.Title;
            this.specialization = item.Specialization || '';
            this.description = item.Course_Description || '';
            this.language = item.Course_Language;
            this.price = item.Price;
            this.level = item.Course_Level;
            this.duration = item.Duration;
            this.teacher_id = item.Teacher_ID;
            this.disable_date = item.Delete_Date;
            this.disable_by = item.Delete_By;
            this.status = item.Course_Status;
            this.teacher_name = item.Teacher_Name || '';
            this.partner_name = '';
            

            const revenueRes = await fetch(`http://localhost:3000/api/courses/${encodeURIComponent(id)}/revenue`);
            if (!revenueRes.ok) throw new Error(`Server responded ${revenueRes.status} for revenue`);
            const revenueData = await revenueRes.json();
            this.revenue = revenueData.total_revenue;
        } catch (error) {
            console.error('Error:', error);
            alert('Failed to load course details: ' + error.message);
        }

    }

    static disable(id){
        // wrapper to call soft delete
        return this.softDelete(id);
    }

    static async softDelete(id){
        try {
            const res = await fetch(`http://localhost:3000/api/courses/${encodeURIComponent(id)}/soft`, {
                method: 'DELETE',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ teacherId: teacherId}),
            });
            if (!res.ok) {
                if (res.status === 500) {
                    const errData = await res.json();
                    alert(errData.message || 'Server error');
                } else {
                    throw new Error(`Server responded ${res.status}`);
                }
                return false;
            }
            alert('Course soft-deleted (Discarded)');
            this.status = 'Discarded';
            // refresh display and reattach listeners
            history.back()
            return true;
        } catch (err) {
            alert('Failed to disable course: ' + err.message);
            return false;
        }
    }

    static async hardDelete(id){
        try {
            const res = await fetch(`http://localhost:3000/api/courses/${encodeURIComponent(id)}/hard`, {
                method: 'DELETE',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ teacherId: teacherId }),
            });
            if (!res.ok) {
                if (res.status === 500) {
                    const errData = await res.json();
                    alert(errData.message || 'Server error');
                } else {
                    throw new Error(`Server responded ${res.status}`);
                }
                return false;
            }
            alert('Course permanently deleted');
            // redirect to home after deletion
            window.location.href = 'Home page.html';
            return true;
        } catch (err) {
            alert('Failed to delete course: ' + err.message);
            return false;
        }
    }

    static async enableCourse(id){
        try {
            const res = await fetch(`http://localhost:3000/api/courses/${encodeURIComponent(id)}`, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ status: 'Available', teacherId: Number(this.teacher_id)}),
            });
            if (!res.ok) {
                if (res.status === 500) {
                    const errData = await res.json();
                    alert(errData.message || 'Server error');
                } else {
                    throw new Error(`Server responded ${res.status}`);
                }
                return false;
            }
            alert('Course re-enabled');
            this.status = 'Available';
            this.display();
            MainPage.attachActionListeners();
            return true;
        } catch (err) {
            alert('Failed to enable course: ' + err.message);
            return false;
        }
    }

    static async openEditForm() {
        // Create or get holder
        let holder = document.getElementById('add-course-form');
        if (!holder) {
            holder = document.createElement('div');
            holder.id = 'add-course-form';
            document.body.appendChild(holder);
        }

        try {
            const tRes = await fetch('../template/course-form.html');
            if (!tRes.ok) throw new Error(`Failed to load template: ${tRes.status}`);
            const tText = await tRes.text();

            const styleMatch = tText.match(/<style[\s\S]*?<\/style>/i);
            const styleHtml = styleMatch ? styleMatch[0] : '';
            const formMatch = tText.match(/<form[\s\S]*?<\/form>/i);
            const formHtml = formMatch ? formMatch[0] : '';
            if (!formHtml) throw new Error('Template form not found');

            holder.innerHTML = styleHtml + formHtml;

            const courseForm = holder.querySelector('#course-form');
            const overlay = holder.querySelector('.overlay');
            const cancelBtn = holder.querySelector('#cancel');
            const acceptBtn = holder.querySelector('#accept');

            // Prefill values
            if (courseForm) {
                courseForm.querySelector('#edit-title').value = this.title || '';
                courseForm.querySelector('#edit-language').value = this.language || '';
                courseForm.querySelector('#edit-description').value = this.description || '';
                // If stored price is 'FREE' or '123 USD', convert to numeric for input
                let numericPrice = '';
                if (this.price && this.price !== 'FREE') {
                    const m = this.price.toString().match(/([0-9]+(\.[0-9]+)?)/);
                    numericPrice = m ? m[0] : '';
                } else if (this.price === 'FREE') {
                    numericPrice = '0';
                }
                const priceInput = courseForm.querySelector('#edit-price');
                if (priceInput) priceInput.value = numericPrice;
                const levelSelect = courseForm.querySelector('#edit-level');
                if (levelSelect) levelSelect.value = this.level || '';
                courseForm.querySelector('#edit-duration').value = this.duration || '';
                courseForm.querySelector('#edit-specialization').value = this.specialization || '';
            }

            const close = () => { holder.innerHTML = ''; };
            if (overlay) overlay.addEventListener('click', close);
            if (cancelBtn) cancelBtn.addEventListener('click', (e) => { e.preventDefault(); close(); });

            if (acceptBtn && courseForm) {
                acceptBtn.addEventListener('click', async (e) => {
                    e.preventDefault();
                    const title = courseForm.querySelector('#edit-title')?.value ?? '';
                    const language = courseForm.querySelector('#edit-language')?.value ?? '';
                    const description = courseForm.querySelector('#edit-description')?.value ?? '';
                    const priceRaw = courseForm.querySelector('#edit-price')?.value ?? '';
                    const level = courseForm.querySelector('#edit-level')?.value ?? '';
                    const duration = courseForm.querySelector('#edit-duration')?.value ?? '';
                    const specialization = courseForm.querySelector('#edit-specialization')?.value ?? '';

                    let priceValue = '';
                    if (priceRaw !== '') {
                        const num = parseFloat(priceRaw.toString());
                        if (!isNaN(num)) priceValue = (num === 0) ? 'FREE' : `${num} USD`;
                    }

                    const payload = {
                        title,
                        language,
                        description,
                        price: priceValue,
                        level,
                        duration,
                        specialization,
                        teacherId: Number(this.teacher_id),
                    };

                    const ok = await Course.updateCourse(this.id, payload);
                    if (ok) {
                        // update local copy (updateCourse performs reload currently)
                        this.title = payload.title;
                        this.language = payload.language;
                        this.description = payload.description;
                        this.price = payload.price;
                        this.level = payload.level;
                        this.duration = payload.duration;
                        this.specialization = payload.specialization;
                        close();
                    }
                });
            }
        } catch (err) {
            console.error('Failed to open edit form:', err);
            alert('Failed to open edit form: ' + err.message);
        }
    }

    static async updateCourse(courseId, data) {
        try {
            const res = await fetch(`http://localhost:3000/api/courses/${encodeURIComponent(courseId)}`, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data),
            });
            if (!res.ok) {
                if (res.status === 500) {
                    const errData = await res.json();
                    alert(errData.message || 'Server error');
                } else {
                    throw new Error(`Server responded ${res.status}`);
                }
                return false;
            }
            alert('Course updated successfully');
            location.reload()
            return true;
        } catch (err) {
            alert('Failed to update course: ' + err.message);
            return false;
        }
    }
}

// Thread and Reply classes remain the same...

class MainPage{
    static loadPre(){
        fetch('../template/topbar.html')
            .then(res => res.text())
            .then(html => document.getElementById('top-bar').innerHTML = html);
        fetch('../template/footer.html')
            .then(res => res.text())
            .then(html => document.getElementById('footer').innerHTML = html);
    }
    
    static async load(){
        this.loadPre();
        const urlParams = new URLSearchParams(window.location.search);
        const courseId = urlParams.get('id');
        await Course.get(courseId);
        Course.display();
        
        // Attach action listeners for buttons rendered in display
        this.attachActionListeners();
    }

    static attachActionListeners(){
        const editButton = document.getElementById('edit-button');
        if (editButton) {
            editButton.addEventListener('click', () => {
                Course.openEditForm();
            });
        }
        const enterButton = document.getElementById('enter-button');
        if (enterButton) {
            enterButton.addEventListener('click', () => {
                window.location.href = "Module.html";
            });
        }
        const disableButton = document.getElementById('disable-button');
        if (disableButton) {
            disableButton.addEventListener('click', async () => {
                const ok = await Course.softDelete(Course.id);
                if (ok) {
                    // listeners are reattached in softDelete via display()
                }
            });
        }
        const enableButton = document.getElementById('enable-button');
        if (enableButton) {
            enableButton.addEventListener('click', async () => {
                await Course.enableCourse(Course.id);
            });
        }
        const deleteButton = document.getElementById('delete-button');
        if (deleteButton) {
            deleteButton.addEventListener('click', async () => {
                const confirmed = confirm('Are you sure you want to permanently delete this course?');
                if (!confirmed) return;
                await Course.hardDelete(Course.id);
            });
        }
    }
}

MainPage.load();
import { is_teacher, teacherId } from "./utils.js";

class CourseBackground {
    static #list = [
        "images/coursebg%201.png",
        "images/coursebg%202.png",
        "images/coursebg%203.png",
        "images/coursebg%204.png",
        "images/coursebg%205.png",
    ];
    static #i = 0;

    static next() {
        const img = this.#list[this.#i];
        this.#i = (this.#i + 1) % this.#list.length;
        return img;
    }
}

class CourseTable {
    static get container() {
        return document.querySelector(".course-table");
    }

    static addAddButton() {
        const container = this.container;
        if (!container) return;

        const addButton = document.createElement("button");
        addButton.className = "add-course";
        addButton.id = "add-course";
        addButton.textContent = "+";
        container.appendChild(addButton);

        addButton.addEventListener("click", async () => {
            try {
                const res = await fetch("../template/course-form.html");
                if (!res.ok) throw new Error(`Failed to load form: ${res.status}`);
                const html = await res.text();
                let holder = document.getElementById("add-course-form");
                if (!holder) {
                    holder = document.createElement('div');
                    holder.id = 'add-course-form';
                    document.body.appendChild(holder);
                }

                holder.innerHTML = html;

                // Elements inside the injected template
                const courseForm = holder.querySelector('#course-form');
                const overlay = holder.querySelector('.overlay');
                const cancelBtn = holder.querySelector('#cancel');
                const acceptBtn = holder.querySelector('#accept');

                const closeForm = () => { holder.innerHTML = ''; };

                if (cancelBtn) {
                    cancelBtn.addEventListener('click', (e) => { e.preventDefault(); closeForm(); });
                }
                if (overlay) {
                    overlay.addEventListener('click', () => closeForm());
                }

                if (acceptBtn && courseForm) {
                    acceptBtn.addEventListener('click', async (e) => {
                        e.preventDefault();
                        const title = courseForm.querySelector('#edit-title')?.value ?? '';
                        const language = courseForm.querySelector('#edit-language')?.value ?? '';
                        const description = courseForm.querySelector('#edit-description')?.value ?? '';
                        const price = courseForm.querySelector('#edit-price')?.value ?? '';
                        const level = courseForm.querySelector('#edit-level')?.value ?? '';
                        const duration = courseForm.querySelector('#edit-duration')?.value ?? '';
                        const specialization = courseForm.querySelector('#edit-specialization')?.value ?? '';

                        try {
                            // 1) Create course (POST)
                            const postRes = await fetch('http://localhost:3000/api/courses', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/json' },
                                body: JSON.stringify({ title: title, teacherId: Number(teacherId) }),
                            });
                            if (!postRes.ok) {
                                if (postRes.status === 500) {
                                    const errData = await postRes.json();
                                    alert(errData.message || 'Server error');
                                } else {
                                    throw new Error(`Create failed: ${postRes.status}`);
                                }
                                return;
                            }
                            const postData = await postRes.json();
                            // assume API returns newCourseId in response (template expected newCourseId)
                            const CourseID = postData.newCourseId || postData.id || postData.ID;
                            if (!CourseID) throw new Error('No CourseID returned from create API');

                            // 2) Update course with details (PUT)
                            let priceValue = '';
                            if (price !== '') {
                                const num = parseFloat(price);
                                if (!isNaN(num)) priceValue = (num === 0) ? 'FREE' : `${num} USD`;
                            }
                            const putBody = {
                                language,
                                description,
                                price: priceValue,
                                level,
                                duration,
                                specialization,
                                teacherId: Number(teacherId),
                            };
                            const putRes = await fetch(`http://localhost:3000/api/courses/${encodeURIComponent(CourseID)}`, {
                                method: 'PUT',
                                headers: { 'Content-Type': 'application/json' },
                                body: JSON.stringify(putBody),
                            });
                            if (!putRes.ok) {
                                if (putRes.status === 500) {
                                    const errData = await putRes.json();
                                    alert(errData.message || 'Server error');
                                } else {
                                    throw new Error(`Update failed: ${putRes.status}`);
                                }
                                return;
                            }

                            alert('Course added successfully!');
                            closeForm();
                            await CourseTable.loadCourses();
                        } catch (err) {
                            alert('Failed to create course: ' + err.message);
                        }
                    });
                }
            } catch (err) {
                alert("Error loading form: " + err.message);
            }
        });
    }

    static createCourseNode({ id, title, teacher_name, partner_name = "", price }) {
        const a = document.createElement("a");
        a.className = "course-link";
        a.href = `Course.html?id=${encodeURIComponent(id)}`;

        const item = document.createElement("div");
        item.className = "item";

        const img = document.createElement("img");
        img.src = CourseBackground.next();
        img.alt = title;

        const pTitle = document.createElement("p");
        pTitle.className = "course-name";
        pTitle.textContent = title.length > 40 ? title.slice(0, 40) + "..." : title;

        const pTeacher = document.createElement("p");
        pTeacher.className = "teacher-name";
        pTeacher.textContent = teacher_name || "";

        const pPartner = document.createElement("p");
        pPartner.className = "partner-name";
        pPartner.textContent = partner_name;

        const pPrice = document.createElement("p");
        pPrice.className = "price";
        pPrice.textContent = price;

        item.appendChild(img);
        item.appendChild(pTitle);
        item.appendChild(pTeacher);
        item.appendChild(pPartner);
        item.appendChild(pPrice);

        a.appendChild(item);
        return a;
    }

    static addCourse(id, title, teacher_name, partner_name, price) {
        const container = this.container;
        if (!container) return;
        const node = this.createCourseNode({ id, title, teacher_name, partner_name, price });
        container.appendChild(node);
    }

    static async submitCourseForm(title, teacherId) {
        try {
            const res = await fetch("http://localhost:3000/api/courses", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ title, teacherId }),
            });
            if (!res.ok) throw new Error(`Server responded ${res.status}`);
            // Reload courses after successful add
            await this.loadCourses();
            alert("Course added successfully!");
            return true;
        } catch (err) {
            alert("Failed to add course: " + err.message);
            return false;
        }
    }

    static async loadCourses(url = "http://localhost:3000/api/courses/search") {
        const container = this.container;
        if (!container) return;

        // Remove only course items, preserve the add button
        const existingItems = container.querySelectorAll("a.course-link");
        existingItems.forEach(item => item.remove());

        try {
            const res = await fetch(url);
            if (!res.ok) throw new Error(`Server responded ${res.status}`);
            const data = await res.json();
            const list = data && data.data ? data.data : [];
            
            // Insert items before the add button (if it exists)
            const addButton = container.querySelector("#add-course");
            for (const item of list) {
                const courseNode = this.createCourseNode({ 
                    id: item.ID, 
                    title: item.Title, 
                    teacher_name: item.Teacher_Name, 
                    partner_name: item.Partner_Name || "", 
                    price: item.Price 
                });
                if (addButton) {
                    container.insertBefore(courseNode, addButton);
                } else {
                    container.appendChild(courseNode);
                }
            }
        } catch (err) {
            alert("Error loading courses: " + err.message);
        }
    }
}

class Filter {
    static attach() {
        const applyButton = document.querySelector(".apply-button");
        if (!applyButton) return;
        applyButton.addEventListener("click", async (e) => {
            e.preventDefault();
            await this.loadFilteredCourses();
        });
    }

    static getFilterParams() {
        const filterForm = document.querySelector(".filter-form");
        const params = new URLSearchParams();
        
        if (!filterForm) return params;

        const minPrice = filterForm.querySelector('input[name="from"]')?.value ?? "";
        const maxPrice = filterForm.querySelector('input[name="to"]')?.value ?? "";
        const language = filterForm.querySelector('select[name="language"]')?.value ?? "";
        const level = filterForm.querySelector('select[name="level"]')?.value ?? "";
        const teacher_id = filterForm.querySelector('input[name="teacher-id"]')?.value ?? "";
        const specialization = filterForm.querySelector('input[name="specialization"]')?.value ?? "";

        if (minPrice) params.set("minPrice", minPrice);
        if (maxPrice) params.set("maxPrice", maxPrice);
        if (language) params.set("language", language);
        if (level) params.set("level", level);
        if (teacher_id) params.set("teacherId", teacher_id);
        if (specialization) params.set("specialization", specialization);

        return params;
    }

    static async loadFilteredCourses() {
        const params = this.getFilterParams();
        // Also include search keyword if present
        const searchInput = document.querySelector('.input-box');
        const kw = searchInput?.value?.trim() ?? "";
        if (kw) {
            params.set('keyword', kw);
        }
        const url = `http://localhost:3000/api/courses/search?${params.toString()}`;
        await CourseTable.loadCourses(url);
    }
}

class MainPage {
    static async loadPre() {
        const topbarHolder = document.getElementById("top-bar");
        if (topbarHolder) {
            const res = await fetch("../template/topbar.html");
            topbarHolder.innerHTML = await res.text();
        }

        const footerHolder = document.getElementById("footer");
        if (footerHolder) {
            const res = await fetch("../template/footer.html");
            footerHolder.innerHTML = await res.text();
        }

        const filterButton = document.querySelector(".filter-button");
        if (filterButton) {
            filterButton.addEventListener("click", () => {
                const filterFrom = document.querySelector(".filter-form");
                if (filterFrom) filterFrom.classList.toggle("hidden");
            });
        }

        // Search box: click or Enter to search via API
        const searchInput = document.querySelector('.input-box');
        const searchButton = document.querySelector('.search-button');
        const doSearch = async () => {
            const kw = searchInput?.value?.trim() ?? "";
            const params = Filter.getFilterParams();
            
            if (kw) {
                params.set('keyword', kw);
            }
            
            const url = `http://localhost:3000/api/courses/search?${params.toString()}`;
            await CourseTable.loadCourses(url);
        };

        if (searchButton) searchButton.addEventListener('click', (e) => { e.preventDefault(); doSearch(); });
        if (searchInput) searchInput.addEventListener('keydown', (e) => { if (e.key === 'Enter') { e.preventDefault(); doSearch(); } });
    }

    static attachDelegates() {
        // No event delegation needed currently
    }

    static async load() {
        await this.loadPre();
        this.attachDelegates();
        Filter.attach();
        await CourseTable.loadCourses();
        if (is_teacher) CourseTable.addAddButton();
    }
}

// Initialize when DOM is ready
if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", () => MainPage.load());
} else {
    MainPage.load();
}






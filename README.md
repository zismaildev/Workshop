# 🎓 My Workshop & Knowledge Hub

ยินดีต้อนรับสู่ **Crate of Knowledge**! 📦
Repository นี้จัดทำขึ้นเพื่อรวบรวม Source Code, Project Example และองค์ความรู้ต่างๆ ที่ได้จากการเข้าร่วมกิจกรรม Tech Camp, Workshop และสัมมนาทางเทคโนโลยีต่างๆ เพื่อใช้เป็น "Digital Garden" สำหรับทบทวนและต่อยอดความรู้ในอนาคต

---

## 🗺️ แผนที่การเรียนรู้ (Learning Path)

Repository นี้แบ่งออกเป็นหัวข้อตามงาน Workshop ที่ได้เข้าร่วม ดังนี้:

| กิจกรรม / งาน (Event) | หัวข้อหลัก (Topic) | เทคโนโลยี (Stack) | ลิงก์ (Go to) |
| :--- | :--- | :--- | :--- |
| **Agoda Tech Camp Day** | สร้าง Chatbot ง่ายๆ ด้วย LINE Messaging API | ![Node.js](https://img.shields.io/badge/Node.js-339933?style=flat-square&logo=nodedotjs&logoColor=white) ![LINE](https://img.shields.io/badge/LINE-00C300?style=flat-square&logo=line&logoColor=white) | [📂 คลิกเพื่อดู](./Tech-Camp-Day) |
| **Northern Tech on the Rock** | 1. สร้าง AI Agent (Strands)<br>2. Confident Deploys (TypeScript)<br>3. RAG with One MongoDB<br>4. GitHub Actions Security | ![Python](https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white) <br> ![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?style=flat-square&logo=typescript&logoColor=white) <br> ![MongoDB](https://img.shields.io/badge/MongoDB-47A248?style=flat-square&logo=mongodb&logoColor=white) <br> ![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=flat-square&logo=github-actions&logoColor=white) | [📂 AI Agent](./Northern-Tech-on-the-Rock/Strands-Agent-Mastery)<br>[📂 TypeScript](./Northern-Tech-on-the-Rock/TypeScript-for-Confident-Deploys)<br>[📂 RAG MongoDB](./Northern-Tech-on-the-Rock/RAG-with-One-MongoDB)<br>[📂 GHA Security](./Northern-Tech-on-the-Rock/GitHub-Actions-Security-Crash-Course) |
| **CMRU Workshop** | 1. Web Security Labs (OWASP ZAP)<br>2. Senior Teaching Junior 2026 | ![PHP](https://img.shields.io/badge/PHP-777BB4?style=flat-square&logo=php&logoColor=white) ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white) | [📂 Security](./AI-App-Security)<br>[📂 Flutter](./Senior-Teaching-Junior-2026) |

---

## 🏗️ รายละเอียดโปรเจกต์ (Project Details)

### 1. [Agoda Tech Camp Day](./Tech-Camp-Day)
เวิร์กช็อปจากทีม **Agoda** ที่สอนสร้าง LINE Chatbot ตั้งแต่พื้นฐานจนถึงระบบใช้งานจริง
- **Project Structure**: Monorepo (Node.js)
- **Key Learnings**:
  - การจัดการ Webhook ของ LINE
  - การใช้ Flex Message
  - การทำระบบสมาชิกและระบบร้านค้า (Loyalty Program)
  - การเชื่อมต่อ External API (OpenMeteo)
- **วิทยากร**: ทีมงาน Agoda
- **Original Repo**: [tech-camp-day/workshop-cookbook](https://github.com/tech-camp-day/workshop-cookbook/tree/main)

### 2. [Northern Tech on the Rock](./Northern-Tech-on-the-Rock)
รวบรวมเวิร์กช็อปจากงาน Tech Conference ภาคเหนือ

#### 2.1 [Strands Agent Mastery](./Northern-Tech-on-the-Rock/Strands-Agent-Mastery)
เวิร์กช็อปเจาะลึกเรื่อง **AI Agents**
- **Tech Stack**: Python, Strands
- **Key Learnings**: พื้นฐานการสร้าง AI Agent, Multi-Agent Patterns
- **วิทยากร**: คุณธณิศร จันทร์สำเร็จ (Solution Architect - AWS Thailand)

#### 2.2 [TypeScript for Confident Deploys](./Northern-Tech-on-the-Rock/TypeScript-for-Confident-Deploys)
เวิร์กช็อปการจัดการ Infrastructure และ Secrets ด้วย TypeScript
- **Tech Stack**: TypeScript, Bun, Azure Container Apps, GitHub Actions
- **Key Learnings**:
  - การเขียน Configuration Infrastructure เป็น Code (IaC) ด้วย TypeScript
  - การจัดการ Secrets อย่างปลอดภัยด้วย Azure Key Vault
  - การทำ Automated Deployment ผ่าน GitHub Actions
- **วิทยากร**: คุณธาดา หวังธรรมมั่ง (Platform Team Lead: T.T. Software Solution) และเจ้าของเพจ ไทยไทป์ [mildronize](https://github.com/mildronize)
- **Original Repo**: [mildronize/ts-confident-deploy-and-secret](https://github.com/mildronize/ts-confident-deploy-and-secret)

#### 2.3 [RAG with One MongoDB](./Northern-Tech-on-the-Rock/RAG-with-One-MongoDB)
เวิร์กช็อปการทำ Hybrid Search
- **Tech Stack**: Python, MongoDB Atlas (Vector Search), Ollama
- **Key Learnings**: การทำ Hybrid Search (Vector + Keyword) โดยใช้เทคนิค RSF และ RRF
- **วิทยากร**: คุณปิติ จำปีทอง (Senior Consulting Engineer: Mongo DB) [ninefyi](https://github.com/ninefyi)
- **Original Repo**: [ninefyi/tech-on-the-rock-2025](https://github.com/ninefyi/tech-on-the-rock-2025)

#### 2.4 [GitHub Actions Security Crash Course](./Northern-Tech-on-the-Rock/GitHub-Actions-Security-Crash-Course)
เวิร์กช็อปการทำ DevSecOps Pipeline
- **Tech Stack**: GitHub Actions, OWASP ZAP, Cloudflare Pages
- **Key Learnings**: การทำ DevSecOps Pipeline, ยิง Security Scan (DAST) อัตโนมัติทุกครั้งที่ Deploy
- **วิทยากร**: คุณปิติ จำปีทอง (Senior Consulting Engineer: Mongo DB) [ninefyi](https://github.com/ninefyi)
- **Original Repo**: [ninefyi/tech-on-the-rock-2025](https://github.com/ninefyi/tech-on-the-rock-2025)

### 3. CMRU Workshop
รวบรวม Lab และโปรเจกต์จากการเรียนที่มหาวิทยาลัยราชภัฏเชียงใหม่

#### 3.1 [AI-App-Security](./AI-App-Security)
วิชา **Secure Web Engineering Lab** สอนเกี่ยวกับช่องโหว่ Web Security และวิธีการป้องกันแบบ Hands-on
- **Tech Stack**: PHP, XAMPP, OWASP ZAP
- **Key Learnings**:
  - XSS (Cross-Site Scripting) และการป้องกัน
  - Access Control และ File Upload Security
  - การใช้ OWASP ZAP สแกนหาช่องโหว่
  - Secure Coding Practices ใน PHP
- **Lab Structure**: แต่ละ Lab มีทั้ง Vulnerable และ Secure Version เพื่อเปรียบเทียบ
- **จำนวน Labs**: 5 Labs (XSS, GET/POST Trust, Access Control, File Upload, Info Disclosure)

#### 3.2 [Senior Teaching Junior 2026](./Senior-Teaching-Junior-2026)
**อบรมวันที่ 23-27 ก.พ. 2569: ระบบแอปมือถือสำหรับ Login และจัดการสินค้า ด้วย Flutter + Firebase + Cloudinary**
โครงการอบรมเชิงปฏิบัติการเพื่อส่งเสริมทักษะการเลือกใช้เครื่องมือและพัฒนาแอปพลิเคชันอย่างมืออาชีพ

- **Tech Stack**: Flutter, Firebase, Figma, AI Code Generator
- **Key Learnings**:
  - การใช้ AI ช่วยเขียนโค้ดเพื่อเพิ่มประสิทธิภาพ
  - พัฒนา Mobile App ด้วย Flutter และเชื่อมต่อ Firebase
  - การออกแบบ UI/UX ด้วย Figma
- **วิทยากร**: Tanonchai (รุ่นพี่รหัส 65 Computer Science) [Tanonchai67](https://github.com/Tanonchai67)

#### 3.3 [Senior Teaching Junior 2026](./Senior-Teaching-Junior-2026)
**อบรมวันที่ 2-6 มี.ค. 2569: ระบบจัดการเวิร์กชอป (Workshop Management System)**
ระบบลงทะเบียนและจัดการกิจกรรมเวิร์กชอป พัฒนาด้วย Laravel 12 ร่วมกับ Livewire 3 ออกแบบ UI ให้มีความสวยงามทันสมัยสไตล์ Glassmorphism ด้วย Flux UI และ Tailwind CSS v4

- **Tech Stack**: Laravel 12, Livewire 3, Tailwind CSS v4, PostgreSQL 16, Docker, Bun, GitHub Actions (Self-hosted Runner)
- **Key Features**:
  - **👨‍🎓 Student Panel**: ลงทะเบียนได้สูงสุด 3 หัวข้อ, ป้องกัน Double Registration, ปิดรับสมัครอัตโนมัติเมื่อที่นั่งเต็ม Real-time, โปรไฟล์ดึงรูปจาก CMRU API
  - **👨‍💼 Admin Panel**: CRUD เวิร์กช็อป, Dashboard จำนวนผู้ลงทะเบียนและที่นั่งคงเหลือ
  - **🚀 CI/CD**: Auto deploy ผ่าน GitHub Actions Self-hosted Runner (Build Vite, Migrate DB, Cleanup)
- **วิทยากร**: Kritsanai (รุ่นพี่รหัส 65 Web Technology) [NightBrain](https://github.com/NightBrain)

> **หมายเหตุ:** โปรเจกต์นี้ถูก Push ไปที่ GitHub Organization [Department-of-Computer-CMRU-2026](https://github.com/Department-of-Computer-CMRU-2026)
> 🔗 **Source Code:** [Workshop-std66143420](https://github.com/Department-of-Computer-CMRU-2026/Workshop-std66143420)

---

## 💡 วัตถุประสงค์ (Purpose)
1.  **Centralize**: รวมโค้ดจากหลายแหล่งไว้ที่เดียว ไม่กระจัดกระจาย
2.  **Standardize**: จัดระเบียบโครงสร้างโฟลเดอร์ให้เป็นมาตรฐาน ดูแลรักษาง่าย
3.  **Knowledge Base**: ใช้เป็นคู่มืออ้างอิง (Reference) เมื่อต้องทำงานโปรเจกต์จริง


---

## 👨‍💻 เกี่ยวกับผู้จัดทำ (About Me)

**ผู้จัดทำ Repository**: [zismaildev](https://github.com/zismaildev)
**สถานะ**: ผู้เข้าร่วมอบรม (Workshop Attendee)

Repository นี้ถูกจัดทำขึ้นเพื่อรวบรวมความรู้และโค้ดตัวอย่างจากการเข้าร่วมกิจกรรมอบรม เพื่อเป็นประโยชน์ต่อการศึกษาและทบทวนในภายหลัง หากมีข้อผิดพลาดประการใด ขออภัยมา ณ ที่นี้

> *"Learning is a treasure that will follow its owner everywhere."*

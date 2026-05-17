# 👥 PEMBAGIAN TUGAS & RESPONSIBILITY MATRIX
## Proyek TukangDekat - 11 Mei - 18 Juni 2026

**Status:** In Planning  
**Last Updated:** 17 Mei 2026  
**Document Version:** 1.0

---

## 📋 STRUKTUR ORGANISASI PROYEK

```
┌─────────────────────────────────────────┐
│  Project Manager: R. Elsa Balqis K.S   │
│  (Overall Coordination & Timeline)      │
└─────────────────┬───────────────────────┘
        ┌─────────┼─────────┐
        │         │         │
    ┌───┴──┐  ┌──┴───┐  ┌──┴────┐
    │Backend│  │Frontend│  │ QA   │
    │ Team  │  │ Team   │  │ Team │
    └───┬──┘  └──┬───┘  └──┬────┘
      (3)        (3)       (1)
```

---

## 🔧 BACKEND TEAM (3 Orang)

### 1️⃣ Muhammad Fajar Nurjaman - Lead Backend Developer

**📌 Posisi:** Backend Architect & DevOps Lead  
**📧 GitHub:** @mfajar  
**📞 Role Code:** BACKEND-LEAD

#### 🎯 Tanggung Jawab Utama
- Arsitektur API & sistem design
- Database design & optimization
- Authentication & Authorization system
- Payment gateway integration
- n8n workflow configuration
- DevOps & Deployment (Docker, Server)
- Code quality & code review
- API documentation

#### 📅 Sprint Tasks

**Minggu 1: Planning & Setup**
- [ ] Setup repository GitHub + branching strategy
- [ ] Setup Backend environment (Laravel, Docker, composer)
- [ ] Create docker-compose.yml & Dockerfile
- [ ] Create .env.example & documentation
- [ ] Database schema design review & finalization
- [ ] Create API endpoint contract

**Minggu 2: Backend Foundation**
- [ ] Create database migrations
- [ ] Database seeding (test data)
- [ ] Authentication module (Register API)
- [ ] Login API (token-based JWT)
- [ ] Logout API & token invalidation
- [ ] Role-based access control (RBAC) middleware
- [ ] Review & test authentication endpoints

**Minggu 3: Order & Payment**
- [ ] Create Order endpoints (POST /orders)
- [ ] Payment gateway sandbox setup (Midtrans/Xendit)
- [ ] Configure webhook secrets & URLs
- [ ] DP payment QRIS generation API
- [ ] Webhook handler for payment callbacks
- [ ] Payment status update logic
- [ ] Test payment flow end-to-end

**Minggu 4: Features & Notifications**
- [ ] n8n integration setup
- [ ] Create webhook endpoints for n8n triggers
- [ ] Order notification events
- [ ] Payment notification events
- [ ] Treasurer monitoring API endpoints
- [ ] Payment transaction reports

**Minggu 5: Testing & Optimization**
- [ ] Performance testing & optimization
- [ ] Database query optimization
- [ ] API response time monitoring
- [ ] Bug fixes (backend)
- [ ] Finalize API documentation (Swagger export)

**Minggu 6: Deployment**
- [ ] Production server setup
- [ ] Database backup & recovery configuration
- [ ] SSL certificate installation
- [ ] Deployment to production
- [ ] Post-launch monitoring

#### 🎁 Deliverables
- ✅ Laravel API project (Git ready)
- ✅ Docker environment setup
- ✅ Database schema & migrations
- ✅ 27 API endpoints (fully documented)
- ✅ Payment gateway integration
- ✅ n8n webhook configuration
- ✅ API Swagger/Postman export
- ✅ Deployment documentation
- ✅ Performance metrics report

#### 📊 Success Metrics
- Zero critical bugs in production
- API response time < 1 second (NFR-01)
- 100% test coverage for critical endpoints
- Payment webhook accuracy: 100%
- Database uptime: 99.9%

---

### 2️⃣ Nabilah Asana Alecia - Backend Developer (Provider & Order)

**📌 Posisi:** Backend Developer - Business Logic  
**📧 GitHub:** @nabilah  
**📞 Role Code:** BACKEND-DEV-1

#### 🎯 Tanggung Jawab Utama
- Provider management module
- Order state machine & lifecycle
- Order business logic
- Payment processing logic
- Transaction management & rollback
- Data validation & error handling
- Unit testing (backend)

#### 📅 Sprint Tasks

**Minggu 1: Planning & Setup**
- [ ] Attend kick-off meeting
- [ ] Review database schema (provider & order tables)
- [ ] Study API contract for provider & order endpoints
- [ ] Setup local development environment

**Minggu 2: Backend Foundation**
- [ ] Provider registration endpoint (FR-05)
- [ ] Provider profile update endpoint (FR-05)
- [ ] Provider verification API (admin) (FR-06)
- [ ] Provider deactivation API (admin) (FR-07)
- [ ] Provider list endpoint (with filter)
- [ ] Provider detail endpoint
- [ ] Unit tests for provider module

**Minggu 3: Order & Payment**
- [ ] Order status update endpoint (FR-12, FR-13)
- [ ] Order accept/reject logic (FR-12)
- [ ] Order state transition validation
- [ ] Final price setting endpoint
- [ ] Final payment endpoint (FR-19, FR-20)
- [ ] Order closure logic (FR-20)
- [ ] Transaction handling & rollback

**Minggu 4: Features & Notifications**
- [ ] Notification event for order status changes
- [ ] Notification event for payment status
- [ ] Order history endpoint
- [ ] Customer order tracking API
- [ ] Provider order queue API

**Minggu 5: Testing & Optimization**
- [ ] Functional testing - all order endpoints
- [ ] Integration testing - order + payment flow
- [ ] Bug fixes (order & payment related)
- [ ] Performance testing - order queries
- [ ] Security testing - access control

**Minggu 6: Deployment**
- [ ] Final UAT coordination
- [ ] Production bug fixes (if any)
- [ ] Post-launch monitoring

#### 🎁 Deliverables
- ✅ Provider management API (6 endpoints)
- ✅ Order management API (8 endpoints)
- ✅ Payment processing logic
- ✅ Transaction handling implementation
- ✅ Unit tests (70% coverage)
- ✅ Integration test cases

#### 📊 Success Metrics
- All order endpoints working correctly
- Zero payment-related bugs
- State machine transitions: 100% valid
- Unit test coverage: ≥ 70%
- Integration test pass rate: 100%

---

### 3️⃣ Fatin Asyifa Nurrizky JenPutri - Backend Developer (Catalog & Features)

**📌 Posisi:** Backend Developer - Catalog & Features  
**📧 GitHub:** @fatin  
**📞 Role Code:** BACKEND-DEV-2

#### 🎯 Tanggung Jawab Utama
- Service catalog & search functionality
- Category management
- Rating & review system
- Treasurer monitoring dashboard API
- Search & filter logic
- Data aggregation & reporting
- API validation & error responses

#### 📅 Sprint Tasks

**Minggu 1: Planning & Setup**
- [ ] Attend kick-off meeting
- [ ] Review database schema (category, service, rating tables)
- [ ] Study API contract for catalog endpoints
- [ ] Setup local development environment

**Minggu 2: Backend Foundation**
- [ ] Category CRUD endpoints
- [ ] Service catalog endpoint (FR-08)
- [ ] Provider list by category (FR-08)
- [ ] Search endpoint - by keyword (FR-09)
- [ ] Provider detail endpoint (FR-10)
- [ ] Provider statistics (ratings, reviews)

**Minggu 3: Order & Payment**
- [ ] DP payment logic & calculation (FR-15, FR-16)
- [ ] Payment status validation
- [ ] Order can proceed only if DP paid (FR-14)
- [ ] Final price calculation
- [ ] Invoice generation

**Minggu 4: Features & Notifications**
- [ ] Rating endpoint POST (FR-23)
- [ ] Review/ulasan endpoint POST (FR-23)
- [ ] Average rating calculation (FR-24)
- [ ] Treasurer transaction list API (FR-25)
- [ ] Treasurer summary report API (FR-26)
- [ ] Date range filtering for reports

**Minggu 5: Testing & Optimization**
- [ ] Functional testing - catalog endpoints
- [ ] Functional testing - rating endpoints
- [ ] Functional testing - treasurer dashboard
- [ ] Search performance testing
- [ ] Report generation testing
- [ ] Bug fixes (catalog & features)

**Minggu 6: Deployment**
- [ ] Final testing & validation
- [ ] Production deployment support
- [ ] Post-launch monitoring

#### 🎁 Deliverables
- ✅ Category & Catalog API (5 endpoints)
- ✅ Search functionality
- ✅ Rating & Review API (4 endpoints)
- ✅ Treasurer monitoring API (3 endpoints)
- ✅ Report generation
- ✅ Functional & integration tests

#### 📊 Success Metrics
- All catalog searches < 500ms
- Rating system: 100% accurate
- Treasurer reports: 100% accurate
- Test coverage: ≥ 70%
- Zero data inconsistency issues

---

## 🎨 FRONTEND TEAM (3 Orang)

### 1️⃣ Tetep Safarudin - Lead Frontend Developer

**📌 Posisi:** Frontend Architect & Navigation Lead  
**📧 GitHub:** @tetep  
**📞 Role Code:** FRONTEND-LEAD

#### 🎯 Tanggung Jawab Utama
- UI/UX implementation architecture
- Flutter project setup & configuration
- Navigation & routing management
- State management architecture (GetX / Provider)
- Authentication UI flow
- Component library & reusable widgets
- Code review (frontend)
- Frontend documentation

#### 📅 Sprint Tasks

**Minggu 1: Planning & Setup**
- [ ] Setup Flutter project (latest version)
- [ ] Create pubspec.yaml dengan dependencies
- [ ] Setup project folder structure
- [ ] Create README (Flutter setup guide)
- [ ] Define naming conventions & coding standards
- [ ] Setup CI/CD pipeline untuk flutter

**Minggu 2: Backend Foundation**
- [ ] Create authentication screens (login, register, forgot password)
- [ ] Implement HTTP client & API service layer
- [ ] Login screen UI (beautiful design)
- [ ] Register screen UI
- [ ] Onboarding / role selection screen
- [ ] Home navigation structure
- [ ] Bottom navigation bar component
- [ ] Connect auth screens to backend API

**Minggu 3: Order & Payment**
- [ ] Provider list screen
- [ ] Provider detail screen
- [ ] Order creation form screen
- [ ] Payment QR display screen
- [ ] Order history screen
- [ ] Order detail & status tracking

**Minggu 4: Features & Notifications**
- [ ] Notification center screen
- [ ] Notification alert component
- [ ] Real-time notification integration
- [ ] Admin/treasurer dashboard navigation
- [ ] Dashboard layout setup

**Minggu 5: Testing & Optimization**
- [ ] UI consistency review
- [ ] Navigation flow testing
- [ ] Responsive design testing (different screen sizes)
- [ ] Performance optimization (lazy loading)
- [ ] Bug fixes (UI/navigation)

**Minggu 6: Deployment**
- [ ] APK/IPA build preparation
- [ ] App store preparation (metadata, screenshots)
- [ ] Final UI review
- [ ] Beta testing coordination

#### 🎁 Deliverables
- ✅ Flutter mobile app project
- ✅ Authentication screens (3)
- ✅ Navigation architecture
- ✅ Reusable widget library
- ✅ API service layer
- ✅ State management setup
- ✅ UI consistency guidelines
- ✅ Frontend documentation
- ✅ APK build

#### 📊 Success Metrics
- App launch time: < 3 seconds
- Navigation smoothness: 60 FPS
- Screen transitions: smooth & no lag
- API integration: 100% working
- Code quality: high readability

---

### 2️⃣ Fazna Alaisal Ramadan - Frontend Developer (Order & Payment UI)

**📌 Posisi:** Frontend Developer - Order & Payment  
**📧 GitHub:** @fazna  
**📞 Role Code:** FRONTEND-DEV-1

#### 🎯 Tanggung Jawab Utama
- Order management screens
- Payment UI & QR display
- Order history & tracking
- Rating & review screens
- Form validation & error handling
- User input management
- Local storage & data persistence

#### 📅 Sprint Tasks

**Minggu 1: Planning & Setup**
- [ ] Review design mockups
- [ ] Study order API contract
- [ ] Setup local development environment
- [ ] Familiarize dengan Flutter project structure

**Minggu 2: Backend Foundation**
- [ ] Assist with authentication screens
- [ ] Home screen layout
- [ ] Category browsing screen

**Minggu 3: Order & Payment**
- [ ] Order creation form screen (location, date, time, notes)
- [ ] Form validation (real-time)
- [ ] Photo upload preview (optional)
- [ ] Payment method selection screen
- [ ] QRIS code display screen
- [ ] Payment confirmation screen
- [ ] Order detail screen with status tracking
- [ ] Order history list screen
- [ ] Implement order status polling/real-time updates

**Minggu 4: Features & Notifications**
- [ ] Rating screen (star rating widget)
- [ ] Review/ulasan input screen
- [ ] Photo upload for review
- [ ] Submit rating API integration
- [ ] Rating display in provider profile

**Minggu 5: Testing & Optimization**
- [ ] Functional testing - order flow
- [ ] Payment screen testing
- [ ] Form validation testing
- [ ] UI responsiveness testing
- [ ] Bug fixes (order & payment screens)

**Minggu 6: Deployment**
- [ ] Final testing coordination
- [ ] APK preparation
- [ ] User testing feedback implementation

#### 🎁 Deliverables
- ✅ Order creation screen
- ✅ Payment/QRIS screen
- ✅ Order history screen
- ✅ Order detail screen
- ✅ Rating & review screen
- ✅ Form validation logic
- ✅ Integration tests

#### 📊 Success Metrics
- Order creation: < 3 taps
- Form validation: real-time & accurate
- Payment screen: clear & user-friendly
- Rating submission: 1-tap confirmation
- Test coverage: ≥ 60%

---

### 3️⃣ Nabil Ramadhan - Frontend Developer (Admin & Dashboard)

**📌 Posisi:** Frontend Developer - Admin Dashboard  
**📧 GitHub:** @nabil  
**📞 Role Code:** FRONTEND-DEV-2

#### 🎯 Tanggung Jawab Utama
- Admin dashboard screens
- Treasurer monitoring dashboard
- Provider verification screens
- Advanced search & filtering
- Role-based UI rendering
- Admin-specific features
- Dashboard data visualization

#### 📅 Sprint Tasks

**Minggu 1: Planning & Setup**
- [ ] Review admin dashboard mockups
- [ ] Study treasurer API contract
- [ ] Setup local development environment

**Minggu 2: Backend Foundation**
- [ ] Admin login screen
- [ ] Admin home/dashboard layout
- [ ] Main navigation for admin panel

**Minggu 3: Order & Payment**
- [ ] Order monitoring screen (admin)
- [ ] View all orders (filterable)
- [ ] Order detail view (admin)

**Minggu 4: Features & Notifications**
- [ ] Provider verification screen
- [ ] Provider list (admin view)
- [ ] Provider profile review
- [ ] Approve/reject provider action
- [ ] Provider deactivation
- [ ] Treasurer - Transaction list screen
- [ ] Treasurer - Summary report (date range)
- [ ] Transaction detail view

**Minggu 5: Testing & Optimization**
- [ ] Functional testing - dashboard screens
- [ ] Search & filter testing
- [ ] Data accuracy testing
- [ ] UI responsiveness testing
- [ ] Bug fixes (admin screens)

**Minggu 6: Deployment**
- [ ] Final UAT coordination (admin flow)
- [ ] APK preparation

#### 🎁 Deliverables
- ✅ Admin dashboard (main screen)
- ✅ Provider verification screen
- ✅ Order monitoring screen
- ✅ Treasurer transaction screen
- ✅ Report/summary screen
- ✅ Search & filter functionality
- ✅ Integration tests

#### 📊 Success Metrics
- Dashboard loads: < 2 seconds
- Search results: < 500ms
- Data accuracy: 100%
- Role-based access: enforced
- Test coverage: ≥ 60%

---

## 🧪 QA TEAM (1 Orang)

### Aldy Ramadani - QA Lead & Test Engineer

**📌 Posisi:** Quality Assurance & Test Lead  
**📧 GitHub:** @aldy  
**📞 Role Code:** QA-LEAD

#### 🎯 Tanggung Jawab Utama
- Test planning & strategy
- Test case creation (all features)
- Manual testing execution
- Bug tracking & prioritization
- Regression testing
- Performance testing
- Security testing
- UAT coordination
- Test documentation
- Quality metrics reporting

#### 📅 Sprint Tasks

**Minggu 1: Planning & Setup**
- [ ] Create test plan & strategy
- [ ] Define test case template
- [ ] Setup test environment
- [ ] Create testing checklist
- [ ] Create bug tracking template
- [ ] Study SRS & functional requirements

**Minggu 2: Backend Foundation**
- [ ] Create test cases untuk authentication (15 test cases)
- [ ] Create test cases untuk provider management (12 test cases)
- [ ] Create test cases untuk catalog & search (18 test cases)
- [ ] Execute smoke testing
- [ ] Report bugs (if any)
- [ ] Verify bug fixes

**Minggu 3: Order & Payment**
- [ ] Create test cases untuk order lifecycle (20 test cases)
- [ ] Create test cases untuk payment (25 test cases)
- [ ] Execute end-to-end order flow testing
- [ ] Execute payment flow testing
- [ ] Webhook callback testing
- [ ] Report & track bugs

**Minggu 4: Features & Notifications**
- [ ] Create test cases untuk notifications (15 test cases)
- [ ] Create test cases untuk rating (12 test cases)
- [ ] Create test cases untuk treasurer (10 test cases)
- [ ] Integration testing round 1
- [ ] Test n8n notification delivery
- [ ] Report issues

**Minggu 5: Testing & Optimization**
- [ ] Comprehensive functional testing (all 50+ test cases)
- [ ] Performance testing (API response time, load testing)
- [ ] Security testing (authentication, authorization, injection attacks)
- [ ] Compatibility testing (different Android versions)
- [ ] Usability testing (UI/UX review)
- [ ] Regression testing (all fixed bugs)
- [ ] Generate final test report

**Minggu 6: Deployment**
- [ ] UAT test case execution
- [ ] UAT support & coordination
- [ ] Post-launch monitoring
- [ ] Production issue tracking

#### 🎁 Deliverables
- ✅ Test plan document (10+ pages)
- ✅ 50+ test cases (documented)
- ✅ Test execution reports (weekly)
- ✅ Bug tracking spreadsheet
- ✅ Performance test report
- ✅ Security audit report
- ✅ UAT plan & checklist
- ✅ Final quality report

#### 📊 Success Metrics
- Test coverage: 100% of FR & NFR
- Bug discovery rate: ≥ 90%
- Critical bugs: 0 in production
- Test pass rate: ≥ 95%
- Mean time to fix: < 24 hours (critical)

---

## 🎯 PROJECT MANAGER

### R. Elsa Balqis Khoerunnisa S - Project Manager

**📌 Posisi:** Project Manager & Coordinator  
**📧 GitHub:** @radenelsa7-bot  
**📞 Role Code:** PM

#### 🎯 Tanggung Jawab Utama
- Overall project coordination
- Timeline management & tracking
- Risk management
- Stakeholder communication
- Resource allocation
- Quality assurance oversight
- Issue escalation & resolution
- Documentation & reporting
- Team motivation & morale

#### 📅 Sprint Tasks

**Minggu 1: Planning & Setup**
- [ ] Conduct kick-off meeting
- [ ] Distribute roles & responsibilities
- [ ] Setup GitHub project board
- [ ] Create communication channels (Discord/WhatsApp)
- [ ] Define meeting schedule & cadence
- [ ] Risk assessment & mitigation planning
- [ ] Stakeholder briefing

**Minggu 2-5: During Development**
- [ ] Daily standup coordination (15 min, daily)
- [ ] Sprint planning (Senin pagi)
- [ ] Mid-week check-in (Rabu)
- [ ] Sprint retrospective (Jumat)
- [ ] Monitor progress vs timeline
- [ ] Track blockers & issues
- [ ] Coordinate between backend & frontend
- [ ] Weekly stakeholder updates (Jumat)
- [ ] Update risk register
- [ ] Manage scope changes

**Minggu 5-6: Testing & Deployment**
- [ ] Coordinate QA testing
- [ ] Manage bug prioritization
- [ ] Prepare UAT environment
- [ ] Coordinate UAT with stakeholders
- [ ] Final deployment coordination
- [ ] Post-launch support

#### 📋 PM Daily Activities

**Daily (08:00 AM)**
- Standup meeting (15 min)
- Status updates from each team
- Identify blockers
- Prioritize resolution

**Twice Weekly (Rabu & Jumat)**
- Mid-week check-in (10 min)
- Progress tracking
- Sprint metrics review

**Weekly (Jumat 04:00 PM)**
- Sprint review (30 min)
- Demo of completed features
- Retrospective (15 min)
- Next sprint planning (30 min)

**Weekly (Jumat 05:00 PM)**
- Stakeholder update
- Milestone review
- Risk discussion

#### 🎁 Deliverables
- ✅ Project management plan
- ✅ Risk register & mitigation plan
- ✅ Weekly progress reports (6 reports)
- ✅ GitHub project board (updated)
- ✅ Stakeholder communications (weekly)
- ✅ Meeting notes & action items
- ✅ Final project closure report
- ✅ Lessons learned document

#### 📊 Success Metrics
- Timeline adherence: 100%
- Scope creep: < 5%
- Team satisfaction: ≥ 4/5
- Stakeholder satisfaction: ≥ 4/5
- Issues resolution time: < 24 hours
- Zero missed milestones

---

## 📊 RESPONSIBILITY MATRIX (RACI)

| Task | PM | Backend Lead | Backend Dev 1 | Backend Dev 2 | Frontend Lead | Frontend Dev 1 | Frontend Dev 2 | QA |
|------|----|----|----|----|----|----|----|----|----|
| **Database Design** | C | R | C | C | - | - | - | - |
| **API Contract** | C | R | A | A | A | - | - | - |
| **Authentication** | C | R | A | - | A | A | - | - |
| **Provider Mgmt** | C | A | R | - | - | - | - | - |
| **Order Lifecycle** | C | A | R | A | - | - | - | - |
| **Payment Integration** | C | R | A | A | - | - | - | A |
| **Catalog & Search** | C | A | - | R | - | - | - | - |
| **Rating & Review** | C | - | - | R | - | A | - | A |
| **Notifications (n8n)** | C | R | A | A | - | - | - | - |
| **Treasurer Dashboard** | C | - | - | R | A | - | - | A |
| **Auth UI** | C | - | - | - | R | A | - | - |
| **Order UI** | C | - | - | - | A | R | - | - |
| **Payment UI** | C | - | - | - | A | R | - | - |
| **Admin Dashboard** | C | - | - | - | A | - | R | - |
| **Testing & QA** | C | A | A | A | A | A | A | R |
| **Deployment** | R | R | A | - | - | - | - | C |
| **Stakeholder Comm** | R | C | - | - | C | - | - | - |
| **Risk Management** | R | A | - | - | - | - | - | - |

**Legend:**
- **R** = Responsible (Does the work)
- **A** = Accountable (Final authority/decision maker)
- **C** = Consulted (Provides input)
- **-** = Not involved

---

## 👥 TEAM COMMUNICATION RULES

### 1. Daily Standup
- **When:** 08:00 AM setiap hari kerja
- **Duration:** 15 minutes maximum
- **Format:** 
  - What did you do yesterday?
  - What will you do today?
  - Any blockers?
- **Platform:** Discord voice channel atau in-person

### 2. Sprint Planning
- **When:** Senin, 09:00 AM
- **Duration:** 45 minutes
- **Attendees:** Semua team members
- **Output:** Sprint backlog, task assignment

### 3. Code Review
- **Rule:** Setiap PR harus di-review minimal 2 orang
- **Approval:** Lead harus approve sebelum merge
- **Timeline:** Review selesai dalam 24 jam

### 4. Issue Reporting
- **Channel:** GitHub Issues (labeled by priority)
- **Template:** Bug report template (di repo)
- **Response:** Critical bugs = 24 jam, High = 48 jam

### 5. Status Updates
- **When:** Jumat, 05:00 PM
- **Format:** Weekly progress report
- **Recipients:** PM + Stakeholders

---

## 🎓 SKILL REQUIREMENTS & GAPS

| Role | Required Skills | Training Needed? | Owner |
|------|-----------------|-----------------|-------|
| Backend Lead | Laravel, Docker, API Design, MySQL | Docker advanced | M. Fajar |
| Backend Dev 1 | Laravel, PHP, Database Design | Payment Gateway | Nabilah |
| Backend Dev 2 | Laravel, PHP, ORM, SQL | n8n integration | Fatin |
| Frontend Lead | Flutter, Dart, State Mgmt | GetX state management | Tetep |
| Frontend Dev 1 | Flutter, Dart, UI/UX | Form validation, real-time updates | Fazna |
| Frontend Dev 2 | Flutter, Dart, UI | Admin dashboard patterns | Nabil |
| QA | Test Planning, Manual Testing | Automated testing | Aldy |
| PM | Agile, Risk Mgmt, Communication | Stakeholder management | R. Elsa |

---

## 📞 ESCALATION PATH

```
Team Member Issue
        ↓
  Direct Lead/PM
        ↓
  Project Manager
        ↓
  Stakeholders/Dosen
```

**Response Times:**
- Critical: 2 hours
- High: 4 hours
- Medium: 8 hours
- Low: 24 hours

---

**Document Version:** 1.0  
**Last Updated:** 17 Mei 2026  
**Approval:** R. Elsa Balqis Khoerunnisa S (PM)
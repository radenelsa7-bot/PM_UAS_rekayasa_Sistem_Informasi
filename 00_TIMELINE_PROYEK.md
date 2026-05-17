# 📅 TIMELINE PROYEK TUKANG DEKAT
## Platform Pemesanan Jasa Lokal Kecamatan Bojongloa Kaler Berbasis Mobile & API

**Periode:** 11 Mei 2026 - 18 Juni 2026  
**Status:** In Planning  
**Last Updated:** 17 Mei 2026

---

## 📊 RINGKASAN TIMELINE

```
MINGGU 1 (11-17 MEI)  → Planning & Setup
MINGGU 2 (18-24 MEI)  → Backend Foundation
MINGGU 3 (25-31 MEI)  → Order & Payment Core
MINGGU 4 (01-07 JUNI) → Features & Notifications
MINGGU 5 (08-14 JUNI) → Testing & Fixes
MINGGU 6 (15-18 JUNI) → Deployment & Handover
```

**Total:** 39 hari kerja (~6 minggu)

---

## 🎯 MINGGU 1: PLANNING & SETUP (11-17 MEI)

### Milestone: Project Initialization & Environment Setup

| Hari | Tanggal | Task | Owner | Deliverable | Status |
|-----|---------|------|-------|-------------|--------|
| Sabtu | 11-05 | Kick-off Meeting + Task Assignment | R. Elsa (PM) | Meeting Notes, Task List | ⏳ Planned |
| Minggu | 12-05 | Setup Repository (GitHub) & Branching Strategy | M. Fajar | Git Repo Ready, CONTRIBUTING.md | ⏳ Planned |
| Senin | 13-05 | Setup Backend Dev Environment (Laravel, Docker) | M. Fajar | Dockerfile, docker-compose.yml, .env.example | ⏳ Planned |
| Senin | 13-05 | Setup Frontend Dev Environment (Flutter) | Tetep Safarudin | Flutter Project, pubspec.yaml | ⏳ Planned |
| Selasa | 14-05 | Database Design Review & Finalization | Backend Team + PM | Final ERD, SQL Schema, migrations/ | ⏳ Planned |
| Rabu | 15-05 | API Contract & Endpoint Documentation | M. Fajar | Postman Collection, API Docs | ⏳ Planned |
| Kamis | 16-05 | UI/UX Review & Design Assets Handover | Frontend + PM | Design System, Figma Link | ⏳ Planned |
| Jumat | 17-05 | Risk Assessment & Contingency Planning | PM | Risk Register, Mitigation Plan | ⏳ Planned |

### Key Activities
- 🔧 Environment setup (Backend, Frontend, Git)
- 📋 Finalize database schema
- 📖 Create API documentation template
- ⚠️ Risk identification & mitigation
- 👥 Team alignment & sprint planning

### Success Criteria
✅ All dev environments ready  
✅ Repository configured with branching strategy  
✅ Database schema finalized  
✅ API contract documented  
✅ Team understands requirements & timelines

---

## 🎯 MINGGU 2: BACKEND FOUNDATION (18-24 MEI)

### Milestone: Core API Development Begins

| Hari | Tanggal | Task | Owner | Deliverable | Status | Related FR |
|-----|---------|------|-------|-------------|--------|------------|
| Sabtu | 18-05 | Database Migration & Seeding | M. Fajar | DB Ready, Sample Data | ⏳ Planned | - |
| Minggu | 19-05 | Authentication Module Implementation | M. Fajar | Login/Register/Logout API | ⏳ Planned | FR-01, FR-02, FR-03, FR-04 |
| Senin | 20-05 | Provider Management Endpoints | Nabilah Asana | Provider CRUD API | ⏳ Planned | FR-05, FR-06, FR-07 |
| Selasa | 21-05 | Service Catalog & Search Implementation | Fatin Asyifa | Catalog API, Search Endpoint | ⏳ Planned | FR-08, FR-09, FR-10 |
| Rabu | 22-05 | Payment Gateway Setup & Config | M. Fajar | Payment Gateway Sandbox Ready, Secret Keys | ⏳ Planned | FR-15, FR-16 |
| Kamis | 23-05 | Begin Frontend - Auth Screens | Tetep Safarudin | Login/Register/Onboarding Screens | ⏳ Planned | - |
| Jumat | 24-05 | Weekly QA Review & Integration Check | Aldy Ramadani | QA Report, Bug List | ⏳ Planned | - |

### Key Deliverables
- ✅ Functional database schema
- ✅ Authentication API (token-based)
- ✅ Provider management endpoints
- ✅ Service catalog endpoints
- ✅ Payment gateway sandbox configured
- ✅ Flutter auth screens connected to API

### Success Criteria
✅ All 13 backend endpoints working  
✅ Authentication tested & working  
✅ Database transactions stable  
✅ Frontend auth screens functional  
✅ No critical bugs

---

## 🎯 MINGGU 3: ORDER & PAYMENT CORE (25-31 MEI)

### Milestone: Order Lifecycle & Payment Implementation

| Hari | Tanggal | Task | Owner | Deliverable | Status | Related FR |
|-----|---------|------|-------|-------------|--------|------------|
| Sabtu | 25-05 | Order Creation Endpoint | M. Fajar | POST /orders API | ⏳ Planned | FR-11 |
| Minggu | 26-05 | Order State Management | Nabilah Asana | Status Update, State Transitions | ⏳ Planned | FR-12, FR-13 |
| Senin | 27-05 | DP Payment & QRIS Generation | Fatin Asyifa | QRIS Generator, DP Invoice | ⏳ Planned | FR-15, FR-16 |
| Selasa | 28-05 | Payment Webhook Handler | M. Fajar | Webhook Receiver, Payment Confirmation | ⏳ Planned | FR-17 |
| Rabu | 29-05 | Final Payment Endpoint | Nabilah Asana | Pelunasan API, Order Completion | ⏳ Planned | FR-18, FR-19, FR-20 |
| Kamis | 30-05 | Frontend - Order & Payment UI | Tetep + Fazna | Order Form, Payment QR Screen, History | ⏳ Planned | - |
| Jumat | 31-05 | Integration Testing - Payment Flow | Aldy Ramadani | End-to-End Test Report | ⏳ Planned | - |

### Key Deliverables
- ✅ Order creation & management API
- ✅ Order state machine (CREATED → ACCEPTED → IN_PROGRESS → COMPLETED → CLOSED)
- ✅ DP payment (50%) with QRIS
- ✅ Webhook handler for payment callbacks
- ✅ Final payment endpoint
- ✅ Flutter screens for ordering & payment

### Success Criteria
✅ Complete order lifecycle working  
✅ Payment flow tested end-to-end  
✅ QRIS generation functional  
✅ Webhook correctly processes payment events  
✅ Zero payment-related critical bugs

---

## 🎯 MINGGU 4: FEATURES & NOTIFICATIONS (01-07 JUNI)

### Milestone: Notification & Rating Features

| Hari | Tanggal | Task | Owner | Deliverable | Status | Related FR |
|-----|---------|------|-------|-------------|--------|------------|
| Sabtu | 01-06 | n8n Integration Setup | M. Fajar | n8n Workflows, Webhooks | ⏳ Planned | FR-21, FR-22 |
| Minggu | 02-06 | Notification Events Trigger | Nabilah Asana | Event Publishing, Email/WhatsApp | ⏳ Planned | FR-21, FR-22 |
| Senin | 03-06 | Rating & Review Endpoint | Fatin Asyifa | Rating CRUD, Average Calculation | ⏳ Planned | FR-23, FR-24 |
| Selasa | 04-06 | Treasurer Dashboard Backend | M. Fajar | Monitoring API, Transaction Reports | ⏳ Planned | FR-25, FR-26 |
| Rabu | 05-06 | Frontend - Notification UI | Tetep Safarudin | Notification Center, Alerts | ⏳ Planned | - |
| Kamis | 06-06 | Frontend - Rating & Review UI | Fazna Alaisal | Rating Form, Review Display | ⏳ Planned | - |
| Jumat | 07-06 | Integration Testing Round 1 | Aldy Ramadani | Full System Test Report v1 | ⏳ Planned | - |

### Key Deliverables
- ✅ n8n workflows for email/WhatsApp notifications
- ✅ Event system for order status changes
- ✅ Rating & review system
- ✅ Treasurer monitoring dashboard API
- ✅ Flutter notification & rating UI

### Success Criteria
✅ Notifications sent correctly  
✅ Rating system functional  
✅ Treasurer dashboard showing accurate data  
✅ All integration tests passed  
✅ <5 minor bugs identified

---

## 🎯 MINGGU 5: TESTING & OPTIMIZATION (08-14 JUNI)

### Milestone: Bug Fixes & Performance Optimization

| Hari | Tanggal | Task | Owner | Deliverable | Status | Related NFR |
|-----|---------|------|-------|-------------|--------|-------------|
| Sabtu | 08-06 | Functional Testing - All Features | Aldy Ramadani | Comprehensive Test Cases, Results | ⏳ Planned | NFR-08, NFR-09 |
| Minggu | 09-06 | Security Testing | PM + Aldy | Security Audit Report | ⏳ Planned | NFR-04, NFR-05, NFR-06 |
| Senin | 10-06 | Performance Testing & Optimization | Aldy Ramadani | Load Test, Performance Metrics | ⏳ Planned | NFR-01, NFR-02 |
| Selasa | 11-06 | Bug Fixes (Priority: Critical & High) | All Teams | Fixed Bugs, Regression Tests | ⏳ Planned | - |
| Rabu | 12-06 | API Documentation Finalization | M. Fajar | Swagger/Postman Export, README | ⏳ Planned | - |
| Kamis | 13-06 | User Documentation Draft | PM | User Manual, Provider Guide | ⏳ Planned | - |
| Jumat | 14-06 | UAT Preparation & Environment Setup | PM + Aldy | UAT Plan, Test Data | ⏳ Planned | - |

### Key Deliverables
- ✅ Complete test coverage (50+ test cases)
- ✅ Security audit report
- ✅ Performance benchmarks (API < 1 sec)
- ✅ Zero critical bugs
- ✅ Complete API documentation
- ✅ User manuals
- ✅ UAT environment ready

### Success Criteria
✅ All tests passed  
✅ Performance meets NFR-01 (< 1 sec)  
✅ Security audit passed  
✅ Documentation complete  
✅ Ready for UAT

---

## 🎯 MINGGU 6: DEPLOYMENT & HANDOVER (15-18 JUNI)

### Milestone: Final Testing & Production Ready

| Hari | Tanggal | Task | Owner | Deliverable | Status |
|-----|---------|------|-------|-------------|--------|
| Sabtu | 15-06 | User Acceptance Testing (UAT) | PM + Stakeholders | UAT Sign-off, Feedback | ⏳ Planned |
| Minggu | 16-06 | Final Bug Fixes & Deployment Prep | All Teams | Release Checklist, Go-Live Plan | ⏳ Planned |
| Senin | 17-06 | Production Deployment | M. Fajar + PM | Live System, Health Check | ⏳ Planned |
| Selasa | 18-06 | Post-Launch Monitoring & Handover | All Teams | Project Closure Report, Lessons Learned | ⏳ Planned |

### Key Deliverables
- ✅ System deployed to production
- ✅ All UAT sign-offs obtained
- ✅ Production health check passed
- ✅ Support documentation
- ✅ Project closure report

### Success Criteria
✅ System live & accessible  
✅ All UAT sign-offs complete  
✅ Zero critical production issues  
✅ All team members briefed on support procedures  
✅ Project closure approved

---

## 📌 MILESTONE SUMMARY

| Minggu | Milestone | Key Deliverable | Target Date |
|--------|-----------|-----------------|-------------|
| 1 | ✅ Planning & Setup | Dev Environment Ready, API Contract | 17 Mei |
| 2 | ✅ Backend Foundation | Auth & Catalog APIs | 24 Mei |
| 3 | ✅ Order & Payment | Full Order Lifecycle & Payment Flow | 31 Mei |
| 4 | ✅ Features Complete | Notifications, Ratings, Treasury | 07 Juni |
| 5 | ✅ Testing Phase | Bug Fixes, Performance Optimization | 14 Juni |
| 6 | ✅ Go-Live | Production Deployment & UAT Sign-off | 18 Juni |

---

## 👥 TEAM CONTACTS

| Role | Nama | Kontak | Focus |
|------|------|--------|-------|
| **Project Manager** | R. Elsa Balqis Khoerunnisa S | @radenelsa7-bot | Overall Coordination |
| **Backend Lead** | Muhammad Fajar Nurjaman | @mfajar | API, Infrastructure, DevOps |
| **Backend Dev** | Nabilah Asana Alecia | @nabilah | Provider, Orders, Payments |
| **Backend Dev** | Fatin Asyifa Nurrizky JenPutri | @fatin | Catalog, Rating, Treasury |
| **Frontend Lead** | Tetep Safarudin | @tetep | Navigation, Auth UI |
| **Frontend Dev** | Fazna Alaisal Ramadan | @fazna | Order, Payment, Rating UI |
| **Frontend Dev** | Nabil Ramadhan | @nabil | Admin, Dashboard, Search |
| **QA Lead** | Aldy Ramadani | @aldy | Testing, Quality Assurance |

---

## 🚨 CRITICAL PATH ITEMS

1. **Minggu 1:** Database schema finalized → No delays tolerated
2. **Minggu 2:** Authentication API → Blocks all frontend development
3. **Minggu 3:** Payment gateway integration → Blocks Order feature
4. **Minggu 4:** n8n setup → Blocks notification feature
5. **Minggu 5:** QA testing & bug fixes → Blocks UAT readiness

---

## 📊 VELOCITY & CAPACITY

- **Backend Team:** 3 developers = ~45 story points/minggu
- **Frontend Team:** 3 developers = ~40 story points/minggu
- **QA:** 1 QA = ~30 test cases/minggu
- **PM:** Coordination & stakeholder management

---

## 🔄 WEEKLY CADENCE

**Setiap Hari (15 min)**
- 08:00 AM - Daily Standup (status, blockers)

**Setiap Minggu**
- **Senin 09:00 AM** - Sprint Planning & Review
- **Rabu 02:00 PM** - Mid-week Check-in
- **Jumat 04:00 PM** - Sprint Retrospective & Next Week Planning

**Bi-Weekly**
- **Jumat 05:00 PM** - Stakeholder Update & Demo

---

## 📝 NOTES

- Timeline fleksibel tetapi sprint tetap 1 minggu
- Daily standup wajib untuk accountability
- PR harus di-review sebelum merge (code quality)
- Bug kritis harus fixed dalam 24 jam
- Komunikasi via GitHub Issues + Discord/WhatsApp

---

**Last Updated:** 17 Mei 2026 | **Version:** 1.0 | **PM:** R. Elsa Balqis Khoerunnisa S
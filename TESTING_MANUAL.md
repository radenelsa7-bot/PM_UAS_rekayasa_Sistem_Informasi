# 🧪 Manual Testing Guide - TukangDekat Mobile App

**Status:** ✅ App compiled successfully and running on Chrome
**Backend:** http://127.0.0.1:8000 (running)
**Frontend:** Chrome web app (running)

---

## Setup Checklist

Before starting tests, verify:

- [x] Backend running on http://127.0.0.1:8000
- [x] Flutter app running in Chrome
- [x] Chrome DevTools open (F12)
- [x] Test accounts seeded in database

---

## Test Scenarios

### Scenario 1: Launch App & Splash Screen

**Steps:**
1. Open Chrome (should already be open from `flutter run -d chrome`)
2. Look for app loading screen

**Expected Results:**
- [ ] SplashPage appears (show "CircularProgressIndicator")
- [ ] After 2-3 seconds, redirects to LoginPage (no saved token)
- [ ] URL: http://localhost:xxxxx (Chrome dev server)

**If Issue:**
- Check browser console (F12 → Console tab)
- Look for "CORS errors" or "connection refused"
- Verify backend running: http://127.0.0.1:8000

---

### Scenario 2: Login Page Display

**Expected Results:**
- [ ] "TukangDekat" title visible
- [ ] "Layanan Teknisi Terpercaya" subtitle visible
- [ ] Email field with email icon
- [ ] Password field with lock icon
- [ ] "Masuk" button
- [ ] "Belum punya akun? Daftar" link at bottom

**Test Data Pre-filled:**
- Email: `customer@test.com`
- Password: `password123`

---

### Scenario 3: Successful Login

**Steps:**
1. Email field should show: `customer@test.com`
2. Password field should show: `password123`
3. Click "Masuk" button

**Expected Results:**
- [ ] Button shows loading spinner while authenticating
- [ ] Network tab shows: POST /api/auth/login → 200 OK
- [ ] Response contains: token + user data (id, name, email, role)
- [ ] After success, navigates to HomePage
- [ ] Token saved in secure storage (not visible but happens)

**Network Request Check (DevTools):**
1. Open DevTools (F12)
2. Go to Network tab
3. Filter by: "auth"
4. You should see:
   ```
   POST /api/auth/login
   Status: 200
   Response: {
     "message": "ok",
     "token": "xxx...",
     "user": {
       "id": 1,
       "name": "Fajar",
       "email": "customer@test.com",
       "role": "CUSTOMER"
     }
   }
   ```

---

### Scenario 4: HomePage Display

**After successful login, should see:**

**Tab 1: Beranda (Home/Catalog)**
- [ ] Search bar: "Cari teknisi atau layanan" with search icon
- [ ] "Kategori Layanan" section
- [ ] 5 category cards (Listrik, Plumbing, AC, Bangunan Ringan, Elektronik)
- [ ] Horizontal scrollable category list

**Tab 2: Pesanan (My Orders)**
- [ ] Empty state with "Belum ada order" message

**Tab 3: Akun (Account)**
- [ ] "Profil Akun" title
- [ ] Card showing: Email, Role, ID

**AppBar:**
- [ ] Title: "TukangDekat"
- [ ] 3 tabs visible at bottom
- [ ] Logout button (icon) at top right

---

### Scenario 5: Browse Categories

**Steps:**
1. On Beranda tab
2. Scroll horizontal through category cards
3. Click on "Listrik" category (first card)

**Expected Results:**
- [ ] Category card highlights (different color/background)
- [ ] "Teknisi Tersedia" section appears below
- [ ] Shows 3 providers for Listrik category
- [ ] Each provider card shows:
  - Name (e.g., "Andi Elektrik")
  - Description/area
  - Rating (★ 4.5 or similar)
  - Arrow icon (→)

**Network Check:**
- DevTools Network tab should show:
  ```
  GET /api/catalog/categories/{id}/providers
  Status: 200
  Response: {
    "data": [
      {
        "id": 1,
        "businessName": "Andi Elektrik",
        "avgRating": 4.5,
        ...
      },
      ...
    ]
  }
  ```

---

### Scenario 6: Provider Detail Page

**Steps:**
1. Click on one provider card (e.g., "Andi Elektrik")

**Expected Results:**
- [ ] Navigate to ProviderDetailPage
- [ ] AppBar shows "Detail Teknisi" title
- [ ] Back button (←) appears at left
- [ ] Shows provider info:
  - Profile picture (circle avatar with icon)
  - Business name (large)
  - Rating with stars (★ 4.5)
  - "Terverifikasi" badge (if verified)
  - Description text
  - Area/Address

**Layanan Tersedia (Services) Section:**
- [ ] Title "Layanan Tersedia"
- [ ] List of services with:
  - Service name
  - Price format: "Rp50000 / jam" (or per pekerjaan)

**CTA Button:**
- [ ] "Pesan Sekarang" button at bottom (full width)

**Network Check:**
```
GET /api/catalog/providers/{id}
Status: 200
Response includes: services array
```

---

### Scenario 7: Create Order

**Steps:**
1. On ProviderDetailPage
2. Click "Pesan Sekarang" button

**Expected Results:**
- [ ] Navigate to CreateOrderPage
- [ ] AppBar shows "Buat Order" title
- [ ] "Detail Order" section visible

**Form Fields:**
- [ ] "Alamat Lokasi" text field (3 lines, location icon)
- [ ] "Catatan Tambahan" field (3 lines, note icon)
- [ ] "Tanggal Pekerjaan" button (calendar icon)
- [ ] "Jam Pekerjaan" button (clock icon)
- [ ] Payment info box explaining 50-50 split
- [ ] "Buat Order" button

**Steps to Fill Form:**
1. Type address: "Jl. Contoh No 123, Bandung"
2. Type notes: "Ada masalah dengan instalasi"
3. Click "Tanggal Pekerjaan" → Pick tomorrow's date
4. Click "Jam Pekerjaan" → Pick time (e.g., 14:00)
5. Click "Buat Order"

**Expected Results:**
- [ ] Button shows loading spinner
- [ ] Network tab shows: POST /api/orders → 201 Created
- [ ] Success message appears: "Order berhasil dibuat!"
- [ ] Navigate back to CatalogPage

**Network Request:**
```
POST /api/orders
Payload: {
  "provider_id": 1,
  "address": "...",
  "schedule_at": "2026-05-15T14:00:00.000Z",
  ...
}
Status: 201
Response: created OrderData
```

---

### Scenario 8: View My Orders

**Steps:**
1. After order created, click "Pesanan" tab

**Expected Results:**
- [ ] Order appears in list with:
  - Order card layout
  - Status badge (color-coded, e.g., blue for "CREATED")
  - Order code (ORD-20260514-XXXX)
  - Address
  - Schedule date/time
  - Estimated price (Rp...)

**Click on Order:**
1. Click the order card

**Expected Results - Order Detail:**
- [ ] Navigate to OrderDetailPage
- [ ] Shows sections:
  - Status card (with color)
  - Order code
  - Address
  - Schedule
  - Pricing info
  - Payment breakdown (DP + Final)

**Network Check:**
```
GET /api/orders
Status: 200
Response: list of orders

GET /api/orders/{id}
Status: 200
Response: full order details
```

---

### Scenario 9: Search Provider

**Steps:**
1. Back to Beranda tab
2. Click search bar at top
3. Type provider name: "Andi"

**Expected Results:**
- [ ] Search input focuses
- [ ] While typing, results update in real-time
- [ ] Shows matching providers
- [ ] Can click to view provider detail

**Network Check:**
```
GET /api/catalog/providers/search?q=andi
Status: 200
Response: filtered providers
```

---

### Scenario 10: Logout

**Steps:**
1. On any page with AppBar
2. Click logout button (icon) at top right

**Expected Results:**
- [ ] Button shows loading spinner
- [ ] Network tab shows: POST /api/auth/logout → 200
- [ ] Navigate back to LoginPage
- [ ] Token cleared from storage
- [ ] "Belum punya akun? Daftar" link visible
- [ ] Can login again with fresh session

---

## Error Scenarios to Test

### E1: Wrong Credentials
**Steps:**
1. On LoginPage
2. Change email to: invalid@test.com
3. Keep password: password123
4. Click Masuk

**Expected:**
- [ ] Error message appears
- [ ] Network shows: POST /api/auth/login → 422 (validation error)
- [ ] Stay on LoginPage (no navigation)

### E2: Empty Form
**Steps:**
1. On LoginPage
2. Clear both fields
3. Click Masuk

**Expected:**
- [ ] Form validation errors appear
- [ ] "Email wajib diisi" message
- [ ] "Password wajib diisi" message
- [ ] No API call made (validation on client-side)

### E3: Backend Offline
**Steps:**
1. Stop backend server (in terminal where `php artisan serve` running)
2. Try login

**Expected:**
- [ ] Loading spinner shows
- [ ] After timeout (~5-10 seconds), error message appears
- [ ] Network tab shows: Failed (Connection error)
- [ ] Error message: "Connection error" or similar

---

## Browser DevTools Checklist

### Console Tab (F12 → Console)
- [ ] No red error messages
- [ ] No "CORS" errors
- [ ] No "undefined" errors
- [ ] Check for warnings (yellow text) - usually okay

### Network Tab (F12 → Network)
- [ ] All API requests show "200 OK" or "201 Created"
- [ ] No "404 Not Found" errors
- [ ] No "500 Internal Server Error"
- [ ] Response time < 1 second (usually 100-300ms)

### Storage Tab (F12 → Application/Storage)
- [ ] After login, check "Local Storage" or "Secure Storage"
- [ ] Token should be saved (may be encrypted)
- [ ] After logout, token should be cleared

---

## Quick Test Checklist

Print this and check off as you go:

```
LANDING:
- [ ] App loads without errors
- [ ] SplashPage appears
- [ ] Redirect to LoginPage

LOGIN:
- [ ] Email field pre-filled with customer@test.com
- [ ] Password field pre-filled with password123
- [ ] Click Masuk works
- [ ] Navigate to HomePage

HOMEPAGE:
- [ ] 3 tabs visible (Beranda, Pesanan, Akun)
- [ ] Tab 1 shows categories
- [ ] Tab 2 shows "Belum ada order"
- [ ] Tab 3 shows profile info

CATALOG:
- [ ] Click category filters providers
- [ ] Click provider shows detail
- [ ] Click "Pesan Sekarang" opens form

CREATE ORDER:
- [ ] Fill form fields
- [ ] Pick date and time
- [ ] Submit creates order
- [ ] Success message appears

VIEW ORDERS:
- [ ] Click Pesanan tab shows order
- [ ] Click order shows details
- [ ] See payment breakdown

SEARCH:
- [ ] Type in search bar
- [ ] Results appear in real-time
- [ ] Can click result

LOGOUT:
- [ ] Click logout button
- [ ] Back to LoginPage
- [ ] Can login again

ERRORS:
- [ ] Wrong credentials show error
- [ ] Empty form validates
- [ ] No console errors
```

---

## Success Criteria

✅ **APP IS WORKING IF:**
1. Compilation successful (no red errors)
2. App opens in Chrome without crashing
3. Can login with test account
4. Can browse categories and providers
5. Can create order
6. Can view order details
7. No console errors
8. Network requests complete successfully

---

## Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| "Couldn't connect to backend" | Start backend: `php artisan serve` |
| "CORS errors" in console | Add CORS headers to Laravel (usually already configured) |
| Button doesn't respond | Check if loading spinner showing - wait for response |
| Blank page after login | Check browser console for errors |
| Can't create order | Fill all required fields (address, date, time) |
| Order doesn't appear | Wait 2 seconds and refresh Pesanan tab |

---

## Next: If All Tests Pass ✅

Proceed to Phase 3:
1. Payment gateway integration (Midtrans/Xendit)
2. Provider order acceptance flow
3. Real-time notifications

---

**Testing Started:** May 14, 2026
**Status:** Ready for manual testing

Good luck! 🎉

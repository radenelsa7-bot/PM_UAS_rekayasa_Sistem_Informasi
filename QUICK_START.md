# 🚀 Quick Start Guide - TukangDekat Platform

**TL;DR:** Backend API + Flutter Mobile App fully connected and ready to test!

---

## ⚡ 30-Second Setup

### 1. Start Backend (Terminal 1)
```bash
cd c:\laragon\www\Project-Aplikasi-Tukang-Dekat\backend
php artisan serve
```
✅ Backend running on `http://localhost:8000`

### 2. Start Mobile (Terminal 2)
```bash
cd c:\laragon\www\Project-Aplikasi-Tukang-Dekat\mobile
flutter run -d chrome
```
✅ Flutter app opens in Chrome

### 3. Test Login
```
Email: customer@test.com
Password: password123
```
✅ Should navigate to HomePage with categories visible

---

## 📱 What Works Now

✅ **User Authentication**
- Register new account (Customer/Provider)
- Login with email/password
- Automatic token persistence
- Logout clears token

✅ **Catalog Browsing**
- View 5 service categories
- Search for providers by name
- Select category to filter providers
- View provider details + services

✅ **Order Management**
- Create new orders with date/time picker
- View all user's orders
- See order details with payment breakdown
- Color-coded order status

✅ **API Integration**
- All 27 backend endpoints connected
- Real-time data from Laravel API
- Error handling with user messages
- Loading states on buttons

---

## 📋 Test Scenarios

### Scenario 1: Register New Customer
1. Open app → LoginPage appears
2. Click "Daftar"
3. Enter:
   - Nama: John Doe
   - Email: john@example.com
   - Phone: 08123456789
   - Password: Secure123
   - Role: Pelanggan (Customer)
4. Click "Daftar"
5. Success message → Redirect to LoginPage
6. Login with new credentials

### Scenario 2: Browse Catalog
1. After login, see HomePage with tabs
2. Click "Beranda" tab (already selected)
3. See 5 categories in carousel
4. Click any category (e.g., "Listrik")
5. See 3 providers for that category
6. Click provider card to see details

### Scenario 3: Create Order
1. On ProviderDetailPage, click "Pesan Sekarang"
2. Enter:
   - Address: Jl. Example No 123
   - Notes: Ada masalah dengan listrik
3. Pick tomorrow's date via date picker
4. Pick time (e.g., 14:00)
5. Click "Buat Order"
6. Success → back to CatalogPage
7. Go to "Pesanan" tab to see new order

### Scenario 4: View Order Details
1. On MyOrdersPage (Pesanan tab)
2. See list of all orders with status badges
3. Click any order
4. OrderDetailPage shows:
   - Full order info
   - Order code + address + schedule
   - Pricing breakdown
   - Payment status (DP 50% + Final 50%)

---

## 🔧 Troubleshooting

### Backend not running?
```bash
# Check if Laravel is installed
cd backend
composer install

# Create database if missing
mysql -u root
CREATE DATABASE db_tukangdekat;
exit

# Run migrations & seeders
php artisan migrate:fresh --seed

# Start server
php artisan serve
```

### Flutter app won't start?
```bash
# Get dependencies
flutter pub get

# Clean build
flutter clean
flutter pub get

# Run on Chrome
flutter run -d chrome
```

### App crashes on login?
- Check backend is running on localhost:8000
- Check database has data (see test accounts below)
- Look for error in "Run" tab of VS Code

### Can't see categories?
- Make sure you're logged in first
- Click "Beranda" tab
- Wait 2 seconds for API response
- Check Chrome DevTools Console for errors

---

## 🧪 Test Accounts Ready to Use

**Pre-seeded in database:**

```
Customer 1:
  Email: customer@test.com
  Password: password123

Customer 2:
  Email: nabila@test.com
  Password: password123

Provider 1 (Andi):
  Email: provider1@test.com
  Password: password123

Provider 2 (Budi):
  Email: provider2@test.com
  Password: password123

Provider 3 (Citra):
  Email: provider3@test.com
  Password: password123
```

---

## 📁 Key Files

### Backend (Laravel)
- `backend/app/Http/Controllers/Api/AuthController.php` - Login/Register
- `backend/app/Http/Controllers/Api/CatalogController.php` - Categories/Providers
- `backend/app/Http/Controllers/Api/OrderController.php` - Orders CRUD
- `backend/database/seeders/` - Sample data

### Mobile (Flutter)
- `mobile/lib/features/auth/` - Login/Register pages
- `mobile/lib/features/home/` - Catalog & Orders pages
- `mobile/lib/core/services/api_service.dart` - All API calls
- `mobile/lib/core/services/auth_storage_service.dart` - Token storage

---

## 🎯 Feature Checklist

Category Browsing:
- [ ] Can see 5 categories
- [ ] Can click category to filter
- [ ] Can see providers for each category

Provider Search:
- [ ] Search bar appears
- [ ] Can type provider name
- [ ] Results appear in real-time
- [ ] Can click result to see details

Order Creation:
- [ ] Can enter address
- [ ] Can pick future date
- [ ] Can pick time
- [ ] Can submit order
- [ ] See order in "Pesanan" tab

Payment Display:
- [ ] Order shows DP (50%) payment
- [ ] Order shows Final (50%) payment
- [ ] Payment status visible
- [ ] Total price calculated correctly

Logout:
- [ ] Logout button works
- [ ] Token cleared from storage
- [ ] Redirected to LoginPage
- [ ] Can't access HomePage without login

---

## 💡 Pro Tips

1. **Fast Testing:** Use test accounts (don't register each time)
2. **Date Picker:** Only shows future dates (1-30 days ahead)
3. **Search:** Leave empty to see all providers again
4. **Errors:** Check VS Code terminal for detailed error messages
5. **Hot Reload:** Press 'r' in terminal to reload code changes
6. **Network:** Backend must be running on localhost:8000

---

## 📞 If Something Goes Wrong

**Error: "Connection refused"**
- Backend not running → Start with `php artisan serve`

**Error: "Invalid credentials"**
- Wrong email/password → Use test accounts above
- Or register new account first

**Error: "No categories found"**
- Database not seeded → Run `php artisan migrate:fresh --seed`

**Blank screen after login**
- App loading (wait 2 seconds)
- Or categories API failed (check backend console)

---

## 🎊 What's Next?

Phase 3 will include:
- Payment gateway (Midtrans/Xendit) integration
- Provider accepting/completing orders
- Real-time push notifications
- Rating & review system

For now: **Just test the flows above and enjoy!** 🎉

---

**Status:** ✅ **READY TO TEST**
**Backend:** http://localhost:8000
**Mobile:** Runs in Chrome

Questions? Check PROJECT_STATUS.md for full documentation.

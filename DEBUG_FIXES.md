# Debug Fixes Report - May 14, 2026

## Issues Fixed

### 1. ✅ Search Endpoint 404 Error

**Problem:** 
- Search bar showing error: `DioException [bad response]: 404`
- Endpoint: `/api/catalog/providers/search?q=AC`

**Root Cause:**
- Route order in Laravel - `/providers/{providerId}` was matching `/providers/search` before search route was evaluated
- In Laravel routing, specific routes must be defined BEFORE dynamic parameter routes

**Solution Applied:**
- **File:** `backend/routes/api.php` (lines 18-23)
- **Change:** Moved `/providers/search` route BEFORE `/providers/{providerId}` route
- **Before:**
  ```php
  Route::get('/providers/{providerId}', [CatalogController::class, 'getProviderDetail']);
  Route::get('/providers/search', [CatalogController::class, 'searchProviders']);
  ```
- **After:**
  ```php
  Route::get('/providers/search', [CatalogController::class, 'searchProviders']);
  Route::get('/providers/{providerId}', [CatalogController::class, 'getProviderDetail']);
  ```

**Verification:**
- Restart backend server
- Try search with "AC" - should now return providers instead of 404

---

### 2. ✅ Order Filtering Issue - Token Not Cleared on Logout

**Problem:**
- Orders from user A (Fajar) visible in user B's (Nabila) account
- Should only show orders belonging to authenticated user

**Root Cause:**
- `logout()` method was not calling `apiService.clearToken()`
- Old token remained in Dio HTTP headers
- When new user logged in, if logout didn't properly clear headers, requests could use mixed/old tokens
- Backend `getMyOrders()` receives correct user from token, but frontend might have stale token

**Solution Applied:**
- **File:** `mobile/lib/features/auth/auth_controller.dart` (logout method)
- **Change:** Added `apiService.clearToken()` call in logout
- **Before:**
  ```dart
  Future<void> logout() async {
    // ... no clearToken() call
    await _ref.read(authStorageProvider).clearAll();
  }
  ```
- **After:**
  ```dart
  Future<void> logout() async {
    final apiService = _ref.read(apiServiceProvider);
    await apiService.logout();
    apiService.clearToken();  // ← Added this line
    await _ref.read(authStorageProvider).clearAll();
  }
  ```

**Why This Fixes It:**
1. Old token removed from Dio headers immediately
2. New user's login will set new token in headers
3. Subsequent API calls use correct auth
4. Backend filters orders correctly by authenticated user_id

---

## Backend Verification

### Endpoint: `/api/catalog/providers/search`

**Test Command:**
```bash
curl -s -X GET "http://localhost:8000/api/catalog/providers/search?q=listrik" | python -m json.tool
```

**Expected Response (200 OK):**
```json
{
  "data": [
    {
      "id": 1,
      "business_name": "Andi Jasa Listrik",
      "area": "Bojongloa Kaler",
      "avg_rating": "5.00"
    }
  ]
}
```

**Error Response (400):**
```json
{
  "message": "Query parameter q is required."
}
```

### Endpoint: `/api/orders/my-orders` (Protected)

**Test Command:**
```bash
# Login as Fajar
curl -s -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"fajar@example.com","password":"password123"}' | python -m json.tool

# Get Fajar's orders with token
curl -s -X GET http://localhost:8000/api/orders/my-orders \
  -H "Authorization: Bearer TOKEN_HERE" | python -m json.tool
```

**Expected:** Only Fajar's orders returned

---

## Manual Testing Steps

### Step 1: Test Search (Frontend)
1. Open app at `localhost:62119` (or current Flutter dev port)
2. Go to "Beranda" tab
3. Type "listrik" in search bar
4. **Expected:** List of providers with "listrik" in name/area (NOT 404 error)

### Step 2: Test Order Filtering (Frontend)
1. Click logout button (if logged in)
2. On LoginPage, login as **Fajar**:
   - Email: `fajar@example.com`
   - Password: `password123`
3. Go to "Pesanan" tab
4. **Expected:** See orders assigned to Fajar
5. Note the order code (e.g., `ORD-20260513-0001`)
6. Click logout button in AppBar
7. On LoginPage, login as **Nabila**:
   - Email: `nabila@example.com`
   - Password: `password123`
8. Go to "Pesanan" tab
9. **Expected:** See DIFFERENT orders (NOT the orders from Fajar)
10. Verify Fajar's order code is NOT visible

### Step 3: Verify Backend Token Handling
1. In Chrome DevTools (F12), go to Network tab
2. Go to "Pesanan" tab
3. Look for API request to `my-orders`
4. Click on request, go to Headers tab
5. Look for `Authorization` header
6. **Expected:** Should show `Bearer <token>` with different tokens for different users

---

## Files Modified

1. **Backend:**
   - `backend/routes/api.php` - Route ordering fix
   - `backend/app/Http/Controllers/Api/CatalogController.php` - Search validation already added

2. **Frontend:**
   - `mobile/lib/features/auth/auth_controller.dart` - Added clearToken() in logout
   - `mobile/lib/core/services/api_service.dart` - Already has correct setToken/clearToken
   - `mobile/lib/core/http/dio_provider.dart` - Already has 30s timeout

---

## Next Steps if Issues Persist

### If Search Still Returns 404:
1. Clear browser cache (Ctrl+Shift+Delete)
2. Restart backend server
3. Run `flutter clean` and `flutter run` again
4. Check backend logs for actual error

### If Orders Still Show Across Users:
1. Check DevTools Network tab for Authorization header
2. Verify token is different for each user login
3. Check backend logs to see which user_id is being received
4. Run manual curl test to isolate if issue is frontend or backend

---

## Status
- ✅ Search route ordering fixed
- ✅ Logout token cleanup fixed  
- ✅ Ready for testing
- 🔄 Awaiting manual test verification

#!/bin/bash
# Script untuk membuat feature branches untuk UAS frontend tasks

cd "C:\Users\H P\Documents\UAS\PM_UAS_rekayasa_Sistem_Informasi"

echo "=== Creating Feature Branches from main ==="
echo ""

git branch feature/frontend-71-payment-dp-qris
echo "✓ Created feature/frontend-71-payment-dp-qris"

git branch feature/frontend-72-payment-final-qris
echo "✓ Created feature/frontend-72-payment-final-qris"

git branch feature/frontend-84-build-apk-demo
echo "✓ Created feature/frontend-84-build-apk-demo"

git branch feature/frontend-21-form-buat-order
echo "✓ Created feature/frontend-21-form-buat-order"

git branch feature/frontend-31-rating-review-dashboard
echo "✓ Created feature/frontend-31-rating-review-dashboard"

git branch feature/frontend-48-integration-end-to-end
echo "✓ Created feature/frontend-48-integration-end-to-end"

echo ""
echo "=== All Feature Branches Created ==="
git branch --list | grep feature/frontend

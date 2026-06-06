<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\Review;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;

class ReviewController extends Controller
{
  /**
   * Create review untuk order
   */
  public function createReview(Request $request, $orderId)
  {
    $user = Auth::user();

    if ($user->role !== 'CUSTOMER') {
      return response()->json([
        'message' => 'only customer can create review',
      ], 403);
    }

    $order = Order::find($orderId);

    if (!$order) {
      return response()->json([
        'message' => 'order not found',
      ], 404);
    }

    if ($order->customer_id !== $user->id) {
      return response()->json([
        'message' => 'unauthorized',
      ], 403);
    }

    if ($order->status !== 'COMPLETED' && $order->status !== 'CLOSED') {
      return response()->json([
        'message' => 'order not completed yet',
      ], 400);
    }

    // Check apakah sudah ada review
    if ($order->review) {
      return response()->json([
        'message' => 'review already exists for this order',
      ], 400);
    }

    $validated = $request->validate([
      'rating' => 'required|integer|between:1,5',
      'comment' => 'nullable|string|max:1000|min:5',
    ]);

    $review = Review::create([
      'order_id' => $order->id,
      'customer_id' => $user->id,
      'provider_id' => $order->provider_id,
      'rating' => $validated['rating'],
      'comment' => $validated['comment'] ?? null,
    ]);

    // Update provider avg_rating
    $providerProfile = $order->provider->providerProfile;
    if ($providerProfile) {
      $avgRating = Review::where('provider_id', $order->provider_id)->avg('rating');
      $providerProfile->update(['avg_rating' => round($avgRating, 2)]);
    }

    Log::channel('api')->info('Review created', [
      'review_id' => $review->id,
      'order_id' => $order->id,
      'customer_id' => $user->id,
      'rating' => $validated['rating'],
    ]);

    return response()->json([
      'message' => 'review created',
      'data' => $review,
    ], 201);
  }

  /**
   * Get reviews untuk provider
   */
  public function getProviderReviews($providerId)
  {
    $reviews = Review::where('provider_id', $providerId)
      ->with(['customer', 'order'])
      ->latest()
      ->get();

    return response()->json([
      'data' => $reviews,
    ], 200);
  }

  /**
   * Get review untuk order
   */
  public function getOrderReview($orderId)
  {
    $review = Review::where('order_id', $orderId)
      ->with(['customer', 'provider'])
      ->first();

    if (!$review) {
      return response()->json([
        'message' => 'review not found',
      ], 404);
    }

    return response()->json([
      'data' => $review,
    ], 200);
  }
}

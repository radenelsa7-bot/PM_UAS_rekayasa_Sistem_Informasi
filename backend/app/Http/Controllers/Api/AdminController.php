<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ProviderProfile;
use App\Services\N8nNotificationService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;

class AdminController extends Controller
{
  private function ensureAdmin(): ?\Illuminate\Http\JsonResponse
  {
    $user = Auth::user();

    if (!$user || $user->role !== 'ADMIN') {
      return response()->json([
        'message' => 'only admin can access this resource',
      ], 403);
    }

    return null;
  }

  public function getPendingProviders(Request $request)
  {
    if ($response = $this->ensureAdmin()) {
      return $response;
    }

    $providers = ProviderProfile::with('user')
      ->where('is_verified', false)
      ->latest()
      ->get();

    return response()->json([
      'data' => $providers,
    ], 200);
  }

  public function updateVerification(Request $request, $providerId)
  {
    if ($response = $this->ensureAdmin()) {
      return $response;
    }

    $validated = $request->validate([
      'is_verified' => 'required|boolean',
    ]);

    $provider = ProviderProfile::with('user')->find($providerId);

    if (!$provider) {
      return response()->json([
        'message' => 'provider not found',
      ], 404);
    }

    $provider->update([
      'is_verified' => $validated['is_verified'],
    ]);

    Log::channel('api')->warning('Provider verification updated', [
      'admin_id' => $user->id,
      'provider_id' => $provider->id,
      'user_id' => $provider->user_id,
      'is_verified' => $provider->is_verified,
      'timestamp' => now(),
    ]);

    app(N8nNotificationService::class)->dispatch(
      $validated['is_verified'] ? 'provider_verified' : 'provider_unverified',
      [
        'provider_id' => $provider->id,
        'user_id' => $provider->user_id,
        'business_name' => $provider->business_name,
        'area' => $provider->area,
        'is_verified' => $provider->is_verified,
      ]
    );

    return response()->json([
      'message' => 'verification updated',
      'data' => $provider,
    ], 200);
  }
}

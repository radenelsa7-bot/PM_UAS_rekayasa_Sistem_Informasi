<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\ProviderPayout;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Jobs\SendProviderPayoutJob;
use App\Models\ProviderPayoutAttempt;

class ProviderPayoutController extends Controller
{
  public function index(Request $request)
  {
    $user = Auth::user();
    if (!$user || !in_array($user->role, ['TREASURER', 'ADMIN'])) {
      abort(403);
    }
    $perPage = (int) ($request->get('per_page', 20));
    $payouts = ProviderPayout::with('provider')->latest()->paginate($perPage);
    return view('admin.treasurer.provider_payouts', compact('payouts'));
  }

  public function detail(Request $request, $id)
  {
    $user = Auth::user();
    if (!$user || !in_array($user->role, ['TREASURER', 'ADMIN'])) {
      abort(403);
    }

    $p = ProviderPayout::with('attempts','provider')->findOrFail($id);
    return view('admin.treasurer.provider_payout_detail', compact('p'));
  }

  // Process single payout (mock)
  public function send(Request $request, $id)
  {
    $user = Auth::user();
    if (!$user || !in_array($user->role, ['TREASURER', 'ADMIN'])) {
      return response()->json(['message' => 'forbidden'], 403);
    }

    $p = ProviderPayout::findOrFail($id);
    if ($p->status !== 'PENDING') {
      return response()->json(['message' => 'payout not pending'], 400);
    }

    // read force_fail option from request
    $forceFail = (bool) ($request->input('force_fail') ?? false);

    // Dispatch job with option
    SendProviderPayoutJob::dispatch($p->id, ['force_fail' => $forceFail]);
    return response()->json(['message' => 'dispatched', 'id' => $p->id, 'force_fail' => $forceFail]);
  }

  // Batch send
  public function sendBatch(Request $request)
  {
    $user = Auth::user();
    if (!$user || !in_array($user->role, ['TREASURER', 'ADMIN'])) {
      return response()->json(['message' => 'forbidden'], 403);
    }

    $ids = $request->input('ids', []);
    if (empty($ids) || !is_array($ids)) {
      return response()->json(['message' => 'no ids provided'], 400);
    }

    $results = [];
    foreach ($ids as $id) {
      $p = ProviderPayout::find($id);
      if (!$p) {
        $results[$id] = 'not_found';
        continue;
      }
      if ($p->status !== 'PENDING') {
        $results[$id] = 'not_pending';
        continue;
      }

      $forceFail = (bool) ($request->input('force_fail') ?? false);
      SendProviderPayoutJob::dispatch($p->id, ['force_fail' => $forceFail]);
      $results[$id] = ['status' => 'dispatched', 'force_fail' => $forceFail];
    }

    return response()->json(['results' => $results]);
  }

  public function retry(Request $request, $id)
  {
    $user = Auth::user();
    if (!$user || !in_array($user->role, ['TREASURER', 'ADMIN'])) {
      return response()->json(['message' => 'forbidden'], 403);
    }

    $p = ProviderPayout::findOrFail($id);
    // allow retry only if FAILED
    if ($p->status !== 'FAILED') {
      return response()->json(['message' => 'only failed payouts can be retried'], 400);
    }

    // reset to PENDING so job can process it
    $p->status = 'PENDING';
    $p->error_message = null;
    $p->transaction_reference = null;
    $p->save();

    // dispatch with option to not force fail
    SendProviderPayoutJob::dispatch($p->id, ['force_fail' => false]);
    return response()->json(['message' => 'retry dispatched']);
  }
}

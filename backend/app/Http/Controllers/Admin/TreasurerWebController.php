<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class TreasurerWebController extends Controller
{
  public function index(Request $request)
  {
    $user = Auth::user();

    if (!$user || $user->role !== 'TREASURER') {
      abort(403, 'only treasurer can access this page');
    }

    return view('admin.treasurer.report_standalone');
  }
}

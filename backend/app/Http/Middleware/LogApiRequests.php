<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Symfony\Component\HttpFoundation\Response;

class LogApiRequests
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        $user = auth('sanctum')->user();
        
        Log::channel('api')->info('API Request', [
            'method' => $request->getMethod(),
            'path' => $request->getPathInfo(),
            'user_id' => $user?->id ?? 'anonymous',
            'user_role' => $user?->role ?? 'none',
            'ip' => $request->ip(),
            'timestamp' => now(),
        ]);

        return $next($request);
    }
}

<?php

namespace App\Services;

use Illuminate\Support\Facades\Log;

class ErrorResponseService
{
    /**
     * Return standardized validation error response
     */
    public static function validationError(array $errors): array
    {
        Log::channel('api')->warning('Validation error', ['errors' => $errors]);
        
        return [
            'success' => false,
            'message' => 'Validation error',
            'errors' => $errors,
            'code' => 'VALIDATION_ERROR',
        ];
    }

    /**
     * Return standardized authorization error response
     */
    public static function unauthorized(): array
    {
        Log::channel('api')->warning('Unauthorized access attempt');
        
        return [
            'success' => false,
            'message' => 'You are not authorized to access this resource',
            'code' => 'UNAUTHORIZED',
        ];
    }

    /**
     * Return standardized forbidden error response
     */
    public static function forbidden(): array
    {
        Log::channel('api')->warning('Forbidden access attempt');
        
        return [
            'success' => false,
            'message' => 'Access forbidden',
            'code' => 'FORBIDDEN',
        ];
    }

    /**
     * Return standardized not found error response
     */
    public static function notFound(string $resource = 'Resource'): array
    {
        return [
            'success' => false,
            'message' => "{$resource} not found",
            'code' => 'NOT_FOUND',
        ];
    }

    /**
     * Return standardized business logic error response
     */
    public static function businessLogicError(string $message): array
    {
        Log::channel('api')->warning('Business logic error', ['message' => $message]);
        
        return [
            'success' => false,
            'message' => $message,
            'code' => 'BUSINESS_LOGIC_ERROR',
        ];
    }

    /**
     * Return standardized internal server error response
     */
    public static function internalError(string $message = 'Internal server error'): array
    {
        Log::channel('api')->error('Internal server error', ['message' => $message]);
        
        return [
            'success' => false,
            'message' => $message,
            'code' => 'INTERNAL_ERROR',
        ];
    }
}

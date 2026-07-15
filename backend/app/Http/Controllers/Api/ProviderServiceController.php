<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\ProviderServiceRequest;
<<<<<<< HEAD
use App\Models\Order;
=======
>>>>>>> d11988a502d317c7882c6ee4cfdd1998a9b97034
use App\Models\ProviderService;
use App\Traits\ApiResponse;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ProviderServiceController extends Controller
{
    use ApiResponse;

    public function store(ProviderServiceRequest $request): JsonResponse
    {
        $user = $request->user();

        if ($user->role !== 'PROVIDER') {
            return $this->forbidden('Only providers can create services');
        }

        $profile = $user->providerProfile;
        if (!$profile) {
            return $this->notFound('Provider profile not found');
        }

        $service = ProviderService::create([
            'provider_profile_id' => $profile->id,
            'category_id' => $request->input('category_id'),
            'name' => $request->input('name'),
<<<<<<< HEAD
            'description' => $request->input('description'),
=======
>>>>>>> d11988a502d317c7882c6ee4cfdd1998a9b97034
            'base_price' => $request->input('base_price'),
            'price_unit' => $request->input('price_unit'),
            'is_active' => $request->boolean('is_active', true),
        ]);

        return $this->success([
            'service_id' => $service->id,
        ], 'Service created successfully', 201);
    }

    public function update(ProviderServiceRequest $request, int $id): JsonResponse
    {
        $user = $request->user();

        if ($user->role !== 'PROVIDER') {
            return $this->forbidden('Only providers can update services');
        }

        $profile = $user->providerProfile;
        if (!$profile) {
            return $this->notFound('Provider profile not found');
        }

        $service = ProviderService::where('id', $id)
            ->where('provider_profile_id', $profile->id)
            ->first();

        if (!$service) {
            return $this->notFound('Service not found');
        }

        $service->update($request->validated());

        return $this->success([
            'service' => $service,
        ], 'Service updated successfully', 200);
    }
<<<<<<< HEAD

    public function destroy(Request $request, int $id): JsonResponse
    {
        $user = $request->user();

        if ($user->role !== 'PROVIDER') {
            return $this->forbidden('Only providers can delete services');
        }

        $profile = $user->providerProfile;
        if (!$profile) {
            return $this->notFound('Provider profile not found');
        }

        $service = ProviderService::where('id', $id)
            ->where('provider_profile_id', $profile->id)
            ->first();

        if (!$service) {
            return $this->notFound('Service not found');
        }

        if (Order::where('provider_service_id', $service->id)->exists()) {
            return $this->conflict('Layanan tidak dapat dihapus karena sudah digunakan pada pesanan');
        }

        $service->delete();

        return $this->success(null, 'Service deleted successfully', 200);
    }
=======
>>>>>>> d11988a502d317c7882c6ee4cfdd1998a9b97034
}

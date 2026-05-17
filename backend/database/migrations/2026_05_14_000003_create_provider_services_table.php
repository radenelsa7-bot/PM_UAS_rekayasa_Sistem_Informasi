<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
  /**
   * Run the migrations.
   */
  public function up(): void
  {
    Schema::create('provider_services', function (Blueprint $table) {
      $table->id();
      $table->foreignId('provider_profile_id')->constrained('provider_profiles')->onDelete('cascade');
      $table->foreignId('category_id')->constrained('service_categories')->onDelete('restrict');
      $table->string('name', 120);
      $table->unsignedInteger('base_price')->default(0);
      $table->string('price_unit', 30)->nullable();
      $table->boolean('is_active')->default(true);
      $table->timestamps();
    });
  }

  /**
   * Reverse the migrations.
   */
  public function down(): void
  {
    Schema::dropIfExists('provider_services');
  }
};

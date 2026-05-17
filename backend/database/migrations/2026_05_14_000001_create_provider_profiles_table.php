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
    Schema::create('provider_profiles', function (Blueprint $table) {
      $table->id();
      $table->foreignId('user_id')->unique()->constrained('users')->onDelete('cascade');
      $table->string('business_name', 150)->nullable();
      $table->text('description')->nullable();
      $table->string('area', 100)->nullable();
      $table->text('address')->nullable();
      $table->boolean('is_verified')->default(false);
      $table->decimal('avg_rating', 3, 2)->default(0);
      $table->timestamps();
    });
  }

  /**
   * Reverse the migrations.
   */
  public function down(): void
  {
    Schema::dropIfExists('provider_profiles');
  }
};

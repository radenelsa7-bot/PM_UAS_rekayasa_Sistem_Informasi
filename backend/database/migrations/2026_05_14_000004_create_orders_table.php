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
    Schema::create('orders', function (Blueprint $table) {
      $table->id();
      $table->string('order_code', 50)->unique();
      $table->foreignId('customer_id')->constrained('users')->onDelete('cascade');
      $table->foreignId('provider_id')->constrained('users')->onDelete('restrict');
      $table->foreignId('category_id')->nullable()->constrained('service_categories')->onDelete('restrict');
      $table->foreignId('provider_service_id')->nullable()->constrained('provider_services')->onDelete('restrict');
      $table->dateTime('schedule_at');
      $table->text('address');
      $table->text('notes')->nullable();
      $table->unsignedInteger('estimated_price');
      $table->unsignedInteger('final_price')->nullable();
      $table->enum('status', ['CREATED', 'ACCEPTED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED', 'CLOSED'])->default('CREATED');
      $table->timestamps();

      // Index for better query performance
      $table->index('customer_id');
      $table->index('provider_id');
      $table->index('status');
    });
  }

  /**
   * Reverse the migrations.
   */
  public function down(): void
  {
    Schema::dropIfExists('orders');
  }
};

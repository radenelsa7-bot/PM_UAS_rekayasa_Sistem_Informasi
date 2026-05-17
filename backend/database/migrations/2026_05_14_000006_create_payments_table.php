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
    Schema::create('payments', function (Blueprint $table) {
      $table->id();
      $table->foreignId('order_id')->constrained('orders')->onDelete('cascade');
      $table->enum('payment_type', ['DP', 'FINAL']);
      $table->unsignedInteger('amount');
      $table->enum('status', ['UNPAID', 'PENDING', 'PAID', 'FAILED', 'EXPIRED'])->default('UNPAID');
      $table->string('provider', 50)->nullable();
      $table->string('external_payment_id', 100)->nullable();
      $table->dateTime('paid_at')->nullable();
      $table->timestamps();

      // Index untuk query yang lebih cepat
      $table->index('order_id');
      $table->index('status');
    });
  }

  /**
   * Reverse the migrations.
   */
  public function down(): void
  {
    Schema::dropIfExists('payments');
  }
};

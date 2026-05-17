<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
  public function up()
  {
    Schema::create('provider_payouts', function (Blueprint $table) {
      $table->id();
      $table->unsignedBigInteger('provider_id');
      $table->decimal('amount', 15, 2)->default(0);
      $table->json('payment_ids')->nullable();
      $table->enum('status', ['PENDING', 'SENT', 'FAILED'])->default('PENDING');
      $table->timestamp('sent_at')->nullable();
      $table->timestamps();

      $table->foreign('provider_id')->references('id')->on('users')->onDelete('cascade');
    });
  }

  public function down()
  {
    Schema::dropIfExists('provider_payouts');
  }
};

<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
  public function up()
  {
    Schema::create('provider_payout_attempts', function (Blueprint $table) {
      $table->id();
      $table->unsignedBigInteger('provider_payout_id');
      $table->enum('status', ['PENDING', 'SENT', 'FAILED'])->default('PENDING');
      $table->string('transaction_reference')->nullable();
      $table->text('error_message')->nullable();
      $table->json('meta')->nullable();
      $table->timestamps();

      $table->foreign('provider_payout_id')->references('id')->on('provider_payouts')->onDelete('cascade');
    });
  }

  public function down()
  {
    Schema::dropIfExists('provider_payout_attempts');
  }
};

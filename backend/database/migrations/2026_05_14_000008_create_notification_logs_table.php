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
    Schema::create('notification_logs', function (Blueprint $table) {
      $table->id();
      $table->string('event_name', 100);
      $table->enum('channel', ['WA', 'EMAIL']);
      $table->longText('payload_json');
      $table->enum('status', ['SENT', 'FAILED'])->default('SENT');
      $table->dateTime('sent_at')->nullable();
      $table->timestamps();

      $table->index('event_name');
      $table->index('status');
    });
  }

  /**
   * Reverse the migrations.
   */
  public function down(): void
  {
    Schema::dropIfExists('notification_logs');
  }
};

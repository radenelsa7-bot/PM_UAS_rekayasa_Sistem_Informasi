<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
  public function up()
  {
    Schema::table('provider_payouts', function (Blueprint $table) {
      if (!Schema::hasColumn('provider_payouts', 'transaction_reference')) {
        $table->string('transaction_reference')->nullable()->after('status');
      }
      if (!Schema::hasColumn('provider_payouts', 'error_message')) {
        $table->text('error_message')->nullable()->after('transaction_reference');
      }
    });
  }

  public function down()
  {
    Schema::table('provider_payouts', function (Blueprint $table) {
      $table->dropColumn(['transaction_reference', 'error_message']);
    });
  }
};

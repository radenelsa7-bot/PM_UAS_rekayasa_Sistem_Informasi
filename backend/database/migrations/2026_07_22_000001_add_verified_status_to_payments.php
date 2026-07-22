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
        Schema::table('payments', function (Blueprint $table) {
            // For SQLite (testing), we skip enum alterations and rely on application validation
            // For MySQL, we need to modify the enum column
            $driver = \Illuminate\Support\Facades\DB::getDriverName();
            if ($driver === 'mysql') {
                \Illuminate\Support\Facades\DB::statement("
                    ALTER TABLE payments 
                    MODIFY COLUMN status 
                    ENUM('UNPAID', 'PENDING', 'PAID', 'FAILED', 'EXPIRED', 'VERIFIED') 
                    DEFAULT 'UNPAID'
                ");
            }
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        $driver = \Illuminate\Support\Facades\DB::getDriverName();
        if ($driver === 'mysql') {
            \Illuminate\Support\Facades\DB::statement("
                ALTER TABLE payments 
                MODIFY COLUMN status 
                ENUM('UNPAID', 'PENDING', 'PAID', 'FAILED', 'EXPIRED') 
                DEFAULT 'UNPAID'
            ");
        }
    }
};
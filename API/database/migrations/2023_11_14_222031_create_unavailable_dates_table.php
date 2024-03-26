<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('unavailable_dates', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('salon_id')->nullable();
            $table->unsignedBigInteger('individual_id')->nullable();
            $table->date('unavailable_date');
            $table->timestamps();

            $table->foreign('salon_id')->references('id')->on('salon')->onDelete('cascade');
            $table->foreign('individual_id')->references('id')->on('individual')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('unavailable_dates');
    }
};

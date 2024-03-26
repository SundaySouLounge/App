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
        Schema::create('event_contract', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('user_id');
            $table->unsignedBigInteger('salon_id')->nullable();
            $table->unsignedBigInteger('individual_id')->nullable();
            $table->unsignedBigInteger('salon_uid')->nullable();
            $table->unsignedBigInteger('individual_uid')->nullable();
            $table->text('date');
            $table->text('time');
            $table->text('band_size');
            $table->double('fee', 10, 2)->nullable();
            $table->text('extra_field')->nullable();
            $table->string('status')->default('pendding');
            $table->string('suggester')->default('user');
            $table->timestamps();

            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('salon_id')->references('id')->on('salon')->onDelete('cascade');
            $table->foreign('individual_id')->references('id')->on('individual')->onDelete('cascade');
            $table->foreign('salon_uid')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('individual_uid')->references('id')->on('users')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('event_contract');
    }
};

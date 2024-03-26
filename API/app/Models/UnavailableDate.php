<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UnavailableDate extends Model
{
    use HasFactory;

    protected $table = 'unavailable_dates';

    protected $fillable = ['salon_id', 'individual_id', 'unavailable_date'];

    public function salon()
    {
        return $this->belongsTo(Salon::class);
    }

    public function individual()
    {
        return $this->belongsTo(Individual::class);
    }
}

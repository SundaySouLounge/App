<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class EventContract extends Model
{
    use HasFactory;

    protected $table = 'event_contract';

    public $timestamps = true; //by default timestamp false

    protected $fillable = [
        'user_id',
        'salon_id',
        'individual_id',
        'salon_uid',
        'individual_uid',
        'date',
        'time',
        'band_size',
        'venue_name',
        'venue_address',
        'mobile',
        'fee',
        'status',
        'suggester',
        'extra_field',
        'musician',
        'body',
        'payment_method',
    ];

    // protected $casts = [
    //     'user_id' => 'unsignedBigInteger',
    // ];

    protected $hidden = [
        'updated_at',
        'created_at',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id', 'id');
    }
}

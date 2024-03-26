<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CalendarEvents extends Model
{
    use HasFactory;

    protected $table = 'calendar_events';

    public $timestamps = true; //by default timestamp false

    protected $fillable = ['uid', 'title', 'event_date', 'event_link',];

    protected $hidden = [
        'updated_at',
        'created_at',
    ];

}

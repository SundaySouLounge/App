<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PushNotification extends Model
{
    use HasFactory;

    protected $table = 'push_notification';

    public $timestamps = true; //by default timestamp false

    protected $fillable = ['notification_id', 'user_id', 'title', 'message', 'data'];

    protected $hidden = [
        'updated_at',
        'created_at',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id', 'id');
    }
}

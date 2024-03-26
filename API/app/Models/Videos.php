<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Videos extends Model
{
    use HasFactory;

    protected $table = 'videos';

    public $timestamps = true; //by default timestamp false

    protected $fillable = ['uid', 'title', 'video_link'];

    protected $hidden = [
        'updated_at',
        'created_at',
    ];

}

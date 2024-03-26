<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Salon extends Model
{
    use HasFactory;

    protected $table = 'salon';

    public $timestamps = true; //by default timestamp false

    protected $fillable = [
        'uid',
        'name',
        'cover',
        'categories',
        'address',
        'lat',
        'lng',
        'about',
        'rating',
        'total_rating',
        'website',
        'timing',
        'images',
        'zipcode',
        'service_at_home',
        'verified',
        'travel',
        'wedding',
        'setup',
        'acustic_solo',
        'acustic_duo',
        'acustic_trio',
        'acustic_duoinstru',
        'acustic_quarterinstru',
        'acustic_trioinstru',
        'acustic_soloinstru',
        'acustic_weddinginstru',
        'cid',
        'have_stylist',
        'status',
        'in_home',
        'popular',
        'have_shop',
        'extra_field',
        'contact_name',
        'contact_number',
    ];

    protected $hidden = [
        'updated_at',
        'created_at',
    ];

    protected $casts = [
        'uid' => 'integer',
        'cid' => 'integer',
        'total_rating' => 'integer',
        'service_at_home' => 'integer',
        'verified' => 'integer',
        'have_stylist' => 'integer',
        'status' => 'integer',
    ];

    public function users()
    {
        return $this->belongsToMany(User::class, 'users_salon', 'salon_id', 'user_id')->withTimestamps();
    }

    public function eventContracts()
    {
        return $this->hasMany(EventContract::class, 'salon_id', 'id');
    }
    public function unavailableDates()
    {
        return $this->hasMany(UnavailableDate::class);
    }
}

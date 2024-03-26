<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Individual extends Model
{
    use HasFactory;

    protected $table = 'individual';

    public $timestamps = true; //by default timestamp false

    protected $fillable = [
        'uid',
        'background',
        'categories',
        'address',
        'about',
        'rating',
        'total_rating',
        'website',
        'timing',
        'images',
        'zipcode',
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
        'fee_start',
        'lat',
        'lng',
        'status',
        'in_home',
        'popular',
        'have_shop',
        'extra_field',
        'quartetcheck',
        'triocheck',
        'is_favorite',
        'band_name',
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
        'verified' => 'integer',
        'status' => 'integer',
    ];

    public function users()
    {
        return $this->belongsToMany(User::class, 'users_individual', 'individual_id', 'user_id')->withTimestamps();
    }
    public function eventContracts()
    {
        return $this->hasMany(EventContract::class, 'individual_id', 'id');
    }

    public function unavailableDates()
    {
        return $this->hasMany(UnavailableDate::class);
    }
}

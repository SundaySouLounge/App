<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Tymon\JWTAuth\Contracts\JWTSubject;
use Bavix\Wallet\Traits\HasWallet;
use Bavix\Wallet\Interfaces\Wallet;

class User extends Authenticatable implements JWTSubject, Wallet
{
    use HasApiTokens, HasFactory, Notifiable, HasWallet;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'first_name',
        'last_name',
        'venue_name',
        'venue_address',
        'country_code',
        'mobile',
        'cover',
        'gender',
        'type',
        'fcm_token',
        'stripe_key',
        'extra_field',
        'status',
        'email',
        'password',
        'phone_second',
        'password_second',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    /**
     * Get the identifier that will be stored in the subject claim of the JWT.
     *
     * @return mixed
     */
    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    /**
     * Return a key value array, containing any custom claims to be added to the JWT.
     *
     * @return array
     */
    public function getJWTCustomClaims()
    {
        return [];
    }

    public function individuals()
    {
        return $this->belongsToMany(Individual::class, 'users_individual', 'user_id', 'individual_id')->withTimestamps();
    }

    public function salons()
    {
        return $this->belongsToMany(Salon::class, 'users_salon', 'user_id', 'salon_id')->withTimestamps();
    }
    public function pushNotifications()
    {
        return $this->hasMany(PushNotification::class, 'user_id', 'id');
    }
    public function eventContracts()
    {
        return $this->hasMany(EventContract::class, 'user_id', 'id');
    }
}

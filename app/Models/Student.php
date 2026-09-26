<?php

namespace App\Models;

use App\Models\Subscription;
use App\Models\WatchSession;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Student extends Model
{
    use HasFactory;

    protected $guarded = [];

    public function subscriptions(): HasMany
    {
        return $this->hasMany(Subscription::class);
    }

    public function watchSessions(): HasMany
    {
        return $this->hasMany(WatchSession::class);
    }
}

<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProviderWebhookEvent extends Model
{
    public const UPDATED_AT = null;

    protected $guarded = [];

    protected function casts(): array
    {
        return [
            'payload' => 'array',
            'processed_at' => 'immutable_datetime',
        ];
    }
}

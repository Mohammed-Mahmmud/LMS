<?php

namespace App\Models;

use App\Models\Instructor;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Course extends Model
{
    use HasFactory;

    protected $guarded = [];

    public function instructor(): BelongsTo
    {
        return $this->belongsTo(Instructor::class);
    }
}

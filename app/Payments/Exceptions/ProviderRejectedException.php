<?php

namespace App\Payments\Exceptions;

use RuntimeException;

/** The request is invalid (e.g. 4xx) and retrying it will not help. */
class ProviderRejectedException extends RuntimeException {}

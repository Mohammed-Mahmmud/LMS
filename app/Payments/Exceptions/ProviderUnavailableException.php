<?php

namespace App\Payments\Exceptions;

use RuntimeException;

/** The provider refused the request (e.g. 503) without processing it. */
class ProviderUnavailableException extends RuntimeException {}

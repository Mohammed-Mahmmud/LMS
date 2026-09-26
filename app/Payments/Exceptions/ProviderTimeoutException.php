<?php

namespace App\Payments\Exceptions;

use RuntimeException;

/** The request may or may not have been processed by the provider. */
class ProviderTimeoutException extends RuntimeException {}

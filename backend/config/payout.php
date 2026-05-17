<?php

return [
  // Maximum attempts before marking payout as permanently failed
  'max_attempts' => env('PAYOUT_MAX_ATTEMPTS', 3),

  // Default gateway to use when multiple implementations available
  'gateway' => env('PAYOUT_GATEWAY', 'mock'),
];

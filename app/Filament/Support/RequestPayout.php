<?php

namespace App\Filament\Support;

use App\Models\Instructor;
use App\Payments\PayoutException;
use App\Payments\PayoutService;
use App\Support\Money;
use Filament\Actions\Action as PageAction;
use Filament\Forms\Components\TextInput;
use Filament\Notifications\Notification;
use Filament\Tables\Actions\Action as TableAction;

/**
 * The "Pay out" action, shared by the table row and the view page header.
 */
class RequestPayout
{
    public static function configure(TableAction|PageAction $action): TableAction|PageAction
    {
        return $action
            ->label('Pay out')
            ->icon('heroicon-o-paper-airplane')
            ->color('success')
            ->visible(fn (Instructor $record) => filled($record->payout_account)
                && $record->balanceCents() >= config('ledger.min_payout_cents'))
            ->modalDescription(fn (Instructor $record) => 'Available balance: '.Money::format($record->balanceCents()))
            ->form([
                TextInput::make('amount')
                    ->label('Amount ('.config('ledger.currency').')')
                    ->helperText('Leave empty to pay out the full balance.')
                    ->numeric()
                    ->minValue(config('ledger.min_payout_cents') / 100)
                    ->step(0.01),
            ])
            ->action(function (Instructor $record, array $data) {
                $amountCents = filled($data['amount'] ?? null) ? (int) round($data['amount'] * 100) : null;

                try {
                    $payout = app(PayoutService::class)->request($record, $amountCents);
                } catch (PayoutException $e) {
                    Notification::make()->title('Payout not created')->body($e->getMessage())->danger()->send();

                    return;
                }

                Notification::make()
                    ->title('Payout #'.$payout->id.' queued')
                    ->body(Money::format($payout->amount_cents).' reserved and sent to the provider.')
                    ->success()
                    ->send();
            });
    }
}

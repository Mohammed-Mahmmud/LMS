<?php

namespace App\Filament\Resources\InstructorResource\RelationManagers;

use App\Enums\PayoutStatus;
use App\Models\Payout;
use App\Payments\PayoutService;
use Filament\Resources\RelationManagers\RelationManager;
use Filament\Tables\Actions\Action;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;

class PayoutsRelationManager extends RelationManager
{
    protected static string $relationship = 'payouts';

    public function isReadOnly(): bool
    {
        return false;
    }

    public function table(Table $table): Table
    {
        return $table
            ->defaultSort('id', 'desc')
            ->poll('10s')
            ->columns([
                TextColumn::make('id')->label('#'),
                TextColumn::make('amount_cents')->label('Amount')->money(config('ledger.currency'), divideBy: 100),
                TextColumn::make('status')->badge()->color(fn (PayoutStatus $state) => $state->color()),
                TextColumn::make('attempts'),
                TextColumn::make('provider_reference')->placeholder('—')->copyable(),
                TextColumn::make('last_error')->placeholder('—')->limit(40)->tooltip(fn (Payout $record) => $record->last_error),
                TextColumn::make('requested_at')->dateTime(),
                TextColumn::make('completed_at')->dateTime()->placeholder('—'),
            ])
            ->actions([
                Action::make('reconcile')
                    ->icon('heroicon-o-arrow-path')
                    ->visible(fn (Payout $record) => ! $record->status->isTerminal())
                    ->requiresConfirmation()
                    ->modalDescription('Ask the provider for the current status of this transfer.')
                    ->action(fn (Payout $record) => app(PayoutService::class)->reconcile($record)),
            ]);
    }
}

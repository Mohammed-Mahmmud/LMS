<?php

namespace App\Filament\Resources\InstructorResource\RelationManagers;

use App\Enums\LedgerEntryType;
use Filament\Resources\RelationManagers\RelationManager;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Table;

class LedgerEntriesRelationManager extends RelationManager
{
    protected static string $relationship = 'ledgerEntries';

    protected static ?string $title = 'Ledger';

    public function table(Table $table): Table
    {
        return $table
            ->defaultSort('id', 'desc')
            ->columns([
                TextColumn::make('created_at')->dateTime()->label('Posted'),
                TextColumn::make('type')->badge()->formatStateUsing(fn (LedgerEntryType $state) => $state->label()),
                TextColumn::make('amount_cents')
                    ->label('Amount')
                    ->money(config('ledger.currency'), divideBy: 100)
                    ->color(fn (int $state) => $state < 0 ? 'danger' : 'success'),
                TextColumn::make('subscription_id')->label('Subscription')->placeholder('—'),
                TextColumn::make('payout_id')->label('Payout')->placeholder('—'),
                TextColumn::make('refund_id')->label('Refund')->placeholder('—'),
                TextColumn::make('idempotency_key')->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                SelectFilter::make('type')->options(collect(LedgerEntryType::cases())->mapWithKeys(fn ($t) => [$t->value => $t->label()])),
            ]);
    }
}

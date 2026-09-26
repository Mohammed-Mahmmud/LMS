<?php

namespace App\Filament\Resources;

use App\Enums\LedgerEntryType;
use App\Enums\PayoutStatus;
use App\Filament\Resources\InstructorResource\Pages;
use App\Filament\Resources\InstructorResource\RelationManagers;
use App\Filament\Support\RequestPayout;
use App\Models\Instructor;
use Filament\Infolists\Components\Section;
use Filament\Infolists\Components\TextEntry;
use Filament\Infolists\Infolist;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\Filter;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;

/**
 * Read-only financial view: balances are derived from the ledger, never edited by hand.
 */
class InstructorResource extends Resource
{
    protected static ?string $model = Instructor::class;

    protected static ?string $navigationIcon = 'heroicon-o-banknotes';

    protected static ?string $navigationLabel = 'Instructor balances';

    protected static ?string $recordTitleAttribute = 'name';

    public static function canCreate(): bool
    {
        return false;
    }

    public static function infolist(Infolist $infolist): Infolist
    {
        $currency = config('ledger.currency');

        return $infolist->schema([
            Section::make('Instructor')
                ->columns(3)
                ->schema([
                    TextEntry::make('name'),
                    TextEntry::make('email'),
                    TextEntry::make('payout_account')->placeholder('Not connected')->copyable(),
                ]),
            Section::make('Money')
                ->description('Earned (net) = Paid out + In flight + Owed now')
                ->columns(4)
                ->schema([
                    TextEntry::make('earned')
                        ->label('Earned (net)')
                        ->state(fn (Instructor $record) => $record->earnedCents())
                        ->money($currency, divideBy: 100),
                    TextEntry::make('paid')
                        ->label('Paid out')
                        ->state(fn (Instructor $record) => $record->paidCents())
                        ->money($currency, divideBy: 100),
                    TextEntry::make('in_flight')
                        ->label('In flight')
                        ->state(fn (Instructor $record) => $record->inFlightCents())
                        ->money($currency, divideBy: 100)
                        ->color('warning'),
                    TextEntry::make('balance')
                        ->label('Owed now')
                        ->state(fn (Instructor $record) => $record->balanceCents())
                        ->money($currency, divideBy: 100)
                        ->weight('bold')
                        ->color(fn ($state) => $state < 0 ? 'danger' : 'success'),
                ]),
        ]);
    }

    public static function table(Table $table): Table
    {
        $currency = config('ledger.currency');

        return $table
            ->modifyQueryUsing(fn (Builder $query) => $query
                ->withSum(['ledgerEntries as earned_cents' => fn ($q) => $q->whereIn('type', LedgerEntryType::earningTypes())], 'amount_cents')
                ->withSum(['payouts as paid_cents' => fn ($q) => $q->where('status', PayoutStatus::Succeeded)], 'amount_cents')
                ->withSum(['payouts as in_flight_cents' => fn ($q) => $q->whereIn('status', [PayoutStatus::Pending, PayoutStatus::Processing])], 'amount_cents')
                ->withSum('ledgerEntries as balance_cents', 'amount_cents'))
            ->columns([
                TextColumn::make('name')->searchable()->sortable(),
                TextColumn::make('email')->searchable()->toggleable(isToggledHiddenByDefault: true),
                TextColumn::make('earned_cents')
                    ->label('Earned (net)')
                    ->money($currency, divideBy: 100)
                    ->default(0)
                    ->sortable()
                    ->tooltip('Allocated earnings minus refund clawbacks'),
                TextColumn::make('paid_cents')
                    ->label('Paid out')
                    ->money($currency, divideBy: 100)
                    ->default(0)
                    ->sortable(),
                TextColumn::make('in_flight_cents')
                    ->label('In flight')
                    ->money($currency, divideBy: 100)
                    ->default(0)
                    ->color('warning')
                    ->sortable(),
                TextColumn::make('balance_cents')
                    ->label('Owed now')
                    ->money($currency, divideBy: 100)
                    ->default(0)
                    ->weight('bold')
                    ->color(fn ($state) => $state < 0 ? 'danger' : null)
                    ->sortable(),
            ])
            ->defaultSort('balance_cents', 'desc')
            ->filters([
                Filter::make('owed')
                    ->label('Has a balance to pay')
                    ->query(fn (Builder $query) => $query->whereRaw(
                        '(select coalesce(sum(amount_cents), 0) from ledger_entries where ledger_entries.instructor_id = instructors.id) > 0'
                    )),
            ])
            ->actions([
                RequestPayout::configure(Tables\Actions\Action::make('requestPayout')),
                Tables\Actions\ViewAction::make(),
            ]);
    }

    public static function getRelations(): array
    {
        return [
            RelationManagers\PayoutsRelationManager::class,
            RelationManagers\LedgerEntriesRelationManager::class,
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListInstructors::route('/'),
            'view' => Pages\ViewInstructor::route('/{record}'),
        ];
    }
}

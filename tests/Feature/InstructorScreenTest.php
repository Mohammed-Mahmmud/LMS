<?php

use App\Enums\PayoutStatus;
use App\Filament\Resources\InstructorResource\Pages\ListInstructors;
use App\Filament\Resources\InstructorResource\Pages\ViewInstructor;
use App\Models\Instructor;
use App\Models\User;
use Illuminate\Support\Facades\Queue;

use function Pest\Livewire\livewire;

beforeEach(function () {
    $this->actingAs(User::factory()->create());
});

it('redirects guests to the login page', function () {
    auth()->logout();

    $this->get('/admin/instructors')->assertRedirect('/admin/login');
});

it('lists instructor balances', function () {
    $instructor = Instructor::factory()->create(['name' => 'Sara Hassan']);
    $this->credit($instructor, 12345);

    $this->get('/admin/instructors')->assertOk()->assertSee('Sara Hassan');

    livewire(ListInstructors::class)
        ->assertCanSeeTableRecords([$instructor])
        ->assertSee('123.45');
});

it('renders the instructor page with the money summary', function () {
    $instructor = Instructor::factory()->create();
    $this->credit($instructor, 5000);

    $this->get("/admin/instructors/{$instructor->id}")->assertOk()->assertSee('Owed now');
});

it('creates a payout from the table action', function () {
    Queue::fake();
    $instructor = Instructor::factory()->create();
    $this->credit($instructor, 5000);

    livewire(ListInstructors::class)
        ->callTableAction('requestPayout', $instructor, data: ['amount' => 20])
        ->assertHasNoTableActionErrors();

    expect((int) $instructor->payouts()->value('amount_cents'))->toBe(2000)
        ->and($instructor->payouts()->first()->status)->toBe(PayoutStatus::Pending);
    $this->assertBalance(3000, $instructor);
});

it('hides the payout action below the minimum', function () {
    $instructor = Instructor::factory()->create();
    $this->credit($instructor, 500);

    livewire(ViewInstructor::class, ['record' => $instructor->id])
        ->assertActionHidden('requestPayout');
});

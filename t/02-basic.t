use utf8;
no warnings qw(qw);
use open qw(:std :utf8);

use Test::More qw(no_plan);
use Test::Number::Delta;
use Test::Deep;

use Lingua::RU::OpenCorpora::Tokenizer;

my @tests = (
    [
        'Простейшее предложение.',
        [
            [11, 1],
            [23, 1],
            [24, 1],
        ],
        [qw(
            Простейшее
            предложение
            .
        )],
    ],
    [
        'Это предложение чуть сложнее, но все ещё простое.',
        [
            [4,  1],
            [16, 1],
            [21, 1],
            [29, 1],
            [30, 1],
            [33, 1],
            [37, 1],
            [41, 1],
            [48, 1],
            [49, 1],
        ],
        [qw(
            Это
            предложение
            чуть
            сложнее
            ,
            но
            все
            ещё
            простое
            .
        )],
    ],
);

my $tokenizer = Lingua::RU::OpenCorpora::Tokenizer->new;

for my $t (@tests) {
    my $bounds = $tokenizer->tokens_bounds($t->[0]);
    for my $got (@$bounds) {
        for my $expected (@{ $_->[1] }) {
            cmp_ok $got->[0], $expected->[0], 'boundary';
            delta_within $got->[1], $expected->[1], 0.01, 'probability';
        }
    }

    my $tokens = $tokenizer->tokens($t->[0]);
    cmp_deeply $tokens, $t->[2], 'tokens';
}

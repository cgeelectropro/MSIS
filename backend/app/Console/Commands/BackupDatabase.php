<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\File;
use Symfony\Component\Process\Process;

/**
 * SRS §25.4/DEP-06. Dumps to local disk on a rotation by default — the
 * off-site destination (Decision Register D-26: S3, another VPS, etc.) is
 * still an open Product Owner decision, so this deliberately doesn't guess
 * at one. Once D-26 lands, this is the one place to add the upload step.
 */
class BackupDatabase extends Command
{
    protected $signature = 'app:backup-database {--keep=14 : Number of most recent backups to retain}';

    protected $description = 'Dump the MySQL database to storage/app/backups, gzip-compressed, pruning older backups';

    public function handle(): int
    {
        $connection = config('database.default');
        $config = config("database.connections.{$connection}");

        if ($connection !== 'mysql') {
            $this->warn("Skipping backup: DB_CONNECTION is '{$connection}', not mysql.");

            return self::SUCCESS;
        }

        $directory = storage_path('app/backups');
        File::ensureDirectoryExists($directory);

        $filename = sprintf('msis_%s.sql.gz', now()->format('Y_m_d_His'));
        $path = "{$directory}/{$filename}";

        $dump = new Process([
            'mysqldump',
            '-h', $config['host'],
            '-P', (string) $config['port'],
            '-u', $config['username'],
            '--password='.$config['password'],
            $config['database'],
        ]);
        $dump->setTimeout(300);

        $gzip = new Process(['gzip']);
        $gzip->setTimeout(300);

        $dump->start();
        $handle = fopen($path, 'w');
        $gzip->setInput($dump);
        $gzip->run(function ($type, $buffer) use ($handle) {
            fwrite($handle, $buffer);
        });
        fclose($handle);

        if (! $dump->isSuccessful() || ! $gzip->isSuccessful()) {
            $this->error('Backup failed: '.$dump->getErrorOutput().$gzip->getErrorOutput());
            @unlink($path);

            return self::FAILURE;
        }

        $this->info("Backup written to {$path}");
        $this->prune((int) $this->option('keep'), $directory);

        return self::SUCCESS;
    }

    private function prune(int $keep, string $directory): void
    {
        $backups = collect(File::files($directory))
            ->filter(fn ($file) => str_ends_with($file->getFilename(), '.sql.gz'))
            ->sortByDesc(fn ($file) => $file->getMTime())
            ->values();

        foreach ($backups->slice($keep) as $old) {
            File::delete($old->getPathname());
            $this->info("Pruned old backup: {$old->getFilename()}");
        }
    }
}

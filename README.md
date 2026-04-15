# Hadoop Small Files Experiment Kit

Repo ini disusun untuk menjalankan skenario skripsi:

- variasi jumlah worker dengan 500 small files
- variasi jumlah small files dengan 5 worker
- uji gangguan worker saat job berjalan

Topologi cluster:

- `master` = `192.168.33.92`
- `worker1` = `192.168.33.245`
- `worker2` = `192.168.33.249`
- `worker3` = `192.168.33.251`
- `worker4` = `192.168.33.21`
- `worker5` = `192.168.33.22`

## Struktur Repo

- `config/` berisi konfigurasi Hadoop dan daftar node
- `scripts/` berisi script sinkronisasi dan setup node
- `experiments/` berisi script untuk generate dataset, upload HDFS, jalankan WordCount, dan bantu skenario uji
- `results/` berisi hasil eksperimen dalam format CSV dan log

## Konfigurasi Hadoop

File yang harus ada di semua node:

- `config/hosts`
- `config/workers`
- `config/core-site.xml`
- `config/hdfs-site.xml`
- `config/mapred-site.xml`
- `config/yarn-site.xml`
- `config/hadoop-env.sh`

## Setup Cluster

Di `master`:

```bash
mkdir -p ~/hadoop
cd ~/hadoop
scp -r <repo-ini>/* ~/hadoop/
sudo bash scripts/sync-hosts.sh
bash scripts/setup-master.sh
```

Dari `master`, salin ke semua worker:

```bash
scp -r ~/hadoop riyo@worker1:~/
scp -r ~/hadoop riyo@worker2:~/
scp -r ~/hadoop riyo@worker3:~/
scp -r ~/hadoop riyo@worker4:~/
scp -r ~/hadoop riyo@worker5:~/
```

Di tiap worker:

```bash
cd ~/hadoop
sudo bash scripts/sync-hosts.sh
bash scripts/setup-worker.sh
```

## Urutan Eksperimen

1. Pastikan cluster hidup:

```bash
hdfs dfsadmin -report
jps
```

2. Generate dataset small files:

```bash
bash experiments/generate-small-files.sh 500
```

3. Upload dataset ke HDFS:

```bash
bash experiments/upload-small-files.sh datasets/files_500 /datasets/files_500
```

4. Jalankan WordCount:

```bash
bash experiments/run-wordcount.sh \
  --input /datasets/files_500 \
  --output /results/wordcount_500_w5 \
  --label workers5_files500_run1
```

5. Lihat hasil ringkas:

```bash
cat results/experiment_results.csv
```

## Skenario Proposal

### 1. Variasi jumlah worker, file tetap 500

Gunakan `config/workers` untuk menentukan worker aktif, lalu jalankan ulang `setup-master.sh` dan `start-dfs.sh`.

Daftar skenario:

- `master only`
- `master + 1 worker`
- `master + 2 worker`
- `master + 3 worker`
- `master + 4 worker`
- `master + 5 worker`

Contoh untuk 2 worker:

```bash
printf "worker1\nworker2\n" > config/workers
bash scripts/setup-master.sh
stop-dfs.sh
start-dfs.sh
hdfs dfsadmin -report
```

### 2. Variasi jumlah small files, worker tetap 5

Dataset yang disarankan:

- `100`
- `500`
- `1000`
- `2000`

Contoh:

```bash
bash experiments/generate-small-files.sh 100
bash experiments/generate-small-files.sh 500
bash experiments/generate-small-files.sh 1000
bash experiments/generate-small-files.sh 2000
```

### 3. Uji gangguan worker

Saat job berjalan, matikan satu atau dua worker:

```bash
bash experiments/stop-worker-services.sh worker3
bash experiments/stop-worker-services.sh worker4 worker5
```

Nyalakan lagi setelah uji:

```bash
bash experiments/start-worker-services.sh worker3
bash experiments/start-worker-services.sh worker4 worker5
```

## Monitoring

Untuk proposalmu, data yang perlu dicatat minimal:

- durasi job
- jumlah worker aktif
- jumlah file
- ukuran total dataset
- status job
- screenshot NameNode UI
- screenshot ResourceManager UI
- screenshot JobHistory UI
- metrik Prometheus dan Grafana untuk CPU, memory, disk, dan network

## Hasil Eksperimen

Script `run-wordcount.sh` otomatis menambahkan baris ke:

- `results/experiment_results.csv`

Kolom:

- `timestamp`
- `label`
- `input_path`
- `output_path`
- `worker_count`
- `small_file_count`
- `total_bytes`
- `duration_seconds`
- `status`

## Catatan Penting

- Jalankan eksperimen utama dari `master`
- Pastikan HDFS output path baru setiap run, atau hapus output lama dulu
- Untuk konsistensi penelitian, jalankan setiap skenario lebih dari sekali lalu ambil rata-rata

package benchmark

import (
	"bytes"
	"fmt"
	"os"
	"os/exec"
	"strings"
	"sync"
	"testing"
)

type volume struct {
	file       string
	device     string
	mountpoint string
}

func run(cmd string, args ...string) ([]byte, error) {
	return exec.Command(cmd, args...).CombinedOutput()
}

func Benchmark(b *testing.B) {
	volumes := []*volume{}
	defer func() {
		for _, volume := range volumes {
			run("losetup", "-d", volume.device)
			os.Remove(volume.file)
			os.Remove(volume.mountpoint)
		}
	}()
	oneKZeroes := bytes.Repeat([]byte{0}, 1024)
	for i := 0; i < 256; i++ {
		file := fmt.Sprintf("file-%d", i)
		f, err := os.Create(file)
		if err != nil {
			b.Fatal(err)
		}
		for i := 0; i < 1024; i++ {
			f.Write(oneKZeroes)
		}
		f.Sync()
		mountpoint := fmt.Sprintf("mnt-%d", i)
		os.Mkdir(mountpoint, 0755)
		outputBytes, err := run("losetup", "-f")
		if err != nil {
			b.Fatal(err)
		}
		device := strings.TrimSpace(string(outputBytes))
		_, err = run("losetup", device, file)
		if err != nil {
			b.Fatal(err)
		}
		_, err = run("mkfs.ext4", device)
		if err != nil {
			b.Fatal(err)
		}
		volume := &volume{
			file:       file,
			device:     device,
			mountpoint: mountpoint,
		}
		volumes = append(volumes, volume)
	}
	type benchmark struct {
		name        string
		concurrency int
	}
	benchmarks := make([]benchmark, 0)
	concurrencies := []int{1, 2, 4, 8, 16, 32}
	for _, concurrency := range concurrencies {
		benchmarks = append(benchmarks, benchmark{
			name:        fmt.Sprintf("concurrency%d", concurrency),
			concurrency: concurrency,
		})
	}
	for _, bm := range benchmarks {
		b.Run(bm.name, func(b *testing.B) {
			for i := 0; i < b.N; i++ {
				benchmarkVolumeWithKeymutex(b, volumes, bm.concurrency)
			}
		})
	}
}

func unmountAndMount(v *volume) error {
	if _, err := run("mount", v.device, v.mountpoint); err != nil {
		return err
	}
	if _, err := run("umount", v.mountpoint); err != nil {
		return err
	}
	return nil
}

func benchmarkVolumeWithKeymutex(b *testing.B, volumes []*volume, concurrency int) {
	volumeCh := make(chan *volume)
	var wg sync.WaitGroup
	wg.Add(1)
	go func() {
		defer wg.Done()
		for _, volume := range volumes {
			volumeCh <- volume
		}
		close(volumeCh)
	}()
	for i := 0; i < concurrency; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			defer func() {
				if b.Failed() {
					// If failed, clean all volumes from channel, otherwise no
					// consumer will consume the rest of volumes.
					for _ = range volumeCh {
					}
				}
			}()
			for volume := range volumeCh {
				err := unmountAndMount(volume)
				if err != nil {
					b.Fatal(err)
				}
			}
		}()
	}
	wg.Wait()
}

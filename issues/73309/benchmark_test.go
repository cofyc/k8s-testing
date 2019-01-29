package main

import (
	"fmt"
	"sync"
	"testing"
	"time"
)

func BenchmarkTimeNow(b *testing.B) {
	var t1 time.Time
	var t2 time.Time
	for i := 0; i < b.N; i++ {
		t2 = time.Now()
		if t2.Sub(t1) <= 0 {
			fmt.Printf("die")
		}
		t1 = t2
	}
	_ = t1
	_ = t2
}

type foo struct {
	sync.RWMutex
	cycle int64
}

func (f foo) Cycle() int64 {
	f.RLock()
	defer f.RUnlock()
	return f.cycle
}

func BenchmarkLock(b *testing.B) {
	f := foo{}
	var t int64
	for i := 0; i < b.N; i++ {
		t = f.Cycle()
	}
	_ = t
}

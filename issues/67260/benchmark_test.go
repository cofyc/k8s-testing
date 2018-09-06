package benchmark

import (
	"fmt"
	"testing"
)

func BenchmarkCopyMapOfInts(b *testing.B) {
	mapOfInts := make(map[string]int, 1024)
	for i := 0; i < 1024; i++ {
		mapOfInts[fmt.Sprintf("key-%d", i)] = i
	}
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		new := make(map[string]int, 1024)
		for key, val := range mapOfInts {
			new[key] = val
		}
	}
}

func BenchmarkCopySliceOfInts(b *testing.B) {
	sliceOfInts := make([]int, 1024)
	for i := 0; i < 1024; i++ {
		sliceOfInts[i] = i
	}
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		new := make([]int, 1024)
		copy(new, sliceOfInts)
	}
}

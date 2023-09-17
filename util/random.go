package util

import (
	"math/rand"
	"strings"
	"time"
)

const alphabet = "abcdefghijlmnopqrstuvxz"

func init() {
	rand.Seed(time.Now().UnixNano())
}

// RandomInit generates a random integer between min and max
func RandomInit(min, max int64) int64 {
	return min + rand.Int63n(max-min+1)
}

// RandomString generates random string of length n
func RandomString(n int) string {
	var sb strings.Builder
	k := len(alphabet)

	for i := 0; i < n; i++ {
		c := alphabet[rand.Intn(k)]
		sb.WriteByte(c)
	}

	return sb.String()
}

// RandomOwner generates a random owner name
func RandomOwner() string {
	return RandomString(6)
}

// RandomMoney generates a random amount of money
func RandomMoney() int64 {
	return RandomInit(0, 1000)
}

// RandomCurrency generates a random currency
func RandomCurrency() string {
	currencies := []string{USD, EUR, CAD}
	i := len(currencies)

	return currencies[rand.Intn(i)]
}

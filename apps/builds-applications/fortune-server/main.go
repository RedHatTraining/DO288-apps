package main

import (
	"encoding/json"
	"log"
	"math/rand/v2"
	"net/http"
)

const addr string = ":8080"

// NB: NOT a production-ready setup
func main() {
	fortunes := [...]string{
		"Try again later",
		"How should I know?",
		"Outlook promising",
		"Absolutely",
		"Definitely not",
		"Not likely",
	}

	// configure route handlers
	http.HandleFunc("GET /", func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		answer := fortunes[rand.IntN(len(fortunes))]
		json.NewEncoder(w).Encode(answer)
	})

	// start server
	log.Printf("server starting on %s", addr)
	if err := http.ListenAndServe(addr, nil); err != nil {
		log.Fatal(err)
	}
}

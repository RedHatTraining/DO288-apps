package main

import (
	"encoding/json"
	"log"
	"math/rand/v2"
	"net/http"
	"os"
	"strings"
)

const addr string = ":8080"

// NB: NOT a production-ready setup
func main() {
	fortunes := []string{
		"Try again later",
		"How should I know?",
		"Outlook promising",
		"Absolutely",
		"Definitely not",
		"Not likely",
	}

	// serve the fortunes from the FORTUNES environment variable, if set
	if custom := os.Getenv("FORTUNES"); custom != "" {
		fortunes = strings.Split(custom, ",")
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

package main

import (
	"encoding/json"
	"log"
	"net/http"
	"runtime"
)

const addr string = ":8080"

// NB: NOT a production-ready setup
func main() {
	// configure route handlers
	http.HandleFunc("GET /", func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(map[string]string{
			"message": "Hello, World! I am using " + runtime.Version() + " by the way.",
		})
	})

	// start server
	log.Printf("server starting on %s", addr)
	if err := http.ListenAndServe(addr, nil); err != nil {
		log.Fatal(err)
	}
}

package main

import (
	"bytes"
	"encoding/binary"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
)

const prefixLen = 4

// Message container for requests and responses to the web extension.
type Message struct {
	Text string
}

func main() {
	signalc := make(chan os.Signal, 1)

	signal.Notify(signalc, syscall.SIGINT, syscall.SIGTERM)

	go func(c chan os.Signal) {
		s := <-c

		logFile(fmt.Sprintf("signal: %#v", s))
		os.Exit(0)
	}(signalc)

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		err := sendMessage(r.URL.Path[1:])
		if err != nil {
			w.WriteHeader(500)
			fmt.Fprintf(w, "error: %s", err)
		}

		w.WriteHeader(200)
		fmt.Fprintf(w, "ok")
	})
	logFile(fmt.Sprintf("%s", http.ListenAndServe(":8003", nil)))
}

func sendMessage(projectID string) error {
	content, err := json.Marshal(projectID)
	if err != nil {
		return err
	}

	var (
		contentLen = len(content)

		raw bytes.Buffer
	)

	if err := binary.Write(os.Stdout, binary.LittleEndian, uint32(contentLen)); err != nil {
		return err
	}

	written, err := raw.Write(content)
	if err != nil {
		return err
	}
	if written != contentLen {
		return fmt.Errorf("have %d, want %d", written, contentLen)
	}

	writtenTo, err := raw.WriteTo(os.Stdout)
	if err != nil {
		return err
	}

	if writtenTo != int64(contentLen) {
		return fmt.Errorf("have %d, want %d", writtenTo, contentLen)
	}

	return nil
}

func logFile(text string) {
	f, err := os.OpenFile("/tmp/checkpointer.txt", os.O_CREATE|os.O_APPEND|os.O_WRONLY, 0600)
	if err != nil {
		log.Fatal(err)
	}

	f.WriteString(fmt.Sprintf("%s\n", text))
}

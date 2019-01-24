# Goroutine
## What is Goroutine?
Goroutine is not a thread, but can be thought as a light weight thread.  
Groutine usually requires a few KB in stack size and the size can grow and shrink. On the other
hand, the size of thread is fixed, resulting in wasting space. Hence, it's possible to create 100K
to 1M of goroutines while running threads is limited to 1-10K.  
The Goroutines are multiplexed to fewer number of OS threads. There might be only one thread in a
program with thousands of Goroutines. If any Goroutine in that thread blocks say waiting for user
input, then another OS thread is created and the remaining Goroutines are moved to the new OS
thread. All these are taken care by the runtime and we as programmers are abstracted from these
intricate details and are given a clean API to work with concurrency.  

## Deadlock
If all goroutines are blocked waiting for channel receive/send or WaitGroup to be Done(), deadlock
detector detects it and stops the program.  
However, if at least one of the goroutines stays busy (because of infinate loop, for example),
deadlock detector cannot detect deadlock and the program just hangs.  

**sample code**  
```go
func main() {
  done := make(chan bool)
    go func() {
      for {
        // infinate loop
      }
      done <- true
    }()
  <-done
}
```

## Goroutine leak
Goroutines can leak. They might wait forever for channel or infinate loop. Make sure to close goroutines unless main will stop within short time.  
Reference: [Goroutine leak](https://medium.com/golangspec/goroutine-leak-400063aef468)  

### Channel Broadcasting
In `select` clause, if the listening channel gets closed, that path (case) will be taken. This
closing channel (`close()`) sends message to all the receivers, so if multiple goroutines are
listening to the same one channel waiting for send, closing the channel can unblock all the
goroutines at once. The below code illustrates the example usage.  
```go
func main() {
	done := make(chan bool)
	terminate := make(chan bool)
  // create multiple goroutines
	for i := 0; i < 3; i++ {
		go func(i int) {
			select {
			case done <- true:
        // wait for receiver
			case <-terminate:
        // this case will be selected when the channel gets closed
			}
		}(i)
	}
}
<- done // one of the goroutines will be unblocked
close(terminate) // rest of the goroutines will be unblocked
```

## Analysing Goroutine
`runtime.NumGoroutine()`  
Number of goroutines currently running can be obtained by `runtime.NumGoroutine()`  

`net/http/pprof`  
You can obtain the information about running goroutines (stack trace of each goroutine) using go tool or browser.  
To do this, first you need to start `pprof` server, and while the server is running you can run go
tool command or access via browser.  
The URL is http://localhost:6060/debug/pprof/.  

**sample code**
```go
package main

import _ "net/http/pprof"

func main() {
	srv := &http.Server{Addr: ":6060"}

	go func() {
		log.Println(srv.ListenAndServe())
	}()

  // make goroutines and have fun

  srv.Shutdown(nil)
}
```

[Package net/http/pprof](https://golang.org/pkg/net/http/pprof/)  

`runtime/pprof`

This package also offers to analise goroutines in a similar way to `net/http/pprof` does, but by
adding code to dump information in the source code.  
The code is:  
```go
pprof.Lookup("goroutine").WriteTo(os.Stdout, 1)
```

`gops`
This is a command line tool to provide information about cpu/memmory usuage, stack trace and etc.  
Refer [here](https://github.com/google/gops) for the detail.  

`leaktest`
This detects goroutine leak by tracing the stack trace of the beginning and the end of the test.  
It will be _leak_ if more/different goroutines are running at the end.  
Refer [here](https://github.com/fortytw2/leaktest) for the detail.  



### gRPC vs REST

| Feature         | gRPC              | REST                       |
| --------------- | ----------------- | -------------------------- |
| Transport       | HTTP/2            | HTTP/1.1 or HTTP/2         |
| Data format     | Protobuf (binary) | JSON (text)                |
| Speed           | Faster            | Slower                     |
| Streaming       | Native            | Limited                    |
| API contract    | `.proto` files    | OpenAPI/Swagger (optional) |
| Browser support | Requires gRPC-Web | Native                     |
### When to use gRPC

Choose gRPC when:

- Building microservices
- Internal service-to-service communication
- Low latency is important
- High throughput is required
- You need streaming (e.g., chat, telemetry, real-time updates)

Choose REST when:

- Building public APIs
- Browser compatibility is important
- Human-readable JSON is preferred
- Simplicity matters more than maximum performance

In modern architectures, it's common to use **gRPC internally between services** and expose a **REST or GraphQL API** externally for web and mobile clients.

---------------

gRPC (Google Remote Procedure Call) is a high-performance, open-source framework for communication between distributed services. It lets one application call methods on another application as if they were local function calls.

### Key features

- **High performance**: Uses the HTTP/2 protocol, which supports:
    - Multiplexing (multiple requests over one connection)
    - Header compression
    - Bidirectional streaming
- **Strongly typed APIs**: Defines services and messages using Protocol Buffers (Protobuf).
- **Cross-language support**: Works with Java, Go, C++, Python, C#, Node.js, Rust, and many others.
- **Code generation**: Generates client and server code automatically from `.proto` files.

### How it works

1. Define your service in a `.proto` file.
2. Generate client and server code.
3. Implement the server methods.
4. Call the methods from the client.

Example:

```
syntax = "proto3";service Greeter {  rpc SayHello (HelloRequest) returns (HelloReply);}message HelloRequest {  string name = 1;}message HelloReply {  string message = 1;}
```

Server implementation (Go):

```
func (s *server) SayHello(ctx context.Context, req *pb.HelloRequest) (*pb.HelloReply, error) {    return &pb.HelloReply{        Message: "Hello " + req.Name,    }, nil}
```

Client:

```
resp, err := client.SayHello(ctx, &pb.HelloRequest{    Name: "Alice",})fmt.Println(resp.Message)
```

Output:

```
Hello Alice
```
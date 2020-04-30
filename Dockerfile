ARG compiler
FROM ocaml/opam2:$compiler AS dev
RUN sudo apt-get -y install m4 pkg-config libssl-dev libffi-dev
#FIXME pins
RUN opam install disml
#add things here to use Docker's cache
RUN mkdir /home/opam/repo
WORKDIR /home/opam/repo
COPY *.opam .
ARG packages
RUN for p in $packages; do opam pin add -n $p .; done && \
	opam depext -i $packages && \
	opam install --deps-only $packages && \
	for p in $packages; do opam unpin $p; done

FROM dev AS builder
COPY . .
RUN sudo chown -R opam . && eval $(opam env) && dune build bin/main.exe

FROM debian:stable-slim
COPY --from=builder /home/opam/repo/_build/default/bin/main.exe /app/
WORKDIR /app
ENTRYPOINT ["/app/main.exe"]

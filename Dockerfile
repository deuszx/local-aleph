FROM ubuntu:20.04

# Expose ports of the first node
# 30334 - p2p port
# 9933 - RPC port
# 9944 - ws port 
EXPOSE 30334 9933 9944

WORKDIR aleph

RUN apt-get update && apt-get install -y && apt install net-tools -y

COPY aleph-node/target/release/aleph-node /usr/local/bin
RUN chmod +x /usr/local/bin/aleph-node

COPY run_network.sh run_network.sh
RUN chmod +x run_network.sh

ENTRYPOINT ["./run_network.sh"]
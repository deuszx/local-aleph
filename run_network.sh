#!/usr/bin/env bash 

N_VALIDATORS=4
BASE_PATH="."

account_ids=(
    "5D34dL5prEUaGNQtPPZ3yN5Y6BnkfXunKXXz6fo7ZJbLwRRH"
    "5GBNeWRhZc2jXu7D55rBimKYDk8PGk8itRYFTPfC8RJLKG5o" \
    "5Dfis6XL8J2P6JHUnUtArnFWndn62SydeP8ee8sG2ky9nfm9" \
    "5F4H97f7nQovyrbiq4ZetaaviNwThSVcFobcA5aGab6167dK" \
    "5DiDShBWa1fQx6gLzpf3SFBhMinCoyvHM1BWjPNsmXS8hkrW" \
    "5EFb84yH9tpcFuiKUcsmdoF7xeeY3ajG1ZLQimxQoFt9HMKR" \
    "5DZLHESsfGrJ5YzT3HuRPXsSNb589xQ4Unubh1mYLodzKdVY" \
    "5GHJzqvG6tXnngCpG7B12qjUvbo5e4e9z8Xjidk3CQZHxTPZ" \
    "5CUnSsgAyLND3bxxnfNhgWXSe9Wn676JzLpGLgyJv858qhoX" \
    "5CVKn7HAZW1Ky4r7Vkgsr7VEW88C2sHgUNDiwHY9Ct2hjU8q")
validator_ids=("${account_ids[@]::N_VALIDATORS}")
# space separated ids
validator_ids_string="${validator_ids[*]}"
# comma separated ids
validator_ids_string="${validator_ids_string//${IFS:0:1}/,}"


echo "Bootstrapping chain for nodes 0..$((N_VALIDATORS - 1))"
aleph-node bootstrap-chain --millisecs-per-block 2000 --session-period 40 --base-path "$BASE_PATH" --account-ids "$validator_ids_string" --chain-type local > chainspec.json

bootnodes=""
for i in 0 1; do
    pk=$(aleph-node key inspect-node-key --file $BASE_PATH/${account_ids[$i]}/p2p_secret)
    bootnodes+="/dns4/localhost/tcp/$((30334+i))/p2p/$pk "
done

for i in $(seq 0 "$(( N_VALIDATORS + N_NON_VALIDATORS - 1 ))"); do
  auth=node-$i
  account_id=${account_ids[$i]}
  aleph-node \
    --validator \
    --chain $BASE_PATH/chainspec.json \
    --base-path $BASE_PATH/$account_id \
    --name $auth \
    --rpc-port $((9933 + i)) --ws-port $((9944 + i)) --port $((30334 + i)) \
    --bootnodes $bootnodes \
    --node-key-file $BASE_PATH/$account_id/p2p_secret \
    --unit-creation-delay 500 \
    --execution Native \
    --no-mdns \
    --unsafe-ws-external --unsafe-rpc-external \
    --rpc-cors all \
    -lafa=debug \
    "$@" \
    2> $auth.log > /dev/null & \

    echo "started node-${i}"
done

# Normally, docker containers exit when their foreground process finishes.
# `./run_network.sh` runs Aleph nodes in the background 
# so there would be no foreground process and that would exit docker image.
# Tailing /dev/null keeps the foreground process running indefinitely.

tail -f /dev/null
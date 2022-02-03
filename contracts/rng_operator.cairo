%lang starknet

%builtins pedersen range_check

from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address, get_block_timestamp
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.hash import hash2

@contract_interface
namespace IRNGConsumer:
    func request_rng():
    end

    func will_recieve_rng(rng : felt):
    end
end

struct RNGPayload:
    member randomness : Uint256
    # TODO : add signature, and possibly previous_signature
end

struct Request:
    member callback_address : felt
end

@storage_var
func requests(index : felt) -> (req : Request):
end

@storage_var
func request_index() -> (index : felt):
end

@storage_var
func completed_index() -> (index : felt):
end

@event
func rng_recieved(randomness : Uint256):
end

# @dev argument in constructor appears to be mandatory for hardhat mocha tests
@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    request_index.write(1)
    completed_index.write(1)

    return ()
end

func resolve_requests{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        curr_index : felt, end_index : felt, randomness : Uint256):
    if curr_index == end_index:
        completed_index.write(curr_index)
        return ()
    end
    let (request) = requests.read(curr_index)

    # TODO : make hash unique for each iteration
    let (hash) = hash2{hash_ptr=pedersen_ptr}(randomness.low, randomness.high)
    IRNGConsumer.will_recieve_rng(contract_address=request.callback_address, rng=hash)

    resolve_requests(curr_index + 1, end_index, randomness)
    return ()
end

@external
func resolve_rng_requests{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        rng : RNGPayload):
    # TODO : verify calling address
    # TODO : verify randomness
    rng_recieved.emit(randomness=rng.randomness)
    let (start_index) = request_index.read()
    let (end_index) = completed_index.read()

    resolve_requests(start_index, end_index, rng.randomness)
    return ()
end

@external
func request_rng{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    let (caller_address) = get_caller_address()
    let (curr_index) = request_index.read()

    requests.write(curr_index, Request(callback_address=caller_address))
    request_index.write(curr_index + 1)

    return ()
end

@view
func get_request_index{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        res : felt):
    let (curr_index) = request_index.read()
    return (curr_index)
end

@view
func get_completed_index{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        res : felt):
    let (curr_index) = completed_index.read()
    return (curr_index)
end

@view
func get_request{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        index : felt) -> (res : Request):
    let (req) = requests.read(index)

    return (req)
end

%lang starknet

%builtins pedersen range_check

from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address, get_block_timestamp
from starkware.cairo.common.cairo_builtins import HashBuiltin

struct DrandPayload:
    member randomness : Uint256
    # TODO : add signature, and possibly previous_signature
end

struct RngRequest:
    member address : felt
end

@storage_var
func requests(index : felt) -> (req : RngRequest):
end

@storage_var
func request_index() -> (index : felt):
end

@storage_var
func recieve_index() -> (index : felt):
end

@event
func rng_recieved(randomnes : Uint256):
end

# @dev argument in constructor appears to be mandatory for hardhat mocha tests
@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(arg : felt):
    request_index.write(0)
    recieve_index.write(0)

    return ()
end

func resolve_requests{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        curr_index : felt, end_index : felt, randomness : Uint256):
    if curr_index == end_index:
        recieve_index.write(curr_index)
        return ()
    end
    let (request) = requests.read(curr_index)

    return ()
end

@external
func recieve_rng{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        rng : DrandPayload):
    # TODO : verify calling address
    # TODO : verify randomness
    rng_recieved.emit(randomnes=rng.randomness)
    let (start_index) = request_index.read()
    let (end_index) = recieve_index.read()
    return ()
end

@external
func request_rng{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    let (caller_address) = get_caller_address()
    let (timestamp) = get_block_timestamp()

    let (curr_index) = request_index.read()

    requests.write(curr_index, RngRequest(address=caller_address))
    request_index.write(curr_index + 1)

    return ()
end

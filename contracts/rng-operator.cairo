%lang starknet

from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address, get_block_timestamp

struct DrandPayload:
    member randomness : Uint256
    # TODO : add signature, and possibly previous_signature
end

struct RngRequest:
    member address : felt
end

@storage_var
func requests() -> (req : RngRequest):
end

@event
func rng_recieved(randomnes : Uint256):
end

@view
func recieve_rng{syscall_ptr : felt*, range_check_ptr}(rng : DrandPayload) -> ():
    rng_recieved.emit(randomnes=rng.randomness)
    return ()
end

func request_rng{syscall_ptr : felt*, range_check_ptr}() -> ():
    let caller_address = get_caller_address()
    let timestamp = get_block_timestamp()

    return ()
end

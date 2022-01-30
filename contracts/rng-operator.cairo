%lang starknet

from starkware.cairo.common.uint256 import Uint256

struct DrandPayload:
    member round : felt
    member randomness : Uint256
    # TODO : add signature, and possibly previous_signature
end

@event
func rng_recieved(randomnes : Uint256, round : felt):
end

@view
func recieve_rng{syscall_ptr : felt*, range_check_ptr}(rng : DrandPayload) -> ():
    rng_recieved.emit(randomnes=rng.randomness, round=rng.round)
    return ()
end

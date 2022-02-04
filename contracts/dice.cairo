%lang starknet

%builtins pedersen range_check

from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import unsigned_div_rem

struct DrandPayload:
    member randomness : Uint256
    # TODO : add signature, and possibly previous_signature
end

@contract_interface
namespace IRNGOracle:
    func recieve_rng(amount : DrandPayload):
    end

    func request_rng():
    end
end

@storage_var
func oracle_address() -> (addr : felt):
end

@event
func roll_result(roll : felt):
end

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        oracle_addr : felt):
    oracle_address.write(oracle_addr)

    return ()
end

func request_rng{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    let (oracle) = oracle_address.read()
    IRNGOracle.request_rng(contract_address=oracle)
    return ()
end

@external
func will_recieve_rng{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        rng : felt):
    let (oracle) = oracle_address.read()
    let (caller_address) = get_caller_address()

    assert oracle = caller_address

    return ()
end

func roll_dice{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(rng : felt):
    let (_, roll) = unsigned_div_rem(rng, 6)
    roll_result.emit(roll=roll)
    return ()
end

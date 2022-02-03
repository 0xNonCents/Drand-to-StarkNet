%lang starknet

%builtins pedersen range_check

from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address, get_block_timestamp
from starkware.cairo.common.cairo_builtins import HashBuiltin

struct DrandPayload:
    member randomness : Uint256
    # TODO : add signature, and possibly previous_signature
end

@contract_interface
namespace IRNGOperator:
    func recieve_rng(amount : DrandPayload):
    end

    func request_rng():
    end
end

@storage_var
func operator_address() -> (addr : felt):
end

@storage_var
func latest_rng() -> (rng : felt):
end

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        op_address : felt):
    operator_address.write(op_address)

    return ()
end

@external
func request_rng{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    let (addr) = operator_address.read()
    IRNGOperator.request_rng(contract_address=addr)
    return ()
end

@external
func will_recieve_rng{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        rng : felt):
    # Do something with the rng
    latest_rng.write(rng)
    return ()
end

@view
func get_latest_rng{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        rng : felt):
    let (rng) = latest_rng.read()

    return (rng)
end

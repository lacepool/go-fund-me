use cocktail/vodka_extra_signatories.{key_signed}
use cocktail/vodka_validity_range.{valid_after}
use cardano/assets.{match}
use cardano/transaction.{OutputReference, Transaction}
use aiken/crypto.{VerificationKeyHash}
use aiken/collection/list

pub type Action {
  Donate
  Withdraw
}

validator fundraiser(
  goal: Int,
  deadline: Int,
  owner: VerificationKeyHash,
) {
  spend(
    _datum: Option<Data>,
    redeemer: Action,
    oref: OutputReference,
    tx: Transaction
  ) -> Bool {
    let Transaction { inputs, outputs, .. } = tx

    expect Some(own_input) =
      list.find(inputs, fn(input) { input.output_reference == oref })

    when redeemer is {
      Donate -> {
        // Ensure the output goes back to the same script address.
        expect Some(own_output) =
          list.find(outputs, fn(output) { output.address == own_input.output.address })

        // Ensure the lovelace value has increased.
        match(own_output.value, own_input.output.value, >)
      }
      Withdraw -> {
        // Allow withdrawal if either the goal is met, or the deadline has passed.
        // The owner must have signed the Tx.
        and {
          key_signed(tx.extra_signatories, owner),
          or {
            match(own_input.output.value, goal, >=),
            valid_after(tx.validity_range, deadline),
          }
        }
      }
    }
  }
}

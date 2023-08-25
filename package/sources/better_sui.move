module better_stake_sui::bsui {
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::sui::SUI;
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::url;
    use sui::tx_context::TxContext;

    use std::option;
    use std::vector;
    use sui_system::sui_system::Self as sys;
    use sui_system::staking_pool::StakedSui;

    const EZeroAmount: u64 = 0;

    struct BSUI has drop {}

    struct Storage<phantom T> has key {
        id: UID,
        treasury_cap: TreasuryCap<T>,
        total_points: u64,
        total_staked: u64,
    }

    struct BetterStake has key {
        id: UID,
        points: u64,
        staked: u64,
        coins: vector<StakedSui>,
    }
    
    fun init(otw: BSUI, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency<BSUI>(
            otw, 
            9,
            b"BSUI",
            b"Better Sui",
            b"Better Stake Sui Liquid Staking Token",
            option::some(url::new_unsafe_from_bytes(b"https://cdn.corporatefinanceinstitute.com/assets/icon-cryptocurrency-icx.png")),
            ctx,
        );
        transfer::public_freeze_object(metadata);
        transfer::share_object(Storage {
            id: object::new(ctx), 
            treasury_cap,
            total_points: 0, 
            total_staked: 0,
        });
    }

    // separate function since we need to create one only if the wallet doesn't own one
    public fun create_better_sui(ctx: &mut TxContext): BetterStake {
        BetterStake {
            id: object::new(ctx), 
            points: 0,
            staked: 0,
            coins: vector::empty(),
        }
    }

    // the user might want to stake with different validators in one tx
    // in this case we'd loop over this function and merge returned coins 
    public fun stake(
        validator_addr: address, 
        payment: Coin<SUI>, 
        inventory: BetterStake, 
        storage: &mut Storage<BSUI>,
        state: &mut sys::SuiSystemState, 
        ctx: &mut TxContext
    ): (BetterStake, Coin<BSUI>) {
        let amount = coin::value(&payment);
        assert!(amount != 0, EZeroAmount);

        let staked_sui = sys::request_add_stake_non_entry(state, payment, validator_addr, ctx);
        inventory.staked = inventory.staked + amount;
        vector::push_back(&mut inventory.coins, staked_sui);

        let coins = coin::mint(&mut storage.treasury_cap, amount, ctx);

        (inventory, coins)
    }

}
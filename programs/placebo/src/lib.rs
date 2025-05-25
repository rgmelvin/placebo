use anchor_lang::prelude::*;

declare_id!("4s8JMB7Pbp8JSSXgFrvc41uodD9dvFdj9f6Sv8pWXwZF");

#[program]
pub mod placebo {
    use super::*;

    pub fn say_hello(_ctx: Context<Hello>) -> Result<()> {
        msg!("👋 Hello from Placebo!");
        Ok(())
    }
}

#[derive(Accounts)]
pub struct Hello {}

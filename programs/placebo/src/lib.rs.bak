use anchor_lang::prelude::*;

declare_id!("DEdLFqehJ6knPRqEYfJkhaNXowbDNxivZvqRwvsixd6L");

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

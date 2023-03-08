terraform {
  required_providers {
    grid = {
      source = "threefoldtech/grid"
    }
  }
}

provider "grid" {
    mnemonics = "FROM THE CREATE TWIN STEP"
    network = "dev" # or test to use testnet
}
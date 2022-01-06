const { expect } = require("chai")
const { ethers } = require("hardhat")

describe("multi-receiver-test", function () {
  let alice,bob,charlotte

  beforeEach (async () => {
    [a, b, c] = await ethers.getSigners()
    alice = a
    bob = b
    charlotte = c
    const MR = await ethers.getContractFactory("EIP2981_Multi_Receiver")
    const Mr = await MR.deploy([{wallet: alice.address, percent: 50}, {wallet: alice.address, percent: 30}, {wallet: alice.address, percent: 20}])
    await Mr.deployed()

  })

  it("should create a list of receivers", async function () {

    
  })
})

const { expect } = require("chai")
const { ethers } = require("hardhat")

describe("multi-receiver-test", function () {
  let alice,bob,charlotte
  let Mr

  beforeEach (async () => {
    [a, b, c] = await ethers.getSigners()
    alice = a
    bob = b
    charlotte = c
    const MR = await ethers.getContractFactory("EIP2981_Multi_Receiver")
    Mr = await MR.deploy([{wallet: alice.address, percent: 50}, {wallet: bob.address, percent: 30}, {wallet: charlotte.address, percent: 20}])
    await Mr.deployed()

  })

  it("should create a list of receivers", async function () {
    expect(await Mr.isReceiver(alice.address)).to.deep.equal(true)    
    expect(await Mr.isReceiver(bob.address)).to.deep.equal(true)    
    expect(await Mr.isReceiver(charlotte.address)).to.deep.equal(true)    
  })

  it("should create a list of receivers", async function () {
    expect(await Mr.getPercentage(alice.address)).to.deep.equal(50)    
    expect(await Mr.getPercentage(bob.address)).to.deep.equal(30)    
    expect(await Mr.getPercentage(charlotte.address)).to.deep.equal(20)    
  })

  it("receive and payout funds", async function () {
    //mock royalty payment from some marketplace to this contract
    await alice.sendTransaction({to: Mr.address, value: ethers.utils.parseEther('10')})
  })  
})

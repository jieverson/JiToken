const { expect } = require("chai")
const hre = require("hardhat")

describe("JiToken", function() {
    let token;
    let jiToken;
    let owner;
    let addr1;
    let addr2;
    let tokenBlockReward = 1000000000000000000;

    beforeEach(async () => {
        token = await hre.ethers.getContractFactory("JiToken");
        [owner, addr1, addr2] = await ethers.getSigners()
        jiToken = await token.deploy()
    })

    it("Should set the right owner", async function() {
        expect(await jiToken.owner()).to.equal(owner.address)
    })

    it('Should assign the total supply to the owner', async function() {
        const ownerBalance = await jiToken.balanceOf(owner.address)
        expect(await jiToken.totalSupply()).to.equal(ownerBalance)
    })
})